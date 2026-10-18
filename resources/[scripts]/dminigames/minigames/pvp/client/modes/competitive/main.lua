---MinigameClient do modo Competitivo — HUD, teleporte, rounds e resultado.

local competitivePlayerTeams = {}
local outlinedTeamEntities = {}
local competitiveClientInstance = nil
local isInMatch = false
local myTeam = nil
local competitiveRelationshipGroup = nil
local currentCompetitiveMatchId = nil
local competitiveMatchStartReady = false
local competitiveRoundSpawnReady = false
local pendingCompetitiveRoundStart = nil
local competitiveRoundStartToken = 0
local currentCompetitiveRoundNumber = 0
local competitiveRoundDebug = function() end
local competitiveDeathVoiceMuted = false
local competitiveSavedArmour = nil
local competitiveSavedAppearance = nil
local competitiveAppliedUniformTeamKey = nil
local competitiveLatencyWarningVisible = false
local competitiveLatencyWarningId = nil

local COMPETITIVE_PED_BASE_HEALTH = 100
local COMPETITIVE_PED_MAX_HEALTH = 400
local COMPETITIVE_PED_MAX_ARMOUR = 99
local COMPETITIVE_PLAYER_ENABLE_CONTROL_FLAGS = 0
local COMPETITIVE_MATCH_RESULT_DISPLAY_MS = 15000
local COMPETITIVE_TOURNAMENT_RESULT_DISPLAY_MS = 15000
local COMPETITIVE_SCOREBOARD_REFRESH_MS = 1000
local COMPETITIVE_CLEAN_AREA_DISTANCE = 100.0
local COMPETITIVE_FEMALE_PED_MODEL = GetHashKey( 'mp_f_freemode_01' )
local COMPETITIVE_UNIFORM_TEAM_BY_ROLE = {
    TeamA = 'purple',
    TeamB = 'green',
}
local COMPETITIVE_CLOTHING_COMPONENTS = {
    { key = 'pants',     id = 4 },
    { key = 'arms',      id = 3 },
    { key = 'backpack',  id = 5 },
    { key = 'tshirt',    id = 8 },
    { key = 'vest',      id = 9 },
    { key = 'torso',     id = 11 },
    { key = 'shoes',     id = 6 },
    { key = 'mask',      id = 1 },
    { key = 'decals',    id = 10 },
    { key = 'accessory', id = 7 },
}
local COMPETITIVE_CLOTHING_PROPS = {
    { key = 'hat',      id = 0 },
    { key = 'glass',    id = 1 },
    { key = 'ear',      id = 2 },
    { key = 'watch',    id = 6 },
    { key = 'bracelet', id = 7 },
}
local COMPETITIVE_TEAM_UNIFORMS = {
    purple = {
        female = {
            accessory = { item = 0, texture = 0 },
            shoes     = { item = 35, texture = 0 },
            tshirt    = { item = 3, texture = 0 },
            glass     = { item = 0, texture = -1 },
            backpack  = { item = 0, texture = 0 },
            watch     = { item = -1, texture = -1 },
            arms      = { item = 14, texture = 0 },
            torso     = { item = 212, texture = 22 },
            decals    = { item = 0, texture = 0 },
            bracelet  = { item = -1, texture = -1 },
            pants     = { item = 91, texture = 22 },
            mask      = { item = 0, texture = 0 },
            vest      = { item = 0, texture = 0 },
            hat       = { item = -1, texture = -1 },
            ear       = { item = -1, texture = -1 },
        },
        male = {
            pants     = { item = 88, texture = 22 },
            backpack  = { item = 0, texture = 0 },
            accessory = { item = 0, texture = 0 },
            vest      = { item = 0, texture = 0 },
            glass     = { item = 0, texture = -1 },
            shoes     = { item = 34, texture = 0 },
            mask      = { item = 0, texture = 0 },
            tshirt    = { item = 15, texture = 0 },
            bracelet  = { item = -1, texture = -1 },
            arms      = { item = 198, texture = 0 },
            hat       = { item = -1, texture = -1 },
            watch     = { item = -1, texture = -1 },
            ear       = { item = -1, texture = -1 },
            decals    = { item = 0, texture = 0 },
            torso     = { item = 208, texture = 22 },
        },
    },
    green = {
        male = {
            pants     = { item = 88, texture = 20 },
            backpack  = { item = 0, texture = 0 },
            accessory = { item = 0, texture = 0 },
            vest      = { item = 0, texture = 0 },
            glass     = { item = 0, texture = 0 },
            shoes     = { item = 34, texture = 0 },
            mask      = { item = 0, texture = 0 },
            tshirt    = { item = 15, texture = 0 },
            bracelet  = { item = -1, texture = -1 },
            arms      = { item = 198, texture = 0 },
            hat       = { item = -1, texture = -1 },
            watch     = { item = -1, texture = -1 },
            ear       = { item = -1, texture = -1 },
            decals    = { item = 0, texture = 0 },
            torso     = { item = 208, texture = 20 },
        },
        female = {
            accessory = { item = 0, texture = 0 },
            shoes     = { item = 35, texture = 0 },
            ear       = { item = -1, texture = -1 },
            glass     = { item = 0, texture = -1 },
            backpack  = { item = 0, texture = 0 },
            watch     = { item = -1, texture = -1 },
            arms      = { item = 14, texture = 0 },
            torso     = { item = 212, texture = 20 },
            pants     = { item = 91, texture = 20 },
            bracelet  = { item = -1, texture = -1 },
            vest      = { item = 0, texture = 0 },
            decals    = { item = 0, texture = 0 },
            tshirt    = { item = 3, texture = 0 },
            hat       = { item = -1, texture = -1 },
            mask      = { item = 0, texture = 0 },
        },
    },
}

local function pvpText( key, ... )
    return PvpTranslations.get( key, ... )
end

local function isSameCompetitiveMatchId( a, b )
    if not a or not b then return true end
    return tostring( a ) == tostring( b )
end

local function getCompetitiveEventRoundNumber( data )
    return math.floor( tonumber( data and data.roundNumber ) or 0 )
end

local function isStaleCompetitiveRoundEvent( data )
    local eventRound = getCompetitiveEventRoundNumber( data )
    return eventRound > 0 and currentCompetitiveRoundNumber > 0 and eventRound < currentCompetitiveRoundNumber
end

