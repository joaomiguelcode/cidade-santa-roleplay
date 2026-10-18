---MinigameClient do modo FFA Fuzil.

local ffaRifleClientInstance = nil
local isInFfaRifleMatch = false
local currentFfaRifleMatchId = nil
local currentFfaRifleHudKills = 0
local currentFfaRifleWeaponData = nil
local ffaRifleWeaponDisplayName = nil
local ffaRifleScoreboardPlayers = {}
local ffaRifleScoreboardOpen = false
local ffaRifleScoreboardControlsRunning = false
local ffaRifleScoreboardLastRequestAt = 0
local ffaRifleHudPollingRunning = false
local ffaRifleStaminaRunning = false
local ffaRifleBoundaryAbort = nil
local ffaRifleExitMatchResponseHandler = nil
local ffaRifleWeaponHudEnabled = false
local currentFfaRifleMap = nil

local FFA_RIFLE_PED_BASE_HEALTH = 100
local FFA_RIFLE_PED_MAX_HEALTH = 400
local FFA_RIFLE_SCOREBOARD_REFRESH_MS = 1000
local FFA_RIFLE_PLAYER_ENABLE_CONTROL_FLAGS = 0
local FFA_RIFLE_HUD_MODE = 'FREE_FOR_ALL'
local FFA_RIFLE_CLEAN_AREA_DISTANCE = 100.0
local FFA_RIFLE_BOUNDARY_ID = 'pvp_ffa_rifle'

local function pvpText( key, ... )
    return PvpTranslations.get( key, ... )
end

local function isSameFfaRifleMatchId( a, b )
    if not a or not b then return true end

    return tostring( a ) == tostring( b )
end

local function setCurrentFfaRifleMap( map )
    if type( map ) ~= 'table' then return end

    currentFfaRifleMap = map
end

local function getCurrentFfaRifleSpawnpoints()
    if currentFfaRifleMap and type( currentFfaRifleMap.spawns ) == 'table' and #currentFfaRifleMap.spawns > 0 then
        return currentFfaRifleMap.spawns
    end

    return GetFfaRifleSpawnpoints and GetFfaRifleSpawnpoints() or {}
end

local function setFfaRifleFullHealth( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedMaxHealth( ped, FFA_RIFLE_PED_MAX_HEALTH )
    SetEntityHealth( ped, FFA_RIFLE_PED_MAX_HEALTH )
end

local function restoreFfaRifleCriticalHits( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedSuffersCriticalHits( ped, true )
end

local function setFfaRifleDamageProtection( ped, enabled )
    if not DoesEntityExist( ped ) then return end

    enabled = enabled == true
    SetEntityInvincible( ped, enabled )
    SetEntityCanBeDamaged( ped, not enabled )
    SetEntityProofs( ped, enabled, enabled, enabled, enabled, enabled, enabled, enabled, enabled )
    if not enabled then
        restoreFfaRifleCriticalHits( ped )
    end
    LocalPlayer["state"]["Invincible"] = enabled
end

local function clearFfaRifleLocalMinigameState()
    LocalPlayer["state"]["minigame:active"] = nil
    LocalPlayer["state"]["Invincible"] = false
end

local function restoreDefaultHudAfterFfaRifle()
    TriggerEvent( 'hud:syncConfig' )

    CreateThread( function()
        Wait( 150 )
        TriggerEvent( 'hud:Active', true )
    end )
end

local function isFfaRiflePedDeadOrDying( ped )
    return DoesEntityExist( ped ) and (
        IsEntityDead( ped ) or
        IsPedDeadOrDying( ped, true ) or
        GetEntityHealth( ped ) <= FFA_RIFLE_PED_BASE_HEALTH
    )
end

local function isFfaRifleSurvivalDead()
    if GetResourceState( 'survival' ) ~= 'started' then return false end

    local ok, isDead = pcall( function()
        return exports["survival"]:IsLocalPlayerDead()
    end )

    return ok and isDead == true
end

local function reviveFfaRifleSurvivalState()
    if GetResourceState( 'survival' ) ~= 'started' then return end

    exports["survival"]:Revive( FFA_RIFLE_PED_MAX_HEALTH )
    Wait( 100 )
end

local function alignFfaRifleGameplayCamera()
    SetGameplayCamRelativeHeading( 0.0 )
    SetGameplayCamRelativePitch( 0.0, 1.0 )
end

local function reviveFfaRiflePedAtCurrentPosition( forceNetworkResurrect )
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return ped end

    local coords = GetEntityCoords( ped )
    local heading = GetEntityHeading( ped )
    local shouldNetworkResurrect = forceNetworkResurrect == true

    if not shouldNetworkResurrect then
        shouldNetworkResurrect = isFfaRiflePedDeadOrDying( ped ) or isFfaRifleSurvivalDead()
    end

    if shouldNetworkResurrect then
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, heading )
        Wait( 0 )
    end

    reviveFfaRifleSurvivalState()
    ped = PlayerPedId()

    if DoesEntityExist( ped ) then
        SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, false, false, false )
        SetEntityHeading( ped, heading )
        alignFfaRifleGameplayCamera()
        setFfaRifleFullHealth( ped )
        setFfaRifleDamageProtection( ped, false )
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

