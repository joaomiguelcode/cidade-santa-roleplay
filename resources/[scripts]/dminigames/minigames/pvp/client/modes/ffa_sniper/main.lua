---MinigameClient do modo Apenas Sniper.

local ffaSniperClientInstance = nil
local isInFfaSniperMatch = false
local currentFfaSniperMatchId = nil
local currentFfaSniperHudKills = 0
local currentFfaSniperWeaponData = nil
local ffaSniperWeaponDisplayName = nil
local ffaSniperScoreboardPlayers = {}
local ffaSniperScoreboardOpen = false
local ffaSniperScoreboardControlsRunning = false
local ffaSniperScoreboardLastRequestAt = 0
local ffaSniperHudPollingRunning = false
local ffaSniperStaminaRunning = false
local ffaSniperBoundaryAbort = nil
local ffaSniperExitMatchResponseHandler = nil
local ffaSniperWeaponHudEnabled = false

local FFA_SNIPER_PED_BASE_HEALTH = 100
local FFA_SNIPER_PED_MAX_HEALTH = 400
local FFA_SNIPER_SCOREBOARD_REFRESH_MS = 1000
local FFA_SNIPER_PLAYER_ENABLE_CONTROL_FLAGS = 0
local FFA_SNIPER_HUD_MODE = 'FREE_FOR_ALL'
local FFA_SNIPER_CLEAN_AREA_DISTANCE = 100.0
local FFA_SNIPER_BOUNDARY_ID = 'pvp_ffa_sniper'

local function pvpText( key, ... )
    return PvpTranslations.get( key, ... )
end

local function isSameFfaSniperMatchId( a, b )
    if not a or not b then return true end

    return tostring( a ) == tostring( b )
end

local function setFfaSniperFullHealth( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedMaxHealth( ped, FFA_SNIPER_PED_MAX_HEALTH )
    SetEntityHealth( ped, FFA_SNIPER_PED_MAX_HEALTH )
end

local function restoreFfaSniperCriticalHits( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedSuffersCriticalHits( ped, true )
end

local function setFfaSniperDamageProtection( ped, enabled )
    if not DoesEntityExist( ped ) then return end

    enabled = enabled == true
    SetEntityInvincible( ped, enabled )
    SetEntityCanBeDamaged( ped, not enabled )
    SetEntityProofs( ped, enabled, enabled, enabled, enabled, enabled, enabled, enabled, enabled )
    if not enabled then
        restoreFfaSniperCriticalHits( ped )
    end
    LocalPlayer["state"]["Invincible"] = enabled
end

local function clearFfaSniperLocalMinigameState()
    LocalPlayer["state"]["minigame:active"] = nil
    LocalPlayer["state"]["Invincible"] = false
end

local function restoreDefaultHudAfterFfaSniper()
    TriggerEvent( 'hud:syncConfig' )

    CreateThread( function()
        Wait( 150 )
        TriggerEvent( 'hud:Active', true )
    end )
end

local function isFfaSniperPedDeadOrDying( ped )
    return DoesEntityExist( ped ) and (
        IsEntityDead( ped ) or
        IsPedDeadOrDying( ped, true ) or
        GetEntityHealth( ped ) <= FFA_SNIPER_PED_BASE_HEALTH
    )
end

local function isFfaSniperSurvivalDead()
    if GetResourceState( 'survival' ) ~= 'started' then return false end

    local ok, isDead = pcall( function()
        return exports["survival"]:IsLocalPlayerDead()
    end )

    return ok and isDead == true
end

local function reviveFfaSniperSurvivalState()
    if GetResourceState( 'survival' ) ~= 'started' then return end

    exports["survival"]:Revive( FFA_SNIPER_PED_MAX_HEALTH )
    Wait( 100 )
end

local function alignFfaSniperGameplayCamera()
    SetGameplayCamRelativeHeading( 0.0 )
    SetGameplayCamRelativePitch( 0.0, 1.0 )
end

local function reviveFfaSniperPedAtCurrentPosition( forceNetworkResurrect )
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return ped end

    local coords = GetEntityCoords( ped )
    local heading = GetEntityHeading( ped )
    local shouldNetworkResurrect = forceNetworkResurrect == true

    if not shouldNetworkResurrect then
        shouldNetworkResurrect = isFfaSniperPedDeadOrDying( ped ) or isFfaSniperSurvivalDead()
    end

    if shouldNetworkResurrect then
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, heading )
        Wait( 0 )
    end

    reviveFfaSniperSurvivalState()
    ped = PlayerPedId()

    if DoesEntityExist( ped ) then
        SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, false, false, false )
        SetEntityHeading( ped, heading )
        alignFfaSniperGameplayCamera()
        setFfaSniperFullHealth( ped )
        setFfaSniperDamageProtection( ped, false )
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

    return ped