local function setCompetitiveFullHealth( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedMaxHealth( ped, COMPETITIVE_PED_MAX_HEALTH )
    SetEntityHealth( ped, COMPETITIVE_PED_MAX_HEALTH )
end

local function restoreCompetitiveCriticalHits( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedSuffersCriticalHits( ped, true )
end

local function saveCompetitiveOriginalArmour( ped )
    if competitiveSavedArmour ~= nil then return end
    if not DoesEntityExist( ped ) then return end

    competitiveSavedArmour = GetPedArmour( ped )
end

local function normalizeCompetitiveArmour( ped )
    if not DoesEntityExist( ped ) then return end

    local armour = GetPedArmour( ped )
    if armour > COMPETITIVE_PED_MAX_ARMOUR then
        SetPedArmour( ped, COMPETITIVE_PED_MAX_ARMOUR )
    end
end

local function restoreCompetitiveOriginalArmour( ped )
    if competitiveSavedArmour == nil then return end

    if DoesEntityExist( ped ) then
        SetPedArmour( ped, competitiveSavedArmour )
    end

    competitiveSavedArmour = nil
end

local function getCompetitivePedUniformGender( ped )
    if DoesEntityExist( ped ) and GetEntityModel( ped ) == COMPETITIVE_FEMALE_PED_MODEL then
        return 'female'
    end

    return 'male'
end

local function getCompetitiveTeamUniformKey()
    return COMPETITIVE_UNIFORM_TEAM_BY_ROLE[ myTeam ]
end

local function applyCompetitiveClothingComponent( ped, componentId, data )
    if type( data ) ~= 'table' then return end

    local item = math.floor( tonumber( data.item ) or 0 )
    local texture = math.floor( tonumber( data.texture ) or 0 )

    SetPedComponentVariation( ped, componentId, item, texture, 1 )
end

local function applyCompetitiveClothingProp( ped, propId, data, clearZeroProps )
    if type( data ) ~= 'table' then
        ClearPedProp( ped, propId )
        return
    end

    local item = math.floor( tonumber( data.item ) or -1 )
    local texture = math.floor( tonumber( data.texture ) or 0 )

    if item < 0 or ( clearZeroProps and item == 0 ) then
        ClearPedProp( ped, propId )
        return
    end

    SetPedPropIndex( ped, propId, item, math.max( 0, texture ), 1 )
end

local function saveCompetitiveOriginalAppearance( ped )
    if competitiveSavedAppearance ~= nil then return end
    if not DoesEntityExist( ped ) then
        competitiveRoundDebug( 'uniform:save-skip', { extra = 'ped_missing' } )
        return
    end

    local appearance = {
        components = {},
        props      = {},
    }

    for _, component in ipairs( COMPETITIVE_CLOTHING_COMPONENTS ) do
        appearance.components[ component.key ] = {
            item    = GetPedDrawableVariation( ped, component.id ),
            texture = GetPedTextureVariation( ped, component.id ),
        }
    end

    for _, prop in ipairs( COMPETITIVE_CLOTHING_PROPS ) do
        appearance.props[ prop.key ] = {
            item    = GetPedPropIndex( ped, prop.id ),
            texture = GetPedPropTextureIndex( ped, prop.id ),
        }
    end

    competitiveSavedAppearance = appearance
end

local function restoreCompetitiveOriginalAppearance( ped )
    if competitiveSavedAppearance == nil then
        competitiveAppliedUniformTeamKey = nil
        return
    end
    if not DoesEntityExist( ped ) then
        competitiveRoundDebug( 'uniform:restore-skip', { extra = 'ped_missing' } )
        return
    end

    for _, component in ipairs( COMPETITIVE_CLOTHING_COMPONENTS ) do
        applyCompetitiveClothingComponent( ped, component.id, competitiveSavedAppearance.components[ component.key ] )
    end

    for _, prop in ipairs( COMPETITIVE_CLOTHING_PROPS ) do
        applyCompetitiveClothingProp( ped, prop.id, competitiveSavedAppearance.props[ prop.key ], false )
    end

    competitiveSavedAppearance = nil
    competitiveAppliedUniformTeamKey = nil
    competitiveRoundDebug( 'uniform:restored' )
end

local function applyCompetitiveTeamUniform( ped )
    ped = ped or PlayerPedId()
    if not DoesEntityExist( ped ) then
        competitiveRoundDebug( 'uniform:skip', { extra = 'ped_missing' } )
        return false
    end

    local teamKey = getCompetitiveTeamUniformKey()
    if not teamKey then
        competitiveRoundDebug( 'uniform:skip', { extra = ( 'team=%s' ):format( tostring( myTeam ) ) } )
        return false
    end

    local gender = getCompetitivePedUniformGender( ped )
    local uniform = COMPETITIVE_TEAM_UNIFORMS[ teamKey ] and COMPETITIVE_TEAM_UNIFORMS[ teamKey ][ gender ]
    if type( uniform ) ~= 'table' then
        competitiveRoundDebug( 'uniform:skip', { extra = ( 'team=%s gender=%s' ):format( tostring( teamKey ), tostring( gender ) ) } )
        return false
    end

    if competitiveAppliedUniformTeamKey and competitiveAppliedUniformTeamKey ~= teamKey then
        restoreCompetitiveOriginalAppearance( ped )
    end

    saveCompetitiveOriginalAppearance( ped )

    for _, component in ipairs( COMPETITIVE_CLOTHING_COMPONENTS ) do
        applyCompetitiveClothingComponent( ped, component.id, uniform[ component.key ] )
    end

    for _, prop in ipairs( COMPETITIVE_CLOTHING_PROPS ) do
        applyCompetitiveClothingProp( ped, prop.id, uniform[ prop.key ], true )
    end

    competitiveAppliedUniformTeamKey = teamKey
    competitiveRoundDebug( 'uniform:applied', { extra = ( 'team=%s gender=%s' ):format( teamKey, gender ) } )
    return true
end

local function setCompetitiveDamageProtection( ped, enabled )
    if not DoesEntityExist( ped ) then return end

    enabled = enabled == true
    SetEntityInvincible( ped, enabled )
    SetEntityCanBeDamaged( ped, not enabled )
    SetEntityProofs( ped, enabled, enabled, enabled, enabled, enabled, enabled, enabled, enabled )
    if not enabled then
        restoreCompetitiveCriticalHits( ped )
    end
    LocalPlayer["state"]["Invincible"] = enabled
end

local function restoreCompetitiveCombatDamageState( ped )
    if not DoesEntityExist( ped ) then return end

    setCompetitiveDamageProtection( ped, false )
    restoreCompetitiveCriticalHits( ped )
    normalizeCompetitiveArmour( ped )
end

local function clearCompetitiveLocalMinigameState()
    LocalPlayer["state"]["minigame:active"] = nil
    LocalPlayer["state"]["Invincible"] = false
end

local function restoreDefaultHudAfterCompetitive()
    TriggerEvent( 'hud:syncConfig' )

    CreateThread( function()
        Wait( 150 )
        TriggerEvent( 'hud:Active', true )
    end )
end

local function isCompetitivePedDeadOrDying( ped )
    return IsEntityDead( ped ) or IsPedDeadOrDying( ped, true ) or GetEntityHealth( ped ) <= COMPETITIVE_PED_BASE_HEALTH
end

local function isCompetitiveSurvivalDead()
    if GetResourceState( 'survival' ) ~= 'started' then return false end

    local ok, isDead = pcall( function()
        return exports["survival"]:IsLocalPlayerDead()
    end )

    return ok and isDead == true
end

local function reviveCompetitiveSurvivalState()
    if GetResourceState( 'survival' ) ~= 'started' then return end

    exports["survival"]:Revive( COMPETITIVE_PED_MAX_HEALTH )
    Wait( 100 )
end

local function alignCompetitiveGameplayCamera()
    SetGameplayCamRelativeHeading( 0.0 )
    SetGameplayCamRelativePitch( 0.0, 1.0 )
end

local function reviveCompetitivePedAtCoords( coords, forceNetworkResurrect )
    if not coords then return PlayerPedId() end

    competitiveRoundDebug( 'revive:start', { extra = ( 'target=%.2f,%.2f,%.2f heading=%.2f force=%s' ):format( coords.x, coords.y, coords.z, tonumber( coords.w ) or 0.0, tostring( forceNetworkResurrect == true ) ) } )

    local ped = PlayerPedId()
    local heading = coords.w or ( DoesEntityExist( ped ) and GetEntityHeading( ped ) or 0.0 )
    local shouldNetworkResurrect = forceNetworkResurrect == true

    if DoesEntityExist( ped ) and not shouldNetworkResurrect then
        shouldNetworkResurrect = isCompetitivePedDeadOrDying( ped ) or isCompetitiveSurvivalDead()
    end

    if DoesEntityExist( ped ) and shouldNetworkResurrect then
        competitiveRoundDebug( 'revive:network-resurrect', { extra = ( 'dead=%s survivalDead=%s' ):format( tostring( isCompetitivePedDeadOrDying( ped ) ), tostring( isCompetitiveSurvivalDead() ) ) } )
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, heading )
        Wait( 0 )
        ped = PlayerPedId()
    end

    saveCompetitiveOriginalArmour( ped )
    reviveCompetitiveSurvivalState()
    ped = PlayerPedId()

    if DoesEntityExist( ped ) then
        SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, false, false, false )
        SetEntityHeading( ped, heading )
        alignCompetitiveGameplayCamera()
        setCompetitiveFullHealth( ped )
        restoreCompetitiveCombatDamageState( ped )
        SetEntityVisible( ped, true, false )
        ResetEntityAlpha( ped )
        SetEntityCollision( ped, true, true )
        SetPedCanRagdoll( ped, true )
        SetPedCanRagdollFromPlayerImpact( ped, true )
        ClearPedTasksImmediately( ped )
        ClearPedSecondaryTask( ped )
        SetPedCanSwitchWeapon( ped, true )
        SetCanPedEquipAllWeapons( ped, true )
    end

    competitiveRoundDebug( 'revive:done' )

    return ped
end

local function getCompetitiveHealthPercent( ped )
    local health = math.max( 0, GetEntityHealth( ped ) - COMPETITIVE_PED_BASE_HEALTH )
    local maxHealth = COMPETITIVE_PED_MAX_HEALTH - COMPETITIVE_PED_BASE_HEALTH

    return math.min( 100, math.floor( ( health / maxHealth ) * 100 ) )
end

local function setCompetitiveLastSpawn( coords )
    if not coords then return end
    _G.dminigames_competitive = _G.dminigames_competitive or {}
    _G.dminigames_competitive.lastSpawn = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        w = coords.w or 0.0,
    }
end

local function clearCompetitiveSpawnState()
    _G.dminigames_competitive = nil
end

local function restoreCompetitivePedState()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    if isCompetitivePedDeadOrDying( ped ) then
        local coords = GetEntityCoords( ped )
        local heading = GetEntityHeading( ped )
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, heading )
        ped = PlayerPedId()
    end

    reviveCompetitiveSurvivalState()
    ped = PlayerPedId()

    setCompetitiveFullHealth( ped )
    if isInMatch then
        restoreCompetitiveCombatDamageState( ped )
    else
        setCompetitiveDamageProtection( ped, false )
        restoreCompetitiveCriticalHits( ped )
        restoreCompetitiveOriginalArmour( ped )
        restoreCompetitiveOriginalAppearance( ped )
    end
    FreezeEntityPosition( ped, false )
    SetEntityVisible( ped, true, false )
    ResetEntityAlpha( ped )
    SetEntityCollision( ped, true, true )
    SetPedCanRagdoll( ped, true )
    SetPedCanRagdollFromPlayerImpact( ped, true )
    ClearPedTasksImmediately( ped )
    ClearPedSecondaryTask( ped )
    SetPedCanSwitchWeapon( ped, true )
    SetCanPedEquipAllWeapons( ped, true )
    SetLocalPlayerAsGhost( false )
end

local function clearCompetitiveInputLocks()
    if not competitiveLatencyWarningVisible then
        SetNuiFocus( false, false )
        if type( SetNuiFocusKeepInput ) == 'function' then
            SetNuiFocusKeepInput( false )
        end
    end
    SetPlayerControl( PlayerId(), true, COMPETITIVE_PLAYER_ENABLE_CONTROL_FLAGS )
    RenderScriptCams( false, false, 0, true, false )
    DestroyAllCams( true )
    NewLoadSceneStop()
    ClearFocus()
    competitiveRoundDebug( 'input:clear-locks' )
end

local function cleanCompetitiveRoundArea()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local coords = GetEntityCoords( ped )
    ClearAreaOfVehicles( coords.x, coords.y, coords.z, COMPETITIVE_CLEAN_AREA_DISTANCE, false, false, false, false, false )
    ClearAreaOfEverything( coords.x, coords.y, coords.z, COMPETITIVE_CLEAN_AREA_DISTANCE, false, false, false, false )
end

local function setCompetitiveDeathVoiceMuted( enabled )
    enabled = enabled == true
    if competitiveDeathVoiceMuted == enabled then return end

    if GetResourceState( 'pma-voice' ) ~= 'started' then
        competitiveDeathVoiceMuted = false
        return
    end

    local ok, err
    if enabled then
        ok, err = pcall( function()
            exports['pma-voice']:overrideProximityCheck( function()
                return false
            end )
        end )
    else
        ok, err = pcall( function()
            exports['pma-voice']:resetProximityCheck()
        end )
    end

    if not ok then
        Citizen.Trace( ( '[Competitive][voice] failed to set death mute=%s err=%s\n' ):format( tostring( enabled ), tostring( err ) ) )
        return
    end

    competitiveDeathVoiceMuted = enabled
    competitiveRoundDebug( enabled and 'voice:mute-death' or 'voice:unmute-death' )
end

local function clearCompetitiveBlockingPedState()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    TriggerEvent( 'actions:Cancel' )
    TriggerEvent( 'vrp:removeObjects', 'one' )
    ClearPedTasksImmediately( ped )
    ClearPedSecondaryTask( ped )
    SetEnableHandcuffs( ped, false )
    SetPedCanSwitchWeapon( ped, true )
    SetCanPedEquipAllWeapons( ped, true )
    restoreCompetitiveCriticalHits( ped )
end

local function restoreCompetitivePlayerVisibility( serverId )
    if not serverId then return end

    local player = GetPlayerFromServerId( serverId )
    if player == -1 then return end

    NetworkConcealPlayer( player, false, false )

    local ped = GetPlayerPed( player )
    if DoesEntityExist( ped ) then
        SetEntityVisible( ped, true, false )
        SetEntityCollision( ped, true, true )
        ResetEntityAlpha( ped )
    end
end

local function restoreCompetitivePlayersVisibility()
    for _, player in ipairs( GetActivePlayers() ) do
        NetworkConcealPlayer( player, false, false )

        local ped = GetPlayerPed( player )
        if DoesEntityExist( ped ) then
            SetEntityVisible( ped, true, false )
            ResetEntityAlpha( ped )
            SetEntityCollision( ped, true, true )
        end
    end
end

local function setEntitySilhouette( entity, enabled, r, g, b, a )
    if not DoesEntityExist( entity ) then return end

    SetEntityDrawOutline( entity, enabled == true )
    if enabled then
        SetEntityDrawOutlineColor( r or 80, g or 170, b or 255, a or 255 )
        SetEntityDrawOutlineShader( 1 )
        Citizen.InvokeNative( 1759507165, 'waterreflection' )
    end
end

local function setCompetitiveSameTeamRelationship( teamName )
    if not teamName then return end

    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    if competitiveRelationshipGroup and competitiveRelationshipGroup ~= teamName then
        SetEntityCanBeDamagedByRelationshipGroup( ped, true, GetHashKey( competitiveRelationshipGroup ) )
    end

    AddRelationshipGroup( teamName )
    local teamHash = GetHashKey( teamName )
    SetPedRelationshipGroupHash( ped, teamHash )
    SetEntityCanBeDamagedByRelationshipGroup( ped, false, teamHash )

    competitiveRelationshipGroup = teamName