local function restoreFfaRiflePedState()
    local ped = reviveFfaRiflePedAtCurrentPosition( false )
    if not DoesEntityExist( ped ) then return end

    setFfaRifleFullHealth( ped )
    setFfaRifleDamageProtection( ped, false )
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

local function clearFfaRifleInputLocks()
    SetNuiFocus( false, false )
    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end
    SetPlayerControl( PlayerId(), true, FFA_RIFLE_PLAYER_ENABLE_CONTROL_FLAGS )
    RenderScriptCams( false, false, 0, true, false )
    DestroyAllCams( true )
    NewLoadSceneStop()
    ClearFocus()
end

local function cleanFfaRifleArea()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local coords = GetEntityCoords( ped )
    ClearAreaOfVehicles( coords.x, coords.y, coords.z, FFA_RIFLE_CLEAN_AREA_DISTANCE, false, false, false, false, false )
    ClearAreaOfEverything( coords.x, coords.y, coords.z, FFA_RIFLE_CLEAN_AREA_DISTANCE, false, false, false, false )
end

local function getFfaRifleHealthPercent( ped )
    local health = math.max( 0, GetEntityHealth( ped ) - FFA_RIFLE_PED_BASE_HEALTH )
    local maxHealth = FFA_RIFLE_PED_MAX_HEALTH - FFA_RIFLE_PED_BASE_HEALTH

    return math.min( 100, math.floor( ( health / maxHealth ) * 100 ) )
end

local function normalizeFfaRifleWeaponSkinComponent( component )
    if not component or component == false or component == '' then return nil end

    return component
end

local function getFfaRifleLocalWeaponSkinComponent( weaponName )
    if GetResourceState( 'new_hub' ) ~= 'started' then return nil end

    local ok, component = pcall( function()
        return exports.new_hub:CheckWeaponSkins( weaponName )
    end )

    component = ok and normalizeFfaRifleWeaponSkinComponent( component ) or nil
    if component then return component end

    ok, component = pcall( function()
        return exports.new_hub:GetGroupSkins( weaponName )
    end )

    return ok and normalizeFfaRifleWeaponSkinComponent( component ) or nil
end

local function applyFfaRifleWeaponSkin( ped, weaponHash, weaponName )
    local component = getFfaRifleLocalWeaponSkinComponent( weaponName )
    if not component then return end

    local componentHash = type( component ) == 'number' and component or joaat( tostring( component ) )
    GiveWeaponComponentToPed( ped, weaponHash, componentHash )
end

local function getFfaRifleFallbackWeaponData()
    local data = GetFfaRifleWeapon and GetFfaRifleWeapon() or nil
    if type( data ) == 'table' then return data end

    return {
        id       = 'rifle',
        key      = 'rifle',
        name     = pvpText( 'weapon_rifle' ),
        weapon   = 'WEAPON_SPECIALCARBINE_MK2',
        hud      = 'G3',
        killfeed = 'rifle',
        image    = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_carbinerifle_mk2.webp',
        ammo     = 300,
        slotItem = 'weapon_carbinerifle',
    }
end

local function normalizeFfaRifleWeaponData( data )
    local fallback = getFfaRifleFallbackWeaponData()
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

