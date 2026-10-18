---MinigameClient do modo FFA Pistola.

local ffaPistolClientInstance = nil
local isInFfaPistolMatch = false
local currentFfaPistolMatchId = nil
local currentFfaPistolHudKills = 0
local currentFfaPistolWeaponData = nil
local ffaPistolWeaponDisplayName = nil
local ffaPistolScoreboardPlayers = {}
local ffaPistolScoreboardOpen = false
local ffaPistolScoreboardControlsRunning = false
local ffaPistolScoreboardLastRequestAt = 0
local ffaPistolHudPollingRunning = false
local ffaPistolStaminaRunning = false
local ffaPistolBoundaryAbort = nil
local ffaPistolExitMatchResponseHandler = nil
local ffaPistolWeaponHudEnabled = false
local currentFfaPistolMap = nil

local FFA_PISTOL_PED_BASE_HEALTH = 100
local FFA_PISTOL_PED_MAX_HEALTH = 400
local FFA_PISTOL_SCOREBOARD_REFRESH_MS = 1000
local FFA_PISTOL_PLAYER_ENABLE_CONTROL_FLAGS = 0
local FFA_PISTOL_HUD_MODE = 'FREE_FOR_ALL'
local FFA_PISTOL_CLEAN_AREA_DISTANCE = 100.0
local FFA_PISTOL_BOUNDARY_ID = 'pvp_ffa_pistol'

local function pvpText( key, ... )
    return PvpTranslations.get( key, ... )
end

local function isSameFfaPistolMatchId( a, b )
    if not a or not b then return true end

    return tostring( a ) == tostring( b )
end

local function setCurrentFfaPistolMap( map )
    if type( map ) ~= 'table' then return end

    currentFfaPistolMap = map
end

local function getCurrentFfaPistolSpawnpoints()
    if currentFfaPistolMap and type( currentFfaPistolMap.spawns ) == 'table' and #currentFfaPistolMap.spawns > 0 then
        return currentFfaPistolMap.spawns
    end

    return GetFfaPistolSpawnpoints and GetFfaPistolSpawnpoints() or {}
end

local function setFfaPistolFullHealth( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedMaxHealth( ped, FFA_PISTOL_PED_MAX_HEALTH )
    SetEntityHealth( ped, FFA_PISTOL_PED_MAX_HEALTH )
end

local function restoreFfaPistolCriticalHits( ped )
    if not DoesEntityExist( ped ) then return end

    SetPedSuffersCriticalHits( ped, true )
end

local function setFfaPistolDamageProtection( ped, enabled )
    if not DoesEntityExist( ped ) then return end

    enabled = enabled == true
    SetEntityInvincible( ped, enabled )
    SetEntityCanBeDamaged( ped, not enabled )
    SetEntityProofs( ped, enabled, enabled, enabled, enabled, enabled, enabled, enabled, enabled )
    if not enabled then
        restoreFfaPistolCriticalHits( ped )
    end
    LocalPlayer["state"]["Invincible"] = enabled
end

local function clearFfaPistolLocalMinigameState()
    LocalPlayer["state"]["minigame:active"] = nil
    LocalPlayer["state"]["Invincible"] = false
end

local function restoreDefaultHudAfterFfaPistol()
    TriggerEvent( 'hud:syncConfig' )

    CreateThread( function()
        Wait( 150 )
        TriggerEvent( 'hud:Active', true )
    end )
end

local function isFfaPistolPedDeadOrDying( ped )
    return DoesEntityExist( ped ) and (
        IsEntityDead( ped ) or
        IsPedDeadOrDying( ped, true ) or
        GetEntityHealth( ped ) <= FFA_PISTOL_PED_BASE_HEALTH
    )
end

local function isFfaPistolSurvivalDead()
    if GetResourceState( 'survival' ) ~= 'started' then return false end

    local ok, isDead = pcall( function()
        return exports["survival"]:IsLocalPlayerDead()
    end )

    return ok and isDead == true
end

local function reviveFfaPistolSurvivalState()
    if GetResourceState( 'survival' ) ~= 'started' then return end

    exports["survival"]:Revive( FFA_PISTOL_PED_MAX_HEALTH )
    Wait( 100 )
end

local function alignFfaPistolGameplayCamera()
    SetGameplayCamRelativeHeading( 0.0 )
    SetGameplayCamRelativePitch( 0.0, 1.0 )
end

local function reviveFfaPistolPedAtCurrentPosition( forceNetworkResurrect )
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return ped end

    local coords = GetEntityCoords( ped )
    local heading = GetEntityHeading( ped )
    local shouldNetworkResurrect = forceNetworkResurrect == true

    if not shouldNetworkResurrect then
        shouldNetworkResurrect = isFfaPistolPedDeadOrDying( ped ) or isFfaPistolSurvivalDead()
    end

    if shouldNetworkResurrect then
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, heading )
        Wait( 0 )
    end

    reviveFfaPistolSurvivalState()
    ped = PlayerPedId()

    if DoesEntityExist( ped ) then
        SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, false, false, false )
        SetEntityHeading( ped, heading )
        alignFfaPistolGameplayCamera()
        setFfaPistolFullHealth( ped )
        setFfaPistolDamageProtection( ped, false )
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