end

local function clearCompetitiveSameTeamRelationship()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then
        competitiveRelationshipGroup = nil
        return
    end

    if competitiveRelationshipGroup then
        SetEntityCanBeDamagedByRelationshipGroup( ped, true, GetHashKey( competitiveRelationshipGroup ) )
    end

    SetPedRelationshipGroupHash( ped, GetHashKey( 'PLAYER' ) )
    competitiveRelationshipGroup = nil
end

local function clearCompetitiveTeamSilhouettes()
    for serverId, entry in pairs( outlinedTeamEntities ) do
        local ped = type( entry ) == 'table' and entry.ped or entry
        local teamName = type( entry ) == 'table' and entry.team or competitiveRelationshipGroup

        if DoesEntityExist( ped ) then
            setEntitySilhouette( ped, false )
            if teamName then
                SetEntityCanBeDamagedByRelationshipGroup( ped, true, GetHashKey( teamName ) )
            end
            SetPedRelationshipGroupHash( ped, GetHashKey( 'PLAYER' ) )
        else
            local player = GetPlayerFromServerId( tonumber( serverId ) or serverId )
            if player ~= -1 then
                local currentPed = GetPlayerPed( player )
                if DoesEntityExist( currentPed ) then
                    setEntitySilhouette( currentPed, false )
                    if teamName then
                        SetEntityCanBeDamagedByRelationshipGroup( currentPed, true, GetHashKey( teamName ) )
                    end
                    SetPedRelationshipGroupHash( currentPed, GetHashKey( 'PLAYER' ) )
                end
            end
        end
    end

    outlinedTeamEntities = {}

end

RegisterNetEvent( 'pvp.competitive:clearSilhouettes' )
AddEventHandler( 'pvp.competitive:clearSilhouettes', function()
    clearCompetitiveTeamSilhouettes()
    clearCompetitiveSameTeamRelationship()
    setCompetitiveDeathVoiceMuted( false )
end )

AddEventHandler( 'onResourceStop', function( stoppedResource )
    if stoppedResource ~= GetCurrentResourceName() then return end

    competitiveLatencyWarningVisible = false
    competitiveLatencyWarningId = nil
    TriggerEvent( 'pvp.hud:closeLatencyWarning' )
    setCompetitiveDeathVoiceMuted( false )
    restoreCompetitiveOriginalArmour( PlayerPedId() )
    restoreCompetitiveOriginalAppearance( PlayerPedId() )
end )

local function setCompetitiveTeamFromPlayers( players, teamName )
    if type( players ) ~= 'table' then return end

    for _, player in ipairs( players ) do
        local source = type( player ) == 'table' and tonumber( player.source ) or nil
        if source then
            competitivePlayerTeams[ source ] = teamName
        end
    end
end

local function hydrateCompetitiveTeams( data )
    competitivePlayerTeams = {}
    if type( data ) ~= 'table' then return end

    if type( data.team1 ) == 'table' then
        setCompetitiveTeamFromPlayers( data.team1.players, 'TeamA' )
    end
    if type( data.team2 ) == 'table' then
        setCompetitiveTeamFromPlayers( data.team2.players, 'TeamB' )
    end
end

local function applyCompetitiveTeamSilhouettes()
    clearCompetitiveTeamSilhouettes()

    local localSource = GetPlayerServerId( PlayerId() )
    local localTeam = competitivePlayerTeams[ localSource ]
    if not localTeam then
        clearCompetitiveSameTeamRelationship()
        return
    end

    AddRelationshipGroup( localTeam )
    local localTeamHash = GetHashKey( localTeam )

    for _, player in ipairs( GetActivePlayers() ) do
        local serverId = GetPlayerServerId( player )
        local playerTeam = competitivePlayerTeams[ serverId ]

        if serverId ~= localSource then
            local ped = GetPlayerPed( player )
            if DoesEntityExist( ped ) and playerTeam == localTeam then
                setEntitySilhouette( ped, true, 80, 170, 255, 255 )
                SetPedRelationshipGroupHash( ped, localTeamHash )
                SetEntityCanBeDamagedByRelationshipGroup( ped, false, localTeamHash )
                outlinedTeamEntities[ serverId ] = { ped = ped, team = localTeam }
            elseif DoesEntityExist( ped ) then
                setEntitySilhouette( ped, false )
            end
        end
    end

    setCompetitiveSameTeamRelationship( localTeam )
end

local function normalizeCompetitiveWeaponSkinComponent( component )
    if not component or component == false or component == '' then return nil end
    return component
end

local function getCompetitiveLocalWeaponSkinComponent( weaponName )
    if GetResourceState( 'new_hub' ) ~= 'started' then return nil end

    local ok, component = pcall( function()
        return exports.new_hub:CheckWeaponSkins( weaponName )
    end )

    component = ok and normalizeCompetitiveWeaponSkinComponent( component ) or nil
    if component then return component end

    ok, component = pcall( function()
        return exports.new_hub:GetGroupSkins( weaponName )
    end )

    return ok and normalizeCompetitiveWeaponSkinComponent( component ) or nil
end

local function applyCompetitiveWeaponSkin( ped, weaponHash, weaponName )
    local component = getCompetitiveLocalWeaponSkinComponent( weaponName )
    if not component then return end

    local componentHash = type( component ) == 'number' and component or joaat( tostring( component ) )
    GiveWeaponComponentToPed( ped, weaponHash, componentHash )
    competitiveRoundDebug( 'weapon:skin-applied', { extra = ( 'component=%s' ):format( tostring( component ) ) } )
end

local function getCompetitiveDefaultWeaponData()
    return {
        id       = 'rifle',
        key      = 'rifle',
        name     = COMPETITIVE_WEAPON_HUD or COMPETITIVE_WEAPON,
        weapon   = COMPETITIVE_WEAPON,
        hud      = COMPETITIVE_WEAPON_HUD,
        image    = COMPETITIVE_WEAPON_IMAGE,
        ammo     = COMPETITIVE_AMMO or 300,
        slotItem = 'weapon_carbinerifle',
    }
end

local currentCompetitiveWeaponData = getCompetitiveDefaultWeaponData()
local weaponDisplayName = currentCompetitiveWeaponData.hud or currentCompetitiveWeaponData.name

local function normalizeCompetitiveWeaponData( data )
    local fallback = getCompetitiveDefaultWeaponData()
    data = type( data ) == 'table' and data or {}

    return {
        id       = data.id or fallback.id,
        key      = data.key or data.id or fallback.key,
        name     = data.name or fallback.name,
        weapon   = data.weapon or fallback.weapon,
        hud      = data.hud or data.name or fallback.hud,
        image    = data.image or fallback.image,
        ammo     = tonumber( data.ammo ) or fallback.ammo,
        slotItem = data.slotItem or fallback.slotItem,
    }
end

local function setCurrentCompetitiveWeaponData( data )
    currentCompetitiveWeaponData = normalizeCompetitiveWeaponData( data )
    weaponDisplayName = currentCompetitiveWeaponData.hud or currentCompetitiveWeaponData.name or currentCompetitiveWeaponData.weapon
end

local function resetCurrentCompetitiveWeaponData()
    setCurrentCompetitiveWeaponData( nil )
end

local function getCurrentCompetitiveWeaponName()
    return currentCompetitiveWeaponData.weapon or COMPETITIVE_WEAPON
end

local function getCurrentCompetitiveWeaponHash()
    return joaat( getCurrentCompetitiveWeaponName() )
end

local function getCurrentCompetitiveWeaponAmmo()
    return tonumber( currentCompetitiveWeaponData.ammo ) or COMPETITIVE_AMMO or 300
end

local function giveCompetitiveWeapon()
    local ped = PlayerPedId()
    local weaponName = getCurrentCompetitiveWeaponName()
    local weaponHash = getCurrentCompetitiveWeaponHash()
    local ammo = getCurrentCompetitiveWeaponAmmo()

    competitiveRoundDebug( 'weapon:give-start' )
    SetCanPedEquipAllWeapons( ped, true )
    GiveWeaponToPed( ped, weaponHash, ammo, true, false )
    applyCompetitiveWeaponSkin( ped, weaponHash, weaponName )
    Wait( 100 )
    SetCanPedEquipAllWeapons( ped, true )
    SetPedAmmo( ped, weaponHash, ammo )

    local maxClip = GetMaxAmmoInClip( ped, weaponHash, true )
    if maxClip and maxClip > 0 then
        SetAmmoInClip( ped, weaponHash, math.min( maxClip, ammo ) )
    end

    SetCurrentPedWeapon( ped, weaponHash, true )
    SetPedCurrentWeaponVisible( ped, true, false, false, false )
    SetWeaponsNoAutoswap( true )
    competitiveRoundDebug( 'weapon:give-done' )
end

local currentRoundWins          = { TeamA = 0, TeamB = 0 }
local currentTeamNames          = { TeamA = 'TeamA', TeamB = 'TeamB' }
local matchStartVisibleUntil    = 0
local weaponHudEnabled          = false
local roundFreezeUntil          = 0
local tournamentValidationActive = false
local tournamentValidationThreadRunning = false
local competitiveDead           = false
local competitiveDeadToken      = 0
local competitiveWeaponPrepareToken = 0
local competitiveScoreboardPlayers = {}
local competitiveScoreboardOpen = false
local competitiveScoreboardControlsRunning = false
local competitiveScoreboardLastRequestAt = 0
local competitiveStaminaRunning = false
local currentCompetitiveHudKills = 0
local competitivePauseActive = false
local competitivePauseControlsRunning = false
local competitivePauseMenuBlockRunning = false
local competitivePauseInputLastAt = 0
local competitivePauseVoteType = nil
local competitivePauseVoteCanVote = false
local competitivePauseVoteLastAt = 0

local function getCompetitiveWeaponHudAmmo( ped, weaponHash )
    local _, clipAmmo = GetAmmoInClip( ped, weaponHash )
    local maxClipAmmo = GetMaxAmmoInClip( ped, weaponHash, true )

    clipAmmo = tonumber( clipAmmo ) or 0
    maxClipAmmo = tonumber( maxClipAmmo ) or clipAmmo

    if maxClipAmmo < clipAmmo then
        maxClipAmmo = clipAmmo
    end

    return clipAmmo, maxClipAmmo
end

