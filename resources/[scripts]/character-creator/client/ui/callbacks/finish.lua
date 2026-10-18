-- nos possuimos um efeito de transição que possui wait e isso faz uma proteção para o cara não ficar clicando 100x vezes
local waitingFinish = false

local characterData = nil

---@class CreatorFinishData
---@field ramo string|nil
---@field spawnAtFactionFocus boolean|nil

---@param data CreatorFinishData
---@param callback fun(success: boolean)
RegisterNUICallback('creator:finish', function(data, callback)
    if waitingFinish then return callback(false) end
    waitingFinish = true
    if next(gCreationState) and (gCreationState.flag & eCharacterCreatorCreationState.CREATING) == 0 then
        characterData = nil
    end
    local success
    if data.ramo and not characterData then
        local ok, accepted = pcall(lib.callback.await, 'character-creator:selectRamo', false,
            data.ramo, data.spawnAtFactionFocus == true)
        success = ok and accepted == true
        if success then
            gCreationState = {}
            SetNuiFocus(false, false)
            SendNUIMessage({ action = 'toggle', data = false })
            Hud.setVisible(true)
        else
            -- A NUI publicada fecha o ramo antes do retorno; restaure a tela no erro.
            TriggerEvent('net.character-creator.open-ramo-select')
        end
    else
        success = FinishCreation(false, characterData, data.ramo)
        if success then characterData = nil end
    end
    waitingFinish = false
    callback(success == true)
end)

RegisterNUICallback( "creator:getFactionFocusSpawnAvailability", function( _, callback )
    local prompt = CREATOR_CONFIG.CRIMINAL_FACTION_FOCUS_PROMPT[ GetConvar( 'language', 'pt-br' ) ]
        or CREATOR_CONFIG.CRIMINAL_FACTION_FOCUS_PROMPT[ CITY_NAME ]
        or CREATOR_CONFIG.CRIMINAL_FACTION_FOCUS_PROMPT[ "Santa" ]

    if not prompt then
        return callback( false )
    end

    local factionFocusSpawn = CREATOR_CONFIG.GetFactionFocusSpawn()
    local language = GetConvar( 'language', 'pt-br' )
    local simpleConfirm = CREATOR_CONFIG.CRIMINAL_SIMPLE_CONFIRM[ CITY_NAME ]
    prompt.locale = language
    -- ENG-3902: confirmação simples mesmo sem foco publicado; o spawn no QG é decidido pela API
    -- ENG-3970: a cidade liga a confirmação simples; o texto segue o idioma da cidade
    prompt.simpleConfirm = simpleConfirm and ( CREATOR_CONFIG.CRIMINAL_SIMPLE_CONFIRM_TEXT[ language ] or simpleConfirm )
    callback( ( factionFocusSpawn or prompt.simpleConfirm ) and prompt or false )
end )

RegisterNUICallback('creator:close', function(data, callback)
    callback(true)
    FinishCreation(true)
end)

RegisterNUICallback('createCharacter', function(data, callback)
    sx.logger:debug('Character creation data received')
    characterData = data
    pcall(lib.callback.await, 'character-creator:createCharacter', false, data)
    callback(true)
end)

RegisterNUICallback('getUserValues', function(_, callback)
    callback({})
end)

RegisterNUICallback('validateInfluencerCode', function(data, callback)
    local validate = lib.callback.await("new_spawn:redeemInfluencerCode", false, data.code)
    callback(validate)
end)