local function setCurrentFfaRifleWeaponData( data )
    currentFfaRifleWeaponData = normalizeFfaRifleWeaponData( data )
    ffaRifleWeaponDisplayName = currentFfaRifleWeaponData.hud or currentFfaRifleWeaponData.name or currentFfaRifleWeaponData.weapon
end

local function getCurrentFfaRifleWeaponName()
    if not currentFfaRifleWeaponData then
        setCurrentFfaRifleWeaponData( nil )
    end

    return currentFfaRifleWeaponData.weapon
end

local function getCurrentFfaRifleWeaponHash()
    return joaat( getCurrentFfaRifleWeaponName() )
end

local function getCurrentFfaRifleWeaponAmmo()
    if not currentFfaRifleWeaponData then
        setCurrentFfaRifleWeaponData( nil )
    end

    return tonumber( currentFfaRifleWeaponData.ammo ) or 300
end

local function giveFfaRifleWeapon()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponName = getCurrentFfaRifleWeaponName()
    local weaponHash = getCurrentFfaRifleWeaponHash()
    local ammo = getCurrentFfaRifleWeaponAmmo()

    SetCanPedEquipAllWeapons( ped, true )
    GiveWeaponToPed( ped, weaponHash, ammo, true, false )
    applyFfaRifleWeaponSkin( ped, weaponHash, weaponName )
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

local function clearFfaRifleWeaponState()
    TriggerEvent( 'inventory:CleanWeapons' )

    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponHash = getCurrentFfaRifleWeaponHash()
    SetCurrentPedWeapon( ped, joaat( 'WEAPON_UNARMED' ), true )
    RemoveWeaponFromPed( ped, weaponHash )
    RemoveAllPedWeapons( ped, true )
end

setCurrentFfaRifleWeaponData( nil )

local function getFfaRifleWeaponHudAmmo( ped, weaponHash )
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

local function setFfaRifleHudKills( kills, force )
    kills = math.max( 0, math.floor( tonumber( kills ) or 0 ) )
    if not force and currentFfaRifleHudKills == kills then return end

    currentFfaRifleHudKills = kills
    nuiHud( 'updateHudKills', kills )
end

local function setFfaRifleHudSlotItems( enabled )
    if enabled ~= true then
        nuiHud( 'updateHudSlotItems', {} )
        return
    end

    nuiHud( 'updateHudSlotItems', {
        {
            slot   = 1,
            name   = currentFfaRifleWeaponData.slotItem or 'weapon_carbinerifle',
            image  = currentFfaRifleWeaponData.image,
            active = true,
        },
    } )
end