end

local function restoreFfaSniperPedState()
    local ped = reviveFfaSniperPedAtCurrentPosition( false )
    if not DoesEntityExist( ped ) then return end

    setFfaSniperFullHealth( ped )
    setFfaSniperDamageProtection( ped, false )
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

local function clearFfaSniperInputLocks()
    SetNuiFocus( false, false )
    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end
    SetPlayerControl( PlayerId(), true, FFA_SNIPER_PLAYER_ENABLE_CONTROL_FLAGS )
    RenderScriptCams( false, false, 0, true, false )
    DestroyAllCams( true )
    NewLoadSceneStop()
    ClearFocus()
end

local function cleanFfaSniperArea()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local coords = GetEntityCoords( ped )
    ClearAreaOfVehicles( coords.x, coords.y, coords.z, FFA_SNIPER_CLEAN_AREA_DISTANCE, false, false, false, false, false )
    ClearAreaOfEverything( coords.x, coords.y, coords.z, FFA_SNIPER_CLEAN_AREA_DISTANCE, false, false, false, false )
end

local function getFfaSniperHealthPercent( ped )
    local health = math.max( 0, GetEntityHealth( ped ) - FFA_SNIPER_PED_BASE_HEALTH )
    local maxHealth = FFA_SNIPER_PED_MAX_HEALTH - FFA_SNIPER_PED_BASE_HEALTH

    return math.min( 100, math.floor( ( health / maxHealth ) * 100 ) )
end

local function normalizeFfaSniperWeaponSkinComponent( component )
    if not component or component == false or component == '' then return nil end

    return component
end

local function getFfaSniperLocalWeaponSkinComponent( weaponName )
    if GetResourceState( 'new_hub' ) ~= 'started' then return nil end

    local ok, component = pcall( function()
        return exports.new_hub:CheckWeaponSkins( weaponName )
    end )

    component = ok and normalizeFfaSniperWeaponSkinComponent( component ) or nil
    if component then return component end

    ok, component = pcall( function()
        return exports.new_hub:GetGroupSkins( weaponName )
    end )

    return ok and normalizeFfaSniperWeaponSkinComponent( component ) or nil
end

local function applyFfaSniperWeaponSkin( ped, weaponHash, weaponName )
    local component = getFfaSniperLocalWeaponSkinComponent( weaponName )
    if not component then return end

    local componentHash = type( component ) == 'number' and component or joaat( tostring( component ) )
    GiveWeaponComponentToPed( ped, weaponHash, componentHash )
end

local function getFfaSniperFallbackWeaponData()
    local data = GetFfaSniperWeapon and GetFfaSniperWeapon() or nil
    if type( data ) == 'table' then return data end

    return {
        id       = 'sniper',
        key      = 'sniper',
        name     = pvpText( 'weapon_sniper' ),
        weapon   = 'WEAPON_SNIPERRIFLE',
        hud      = 'Sniper',
        killfeed = 'sniper',
        image    = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_heavysniper.webp',
        ammo     = 300,
        slotItem = 'weapon_heavysniper',
    }
end

local function normalizeFfaSniperWeaponData( data )
    local fallback = getFfaSniperFallbackWeaponData()
    data = type( data ) == 'table' and data or {}

    return {
        id       = data.id or fallback.id,
        key      = data.key or data.id or fallback.key,
        name     = data.name or fallback.name,
        weapon   = data.weapon or fallback.weapon,
        hud      = data.hud or data.name or fallback.hud,
        killfeed = data.killfeed or fallback.killfeed,
        image    = data.image or fallback.image,
        ammo     = tonumber( data.ammo ) or fallback.ammo,
        slotItem = data.slotItem or fallback.slotItem,
    }
end

local function setCurrentFfaSniperWeaponData( data )
    currentFfaSniperWeaponData = normalizeFfaSniperWeaponData( data )
    ffaSniperWeaponDisplayName = currentFfaSniperWeaponData.hud or currentFfaSniperWeaponData.name or currentFfaSniperWeaponData.weapon