local function restoreFfaPistolPedState()
    local ped = reviveFfaPistolPedAtCurrentPosition( false )
    if not DoesEntityExist( ped ) then return end

    setFfaPistolFullHealth( ped )
    setFfaPistolDamageProtection( ped, false )
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

local function clearFfaPistolInputLocks()
    SetNuiFocus( false, false )
    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end
    SetPlayerControl( PlayerId(), true, FFA_PISTOL_PLAYER_ENABLE_CONTROL_FLAGS )
    RenderScriptCams( false, false, 0, true, false )
    DestroyAllCams( true )
    NewLoadSceneStop()
    ClearFocus()
end

local function cleanFfaPistolArea()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local coords = GetEntityCoords( ped )
    ClearAreaOfVehicles( coords.x, coords.y, coords.z, FFA_PISTOL_CLEAN_AREA_DISTANCE, false, false, false, false, false )
    ClearAreaOfEverything( coords.x, coords.y, coords.z, FFA_PISTOL_CLEAN_AREA_DISTANCE, false, false, false, false )
end

local function getFfaPistolHealthPercent( ped )
    local health = math.max( 0, GetEntityHealth( ped ) - FFA_PISTOL_PED_BASE_HEALTH )
    local maxHealth = FFA_PISTOL_PED_MAX_HEALTH - FFA_PISTOL_PED_BASE_HEALTH

    return math.min( 100, math.floor( ( health / maxHealth ) * 100 ) )
end

local function normalizeFfaPistolWeaponSkinComponent( component )
    if not component or component == false or component == '' then return nil end

    return component
end

local function getFfaPistolLocalWeaponSkinComponent( weaponName )
    if GetResourceState( 'new_hub' ) ~= 'started' then return nil end

    local ok, component = pcall( function()
        return exports.new_hub:CheckWeaponSkins( weaponName )
    end )

    component = ok and normalizeFfaPistolWeaponSkinComponent( component ) or nil
    if component then return component end

    ok, component = pcall( function()
        return exports.new_hub:GetGroupSkins( weaponName )
    end )

    return ok and normalizeFfaPistolWeaponSkinComponent( component ) or nil
end

local function applyFfaPistolWeaponSkin( ped, weaponHash, weaponName )
    local component = getFfaPistolLocalWeaponSkinComponent( weaponName )
    if not component then return end

    local componentHash = type( component ) == 'number' and component or joaat( tostring( component ) )
    GiveWeaponComponentToPed( ped, weaponHash, componentHash )
end

local function getFfaPistolFallbackWeaponData()
    local data = GetFfaPistolWeapon and GetFfaPistolWeapon() or nil
    if type( data ) == 'table' then return data end

    return {
        id       = 'pistol',
        key      = 'pistol',
        name     = pvpText( 'weapon_pistol' ),
        weapon   = 'WEAPON_PISTOL_MK2',
        hud      = 'Pistol',
        killfeed = 'pistol',
        image    = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_pistol_mk2.webp',
        ammo     = 300,
        slotItem = 'weapon_pistol_mk2',
    }
end

local function normalizeFfaPistolWeaponData( data )
    local fallback = getFfaPistolFallbackWeaponData()
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

local function setCurrentFfaPistolWeaponData( data )
    currentFfaPistolWeaponData = normalizeFfaPistolWeaponData( data )
    ffaPistolWeaponDisplayName = currentFfaPistolWeaponData.hud or currentFfaPistolWeaponData.name or currentFfaPistolWeaponData.weapon