local function setFfaRifleScoreboardPlayers( players )
    ffaRifleScoreboardPlayers = copyHudPlayers( players )
    nuiHud( 'updateHudPlayerCount', #ffaRifleScoreboardPlayers )

    local mySource = GetPlayerServerId( PlayerId() )
    for _, player in ipairs( ffaRifleScoreboardPlayers ) do
        if tonumber( player.source ) == mySource then
            setFfaRifleHudKills( player.kills )
            break
        end
    end

    if ffaRifleScoreboardOpen then
        nuiHud( 'openScoreboard', ffaRifleScoreboardPlayers )
    end
end

local function requestFfaRifleScoreboard( force )
    local now = GetGameTimer()
    if not force and now - ffaRifleScoreboardLastRequestAt < FFA_RIFLE_SCOREBOARD_REFRESH_MS then return end

    ffaRifleScoreboardLastRequestAt = now
    TriggerServerEvent( 'pvp.ffa_rifle:requestScoreboard' )
end

local function openFfaRifleScoreboard()
    if ffaRifleScoreboardOpen then return end

    ffaRifleScoreboardOpen = true
    requestFfaRifleScoreboard( true )
    nuiHud( 'openScoreboard', ffaRifleScoreboardPlayers )
end

local function closeFfaRifleScoreboard()
    if not ffaRifleScoreboardOpen then return end

    nuiHud( 'closeScoreboard' )
    ffaRifleScoreboardOpen = false
end

RegisterCommand( '+dminigames_ffa_rifle_scoreboard', function()
    if not isInFfaRifleMatch then return end

    openFfaRifleScoreboard()
end, false )

RegisterCommand( '-dminigames_ffa_rifle_scoreboard', function()
    closeFfaRifleScoreboard()
end, false )

RegisterKeyMapping( '+dminigames_ffa_rifle_scoreboard', pvpText( 'scoreboard_key_mapping' ), 'keyboard', 'TAB' )

local function startFfaRifleScoreboardControls()
    if ffaRifleScoreboardControlsRunning then return end

    ffaRifleScoreboardControlsRunning = true
    CreateThread( function()
        while isInFfaRifleMatch do
            DisableControlAction( 0, 37, true )
            if IsDisabledControlJustPressed( 0, 37 ) then
                openFfaRifleScoreboard()
            elseif IsDisabledControlJustReleased( 0, 37 ) then
                closeFfaRifleScoreboard()
            end

            if ffaRifleScoreboardOpen then
                requestFfaRifleScoreboard( false )
            end
            Wait( 0 )
        end

        closeFfaRifleScoreboard()
        ffaRifleScoreboardControlsRunning = false
    end )
end

local function hideFfaRifleHud( closeResult )
    nuiHud( 'hideHud' )
    nuiHud( 'setPauseHintVisible', { visible = true } )
    nuiHud( 'hideCountdown' )
    nuiHud( 'hideKillNotification' )
    nuiHud( 'clearKillFeed' )
    nuiHud( 'updateHudWeapon', nil )
    nuiHud( 'updateHudSlotItems', {} )
    closeFfaRifleScoreboard()
    nuiHud( 'closeMatchStart' )
    nuiHud( 'closePauseOverlay' )

    if closeResult == true then
        nuiHud( 'closeMatchResult' )
    end
end

local function returnToFfaRifleNpc()
    hideFfaRifleHud( true )

    local ped = PlayerPedId()
    if DoesEntityExist( ped ) and PVP_NPC_COORDS then
        SetEntityCoordsNoOffset( ped, PVP_NPC_COORDS.x, PVP_NPC_COORDS.y, PVP_NPC_COORDS.z, false, false, false )
        SetEntityHeading( ped, PVP_NPC_COORDS.w )
    end
end

local function clearFfaRifleExitConfirmation()
    if ffaRifleExitMatchResponseHandler then
        RemoveEventHandler( ffaRifleExitMatchResponseHandler )
        ffaRifleExitMatchResponseHandler = nil
    end
end

local function requestFfaRifleExitConfirmation( cb )
    clearFfaRifleExitConfirmation()

    ffaRifleExitMatchResponseHandler = AddEventHandler( 'pvp.callback:exitMatchResponse', function( data )
        clearFfaRifleExitConfirmation()
        cb( isInFfaRifleMatch and type( data ) == 'table' and data.confirmed == true )
    end )

    nuiHud( 'openExitMatch', {
        title = pvpText( 'exit_match_title' ),
        description = pvpText( 'exit_match_description' ),
        confirmLabel = pvpText( 'exit_match_confirm' ),
        cancelLabel = pvpText( 'exit_match_cancel' ),
    } )
end

local function startFfaRifleHudPolling()
    if ffaRifleHudPollingRunning then return end

    ffaRifleHudPollingRunning = true
    CreateThread( function()
        local nextStatusUpdate = 0

        while isInFfaRifleMatch do
            local ped = PlayerPedId()
            local now = GetGameTimer()

            if now >= nextStatusUpdate then
                nuiHud( 'updateHudStatus', {
                    health = getFfaRifleHealthPercent( ped ),
                    armor = GetPedArmour( ped ),
                } )
                nextStatusUpdate = now + 500
            end

            local weaponHash = getCurrentFfaRifleWeaponHash()
            local hasWeapon = DoesEntityExist( ped ) and HasPedGotWeapon( ped, weaponHash, false )
            if hasWeapon and ffaRifleWeaponHudEnabled then
                local ammo, maxAmmo = getFfaRifleWeaponHudAmmo( ped, weaponHash )
                nuiHud( 'updateHudWeapon', {
                    name = ffaRifleWeaponDisplayName,
                    ammo = ammo,
                    maxAmmo = maxAmmo,
                    image = currentFfaRifleWeaponData.image,
                } )
            else
                nuiHud( 'updateHudWeapon', nil )
            end

            Wait( 200 )
        end

        nuiHud( 'updateHudWeapon', nil )
        setFfaRifleHudSlotItems( false )
        ffaRifleHudPollingRunning = false
    end )
end

local function startFfaRifleStaminaLoop()
    if ffaRifleStaminaRunning then return end

    ffaRifleStaminaRunning = true
    CreateThread( function()
        while isInFfaRifleMatch do
            RestorePlayerStamina( PlayerId(), 1.0 )
            Wait( 0 )
        end

        ffaRifleStaminaRunning = false
    end )
end

local function getFfaRifleBoundaryCenter( spawns )
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

local function stopFfaRifleBoundaryCheck()
    if ffaRifleBoundaryAbort then
        ffaRifleBoundaryAbort()
        ffaRifleBoundaryAbort = nil
    end

    if StopBoundaryCheck then
        StopBoundaryCheck( FFA_RIFLE_BOUNDARY_ID )
    end
end

local function startFfaRifleBoundaryCheck()
    stopFfaRifleBoundaryCheck()

    if not StartBoundaryCheck then return end

    local spawns = getCurrentFfaRifleSpawnpoints()
    local center = getFfaRifleBoundaryCenter( spawns )
    if not center then return end

    ffaRifleBoundaryAbort = StartBoundaryCheck( FFA_RIFLE_BOUNDARY_ID, {
        centerCoords = center,
        maxDistance = FFA_RIFLE_BOUNDARY_RADIUS or 150.0,
        spawnCoords = spawns,
        showWarning = true,
        warningDistance = 0.90,
        warnInterval = 3000,
        teleportThreshold = 5000,
        onTeleport = function()
            if not isInFfaRifleMatch then return end

            CreateThread( function()
                Wait( 250 )
                if not isInFfaRifleMatch then return end
                local ped = PlayerPedId()
                if DoesEntityExist( ped ) then
                    setFfaRifleDamageProtection( ped, false )
                    restoreFfaRifleCriticalHits( ped )
                    giveFfaRifleWeapon()
                    ffaRifleWeaponHudEnabled = true
                    setFfaRifleHudSlotItems( true )
                end
            end )
        end,
    } )
end

local function setupFfaRiflePedAfterSpawn( forceNetworkResurrect )
    clearFfaRifleInputLocks()
    cleanFfaRifleArea()

    local ped = reviveFfaRiflePedAtCurrentPosition( forceNetworkResurrect )
    if not DoesEntityExist( ped ) then return end

    FreezeEntityPosition( ped, false )
    SetPlayerControl( PlayerId(), true, FFA_RIFLE_PLAYER_ENABLE_CONTROL_FLAGS )
    setFfaRifleDamageProtection( ped, false )
    restoreFfaRifleCriticalHits( ped )
    giveFfaRifleWeapon()
    ffaRifleWeaponHudEnabled = true
    setFfaRifleHudSlotItems( true )

    if ffaRifleClientInstance then
        ffaRifleClientInstance:transitionToState( MinigameClient.GameState.MATCH_GAMEPLAY, 'ffa rifle spawn ready' )
    end
end

local function startFfaRifleMatch( data, isLateJoin )
    data = type( data ) == 'table' and data or {}
    setCurrentFfaRifleMap( data.map )

    TriggerEvent( 'pvp.client:forceClosePanel' )
    PvpApplyDayClock()
    LocalPlayer["state"]["minigame:active"] = PVP_FFA_RIFLE_MINIGAME_NAME

    isInFfaRifleMatch = true
    currentFfaRifleMatchId = data.matchId or currentFfaRifleMatchId
    ffaRifleWeaponHudEnabled = false
    currentFfaRifleHudKills = 0
    setCurrentFfaRifleWeaponData( data.weapon )
    clearFfaRifleInputLocks()
    setFfaRifleScoreboardPlayers( {} )

    nuiHud( 'setHudMode', FFA_RIFLE_HUD_MODE )
    nuiHud( 'setPauseHintVisible', { visible = false } )
    nuiHud( 'clearKillFeed' )
    nuiHud( 'showHud' )
    setFfaRifleHudKills( 0, true )
    setFfaRifleHudSlotItems( false )

    startFfaRifleHudPolling()
    startFfaRifleStaminaLoop()
    startFfaRifleScoreboardControls()
    startFfaRifleBoundaryCheck()

    CreateThread( function()
        Wait( isLateJoin and 700 or 500 )
        if not isInFfaRifleMatch or not isSameFfaRifleMatchId( data.matchId, currentFfaRifleMatchId ) then return end

        setupFfaRiflePedAfterSpawn( false )
    end )
end

local function cleanupFfaRifleState( returnToNpc, restoreHud )
    isInFfaRifleMatch = false
    currentFfaRifleMatchId = nil
    ffaRifleWeaponHudEnabled = false
    currentFfaRifleHudKills = 0
    ffaRifleScoreboardPlayers = {}
    currentFfaRifleMap = nil

    stopFfaRifleBoundaryCheck()
    clearFfaRifleExitConfirmation()
    closeFfaRifleScoreboard()
    hideFfaRifleHud( true )
    clearFfaRifleWeaponState()
    restoreFfaRiflePedState()
    clearFfaRifleLocalMinigameState()

    if returnToNpc == true then
        returnToFfaRifleNpc()
    end

    if restoreHud == true then
        restoreDefaultHudAfterFfaRifle()
    end
end

RegisterNetEvent( 'pvp.ffa_rifle:mapState' )
AddEventHandler( 'pvp.ffa_rifle:mapState', function( data )
    if type( data ) ~= 'table' then return end
    if isInFfaRifleMatch and not isSameFfaRifleMatchId( data.matchId, currentFfaRifleMatchId ) then return end

    setCurrentFfaRifleMap( data.map )

    if not isInFfaRifleMatch then return end

    startFfaRifleBoundaryCheck()

    if data.applied ~= true then return end

    ffaRifleWeaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setFfaRifleHudSlotItems( false )

    CreateThread( function()
        Wait( FFA_RIFLE_RESPAWN_SETUP_DELAY_MS or 250 )
        if not isInFfaRifleMatch or not isSameFfaRifleMatchId( data.matchId, currentFfaRifleMatchId ) then return end

        setupFfaRiflePedAfterSpawn( false )
    end )
end )

RegisterNetEvent( 'pvp.ffa_rifle:scoreboardUpdate' )
AddEventHandler( 'pvp.ffa_rifle:scoreboardUpdate', function( data )
    if not isInFfaRifleMatch then return end

    local players = type( data ) == 'table' and ( data.players or data ) or {}
    setFfaRifleScoreboardPlayers( players )
end )

local function OnFfaRifleKillfeed( data )
    if not isInFfaRifleMatch or type( data ) ~= 'table' then return end

    local mySource = GetPlayerServerId( PlayerId() )
    if data.killerSource == mySource then
        if data.killerKills ~= nil then
            setFfaRifleHudKills( data.killerKills )
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

RegisterNetEvent( 'pvp.ffa_rifle:respawned' )
AddEventHandler( 'pvp.ffa_rifle:respawned', function( data )
    if not isInFfaRifleMatch then return end
    if data and not isSameFfaRifleMatchId( data.matchId, currentFfaRifleMatchId ) then return end

    ffaRifleWeaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setFfaRifleHudSlotItems( false )

    CreateThread( function()
        Wait( FFA_RIFLE_RESPAWN_SETUP_DELAY_MS or 250 )
        if not isInFfaRifleMatch then return end

        setupFfaRiflePedAfterSpawn( false )
    end )
end )

ffaRifleClientInstance = MinigameClient({
    name = PVP_FFA_RIFLE_MINIGAME_NAME,

    match = {
        enableKillfeed = true,
        onKillfeed = OnFfaRifleKillfeed,
        reportDamage = true,
        clearWeaponsOnRoundReset = false,
        confirmLeave = requestFfaRifleExitConfirmation,

        onStart = function( data )
            startFfaRifleMatch( data, false )
        end,

        onLateJoin = function( data )
            startFfaRifleMatch( data, true )
        end,

        onPlayerDeath = function( data )
            if not isInFfaRifleMatch then return end
            if data and not isSameFfaRifleMatchId( data.matchId, currentFfaRifleMatchId ) then return end

            ffaRifleWeaponHudEnabled = false
            nuiHud( 'updateHudWeapon', nil )
            setFfaRifleHudSlotItems( false )
            clearFfaRifleWeaponState()
        end,

        onEnd = function()
            cleanupFfaRifleState( true, true )
        end,

        onLeave = function()
            cleanupFfaRifleState( true, true )
        end,
    },
})