end

local function getCurrentFfaSniperWeaponName()
    if not currentFfaSniperWeaponData then
        setCurrentFfaSniperWeaponData( nil )
    end

    return currentFfaSniperWeaponData.weapon
end

local function getCurrentFfaSniperWeaponHash()
    return joaat( getCurrentFfaSniperWeaponName() )
end

local function getCurrentFfaSniperWeaponAmmo()
    if not currentFfaSniperWeaponData then
        setCurrentFfaSniperWeaponData( nil )
    end

    return tonumber( currentFfaSniperWeaponData.ammo ) or 300
end

local function giveFfaSniperWeapon()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponName = getCurrentFfaSniperWeaponName()
    local weaponHash = getCurrentFfaSniperWeaponHash()
    local ammo = getCurrentFfaSniperWeaponAmmo()

    SetCanPedEquipAllWeapons( ped, true )
    GiveWeaponToPed( ped, weaponHash, ammo, true, false )
    applyFfaSniperWeaponSkin( ped, weaponHash, weaponName )
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
end

local function clearFfaSniperWeaponState()
    TriggerEvent( 'inventory:CleanWeapons' )

    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponHash = getCurrentFfaSniperWeaponHash()
    SetCurrentPedWeapon( ped, joaat( 'WEAPON_UNARMED' ), true )
    RemoveWeaponFromPed( ped, weaponHash )
    RemoveAllPedWeapons( ped, true )
end

setCurrentFfaSniperWeaponData( nil )

local function getFfaSniperWeaponHudAmmo( ped, weaponHash )
    local _, clipAmmo = GetAmmoInClip( ped, weaponHash )
    local maxClipAmmo = GetMaxAmmoInClip( ped, weaponHash, true )

    clipAmmo = tonumber( clipAmmo ) or 0
    maxClipAmmo = tonumber( maxClipAmmo ) or clipAmmo

    if maxClipAmmo < clipAmmo then
        maxClipAmmo = clipAmmo
    end

    return clipAmmo, maxClipAmmo
end

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
    copy.name = copy.displayName or copy.rawName or copy.name

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

local function nuiHud( action, payload )
    TriggerEvent( 'pvp.hud:' .. action, payload )
end

local function setFfaSniperHudKills( kills, force )
    kills = math.max( 0, math.floor( tonumber( kills ) or 0 ) )
    if not force and currentFfaSniperHudKills == kills then return end

    currentFfaSniperHudKills = kills
    nuiHud( 'updateHudKills', kills )
end

local function setFfaSniperHudSlotItems( enabled )
    if enabled ~= true then
        nuiHud( 'updateHudSlotItems', {} )
        return
    end

    nuiHud( 'updateHudSlotItems', {
        {
            slot   = 1,
            name   = currentFfaSniperWeaponData.slotItem or 'weapon_heavysniper',
            image  = currentFfaSniperWeaponData.image,
            active = true,
        },
    } )
end