competitiveRoundDebug = function( stage, data )
    data = type( data ) == 'table' and data or {}

    local ped = PlayerPedId()
    local pedExists = DoesEntityExist( ped )
    local coords = pedExists and GetEntityCoords( ped ) or vector3( 0.0, 0.0, 0.0 )
    local weaponHash = getCurrentCompetitiveWeaponHash()
    local hasWeapon = pedExists and HasPedGotWeapon( ped, weaponHash, false ) or false
    local ammo = hasWeapon and GetAmmoInPedWeapon( ped, weaponHash ) or 0
    local selectedWeapon = pedExists and GetSelectedPedWeapon( ped ) or 0
    local frozen = false
    local nuiFocused = 'unknown'

    if pedExists and type( IsEntityPositionFrozen ) == 'function' then
        local ok, value = pcall( IsEntityPositionFrozen, ped )
        frozen = ok and value == true
    end

    if type( IsNuiFocused ) == 'function' then
        local ok, value = pcall( IsNuiFocused )
        if ok then
            nuiFocused = tostring( value )
        end
    end

    Citizen.Trace( ( '[Competitive][round-debug] stage=%s t=%d src=%d match=%s eventMatch=%s round=%s currentRound=%d token=%d inMatch=%s matchReady=%s spawnReady=%s pending=%s team=%s dead=%s weaponHud=%s freezeUntil=%d frozen=%s control=%s health=%d coords=%.2f,%.2f,%.2f hasWeapon=%s selectedWeapon=%s ammo=%d nuiFocus=%s invincibleState=%s extra=%s\n' ):format(
        tostring( stage ),
        GetGameTimer(),
        GetPlayerServerId( PlayerId() ),
        tostring( currentCompetitiveMatchId ),
        tostring( data.matchId ),
        tostring( data.roundNumber ),
        currentCompetitiveRoundNumber,
        competitiveRoundStartToken,
        tostring( isInMatch ),
        tostring( competitiveMatchStartReady ),
        tostring( competitiveRoundSpawnReady ),
        tostring( pendingCompetitiveRoundStart ~= nil ),
        tostring( myTeam ),
        tostring( competitiveDead ),
        tostring( weaponHudEnabled ),
        math.floor( roundFreezeUntil or 0 ),
        tostring( frozen ),
        tostring( IsPlayerControlOn( PlayerId() ) ),
        pedExists and GetEntityHealth( ped ) or 0,
        coords.x,
        coords.y,
        coords.z,
        tostring( hasWeapon ),
        tostring( selectedWeapon ),
        ammo,
        nuiFocused,
        tostring( LocalPlayer["state"]["Invincible"] ),
        tostring( data.extra or '' )
    ) )
end

AddEventHandler( 'pvp.competitive:damageDebug', function( data )
    data = type( data ) == 'table' and data or {}
    competitiveRoundDebug( data.stage or 'damage:event', {
        matchId     = currentCompetitiveMatchId,
        roundNumber = currentCompetitiveRoundNumber,
        extra       = tostring( data.extra or '' ),
    } )
end )

-- =============================================
-- Helpers NUI (action-based para HUD in-game)
-- =============================================
-- O NUI do PvP vive no resource `hud` (Redux slice `pvp` em hud/web).
-- `SendNUIMessage` aqui no `dminigames` cairia no NUI do dminigames e não na
-- UI certa, então repassamos via `TriggerEvent('pvp.hud:<action>', payload)`
-- — handlers locais ao client, no mesmo cliente, cross-resource.
-- A ponte está em `hud/client/hud/pvp.lua`.

-- Eventos chamados em loop de polling — não logar pra não poluir F8
local NOISY_EVENTS = {
    updateHudWeapon = true,
    updateHudStatus = true,
    updateCountdown = true,
}

local function normalizeHudAvatar( avatar )
    if type( avatar ) ~= 'string' then return nil end

    avatar = avatar:gsub( '^%s+', '' ):gsub( '%s+$', '' )
    if avatar == '' then return nil end

    return avatar
end

local function copyHudPlayer( player )
    if type( player ) ~= 'table' then return player end

    local copy = {}
    for key, value in pairs( player ) do
        copy[ key ] = value
    end

    copy.avatar = normalizeHudAvatar( copy.avatar )
    return copy
end

local function copyHudPlayers( players )
    if type( players ) ~= 'table' then return {} end

    local list = {}
    for _, player in ipairs( players ) do
        table.insert( list, copyHudPlayer( player ) )
    end

    return list
end

local function copyHudTeam( team )
    if type( team ) ~= 'table' then return team end

    local copy = {}
    for key, value in pairs( team ) do
        if key ~= 'players' then
            copy[ key ] = value
        end
    end

    copy.players = copyHudPlayers( team.players )
    return copy
end

local function normalizeHudPayload( action, payload )
    if action == 'openScoreboard' or action == 'updateGunGameRankings' then
        return copyHudPlayers( payload )
    end

    if action == 'openMatchStart' and type( payload ) == 'table' then
        local copy = {}
        for key, value in pairs( payload ) do
            copy[ key ] = value
        end

        copy.team1 = copyHudTeam( payload.team1 )
        copy.team2 = copyHudTeam( payload.team2 )
        return copy
    end

    if action == 'openMatchResult' and type( payload ) == 'table' then
        local copy = {}
        for key, value in pairs( payload ) do
            copy[ key ] = value
        end

        copy.topPlayers = copyHudPlayers( payload.topPlayers )
        return copy
    end

    if action == 'openTournamentResult' and type( payload ) == 'table' then
        local copy = {}
        for key, value in pairs( payload ) do
            copy[ key ] = value
        end

        copy.players = copyHudPlayers( payload.players )
        copy.team = copyHudTeam( payload.team )
        return copy
    end

    return payload
end

local function nuiHud( action, payload )
    payload = normalizeHudPayload( action, payload )

    if not NOISY_EVENTS[ action ] then
        print( ('[Competitive][NUI] -> pvp.hud:%s'):format( action ) )
    end
    TriggerEvent( 'pvp.hud:' .. action, payload )
end

local function setCompetitivePauseGlobal( enabled )
    if enabled == true then
        _G.dminigames_competitive = _G.dminigames_competitive or {}
        _G.dminigames_competitive.pauseActive = true
        return
    end

    if _G.dminigames_competitive then
        _G.dminigames_competitive.pauseActive = false
    end
end

local function setCompetitivePauseState( enabled )
    competitivePauseActive = enabled == true
    setCompetitivePauseGlobal( competitivePauseActive )

    if not competitivePauseActive then
        local ped = PlayerPedId()
        if DoesEntityExist( ped ) and not competitiveDead then
            if GetGameTimer() >= ( roundFreezeUntil or 0 ) then
                FreezeEntityPosition( ped, false )
            end
            restoreCompetitiveCombatDamageState( ped )
        end
        return
    end

    if competitivePauseControlsRunning then return end

    competitivePauseControlsRunning = true
    CreateThread( function()
        while isInMatch and competitivePauseActive do
            local ped = PlayerPedId()

            if DoesEntityExist( ped ) then
                FreezeEntityPosition( ped, true )
                setCompetitiveDamageProtection( ped, true )
            end

            DisablePlayerFiring( PlayerId(), true )
            DisableControlAction( 0, 21, true )
            DisableControlAction( 0, 22, true )
            DisableControlAction( 0, 24, true )
            DisableControlAction( 0, 25, true )
            DisableControlAction( 0, 30, true )
            DisableControlAction( 0, 31, true )
            DisableControlAction( 0, 37, true )
            DisableControlAction( 0, 45, true )
            DisableControlAction( 0, 140, true )
            DisableControlAction( 0, 141, true )
            DisableControlAction( 0, 142, true )
            DisableControlAction( 0, 257, true )
            Wait( 0 )
        end

        setCompetitivePauseGlobal( false )
        local ped = PlayerPedId()
        if DoesEntityExist( ped ) and not competitiveDead then
            if GetGameTimer() >= ( roundFreezeUntil or 0 ) then
                FreezeEntityPosition( ped, false )
            end
            restoreCompetitiveCombatDamageState( ped )
        end

        competitivePauseControlsRunning = false
    end )
end

local function clearCompetitivePauseState()
    competitivePauseVoteType = nil
    competitivePauseVoteCanVote = false
    setCompetitivePauseState( false )
    nuiHud( 'closePauseOverlay' )
end

local function setCompetitiveHudKills( kills, force )
    kills = math.max( 0, math.floor( tonumber( kills ) or 0 ) )
    if not force and currentCompetitiveHudKills == kills then return end

    currentCompetitiveHudKills = kills
    nuiHud( 'updateHudKills', kills )
end

local function setCompetitiveHudSlotItems( enabled )
    if enabled ~= true then
        nuiHud( 'updateHudSlotItems', {} )
        return
    end

    nuiHud( 'updateHudSlotItems', {
        {
            slot   = 1,
            name   = currentCompetitiveWeaponData.slotItem or 'weapon_carbinerifle',
            image  = currentCompetitiveWeaponData.image,
            active = true,
        },
    } )
end

local function sendMatchStartToHud( data )
    nuiHud( 'openMatchStart', {
        team1   = data.team1,
        team2   = data.team2,
        mapName = data.mapName,
        mode    = data.mode,
    } )
end

local function buildTournamentBracketHudPayload( data )
    if type( data ) ~= 'table' then return nil end

    local payload = {}
    for key, value in pairs( data ) do
        if key ~= 'resultBySource' and key ~= 'teamIdByRole' then
            payload[ key ] = value
        end
    end

    local mySource = GetPlayerServerId( PlayerId() )
    local resultBySource = type( data.resultBySource ) == 'table' and data.resultBySource or {}
    local result = resultBySource[ tostring( mySource ) ] or resultBySource[ mySource ]

    local teamIdByRole = type( data.teamIdByRole ) == 'table' and data.teamIdByRole or {}
    local myTeamId = myTeam and teamIdByRole[ myTeam ] or nil
    local winnerTeamId = data.winnerTeamId and tostring( data.winnerTeamId ) or nil

    if result ~= 'victory' and result ~= 'defeat' and myTeamId and winnerTeamId then
        result = tostring( myTeamId ) == winnerTeamId and 'victory' or 'defeat'
    end

    if result ~= 'victory' and result ~= 'defeat' then
        return nil
    end

    payload.result = result
    if myTeamId then
        payload.highlightedTeamId = tostring( myTeamId )
    end

    return payload
end

local function buildTournamentResultPlayers( topPlayers, teamRole )
    if type( topPlayers ) ~= 'table' or not teamRole then return {} end

    local players = {}
    for index, player in ipairs( topPlayers ) do
        local source = tonumber( player and player.source )
        if source and competitivePlayerTeams[ source ] == teamRole then
            table.insert( players, {
                id       = tostring( player.id or source or index ),
                playerId = player.playerId,
                name     = player.name,
                avatar   = player.avatar,
                level    = player.level,
            } )
        end
    end

    return players
end

local function buildTournamentResultHudPayload( tournamentData, myStats, topPlayers )
    local bracketPayload = buildTournamentBracketHudPayload( tournamentData )
    if not bracketPayload then return nil end

    myStats = type( myStats ) == 'table' and myStats or {}

    local teamRole = myStats.teamRaw or myTeam
    local teamName = teamRole and currentTeamNames[ teamRole ] or nil
    local players = buildTournamentResultPlayers( topPlayers, teamRole )

    return {
        result       = bracketPayload.result,
        isVictory    = bracketPayload.result == 'victory',
        stage        = bracketPayload.currentStage,
        currentStage = bracketPayload.currentStage,
        gameMode     = myStats.gameMode or 'TEAM_DEATHMATCH',
        teamName     = teamName,
        team         = {
            name    = teamName,
            players = players,
        },
        players      = players,
        stats        = {
            kills              = myStats.kills or 0,
            deaths             = myStats.deaths or 0,
            assists            = myStats.assists or 0,
            headshotPercentage = myStats.headshotPercentage or '0%',
            points             = myStats.points or 0,
            currentLevel       = myStats.currentLevel or myStats.level or 0,
            currentXp          = myStats.currentXp or 0,
            maxXp              = myStats.maxXp or 1000,
        },
    }