end

local function getCurrentFfaPistolWeaponName()
    if not currentFfaPistolWeaponData then
        setCurrentFfaPistolWeaponData( nil )
    end

    return currentFfaPistolWeaponData.weapon
end

local function getCurrentFfaPistolWeaponHash()
    return joaat( getCurrentFfaPistolWeaponName() )
end

local function getCurrentFfaPistolWeaponAmmo()
    if not currentFfaPistolWeaponData then
        setCurrentFfaPistolWeaponData( nil )
    end

    return tonumber( currentFfaPistolWeaponData.ammo ) or 300
end

local function giveFfaPistolWeapon()
    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponName = getCurrentFfaPistolWeaponName()
    local weaponHash = getCurrentFfaPistolWeaponHash()
    local ammo = getCurrentFfaPistolWeaponAmmo()

    SetCanPedEquipAllWeapons( ped, true )
    GiveWeaponToPed( ped, weaponHash, ammo, true, false )
    applyFfaPistolWeaponSkin( ped, weaponHash, weaponName )
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

local function clearFfaPistolWeaponState()
    TriggerEvent( 'inventory:CleanWeapons' )

    local ped = PlayerPedId()
    if not DoesEntityExist( ped ) then return end

    local weaponHash = getCurrentFfaPistolWeaponHash()
    SetCurrentPedWeapon( ped, joaat( 'WEAPON_UNARMED' ), true )
    RemoveWeaponFromPed( ped, weaponHash )
    RemoveAllPedWeapons( ped, true )
end

setCurrentFfaPistolWeaponData( nil )

local function getFfaPistolWeaponHudAmmo( ped, weaponHash )
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

local function setFfaPistolHudKills( kills, force )
    kills = math.max( 0, math.floor( tonumber( kills ) or 0 ) )
    if not force and currentFfaPistolHudKills == kills then return end

    currentFfaPistolHudKills = kills
    nuiHud( 'updateHudKills', kills )
end

local function setFfaPistolHudSlotItems( enabled )
    if enabled ~= true then
        nuiHud( 'updateHudSlotItems', {} )
        return
    end

    nuiHud( 'updateHudSlotItems', {
        {
            slot   = 1,
            name   = currentFfaPistolWeaponData.slotItem or 'weapon_pistol_mk2',
            image  = currentFfaPistolWeaponData.image,
            active = true,
        },
    } )
end