local function setFfaSniperScoreboardPlayers( players )
    ffaSniperScoreboardPlayers = copyHudPlayers( players )
    nuiHud( 'updateHudPlayerCount', #ffaSniperScoreboardPlayers )

    local mySource = GetPlayerServerId( PlayerId() )
    for _, player in ipairs( ffaSniperScoreboardPlayers ) do
        if tonumber( player.source ) == mySource then
            setFfaSniperHudKills( player.kills )
            break
        end
    end

    if ffaSniperScoreboardOpen then
        nuiHud( 'openScoreboard', ffaSniperScoreboardPlayers )
    end
end

local function requestFfaSniperScoreboard( force )
    local now = GetGameTimer()
    if not force and now - ffaSniperScoreboardLastRequestAt < FFA_SNIPER_SCOREBOARD_REFRESH_MS then return end

    ffaSniperScoreboardLastRequestAt = now
    TriggerServerEvent( 'pvp.ffa_sniper:requestScoreboard' )
end

local function openFfaSniperScoreboard()
    if ffaSniperScoreboardOpen then return end

    ffaSniperScoreboardOpen = true
    requestFfaSniperScoreboard( true )
    nuiHud( 'openScoreboard', ffaSniperScoreboardPlayers )
end

local function closeFfaSniperScoreboard()
    if not ffaSniperScoreboardOpen then return end

    nuiHud( 'closeScoreboard' )
    ffaSniperScoreboardOpen = false
end

RegisterCommand( '+dminigames_ffa_sniper_scoreboard', function()
    if not isInFfaSniperMatch then return end

    openFfaSniperScoreboard()
end, false )

RegisterCommand( '-dminigames_ffa_sniper_scoreboard', function()
    closeFfaSniperScoreboard()
end, false )

RegisterKeyMapping( '+dminigames_ffa_sniper_scoreboard', pvpText( 'scoreboard_key_mapping' ), 'keyboard', 'TAB' )

local function startFfaSniperScoreboardControls()
    if ffaSniperScoreboardControlsRunning then return end

    ffaSniperScoreboardControlsRunning = true
    CreateThread( function()
        while isInFfaSniperMatch do
            DisableControlAction( 0, 37, true )
            if IsDisabledControlJustPressed( 0, 37 ) then
                openFfaSniperScoreboard()
            elseif IsDisabledControlJustReleased( 0, 37 ) then
                closeFfaSniperScoreboard()
            end

            if ffaSniperScoreboardOpen then
                requestFfaSniperScoreboard( false )
            end
            Wait( 0 )
        end

        closeFfaSniperScoreboard()
        ffaSniperScoreboardControlsRunning = false
    end )
end

local function hideFfaSniperHud( closeResult )
    nuiHud( 'hideHud' )
    nuiHud( 'setPauseHintVisible', { visible = true } )
    nuiHud( 'hideCountdown' )
    nuiHud( 'hideKillNotification' )
    nuiHud( 'clearKillFeed' )
    nuiHud( 'updateHudWeapon', nil )
    nuiHud( 'updateHudSlotItems', {} )
    closeFfaSniperScoreboard()
    nuiHud( 'closeMatchStart' )
    nuiHud( 'closePauseOverlay' )

    if closeResult == true then
        nuiHud( 'closeMatchResult' )
    end
end

local function returnToFfaSniperNpc()
    hideFfaSniperHud( true )

    local ped = PlayerPedId()
    if DoesEntityExist( ped ) and PVP_NPC_COORDS then
        SetEntityCoordsNoOffset( ped, PVP_NPC_COORDS.x, PVP_NPC_COORDS.y, PVP_NPC_COORDS.z, false, false, false )
        SetEntityHeading( ped, PVP_NPC_COORDS.w )
    end
end

local function clearFfaSniperExitConfirmation()
    if ffaSniperExitMatchResponseHandler then
        RemoveEventHandler( ffaSniperExitMatchResponseHandler )
        ffaSniperExitMatchResponseHandler = nil
    end
end

local function requestFfaSniperExitConfirmation( cb )
    clearFfaSniperExitConfirmation()

    ffaSniperExitMatchResponseHandler = AddEventHandler( 'pvp.callback:exitMatchResponse', function( data )
        clearFfaSniperExitConfirmation()
        cb( isInFfaSniperMatch and type( data ) == 'table' and data.confirmed == true )
    end )

    nuiHud( 'openExitMatch', {
        title = pvpText( 'exit_match_title' ),
        description = pvpText( 'exit_match_description' ),
        confirmLabel = pvpText( 'exit_match_confirm' ),
        cancelLabel = pvpText( 'exit_match_cancel' ),
    } )
end

local function startFfaSniperHudPolling()
    if ffaSniperHudPollingRunning then return end

    ffaSniperHudPollingRunning = true
    CreateThread( function()
        local nextStatusUpdate = 0

        while isInFfaSniperMatch do
            local ped = PlayerPedId()
            local now = GetGameTimer()

            if now >= nextStatusUpdate then
                nuiHud( 'updateHudStatus', {
                    health = getFfaSniperHealthPercent( ped ),
                    armor = GetPedArmour( ped ),
                } )
                nextStatusUpdate = now + 500
            end

            local weaponHash = getCurrentFfaSniperWeaponHash()
            local hasWeapon = DoesEntityExist( ped ) and HasPedGotWeapon( ped, weaponHash, false )
            if hasWeapon and ffaSniperWeaponHudEnabled then
                local ammo, maxAmmo = getFfaSniperWeaponHudAmmo( ped, weaponHash )
                nuiHud( 'updateHudWeapon', {
                    name = ffaSniperWeaponDisplayName,
                    ammo = ammo,
                    maxAmmo = maxAmmo,
                    image = currentFfaSniperWeaponData.image,
                } )
            else
                nuiHud( 'updateHudWeapon', nil )
            end

            Wait( 200 )
        end

        nuiHud( 'updateHudWeapon', nil )
        setFfaSniperHudSlotItems( false )
        ffaSniperHudPollingRunning = false
    end )
end

local function startFfaSniperStaminaLoop()
    if ffaSniperStaminaRunning then return end

    ffaSniperStaminaRunning = true
    CreateThread( function()
        while isInFfaSniperMatch do
            RestorePlayerStamina( PlayerId(), 1.0 )
            Wait( 0 )
        end

        ffaSniperStaminaRunning = false
    end )
end

local function getFfaSniperBoundaryCenter( spawns )
    spawns = type( spawns ) == 'table' and spawns or {}
    if #spawns == 0 then return nil end

    local x, y, z = 0.0, 0.0, 0.0
    for _, coords in ipairs( spawns ) do
        x = x + coords.x
        y = y + coords.y
        z = z + coords.z
    end

    return vector3( x / #spawns, y / #spawns, z / #spawns )
end

local function stopFfaSniperBoundaryCheck()
    if ffaSniperBoundaryAbort then
        ffaSniperBoundaryAbort()
        ffaSniperBoundaryAbort = nil
    end

    if StopBoundaryCheck then
        StopBoundaryCheck( FFA_SNIPER_BOUNDARY_ID )
    end
end

local function startFfaSniperBoundaryCheck()
    stopFfaSniperBoundaryCheck()

    if not StartBoundaryCheck then return end

    local spawns = GetFfaSniperSpawnpoints and GetFfaSniperSpawnpoints() or {}
    local center = getFfaSniperBoundaryCenter( spawns )
    if not center then return end

    ffaSniperBoundaryAbort = StartBoundaryCheck( FFA_SNIPER_BOUNDARY_ID, {
        centerCoords = center,
        maxDistance = FFA_SNIPER_BOUNDARY_RADIUS or 150.0,
        spawnCoords = spawns,
        showWarning = true,
        warningDistance = 0.90,
        warnInterval = 3000,
        teleportThreshold = 5000,
        onTeleport = function()
            if not isInFfaSniperMatch then return end

            CreateThread( function()
                Wait( 250 )
                if not isInFfaSniperMatch then return end
                local ped = PlayerPedId()
                if DoesEntityExist( ped ) then
                    setFfaSniperDamageProtection( ped, false )
                    restoreFfaSniperCriticalHits( ped )
                    giveFfaSniperWeapon()
                    ffaSniperWeaponHudEnabled = true
                    setFfaSniperHudSlotItems( true )
                end
            end )
        end,
    } )
end

local function setupFfaSniperPedAfterSpawn( forceNetworkResurrect )
    clearFfaSniperInputLocks()
    cleanFfaSniperArea()

    local ped = reviveFfaSniperPedAtCurrentPosition( forceNetworkResurrect )
    if not DoesEntityExist( ped ) then return end

    FreezeEntityPosition( ped, false )
    SetPlayerControl( PlayerId(), true, FFA_SNIPER_PLAYER_ENABLE_CONTROL_FLAGS )
    setFfaSniperDamageProtection( ped, false )
    restoreFfaSniperCriticalHits( ped )
    giveFfaSniperWeapon()
    ffaSniperWeaponHudEnabled = true
    setFfaSniperHudSlotItems( true )

    if ffaSniperClientInstance then
        ffaSniperClientInstance:transitionToState( MinigameClient.GameState.MATCH_GAMEPLAY, 'ffa sniper spawn ready' )
    end
end

local function startFfaSniperMatch( data, isLateJoin )
    data = type( data ) == 'table' and data or {}

    TriggerEvent( 'pvp.client:forceClosePanel' )
    PvpApplyDayClock()
    LocalPlayer["state"]["minigame:active"] = PVP_FFA_SNIPER_MINIGAME_NAME

    isInFfaSniperMatch = true
    currentFfaSniperMatchId = data.matchId or currentFfaSniperMatchId
    ffaSniperWeaponHudEnabled = false
    currentFfaSniperHudKills = 0
    setCurrentFfaSniperWeaponData( data.weapon )
    clearFfaSniperInputLocks()
    setFfaSniperScoreboardPlayers( {} )

    nuiHud( 'setHudMode', FFA_SNIPER_HUD_MODE )
    nuiHud( 'setPauseHintVisible', { visible = false } )
    nuiHud( 'clearKillFeed' )
    nuiHud( 'showHud' )
    setFfaSniperHudKills( 0, true )
    setFfaSniperHudSlotItems( false )

    startFfaSniperHudPolling()
    startFfaSniperStaminaLoop()
    startFfaSniperScoreboardControls()
    startFfaSniperBoundaryCheck()

    CreateThread( function()
        Wait( isLateJoin and 700 or 500 )
        if not isInFfaSniperMatch or not isSameFfaSniperMatchId( data.matchId, currentFfaSniperMatchId ) then return end

        setupFfaSniperPedAfterSpawn( false )
    end )
end

local function cleanupFfaSniperState( returnToNpc, restoreHud )
    isInFfaSniperMatch = false
    currentFfaSniperMatchId = nil
    ffaSniperWeaponHudEnabled = false
    currentFfaSniperHudKills = 0
    ffaSniperScoreboardPlayers = {}

    stopFfaSniperBoundaryCheck()
    clearFfaSniperExitConfirmation()
    closeFfaSniperScoreboard()
    hideFfaSniperHud( true )
    clearFfaSniperWeaponState()
    restoreFfaSniperPedState()
    clearFfaSniperLocalMinigameState()

    if returnToNpc == true then
        returnToFfaSniperNpc()
    end

    if restoreHud == true then
        restoreDefaultHudAfterFfaSniper()
    end
end

RegisterNetEvent( 'pvp.ffa_sniper:scoreboardUpdate' )
AddEventHandler( 'pvp.ffa_sniper:scoreboardUpdate', function( data )
    if not isInFfaSniperMatch then return end

    local players = type( data ) == 'table' and ( data.players or data ) or {}
    setFfaSniperScoreboardPlayers( players )
end )

local function OnFfaSniperKillfeed( data )
    if not isInFfaSniperMatch or type( data ) ~= 'table' then return end

    local mySource = GetPlayerServerId( PlayerId() )
    if data.killerSource == mySource then
        if data.killerKills ~= nil then
            setFfaSniperHudKills( data.killerKills )
        end

        nuiHud( 'showKillNotification', {
            killer = data.killer,
            victim = data.victim,
            isHeadshot = data.isHeadshot == true,
        } )

        CreateThread( function()
            Wait( 2500 )
            nuiHud( 'hideKillNotification' )
        end )
    end
end

RegisterNetEvent( 'pvp.ffa_sniper:respawned' )
AddEventHandler( 'pvp.ffa_sniper:respawned', function( data )
    if not isInFfaSniperMatch then return end
    if data and not isSameFfaSniperMatchId( data.matchId, currentFfaSniperMatchId ) then return end

    ffaSniperWeaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setFfaSniperHudSlotItems( false )

    CreateThread( function()
        Wait( FFA_SNIPER_RESPAWN_SETUP_DELAY_MS or 250 )
        if not isInFfaSniperMatch then return end

        setupFfaSniperPedAfterSpawn( false )
    end )
end )

ffaSniperClientInstance = MinigameClient({
    name = PVP_FFA_SNIPER_MINIGAME_NAME,

    match = {
        enableKillfeed = true,
        onKillfeed = OnFfaSniperKillfeed,
        reportDamage = true,
        clearWeaponsOnRoundReset = false,
        confirmLeave = requestFfaSniperExitConfirmation,

        onStart = function( data )
            startFfaSniperMatch( data, false )
        end,

        onLateJoin = function( data )
            startFfaSniperMatch( data, true )
        end,

        onPlayerDeath = function( data )
            if not isInFfaSniperMatch then return end
            if data and not isSameFfaSniperMatchId( data.matchId, currentFfaSniperMatchId ) then return end

            ffaSniperWeaponHudEnabled = false
            nuiHud( 'updateHudWeapon', nil )
            setFfaSniperHudSlotItems( false )
            clearFfaSniperWeaponState()
        end,

        onEnd = function()
            cleanupFfaSniperState( true, true )
        end,

        onLeave = function()
            cleanupFfaSniperState( true, true )
        end,
    },
})