end

local competitiveExitMatchResponseHandler = nil

local function clearCompetitiveExitConfirmation()
    if competitiveExitMatchResponseHandler then
        RemoveEventHandler( competitiveExitMatchResponseHandler )
        competitiveExitMatchResponseHandler = nil
    end
end

local function clearCompetitiveLatencyWarning()
    competitiveLatencyWarningVisible = false
    competitiveLatencyWarningId = nil
    nuiHud( 'closeLatencyWarning' )
end

AddEventHandler( 'pvp.callback:latencyWarningResponse', function( data )
    if not competitiveLatencyWarningVisible then return end

    local alertId = competitiveLatencyWarningId
    clearCompetitiveLatencyWarning()
    if not isInMatch or not alertId then return end

    TriggerServerEvent( 'pvp.competitive:latencyWarningResponse', {
        alertId = alertId,
        continuePlaying = type( data ) ~= 'table' or data.continuePlaying ~= false,
    })
end )

local function requestCompetitiveExitConfirmation( cb )
    clearCompetitiveExitConfirmation()

    competitiveExitMatchResponseHandler = AddEventHandler( 'pvp.callback:exitMatchResponse', function( data )
        clearCompetitiveExitConfirmation()
        cb( isInMatch and type( data ) == 'table' and data.confirmed == true )
    end )

    nuiHud( 'openExitMatch', {
        title = pvpText( 'exit_match_title' ),
        description = pvpText( 'exit_match_description' ),
        confirmLabel = pvpText( 'exit_match_confirm' ),
        cancelLabel = pvpText( 'exit_match_cancel' ),
    } )
end

local function sendCompetitivePauseCallbackResponse( requestId, success, message )
    if not requestId then return end

    TriggerEvent( 'pvp.hud:callbackResponse', requestId, {
        success = success == true,
        message = success == true and nil or message,
    })
end

AddEventHandler( 'pvp.callback:pauseRequest', function( data, requestId )
    if not isInMatch then
        sendCompetitivePauseCallbackResponse( requestId, false, pvpText( 'not_in_this_mode' ) )
        return
    end

    local success, message = RPC.pvp_pauseRequest()
    sendCompetitivePauseCallbackResponse( requestId, success, message )
end )

AddEventHandler( 'pvp.callback:pauseResumeRequest', function( data, requestId )
    if not isInMatch then
        sendCompetitivePauseCallbackResponse( requestId, false, pvpText( 'not_in_this_mode' ) )
        return
    end

    local success, message = RPC.pvp_pauseResumeRequest()
    sendCompetitivePauseCallbackResponse( requestId, success, message )
end )

AddEventHandler( 'pvp.callback:pauseVote', function( data, requestId )
    if not isInMatch then
        sendCompetitivePauseCallbackResponse( requestId, false, pvpText( 'not_in_this_mode' ) )
        return
    end

    data = type( data ) == 'table' and data or {}
    local success, message = RPC.pvp_pauseVote( data.type, data.vote )
    sendCompetitivePauseCallbackResponse( requestId, success, message )
end )

AddEventHandler( 'pvp.callback:tournamentBracketBackToLobby', function( data, requestId )
    nuiHud( 'closeTournamentBracketResult' )
    nuiHud( 'closeMatchResult' )
    restoreDefaultHudAfterCompetitive()
    TriggerServerEvent( 'pvp.server:openPanel', 'tournament_result' )
    sendCompetitivePauseCallbackResponse( requestId, true )
end )

local function setCompetitivePauseVoteState( action, payload )
    payload = type( payload ) == 'table' and payload or {}

    if action == 'openPauseStartVote' then
        competitivePauseVoteType = 'start'
    elseif action == 'openPauseResumeVote' then
        competitivePauseVoteType = 'resume'
    elseif action == 'closePauseOverlay' or action == 'openOpponentPauseActive' then
        competitivePauseVoteType = nil
        competitivePauseVoteCanVote = false
        return
    elseif action ~= 'updatePauseOverlay' then
        return
    end

    if not competitivePauseVoteType then return end

    competitivePauseVoteCanVote = payload.canVote == true and payload.voted == nil
end

local function requestCompetitivePauseVoteFromInput( vote )
    if not isInMatch or not competitivePauseVoteType or not competitivePauseVoteCanVote then return end
    if vote ~= 'yes' and vote ~= 'no' then return end

    local now = GetGameTimer()
    if now - competitivePauseVoteLastAt < 500 then return end
    competitivePauseVoteLastAt = now

    local voteType = competitivePauseVoteType
    CreateThread( function()
        RPC.pvp_pauseVote( voteType, vote )
    end )
end

local function requestCompetitivePauseFromInput()
    if not isInMatch or competitiveDead then return end

    local now = GetGameTimer()
    if now - competitivePauseInputLastAt < 1000 then return end
    competitivePauseInputLastAt = now

    local shouldRequestResume = competitivePauseActive == true
    CreateThread( function()
        if shouldRequestResume then
            RPC.pvp_pauseResumeRequest()
            return
        end

        RPC.pvp_pauseRequest()
    end )
end

local function setCompetitiveScoreboardPlayers( players )
    competitiveScoreboardPlayers = {}
    if type( players ) == 'table' then
        for _, player in ipairs( players ) do
            if type( player ) == 'table' then
                table.insert( competitiveScoreboardPlayers, player )
            end
        end
    end

    local mySource = GetPlayerServerId( PlayerId() )
    for _, player in ipairs( competitiveScoreboardPlayers ) do
        if tonumber( player.source ) == mySource then
            setCompetitiveHudKills( player.kills )
            break
        end
    end

    if competitiveScoreboardOpen then
        nuiHud( 'openScoreboard', competitiveScoreboardPlayers )
    end
end

local function requestCompetitiveScoreboard( force )
    local now = GetGameTimer()
    if not force and now - competitiveScoreboardLastRequestAt < COMPETITIVE_SCOREBOARD_REFRESH_MS then return end

    competitiveScoreboardLastRequestAt = now
    TriggerServerEvent( 'pvp.competitive:requestScoreboard' )
end

local function openCompetitiveScoreboard()
    if competitiveScoreboardOpen then return end

    competitiveScoreboardOpen = true
    requestCompetitiveScoreboard( true )
    nuiHud( 'openScoreboard', competitiveScoreboardPlayers )
end

local function closeCompetitiveScoreboard()
    if not competitiveScoreboardOpen then return end

    nuiHud( 'closeScoreboard' )
    competitiveScoreboardOpen = false
end

RegisterCommand( '+dminigames_competitive_scoreboard', function()
    if not (isInMatch or LocalPlayer['state']['dminigames:spectating'] == 'pvp') then return end
    openCompetitiveScoreboard()
end, false )

RegisterCommand( '-dminigames_competitive_scoreboard', function()
    closeCompetitiveScoreboard()
end, false )

RegisterKeyMapping( '+dminigames_competitive_scoreboard', pvpText( 'scoreboard_key_mapping' ), 'keyboard', 'TAB' )

local function startCompetitiveScoreboardControls()
    if competitiveScoreboardControlsRunning then return end

    competitiveScoreboardControlsRunning = true
    CreateThread( function()
        while isInMatch do
            DisableControlAction( 0, 37, true )
            if IsDisabledControlJustPressed( 0, 37 ) then
                openCompetitiveScoreboard()
            elseif IsDisabledControlJustReleased( 0, 37 ) then
                closeCompetitiveScoreboard()
            end

            if competitiveScoreboardOpen then
                requestCompetitiveScoreboard( false )
            end
            Wait( 0 )
        end

        closeCompetitiveScoreboard()
        competitiveScoreboardControlsRunning = false
    end )
end

---Teleporta o jogador de volta ao NPC do PVP e reseta os elementos in-game do HUD competitivo.
---Não fecha a tela de resultado — em partida normal ela fecha sozinha após 15s (pvp.competitive:matchEnd).
---Para saída voluntária (G), chame nuiHud('closeMatchResult') antes desta função.
local function startCompetitivePauseMenuBlock()
    if competitivePauseMenuBlockRunning then return end

    competitivePauseMenuBlockRunning = true
    CreateThread( function()
        while isInMatch do
            DisableControlAction( 0, 199, true )
            DisableControlAction( 2, 199, true )

            if competitivePauseVoteType and competitivePauseVoteCanVote then
                DisableControlAction( 0, 246, true )
                DisableControlAction( 2, 246, true )
                DisableControlAction( 0, 303, true )
                DisableControlAction( 2, 303, true )

                if IsDisabledControlJustPressed( 0, 246 ) or IsDisabledControlJustPressed( 2, 246 ) then
                    requestCompetitivePauseVoteFromInput( 'yes' )
                elseif IsDisabledControlJustPressed( 0, 303 ) or IsDisabledControlJustPressed( 2, 303 ) then
                    requestCompetitivePauseVoteFromInput( 'no' )
                end
            end

            if IsDisabledControlJustPressed( 0, 199 ) or IsDisabledControlJustPressed( 2, 199 ) then
                requestCompetitivePauseFromInput()
            end

            if IsPauseMenuActive() then
                SetPauseMenuActive( false )
            end

            Wait( 0 )
        end

        competitivePauseMenuBlockRunning = false
    end )
end

local function returnToCompetitiveNpc( data )
    clearCompetitivePauseState()
    nuiHud( 'hideHud' )
    nuiHud( 'hideCountdown' )
    nuiHud( 'hideKillNotification' )
    nuiHud( 'clearKillFeed' )
    closeCompetitiveScoreboard()
    nuiHud( 'closeMatchStart' )

    local returnCoords = type( data ) == 'table' and data.returnCoords or nil
    if not ( returnCoords and returnCoords.x and returnCoords.y and returnCoords.z ) then
        returnCoords = PVP_NPC_COORDS
    end

    -- Teleporta de volta ao NPC (servidor já mudou o bucket antes de enviar o evento)
    local ped = PlayerPedId()
    if DoesEntityExist( ped ) and returnCoords then
        SetEntityCoordsNoOffset( ped, returnCoords.x, returnCoords.y, returnCoords.z, false, false, false )
        SetEntityHeading( ped, returnCoords.w or PVP_NPC_COORDS.w )
    end
end

local function hudScore()
    nuiHud( 'updateHudScore', {
        team1     = currentRoundWins.TeamA,
        team2     = currentRoundWins.TeamB,
        team1Name = currentTeamNames.TeamA,
        team2Name = currentTeamNames.TeamB,
    })
end

local function getCurrentScoreRoundLabel()
    local teamAWins = tonumber( currentRoundWins.TeamA ) or 0
    local teamBWins = tonumber( currentRoundWins.TeamB ) or 0
    local playedRounds = teamAWins + teamBWins

    return pvpText( 'round_label', tostring( math.max( 1, playedRounds ) ) )
end