local function setFfaPistolScoreboardPlayers( players )
    ffaPistolScoreboardPlayers = copyHudPlayers( players )
    nuiHud( 'updateHudPlayerCount', #ffaPistolScoreboardPlayers )

    local mySource = GetPlayerServerId( PlayerId() )
    for _, player in ipairs( ffaPistolScoreboardPlayers ) do
        if tonumber( player.source ) == mySource then
            setFfaPistolHudKills( player.kills )
            break
        end
    end

    if ffaPistolScoreboardOpen then
        nuiHud( 'openScoreboard', ffaPistolScoreboardPlayers )
    end
end

local function requestFfaPistolScoreboard( force )
    local now = GetGameTimer()
    if not force and now - ffaPistolScoreboardLastRequestAt < FFA_PISTOL_SCOREBOARD_REFRESH_MS then return end

    ffaPistolScoreboardLastRequestAt = now
    TriggerServerEvent( 'pvp.ffa_pistol:requestScoreboard' )
end

local function openFfaPistolScoreboard()
    if ffaPistolScoreboardOpen then return end

    ffaPistolScoreboardOpen = true
    requestFfaPistolScoreboard( true )
    nuiHud( 'openScoreboard', ffaPistolScoreboardPlayers )
end

local function closeFfaPistolScoreboard()
    if not ffaPistolScoreboardOpen then return end

    nuiHud( 'closeScoreboard' )
    ffaPistolScoreboardOpen = false
end

RegisterCommand( '+dminigames_ffa_pistol_scoreboard', function()
    if not isInFfaPistolMatch then return end

    openFfaPistolScoreboard()
end, false )

RegisterCommand( '-dminigames_ffa_pistol_scoreboard', function()
    closeFfaPistolScoreboard()
end, false )

RegisterKeyMapping( '+dminigames_ffa_pistol_scoreboard', pvpText( 'scoreboard_key_mapping' ), 'keyboard', 'TAB' )

local function startFfaPistolScoreboardControls()
    if ffaPistolScoreboardControlsRunning then return end

    ffaPistolScoreboardControlsRunning = true
    CreateThread( function()
        while isInFfaPistolMatch do
            DisableControlAction( 0, 37, true )
            if IsDisabledControlJustPressed( 0, 37 ) then
                openFfaPistolScoreboard()
            elseif IsDisabledControlJustReleased( 0, 37 ) then
                closeFfaPistolScoreboard()
            end

            if ffaPistolScoreboardOpen then
                requestFfaPistolScoreboard( false )
            end
            Wait( 0 )
        end

        closeFfaPistolScoreboard()
        ffaPistolScoreboardControlsRunning = false
    end )
end

local function hideFfaPistolHud( closeResult )
    nuiHud( 'hideHud' )
    nuiHud( 'setPauseHintVisible', { visible = true } )
    nuiHud( 'hideCountdown' )
    nuiHud( 'hideKillNotification' )
    nuiHud( 'clearKillFeed' )
    nuiHud( 'updateHudWeapon', nil )
    nuiHud( 'updateHudSlotItems', {} )
    closeFfaPistolScoreboard()
    nuiHud( 'closeMatchStart' )
    nuiHud( 'closePauseOverlay' )

    if closeResult == true then
        nuiHud( 'closeMatchResult' )
    end
end

local function returnToFfaPistolNpc()
    hideFfaPistolHud( true )

    local ped = PlayerPedId()
    if DoesEntityExist( ped ) and PVP_NPC_COORDS then
        SetEntityCoordsNoOffset( ped, PVP_NPC_COORDS.x, PVP_NPC_COORDS.y, PVP_NPC_COORDS.z, false, false, false )
        SetEntityHeading( ped, PVP_NPC_COORDS.w )
    end
end

local function clearFfaPistolExitConfirmation()
    if ffaPistolExitMatchResponseHandler then
        RemoveEventHandler( ffaPistolExitMatchResponseHandler )
        ffaPistolExitMatchResponseHandler = nil
    end
end

local function requestFfaPistolExitConfirmation( cb )
    clearFfaPistolExitConfirmation()

    ffaPistolExitMatchResponseHandler = AddEventHandler( 'pvp.callback:exitMatchResponse', function( data )
        clearFfaPistolExitConfirmation()
        cb( isInFfaPistolMatch and type( data ) == 'table' and data.confirmed == true )
    end )

    nuiHud( 'openExitMatch', {
        title = pvpText( 'exit_match_title' ),
        description = pvpText( 'exit_match_description' ),
        confirmLabel = pvpText( 'exit_match_confirm' ),
        cancelLabel = pvpText( 'exit_match_cancel' ),
    } )
end

local function startFfaPistolHudPolling()
    if ffaPistolHudPollingRunning then return end

    ffaPistolHudPollingRunning = true
    CreateThread( function()
        local nextStatusUpdate = 0

        while isInFfaPistolMatch do
            local ped = PlayerPedId()
            local now = GetGameTimer()

            if now >= nextStatusUpdate then
                nuiHud( 'updateHudStatus', {
                    health = getFfaPistolHealthPercent( ped ),
                    armor = GetPedArmour( ped ),
                } )
                nextStatusUpdate = now + 500
            end

            local weaponHash = getCurrentFfaPistolWeaponHash()
            local hasWeapon = DoesEntityExist( ped ) and HasPedGotWeapon( ped, weaponHash, false )
            if hasWeapon and ffaPistolWeaponHudEnabled then
                local ammo, maxAmmo = getFfaPistolWeaponHudAmmo( ped, weaponHash )
                nuiHud( 'updateHudWeapon', {
                    name = ffaPistolWeaponDisplayName,
                    ammo = ammo,
                    maxAmmo = maxAmmo,
                    image = currentFfaPistolWeaponData.image,
                } )
            else
                nuiHud( 'updateHudWeapon', nil )
            end

            Wait( 200 )
        end

        nuiHud( 'updateHudWeapon', nil )
        setFfaPistolHudSlotItems( false )
        ffaPistolHudPollingRunning = false
    end )
end

local function startFfaPistolStaminaLoop()
    if ffaPistolStaminaRunning then return end

    ffaPistolStaminaRunning = true
    CreateThread( function()
        while isInFfaPistolMatch do
            RestorePlayerStamina( PlayerId(), 1.0 )
            Wait( 0 )
        end

        ffaPistolStaminaRunning = false
    end )
end

local function getFfaPistolBoundaryCenter( spawns )
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

local function stopFfaPistolBoundaryCheck()
    if ffaPistolBoundaryAbort then
        ffaPistolBoundaryAbort()
        ffaPistolBoundaryAbort = nil
    end

    if StopBoundaryCheck then
        StopBoundaryCheck( FFA_PISTOL_BOUNDARY_ID )
    end
end

local function startFfaPistolBoundaryCheck()
    stopFfaPistolBoundaryCheck()

    if not StartBoundaryCheck then return end

    local spawns = getCurrentFfaPistolSpawnpoints()
    local center = getFfaPistolBoundaryCenter( spawns )
    if not center then return end

    ffaPistolBoundaryAbort = StartBoundaryCheck( FFA_PISTOL_BOUNDARY_ID, {
        centerCoords = center,
        maxDistance = FFA_PISTOL_BOUNDARY_RADIUS or 150.0,
        spawnCoords = spawns,
        showWarning = true,
        warningDistance = 0.90,
        warnInterval = 3000,
        teleportThreshold = 5000,
        onTeleport = function()
            if not isInFfaPistolMatch then return end

            CreateThread( function()
                Wait( 250 )
                if not isInFfaPistolMatch then return end
                local ped = PlayerPedId()
                if DoesEntityExist( ped ) then
                    setFfaPistolDamageProtection( ped, false )
                    restoreFfaPistolCriticalHits( ped )
                    giveFfaPistolWeapon()
                    ffaPistolWeaponHudEnabled = true
                    setFfaPistolHudSlotItems( true )
                end
            end )
        end,
    } )
end

local function setupFfaPistolPedAfterSpawn( forceNetworkResurrect )
    clearFfaPistolInputLocks()
    cleanFfaPistolArea()

    local ped = reviveFfaPistolPedAtCurrentPosition( forceNetworkResurrect )
    if not DoesEntityExist( ped ) then return end

    FreezeEntityPosition( ped, false )
    SetPlayerControl( PlayerId(), true, FFA_PISTOL_PLAYER_ENABLE_CONTROL_FLAGS )
    setFfaPistolDamageProtection( ped, false )
    restoreFfaPistolCriticalHits( ped )
    giveFfaPistolWeapon()
    ffaPistolWeaponHudEnabled = true
    setFfaPistolHudSlotItems( true )

    if ffaPistolClientInstance then
        ffaPistolClientInstance:transitionToState( MinigameClient.GameState.MATCH_GAMEPLAY, 'ffa pistol spawn ready' )
    end
end

local function startFfaPistolMatch( data, isLateJoin )
    data = type( data ) == 'table' and data or {}
    setCurrentFfaPistolMap( data.map )

    TriggerEvent( 'pvp.client:forceClosePanel' )
    PvpApplyDayClock()
    LocalPlayer["state"]["minigame:active"] = PVP_FFA_PISTOL_MINIGAME_NAME

    isInFfaPistolMatch = true
    currentFfaPistolMatchId = data.matchId or currentFfaPistolMatchId
    ffaPistolWeaponHudEnabled = false
    currentFfaPistolHudKills = 0
    setCurrentFfaPistolWeaponData( data.weapon )
    clearFfaPistolInputLocks()
    setFfaPistolScoreboardPlayers( {} )

    nuiHud( 'setHudMode', FFA_PISTOL_HUD_MODE )
    nuiHud( 'setPauseHintVisible', { visible = false } )
    nuiHud( 'clearKillFeed' )
    nuiHud( 'showHud' )
    setFfaPistolHudKills( 0, true )
    setFfaPistolHudSlotItems( false )

    startFfaPistolHudPolling()
    startFfaPistolStaminaLoop()
    startFfaPistolScoreboardControls()
    startFfaPistolBoundaryCheck()

    CreateThread( function()
        Wait( isLateJoin and 700 or 500 )
        if not isInFfaPistolMatch or not isSameFfaPistolMatchId( data.matchId, currentFfaPistolMatchId ) then return end

        setupFfaPistolPedAfterSpawn( false )
    end )
end

local function cleanupFfaPistolState( returnToNpc, restoreHud )
    isInFfaPistolMatch = false
    currentFfaPistolMatchId = nil
    ffaPistolWeaponHudEnabled = false
    currentFfaPistolHudKills = 0
    ffaPistolScoreboardPlayers = {}
    currentFfaPistolMap = nil

    stopFfaPistolBoundaryCheck()
    clearFfaPistolExitConfirmation()
    closeFfaPistolScoreboard()
    hideFfaPistolHud( true )
    clearFfaPistolWeaponState()
    restoreFfaPistolPedState()
    clearFfaPistolLocalMinigameState()

    if returnToNpc == true then
        returnToFfaPistolNpc()
    end

    if restoreHud == true then
        restoreDefaultHudAfterFfaPistol()
    end
end

RegisterNetEvent( 'pvp.ffa_pistol:mapState' )
AddEventHandler( 'pvp.ffa_pistol:mapState', function( data )
    if type( data ) ~= 'table' then return end
    if isInFfaPistolMatch and not isSameFfaPistolMatchId( data.matchId, currentFfaPistolMatchId ) then return end

    setCurrentFfaPistolMap( data.map )

    if not isInFfaPistolMatch then return end

    startFfaPistolBoundaryCheck()

    if data.applied ~= true then return end

    ffaPistolWeaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setFfaPistolHudSlotItems( false )

    CreateThread( function()
        Wait( FFA_PISTOL_RESPAWN_SETUP_DELAY_MS or 250 )
        if not isInFfaPistolMatch or not isSameFfaPistolMatchId( data.matchId, currentFfaPistolMatchId ) then return end

        setupFfaPistolPedAfterSpawn( false )
    end )
end )

RegisterNetEvent( 'pvp.ffa_pistol:scoreboardUpdate' )
AddEventHandler( 'pvp.ffa_pistol:scoreboardUpdate', function( data )
    if not isInFfaPistolMatch then return end

    local players = type( data ) == 'table' and ( data.players or data ) or {}
    setFfaPistolScoreboardPlayers( players )
end )

local function OnFfaPistolKillfeed( data )
    if not isInFfaPistolMatch or type( data ) ~= 'table' then return end

    local mySource = GetPlayerServerId( PlayerId() )
    if data.killerSource == mySource then
        if data.killerKills ~= nil then
            setFfaPistolHudKills( data.killerKills )
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

RegisterNetEvent( 'pvp.ffa_pistol:respawned' )
AddEventHandler( 'pvp.ffa_pistol:respawned', function( data )
    if not isInFfaPistolMatch then return end
    if data and not isSameFfaPistolMatchId( data.matchId, currentFfaPistolMatchId ) then return end

    ffaPistolWeaponHudEnabled = false
    nuiHud( 'updateHudWeapon', nil )
    setFfaPistolHudSlotItems( false )

    CreateThread( function()
        Wait( FFA_PISTOL_RESPAWN_SETUP_DELAY_MS or 250 )
        if not isInFfaPistolMatch then return end

        setupFfaPistolPedAfterSpawn( false )
    end )
end )

ffaPistolClientInstance = MinigameClient({
    name = PVP_FFA_PISTOL_MINIGAME_NAME,

    match = {
        enableKillfeed = true,
        onKillfeed = OnFfaPistolKillfeed,
        reportDamage = true,
        clearWeaponsOnRoundReset = false,
        confirmLeave = requestFfaPistolExitConfirmation,

        onStart = function( data )
            startFfaPistolMatch( data, false )
        end,

        onLateJoin = function( data )
            startFfaPistolMatch( data, true )
        end,

        onPlayerDeath = function( data )
            if not isInFfaPistolMatch then return end
            if data and not isSameFfaPistolMatchId( data.matchId, currentFfaPistolMatchId ) then return end

            ffaPistolWeaponHudEnabled = false
            nuiHud( 'updateHudWeapon', nil )
            setFfaPistolHudSlotItems( false )
            clearFfaPistolWeaponState()
        end,

        onEnd = function()
            cleanupFfaPistolState( true, true )
        end,

        onLeave = function()
            cleanupFfaPistolState( true, true )
        end,
    },
})
