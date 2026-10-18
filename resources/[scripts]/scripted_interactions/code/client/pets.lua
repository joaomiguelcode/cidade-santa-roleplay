local gMyPetsOpen = false
---@type string[]?
local gPetCollectibleIds = nil
local gPetEquipmentByCollectibleId = { }

---@param interactionDef ScriptedInteractionDef
---@param stateName string
---@return string
local function GetPetPositionId( interactionDef, stateName )

    if interactionDef.canSwitchState then
        return stateName
    end

    return interactionDef.states[ 1 ].title:match( '%.([^.]+)%.title$' )
end

---@param interactionName string
---@return boolean
local function IsPetInteractionName( interactionName )

    return interactionName:find( '^collectible_pet_' ) ~= nil
end

---@param translationKey string
---@return string | nil
local function GetPetTranslation( translationKey )

    if type( translationKey ) ~= 'string' then
        return nil
    end

    local positionId, translationType = translationKey:match( '^collectibles%.pets%.[^.]+%.([^.]+)%.([^.]+)$' )

    if not positionId or (translationType ~= 'title' and translationType ~= 'description') then
        return nil
    end

    local translations = gPetTranslations[ GetConvar( 'language', 'pt-br' ) ] or gPetTranslations[ 'pt-br' ]

    if translationType == 'description' then
        return translations.descriptions[ positionId ]
    end

    return translations[ positionId ]
end

exports( 'GetPetTranslation', GetPetTranslation )

---@param interactionDef ScriptedInteractionDef
---@param stateName string
---@return number | nil
local function GetPetStateIndex( interactionDef, stateName )

    if not interactionDef.canSwitchState then
        return 1
    end

    for stateIndex, state in ipairs( interactionDef.states ) do
        if state.name == stateName then
            return stateIndex
        end
    end
end

---@param leftPet table
---@param rightPet table
---@return boolean
local function SortPetsByName( leftPet, rightPet )

    local leftName = leftPet.name:lower()
    local rightName = rightPet.name:lower()

    if leftName == rightName then
        return leftPet.itemIndex < rightPet.itemIndex
    end

    return leftName < rightName
end

---@param collectibleIds string[]
---@return table
local function BuildMyPetsUiState( collectibleIds )

    local pets = { }
    local translations = gPetTranslations[ GetConvar( 'language', 'pt-br' ) ] or gPetTranslations[ 'pt-br' ]

    for _, collectibleId in ipairs( collectibleIds or { } ) do
        local interactionDef = GetScriptedInteractionDefinitionByName( collectibleId )
        local collectibleDef = exports.santa_radio:GetCollectibleDefByKey( collectibleId )
        local petId = collectibleId:gsub( '^collectible_pet_', '' )

        assert( interactionDef, ('Missing scripted interaction collectibleId="%s"'):format( collectibleId ) )
        assert( collectibleDef, ('Missing collectible definition collectibleId="%s"'):format( collectibleId ) )

        local petName = exports.vrp:GetItemName( collectibleDef.itemKey )

        assert( petName, ('Missing item translation itemKey="%s"'):format( collectibleDef.itemKey ) )

        local positions = { }
        local stateIndex = gPetEquipmentByCollectibleId[ collectibleId ]
        local equippedState = stateIndex and interactionDef.states[ stateIndex ]

        for _, state in ipairs( interactionDef.states ) do
            local positionId = GetPetPositionId( interactionDef, state.name )
            table.insert( positions, { id = positionId, name = translations[ positionId ], description = translations.descriptions[ positionId ] } )
        end

        table.insert( pets, {
            petId = petId,
            collectibleId = collectibleId,
            itemIndex = collectibleDef.itemKey,
            name = petName,
            ownedQuantity = 1,
            animations = { { id = DEFAULT_SCRIPTED_INTERACTION_STATE, name = translations.idle } },
            positions = positions,
            equipment = equippedState and { { collectibleId = collectibleId, animationId = DEFAULT_SCRIPTED_INTERACTION_STATE, positionId = GetPetPositionId( interactionDef, equippedState.name ) } } or { },
        } )
    end

    table.sort( pets, SortPetsByName )

    return { pets = pets }
end

local function RefreshMyPetsUi()
    if gMyPetsOpen then
        SendNUIMessage( { action = 'scripted_interactions:refreshMyPets' } )
    end
end

local function OpenMyPets()
    gPetCollectibleIds = nil
    gMyPetsOpen = true
    SetNuiFocus( true, true )
    SendNUIMessage( { action = 'scripted_interactions:openMyPets' } )
end

RegisterNUICallback( 'scripted_interactions:requestMyPetsState', function( _, cb )

    if gPetCollectibleIds == nil then
        gPetCollectibleIds = lib.callback.await( 'scripted_interactions:server:getMyPetsState', false )
    end

    SendNUIMessage( { action = 'scripted_interactions:setMyPetsState', data = BuildMyPetsUiState( gPetCollectibleIds ) } )
    cb( { success = true } )
end )

RegisterNUICallback( 'getCityName', function( _, cb )
    cb( GetConvar( 'cityName', '' ) )
end )

RegisterNUICallback( 'scripted_interactions:equipPet', function( data, cb )
    cb( lib.callback.await( 'scripted_interactions:server:equipPet', false, data ) )
end )

RegisterNUICallback( 'scripted_interactions:updateEquippedPet', function( data, cb )
    cb( lib.callback.await( 'scripted_interactions:server:updateEquippedPet', false, data ) )
end )

RegisterNUICallback( 'scripted_interactions:unequipPet', function( data, cb )
    cb( lib.callback.await( 'scripted_interactions:server:unequipPet', false, data ) )
end )

RegisterNUICallback( 'scripted_interactions:closeMyPets', function( _, cb )
    gMyPetsOpen = false
    SetNuiFocus( false, false )
    cb( { success = true } )
end )

RegisterCommandLocalized( 'command.pets', function()
    OpenMyPets()
end )

AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId, _, stateName )

    if entityId ~= PlayerPedId() or not IsPetInteractionName( interactionName ) then
        return
    end

    local interactionDef = GetScriptedInteractionDefinitionByName( interactionName )

    if not interactionDef then
        return
    end

    local stateIndex = GetPetStateIndex( interactionDef, stateName )

    assert( stateIndex, ('Missing pet state interactionName="%s" stateName="%s"'):format( interactionName, stateName ) )

    gPetEquipmentByCollectibleId[ interactionName ] = stateIndex

    RefreshMyPetsUi()
end )

AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStopped', function( interactionName, entityId )

    if entityId ~= PlayerPedId() or not IsPetInteractionName( interactionName ) then
        return
    end

    gPetEquipmentByCollectibleId[ interactionName ] = nil
    RefreshMyPetsUi()
end )