local function updateCurrentTeamNames( data )
    if type( data ) ~= 'table' then return end

    if type( data.teamNames ) == 'table' then
        currentTeamNames.TeamA = data.teamNames.TeamA or currentTeamNames.TeamA
        currentTeamNames.TeamB = data.teamNames.TeamB or currentTeamNames.TeamB
        return
    end

    if type( data.team1 ) == 'table' and data.team1.name then
        currentTeamNames.TeamA = data.team1.name
    end

    if type( data.team2 ) == 'table' and data.team2.name then
        currentTeamNames.TeamB = data.team2.name
    end
end

local function holdCompetitiveFreezeUntil( endsAt )
    roundFreezeUntil = math.max( roundFreezeUntil, endsAt or 0 )
    competitiveRoundDebug( 'freeze:hold', { extra = ( 'endsAt=%d' ):format( math.floor( roundFreezeUntil ) ) } )

    CreateThread( function()
        while isInMatch and GetGameTimer() < roundFreezeUntil do
            local ped = PlayerPedId()

            FreezeEntityPosition( ped, true )
            DisablePlayerFiring( PlayerId(), true )
            DisableControlAction( 0, 24, true )
            DisableControlAction( 0, 25, true )
            DisableControlAction( 0, 37, true )
            DisableControlAction( 0, 45, true )
            DisableControlAction( 0, 140, true )
            DisableControlAction( 0, 141, true )
            DisableControlAction( 0, 142, true )
            DisableControlAction( 0, 257, true )
            Wait( 0 )
        end
    end )
end

local function setTournamentValidationState( active )
    tournamentValidationActive = active == true
    if not tournamentValidationActive or tournamentValidationThreadRunning then return end

    tournamentValidationThreadRunning = true
    CreateThread( function()
        while isInMatch and tournamentValidationActive do
            local ped = PlayerPedId()
            if DoesEntityExist( ped ) then
                FreezeEntityPosition( ped, true )
                setCompetitiveDamageProtection( ped, true )
            end

            DisablePlayerFiring( PlayerId(), true )
            DisableControlAction( 0, 21, true )
            DisableControlAction( 0, 22, true )
            DisableControlAction( 0, 24, true )
            DisableControlAction( 0, 25, true )
            DisableControlAction( 0, 30, true )
            DisableControlAction( 0, 31, true )
            DisableControlAction( 0, 32, true )
            DisableControlAction( 0, 33, true )
            DisableControlAction( 0, 34, true )
            DisableControlAction( 0, 35, true )
            DisableControlAction( 0, 37, true )
            DisableControlAction( 0, 45, true )
            DisableControlAction( 0, 140, true )
            DisableControlAction( 0, 141, true )
            DisableControlAction( 0, 142, true )
            DisableControlAction( 0, 257, true )
            Wait( 0 )
        end

        tournamentValidationThreadRunning = false
    end )
end

local function clearCompetitiveWeaponState()
    competitiveWeaponPrepareToken = competitiveWeaponPrepareToken + 1
    TriggerEvent( 'inventory:CleanWeapons' )

    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponHash = getCurrentCompetitiveWeaponHash()
    SetCurrentPedWeapon( ped, joaat( 'WEAPON_UNARMED' ), true )
    RemoveWeaponFromPed( ped, weaponHash )
    RemoveAllPedWeapons( ped, true )
end

local function prepareCompetitiveWeaponForRound()
    competitiveWeaponPrepareToken = competitiveWeaponPrepareToken + 1
    local token = competitiveWeaponPrepareToken
    competitiveRoundDebug( 'weapon:prepare-scheduled', { extra = ( 'prepareToken=%d' ):format( token ) } )

    CreateThread( function()
        Wait( 100 )

        if isInMatch and token == competitiveWeaponPrepareToken and not competitiveDead then
            competitiveRoundDebug( 'weapon:prepare-apply', { extra = ( 'prepareToken=%d' ):format( token ) } )
            giveCompetitiveWeapon()
        else
            competitiveRoundDebug( 'weapon:prepare-skip', { extra = ( 'prepareToken=%d current=%d' ):format( token, competitiveWeaponPrepareToken ) } )
        end
    end )
end

local function setCompetitiveDeadState( enabled )
    competitiveDead = enabled == true
    competitiveDeadToken = competitiveDeadToken + 1
    competitiveRoundDebug( 'dead-state:set', { extra = ( 'enabled=%s deadToken=%d' ):format( tostring( competitiveDead ), competitiveDeadToken ) } )
    setCompetitiveDeathVoiceMuted( competitiveDead )

    if competitiveClientInstance then
        competitiveClientInstance:setDownedState( competitiveDead )
    end
end

-- =============================================
-- Threads de polling de HUD (health/armor/ammo)
-- =============================================

local function startHudPolling()
    -- Health / Armor
    CreateThread( function()
        while isInMatch do
            local ped    = PlayerPedId()
            local hp     = getCompetitiveHealthPercent( ped )
            local armor  = GetPedArmour( ped )
            nuiHud( 'updateHudStatus', { health = hp, armor = armor } )
            Wait( 500 )
        end
    end )

    -- Weapon / Ammo
    CreateThread( function()
        while isInMatch do
            local ped        = PlayerPedId()
            local weapHash   = getCurrentCompetitiveWeaponHash()
            local hasWeapon  = HasPedGotWeapon( ped, weapHash, false )
            if hasWeapon and weaponHudEnabled then
                local ammo, maxAmmo = getCompetitiveWeaponHudAmmo( ped, weapHash )
                nuiHud( 'updateHudWeapon', {
                    name    = weaponDisplayName,
                    ammo    = ammo,
                    maxAmmo = maxAmmo,
                    image   = currentCompetitiveWeaponData.image,
                })
            else
                nuiHud( 'updateHudWeapon', nil )  -- null: limpa HUD de arma
            end
            Wait( 200 )
        end
        nuiHud( 'updateHudWeapon', nil )
        setCompetitiveHudSlotItems( false )
    end )
end

local function startCompetitiveStaminaLoop()
    if competitiveStaminaRunning then return end

    competitiveStaminaRunning = true
    CreateThread( function()
        while isInMatch do
            RestorePlayerStamina( PlayerId(), 1.0 )
            Wait( 0 )
        end

        competitiveStaminaRunning = false
    end )
end

-- =============================================
-- Countdown helper
-- =============================================

local function showCountdownSequence( totalMs, label )
    CreateThread( function()
        local steps = math.floor( totalMs / 1000 )
        nuiHud( 'showCountdown', { count = steps, label = label } )
        for i = steps, 1, -1 do
            nuiHud( 'updateCountdown', i )
            Wait( 1000 )
        end
        nuiHud( 'hideCountdown' )
    end )
end

local function getCompetitiveRoundStartBlockReason( data )
    if not isInMatch then return 'not_in_match' end
    if not competitiveRoundSpawnReady then return 'spawn_not_ready' end

    local roundNumber = tonumber( data and data.roundNumber ) or 1
    if roundNumber <= 1 and not competitiveMatchStartReady then return 'match_start_not_ready' end

    return nil
end

local function processCompetitiveRoundStart( data )
    data = type( data ) == 'table' and data or {}
    if isStaleCompetitiveRoundEvent( data ) then
        competitiveRoundDebug( 'roundStart:process-stale', data )
        return
    end

    competitiveRoundDebug( 'roundStart:process-start', data )
    pendingCompetitiveRoundStart = nil
    competitiveRoundSpawnReady = false
    competitiveRoundStartToken = competitiveRoundStartToken + 1
    local token = competitiveRoundStartToken
    local roundNumber = getCompetitiveEventRoundNumber( data )
    if roundNumber > 0 then
        currentCompetitiveRoundNumber = roundNumber
    end

    hydrateCompetitiveTeams( data )
    myTeam = competitivePlayerTeams[ GetPlayerServerId( PlayerId() ) ] or myTeam
    currentRoundWins = data.roundWins or currentRoundWins
    updateCurrentTeamNames( data )
    setCompetitiveDeadState( false )
    weaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setCompetitiveHudSlotItems( false )

    if data.pauseActive == true then
        competitiveRoundDebug( 'roundStart:pause-active', data )
        pendingCompetitiveRoundStart = nil
        roundFreezeUntil = 0
        nuiHud( 'hideCountdown' )
        hudScore()

        local ped = PlayerPedId()
        if DoesEntityExist( ped ) then
            FreezeEntityPosition( ped, true )
            setCompetitiveDamageProtection( ped, true )
        end

        return
    end

    CreateThread( function()
        local waitBeforeRoundHud = math.max( 0, matchStartVisibleUntil - GetGameTimer() )
        competitiveRoundDebug( 'roundStart:thread-start', { matchId = data.matchId, roundNumber = data.roundNumber, extra = ( 'waitBeforeRoundHud=%d' ):format( waitBeforeRoundHud ) } )
        holdCompetitiveFreezeUntil( GetGameTimer() + waitBeforeRoundHud + COMPETITIVE_FREEZE_MS + 500 )

        if waitBeforeRoundHud > 0 then
            Wait( waitBeforeRoundHud )
            if not isInMatch or token ~= competitiveRoundStartToken then
                competitiveRoundDebug( 'roundStart:thread-cancel-before-hud', { matchId = data.matchId, roundNumber = data.roundNumber, extra = ( 'token=%d current=%d' ):format( token, competitiveRoundStartToken ) } )
                return
            end
        end

        competitiveRoundDebug( 'roundStart:hud-open', data )
        clearCompetitiveInputLocks()
        nuiHud( 'closeMatchStart' )
        nuiHud( 'clearKillFeed' )
        nuiHud( 'setPauseHintVisible', { visible = true } )
        nuiHud( 'showHud' )
        hudScore()

        local ped = PlayerPedId()
        FreezeEntityPosition( ped, true )
        clearCompetitiveBlockingPedState()
        competitiveRoundDebug( 'roundStart:weapon-before-countdown', data )
        giveCompetitiveWeapon()
        competitiveRoundDebug( 'roundStart:countdown-start', data )
        showCountdownSequence( COMPETITIVE_FREEZE_MS, getCurrentScoreRoundLabel() )
        Wait( COMPETITIVE_FREEZE_MS )
        if not isInMatch or token ~= competitiveRoundStartToken then
            competitiveRoundDebug( 'roundStart:thread-cancel-before-unlock', { matchId = data.matchId, roundNumber = data.roundNumber, extra = ( 'token=%d current=%d' ):format( token, competitiveRoundStartToken ) } )
            return
        end
        competitiveRoundDebug( 'roundStart:unlock-start', data )
        clearCompetitiveBlockingPedState()
        clearCompetitiveInputLocks()
        giveCompetitiveWeapon()
        applyCompetitiveTeamSilhouettes()
        weaponHudEnabled = true
        setCompetitiveHudSlotItems( true )
        roundFreezeUntil = 0
        ped = PlayerPedId()
        restoreCompetitiveCombatDamageState( ped )
        FreezeEntityPosition( ped, false )
        SetPlayerControl( PlayerId(), true, COMPETITIVE_PLAYER_ENABLE_CONTROL_FLAGS )
        competitiveRoundDebug( 'roundStart:unlock-done', data )
    end )
end

local function tryProcessPendingCompetitiveRoundStart()
    if not pendingCompetitiveRoundStart then return false end
    local blockReason = getCompetitiveRoundStartBlockReason( pendingCompetitiveRoundStart )
    if blockReason then
        competitiveRoundDebug( 'roundStart:pending-blocked', { matchId = pendingCompetitiveRoundStart.matchId, roundNumber = pendingCompetitiveRoundStart.roundNumber, extra = blockReason } )
        return false
    end

    processCompetitiveRoundStart( pendingCompetitiveRoundStart )
    return true
end

-- =============================================
-- Eventos customizados do servidor
-- =============================================

RegisterNetEvent( 'pvp.competitive:matchStart' )
AddEventHandler( 'pvp.competitive:matchStart', function( data )
    competitiveRoundDebug( 'matchStart:received', data )
    -- Para roundBased, o framework client dispara onRoundStart (não onMatchStart).
    -- O matchConfig.onStart nunca é chamado, então inicializamos aqui.
    TriggerEvent( 'pvp.client:forceClosePanel' )
    clearCompetitiveLatencyWarning()

    PvpApplyDayClock()

    LocalPlayer["state"]["minigame:active"] = PVP_COMPETITIVE_MINIGAME_NAME
    isInMatch = true
    setTournamentValidationState( data and data.tournamentAwaitingValidation == true )
    currentCompetitiveMatchId = data and data.matchId or currentCompetitiveMatchId
    setCurrentCompetitiveWeaponData( data and data.weapon )
    competitiveMatchStartReady = true
    currentCompetitiveRoundNumber = 0
    if pendingCompetitiveRoundStart and not isSameCompetitiveMatchId( pendingCompetitiveRoundStart.matchId, currentCompetitiveMatchId ) then
        pendingCompetitiveRoundStart = nil
    end
    clearCompetitiveInputLocks()
    clearCompetitiveBlockingPedState()
    weaponHudEnabled = false
    setCompetitiveHudKills( 0, true )
    setCompetitiveHudSlotItems( false )
    setCompetitiveScoreboardPlayers( {} )
    matchStartVisibleUntil = GetGameTimer() + COMPETITIVE_FREEZE_MS + 500
    holdCompetitiveFreezeUntil( matchStartVisibleUntil + COMPETITIVE_FREEZE_MS + 500 )
    startHudPolling()
    startCompetitiveStaminaLoop()
    startCompetitiveScoreboardControls()
    startCompetitivePauseMenuBlock()
    clearCompetitiveTeamSilhouettes()
    hydrateCompetitiveTeams( data )
    updateCurrentTeamNames( data )
    myTeam = competitivePlayerTeams[ GetPlayerServerId( PlayerId() ) ] or myTeam
    competitiveRoundDebug( 'matchStart:ready', data )
    nuiHud( 'setHudMode', 'TEAM_DEATHMATCH' )
    nuiHud( 'setPauseHintVisible', { visible = true } )
    sendMatchStartToHud( data )
    tryProcessPendingCompetitiveRoundStart()

    -- Fecha automaticamente após COMPETITIVE_FREEZE_MS
    CreateThread( function()
        Wait( COMPETITIVE_FREEZE_MS + 500 )
        nuiHud( 'closeMatchStart' )
        matchStartVisibleUntil = 0
    end )
end )

RegisterNetEvent( 'pvp.competitive:teamsUpdate' )
AddEventHandler( 'pvp.competitive:teamsUpdate', function( data )
    if type( data ) ~= 'table' then return end

    hydrateCompetitiveTeams( data )
    updateCurrentTeamNames( data )
    myTeam = competitivePlayerTeams[ GetPlayerServerId( PlayerId() ) ] or myTeam

    if isInMatch then
        applyCompetitiveTeamSilhouettes()
    end
end )

RegisterNetEvent( 'pvp.competitive:teleport' )
AddEventHandler( 'pvp.competitive:teleport', function( coords, options )
    if not coords then return end
    options = type( options ) == 'table' and options or {}
    competitiveRoundDebug( 'teleport:received', { extra = ( 'coords=%.2f,%.2f,%.2f heading=%.2f' ):format( coords.x, coords.y, coords.z, tonumber( coords.w ) or 0.0 ) } )
    isInMatch = true
    myTeam = options.playerRole or myTeam
    competitiveRoundSpawnReady = true
    local wasCompetitiveDead = competitiveDead
    clearCompetitiveInputLocks()
    setCompetitiveDeadState( false )
    restoreCompetitivePlayersVisibility()
    setCompetitiveLastSpawn( coords )
    local ped = reviveCompetitivePedAtCoords( coords, wasCompetitiveDead )
    clearCompetitiveInputLocks()
    clearCompetitiveBlockingPedState()
    applyCompetitiveTeamUniform( ped )
    FreezeEntityPosition( ped, true )
    competitiveRoundDebug( 'teleport:frozen-after-revive' )
    weaponHudEnabled = false
    prepareCompetitiveWeaponForRound()
    tryProcessPendingCompetitiveRoundStart()
end )

RegisterNetEvent( 'pvp.competitive:waitingTeleport' )
AddEventHandler( 'pvp.competitive:waitingTeleport', function( coords, options )
    if not coords then return end

    options = type( options ) == 'table' and options or {}
    competitiveRoundDebug( 'waitingTeleport:received', {
        matchId = options.matchId or currentCompetitiveMatchId,
        extra   = ( 'forceRevive=%s reconnect=%s resync=%s' ):format(
            tostring( options.forceRevive == true ),
            tostring( options.reconnect == true ),
            tostring( options.resync == true )
        ),
    } )

    LocalPlayer["state"]["minigame:active"] = PVP_COMPETITIVE_MINIGAME_NAME
    PvpApplyDayClock()
    isInMatch = true
    currentCompetitiveMatchId = options.matchId or currentCompetitiveMatchId
    competitiveMatchStartReady = true
    competitiveRoundSpawnReady = false
    pendingCompetitiveRoundStart = nil
    local wasCompetitiveDead = competitiveDead
    clearCompetitiveInputLocks()
    setCompetitiveDeadState( false )
    restoreCompetitivePlayersVisibility()
    setCompetitiveLastSpawn( coords )

    local ped = reviveCompetitivePedAtCoords( coords, options.forceRevive == true or wasCompetitiveDead )
    clearCompetitiveInputLocks()
    clearCompetitiveBlockingPedState()
    myTeam = options.playerRole or myTeam
    applyCompetitiveTeamUniform( ped )
    FreezeEntityPosition( ped, false )
    weaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setCompetitiveHudSlotItems( false )
    clearCompetitiveWeaponState()
end )

RegisterNetEvent( 'pvp.competitive:roundStart' )
AddEventHandler( 'pvp.competitive:roundStart', function( data )
    competitiveRoundDebug( 'roundStart:received', data )
    if data and not isSameCompetitiveMatchId( data.matchId, currentCompetitiveMatchId ) then
        competitiveRoundDebug( 'roundStart:ignored-match', data )
        return
    end
    if isStaleCompetitiveRoundEvent( data ) then
        competitiveRoundDebug( 'roundStart:ignored-stale', data )
        return
    end

    setTournamentValidationState( false )
    pendingCompetitiveRoundStart = data or {}
    if tryProcessPendingCompetitiveRoundStart() then
        competitiveRoundDebug( 'roundStart:processed-immediate', data )
        return
    end

    competitiveRoundDebug( 'roundStart:pending', { matchId = data and data.matchId, roundNumber = data and data.roundNumber, extra = getCompetitiveRoundStartBlockReason( pendingCompetitiveRoundStart ) or '' } )
end )

RegisterNetEvent( 'pvp.competitive:roundEnd' )
AddEventHandler( 'pvp.competitive:roundEnd', function( data )
    if not isInMatch then return end
    if data and not isSameCompetitiveMatchId( data.matchId, currentCompetitiveMatchId ) then return end
    if isStaleCompetitiveRoundEvent( data ) then return end

    competitiveRoundDebug( 'roundEnd:received', data )
    currentRoundWins = data.roundWins or currentRoundWins
    updateCurrentTeamNames( data )
    competitiveRoundSpawnReady = false
    pendingCompetitiveRoundStart = nil
    competitiveRoundStartToken = competitiveRoundStartToken + 1
    clearCompetitivePauseState()
    nuiHud( 'hideCountdown' )
    hudScore()
    weaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setCompetitiveHudSlotItems( false )

    local ped = PlayerPedId()
    holdCompetitiveFreezeUntil( GetGameTimer() + COMPETITIVE_FREEZE_MS + 500 )
    FreezeEntityPosition( ped, true )
end )

RegisterNetEvent( 'pvp.competitive:tournamentValidationState' )
AddEventHandler( 'pvp.competitive:tournamentValidationState', function( data )
    if not isInMatch then return end
    setTournamentValidationState( type( data ) == 'table' and data.active == true )
end )

RegisterNetEvent( 'pvp.competitive:scoreboardUpdate' )
AddEventHandler( 'pvp.competitive:scoreboardUpdate', function( data )
    if not (isInMatch or LocalPlayer['state']['dminigames:spectating'] == 'pvp') then return end

    local players = type( data ) == 'table' and ( data.players or data ) or {}
    setCompetitiveScoreboardPlayers( players )
end )

RegisterNetEvent( 'pvp.competitive:latencyWarning' )
AddEventHandler( 'pvp.competitive:latencyWarning', function( data )
    if not isInMatch or type( data ) ~= 'table' then return end
    if data.matchId and not isSameCompetitiveMatchId( data.matchId, currentCompetitiveMatchId ) then return end
    if type( data.alertId ) ~= 'string' then return end

    competitiveLatencyWarningVisible = true
    competitiveLatencyWarningId = data.alertId
    nuiHud( 'openLatencyWarning', {
        variant = data.variant == 'group' and 'group' or 'duel',
        playerPing = tonumber( data.playerPing ) or 0,
        opponentPing = tonumber( data.opponentPing ) or 0,
        highestPing = tonumber( data.highestPing ) or 0,
        playerPacketLoss = tonumber( data.playerPacketLoss ) or 0,
        opponentPacketLoss = tonumber( data.opponentPacketLoss ) or 0,
        highestPacketLoss = tonumber( data.highestPacketLoss ) or 0,
        disparityPercent = tonumber( data.disparityPercent ) or 0,
    } )
end )

RegisterNetEvent( 'pvp.competitive:spectateHud' )
AddEventHandler( 'pvp.competitive:spectateHud', function( data )
    data = type( data ) == 'table' and data or {}
    if isInMatch then return end
    if LocalPlayer['state']['dminigames:spectating'] ~= 'pvp' and not data.tournamentMatchId then return end

    if data.show == false then
        nuiHud( 'hideHud' )
        return
    end

    if data.tournamentMatchId then
        PvpApplyDayClock()
    end

    if type( data.roundWins ) == 'table' then
        currentRoundWins = {
            TeamA = tonumber( data.roundWins.TeamA ) or 0,
            TeamB = tonumber( data.roundWins.TeamB ) or 0,
        }
    end

    updateCurrentTeamNames( data )
    setCompetitiveHudKills( 0, true )
    setCompetitiveHudSlotItems( false )
    nuiHud( 'updateHudWeapon', nil )
    nuiHud( 'hideCountdown' )
    nuiHud( 'showHud' )
    hudScore()
end )

AddEventHandler( 'pvp.competitive:spectateHudStop', function()
    if isInMatch then return end

    nuiHud( 'hideHud' )
    nuiHud( 'hideCountdown' )
    setCompetitiveHudSlotItems( false )
    nuiHud( 'updateHudWeapon', nil )
    currentRoundWins = { TeamA = 0, TeamB = 0 }
    currentTeamNames = { TeamA = 'TeamA', TeamB = 'TeamB' }
    currentCompetitiveHudKills = 0
    restoreDefaultHudAfterCompetitive()
end )

RegisterNetEvent( 'pvp.competitive:pauseHud' )
AddEventHandler( 'pvp.competitive:pauseHud', function( data )
    if not isInMatch or type( data ) ~= 'table' or type( data.action ) ~= 'string' then return end

    setCompetitivePauseVoteState( data.action, data.data )
    nuiHud( data.action, data.data )
end )

RegisterNetEvent( 'pvp.competitive:pauseState' )
AddEventHandler( 'pvp.competitive:pauseState', function( data )
    if not isInMatch or type( data ) ~= 'table' then return end

    if data.active ~= true then
        roundFreezeUntil = 0
    end

    setCompetitivePauseState( data.active == true )
    if data.active ~= true and not competitiveDead then
        clearCompetitiveInputLocks()
        clearCompetitiveBlockingPedState()

        local ped = PlayerPedId()
        if DoesEntityExist( ped ) then
            FreezeEntityPosition( ped, false )
            SetPlayerControl( PlayerId(), true, COMPETITIVE_PLAYER_ENABLE_CONTROL_FLAGS )
            setCompetitiveDamageProtection( ped, false )
        end

        giveCompetitiveWeapon()
        weaponHudEnabled = true
        setCompetitiveHudSlotItems( true )
    end
end )

local function OnCompetitiveKillfeed( data )
    if not isInMatch then return end

    if isInMatch and data.victimSource ~= GetPlayerServerId( PlayerId() ) then
        restoreCompetitivePlayerVisibility( data.victimSource )
    end

    -- Kill notification apenas para quem matou
    local mySource = GetPlayerServerId( PlayerId() )
    if data.killerSource == mySource then
        if data.killerKills ~= nil then
            setCompetitiveHudKills( data.killerKills )
        end

        nuiHud( 'showKillNotification', {
            killer     = data.killer,
            victim     = data.victim,
            isHeadshot = data.isHeadshot,
        } )
        CreateThread( function()
            Wait( 2500 )
            nuiHud( 'hideKillNotification' )
        end )
    end
end

RegisterNetEvent( 'pvp.competitive:kill', function( data )
    if not isInMatch and LocalPlayer['state']['dminigames:spectating'] == 'pvp'
        and competitiveClientInstance
    then
        competitiveClientInstance:AddKillfeedItem( data )
    end
end )

RegisterNetEvent( 'pvp.competitive:matchEnd' )
AddEventHandler( 'pvp.competitive:matchEnd', function( data )
    if not isInMatch then return end

    setTournamentValidationState( false )
    isInMatch = false
    weaponHudEnabled = false
    roundFreezeUntil = 0
    clearCompetitivePauseState()
    currentCompetitiveMatchId = nil
    competitiveMatchStartReady = false
    competitiveRoundSpawnReady = false
    pendingCompetitiveRoundStart = nil
    currentCompetitiveRoundNumber = 0
    competitiveRoundStartToken = competitiveRoundStartToken + 1
    clearCompetitiveInputLocks()
    clearCompetitiveLatencyWarning()
    setCompetitiveDeadState( false )
    closeCompetitiveScoreboard()
    clearCompetitiveSpawnState()
    restoreCompetitivePlayersVisibility()
    clearCompetitiveTeamSilhouettes()
    clearCompetitiveSameTeamRelationship()
    nuiHud( 'hideCountdown' )
    setCompetitiveHudSlotItems( false )

    clearCompetitiveWeaponState()
    resetCurrentCompetitiveWeaponData()
    restoreCompetitivePedState()

    -- Stats do próprio jogador
    local mySource   = GetPlayerServerId( PlayerId() )
    local allStats   = data.allStats or {}
    local myRaw      = allStats[ tostring( mySource ) ] or allStats[ mySource ] or {}
    local didWin     = myRaw.isVictory
    if didWin == nil then didWin = myRaw.won end
    if didWin == nil then didWin = (data.winner == (myRaw.teamRaw or myTeam)) end
    didWin = didWin == true
    local level      = myRaw.currentLevel or myRaw.level or 0
    local currentXp  = myRaw.currentXp or 0
    local headshots  = myRaw.headshots or 0
    local kills      = myRaw.kills or 0
    local headshotPercentage = ('%d%%'):format( kills > 0 and math.floor( (headshots / kills) * 100 ) or 0 )

    local myStats = {
        kills    = kills,
        deaths   = myRaw.deaths  or 0,
        assists  = myRaw.assists or 0,
        damage   = myRaw.damage  or 0,
        mvp      = myRaw.mvp == true,
        headshots = headshots,
        headshotPercentage = headshotPercentage,
        points   = myRaw.points  or (didWin and 70 or -50),
        level    = level,
        currentLevel = level,
        currentXp = currentXp,
        maxXp = myRaw.maxXp or 1000,
        victory  = didWin,
        isVictory = didWin,
        teamRaw  = myRaw.teamRaw or myTeam,
        mode     = 'TEAM_DEATHMATCH',
        gameMode = 'TEAM_DEATHMATCH',
    }

    local tournamentResult = buildTournamentResultHudPayload( data.tournamentBracketResult, myStats, data.topPlayers )

    nuiHud( 'hideHud' )

    if tournamentResult then
        nuiHud( 'openTournamentResult', tournamentResult )
    else
        nuiHud( 'openMatchResult', {
            stats      = myStats,
            topPlayers = data.topPlayers or {},
        } )
    end

    local resultDisplayMs = tournamentResult and COMPETITIVE_TOURNAMENT_RESULT_DISPLAY_MS or COMPETITIVE_MATCH_RESULT_DISPLAY_MS

    CreateThread( function()
        Wait( resultDisplayMs )
        nuiHud( tournamentResult and 'closeTournamentResult' or 'closeMatchResult' )
        -- Não usamos `hideAllPvP` aqui pois ele parece derrubar também a HUD
        -- principal RP no NUI do `hud`. `hideHud` + `closeMatchResult` já
        -- limpam todos os overlays do PvP.
        restoreDefaultHudAfterCompetitive()
    end )

    currentRoundWins = { TeamA = 0, TeamB = 0 }
    currentCompetitiveHudKills = 0
    competitiveScoreboardPlayers = {}
    competitivePlayerTeams = {}
    myTeam = nil
end )

-- =============================================
-- MinigameClient
-- =============================================

CreateThread( function()
    Wait( 1200 )

    competitiveClientInstance = MinigameClient({
        name = PVP_COMPETITIVE_MINIGAME_NAME,

        match = {
            enableKillfeed = true,
            onKillfeed = OnCompetitiveKillfeed,
            reportDamage = true,
            clearWeaponsOnRoundReset = false,
            downedState = true,
            confirmLeave = requestCompetitiveExitConfirmation,

            onStart = function( data )
                -- Para roundBased o framework não chama onMatchStart — inicializado em pvp.competitive:matchStart
            end,

            onEnd = function( data )
                competitiveRoundDebug( 'framework:onEnd', data )
                setTournamentValidationState( false )
                isInMatch = false
                weaponHudEnabled = false
                roundFreezeUntil = 0
                clearCompetitivePauseState()
                currentCompetitiveMatchId = nil
                competitiveMatchStartReady = false
                competitiveRoundSpawnReady = false
                pendingCompetitiveRoundStart = nil
                currentCompetitiveRoundNumber = 0
                competitiveRoundStartToken = competitiveRoundStartToken + 1
                clearCompetitiveInputLocks()
                clearCompetitiveExitConfirmation()
                clearCompetitiveLatencyWarning()
                setCompetitiveDeadState( false )
                closeCompetitiveScoreboard()
                myTeam    = nil
                clearCompetitiveSpawnState()
                restoreCompetitivePlayersVisibility()
                clearCompetitiveTeamSilhouettes()
                clearCompetitiveSameTeamRelationship()
                competitiveScoreboardPlayers = {}
                competitivePlayerTeams = {}
                currentRoundWins = { TeamA = 0, TeamB = 0 }
                currentTeamNames = { TeamA = 'TeamA', TeamB = 'TeamB' }
                currentCompetitiveHudKills = 0
                setCompetitiveHudSlotItems( false )
                clearCompetitiveWeaponState()
                resetCurrentCompetitiveWeaponData()
                restoreCompetitivePedState()
                clearCompetitiveLocalMinigameState()
                returnToCompetitiveNpc( data )
            end,

            onRoundStart = function( data )
                competitiveRoundDebug( 'framework:onRoundStart', data )
                cleanCompetitiveRoundArea()
                -- Captura o time do jogador pelo evento base do framework, antes dos eventos customizados.
                if data.playerRole then
                    myTeam = data.playerRole
                end
            end,

            onRoundEnd = function( data )
                -- Tratado por pvp.competitive:roundEnd (evento servidor)
            end,

            onPlayerDeath = function( data )
                if isStaleCompetitiveRoundEvent( data ) then return end

                competitiveRoundDebug( 'framework:onPlayerDeath', data )
                setCompetitiveDeadState( true )
                RemoveAllPedWeapons( PlayerPedId(), true )
            end,

            onLeave = function( data )
                competitiveRoundDebug( 'framework:onLeave', data )
                setTournamentValidationState( false )
                isInMatch = false
                weaponHudEnabled = false
                roundFreezeUntil = 0
                clearCompetitivePauseState()
                currentCompetitiveMatchId = nil
                competitiveMatchStartReady = false
                competitiveRoundSpawnReady = false
                pendingCompetitiveRoundStart = nil
                currentCompetitiveRoundNumber = 0
                competitiveRoundStartToken = competitiveRoundStartToken + 1
                clearCompetitiveInputLocks()
                clearCompetitiveExitConfirmation()
                clearCompetitiveLatencyWarning()
                setCompetitiveDeadState( false )
                closeCompetitiveScoreboard()
                myTeam    = nil
                clearCompetitiveSpawnState()
                restoreCompetitivePlayersVisibility()
                clearCompetitiveTeamSilhouettes()
                clearCompetitiveSameTeamRelationship()
                competitiveScoreboardPlayers = {}
                competitivePlayerTeams = {}
                currentTeamNames = { TeamA = 'TeamA', TeamB = 'TeamB' }
                currentCompetitiveHudKills = 0
                setCompetitiveHudSlotItems( false )
                clearCompetitiveWeaponState()
                resetCurrentCompetitiveWeaponData()
                restoreCompetitivePedState()
                clearCompetitiveLocalMinigameState()
                nuiHud( 'closeMatchResult' )
                returnToCompetitiveNpc( data )
                restoreDefaultHudAfterCompetitive()
            end,

            onLateJoin = function( data ) end,
        },
    })
end )
