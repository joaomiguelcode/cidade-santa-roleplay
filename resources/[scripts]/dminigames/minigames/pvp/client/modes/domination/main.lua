---@class DominationSelectorPreviewOrigin
---@field ped number
---@field coords vector3
---@field heading number
---@field visible boolean
---@field vehicle number
---@field seat integer?

---@class DominationClient
---@field renderer MapZoneRenderer?
---@field zoneTracker SpatialZoneTracker
---@field capturePointTracker SpatialZoneTracker
---@field boundaryRenderer SpatialZoneBoundaryRenderer?
---@field capturePointRenderer DominationCapturePointRenderer?
---@field revivePointRenderer DominationCapturePointRenderer?
---@field lootDuiProbe DominationLootDuiProbe?
---@field rankingBoardRenderers DominationRankingBoardRenderer[]
---@field snapshot table?
---@field zoneById table<string, table>
---@field safeZoneById table<string, table>
---@field localInsideById table<string, boolean>
---@field localInsideCapturePointById table<string, boolean>
---@field authoritativeInsideById table<string, boolean>
---@field active boolean
---@field lifecycleRevision integer
---@field selectorOpen boolean
---@field respawnToken integer?
---@field respawnChoiceOpen boolean
---@field selectorLeavesMatchOnClose boolean
---@field previewCamera number?
---@field previewCameras table<number, boolean>
---@field previewCameraRevision integer
---@field previewRequestRevision integer
---@field previewZoneId string?
---@field previewMinimapLocked boolean
---@field previewRadarDistance number
---@field areaLoadRevision integer
---@field areaLoad table?
---@field selectorZoneById table<string, table>
---@field exitMatchResponseHandler number?
---@field zoneDebugEnabled boolean
---@field zoneDebugRevision integer
---@field safeHealingRevision integer
---@field safeProtectionActive boolean
---@field safeCollisionProtectionActive boolean
---@field safeProtectionRevision integer
---@field safeExitProtectionUntil integer?
---@field safeExitProtectionRevision integer
---@field safeCollisionEntities table<number, boolean>
---@field vehicleCollisionEntities number[]
---@field hudVisible boolean
---@field hudRevision integer
---@field hudWeaponName string?
---@field hudStatusSignature string?
---@field hudWeaponSignature string?
---@field deathHudVisible boolean
---@field deathDurationSeconds integer?
---@field captureHudZoneId string?
---@field captureHudCompletionZoneId string?
---@field captureHudCompletionRevision integer
---@field captureHudCompletion { zoneId: string, payload: table }?
---@field selectorFadeOwned boolean
---@field teleportFadeOwned boolean
---@field teleportFrozenPed number?
---@field teleportRevision integer
---@field selectorCayoPreviewOwned boolean
---@field selectorPreviewFreezeRevision integer
---@field selectorPreviewFrozenPed number?
---@field selectorPreviewFrozenVehicle number?
---@field selectorPreviewOrigin DominationSelectorPreviewOrigin?
---@field gameplayActive boolean
---@field presenceHeartbeatRevision integer
---@field revivablePlayerBySource table<number, boolean>
---@field reviveCandidateSource number?
---@field reviveCandidateMode string?
---@field reviveRequestTargetSource number?
---@field reviveRequestReleased boolean
---@field reviveAttemptId integer?
---@field reviveAttemptTargetSource number?
---@field reviveAttemptFinishAt integer?
---@field reviveCompletionPending boolean
---@field reviveLoopRevision integer
---@field reviveCompletionRevision integer
---@field reviveAnimationRevision integer
---@field reviveAnimationPed number?
---@field lootHoldTargetSource number?
---@field lootHoldFinishAt integer?
---@field lootCompletionRevision integer
---@field teamPlayerBySource table<number, boolean>
---@field outlinedTeamPedBySource table<number, number>
---@field teamOutlineRevision integer
---@field headquartersFreezeRevision integer
---@field headquartersFrozenPed number?
---@field storeAvailable boolean
---@field storeOpen boolean
---@field storeRequestInFlight boolean
---@field vehiclesOpen boolean
---@field vehiclesAvailable boolean
---@field vehiclesRequestInFlight boolean
---@field vehicles table[]
---@field vehicleRemovalWarning table?
---@field zoneMapRefreshRunning boolean?
---@field zoneMapRefreshPending boolean?
local DominationClient = class()

local DOMINATION_SELECTOR_EVENT = 'PVP_DOMINATION_SAFE_ZONE_SELECTOR'
local DOMINATION_STORE_EVENT = 'PVP_DOMINATION_STORE'
local DOMINATION_VEHICLES_EVENT = 'PVP_DOMINATION_VEHICLES'
local DOMINATION_STORE_CATEGORY_IDS = { 'vehicles', 'weapons' }
local DOMINATION_SELECTOR_FADE_MS = 250
local DOMINATION_SELECTOR_SETTLE_MS = 100
local DOMINATION_SELECTOR_PREVIEW_DEBOUNCE_MS = 250
local DOMINATION_TELEPORT_FADE_MS = 250
local DOMINATION_SAFE_ZONE_TELEPORT_FREEZE_MS = 3000
local DOMINATION_HEADQUARTERS_LOAD_FREEZE_MS = 4000
-- Teto de espera pela pose abatida antes de abrir a escolha de renascer.
local DOMINATION_RESPAWN_CHOICE_POSE_TIMEOUT_MS = 2000
local DOMINATION_SCENE_LOAD_RADIUS = 50.0
local DOMINATION_CAYO_SAFE_ZONE_ID = 'ilha'
local DOMINATION_MINIMAP_OWNER = 'dminigames:domination'
local DOMINATION_ZONE_CLIENT_INTERVAL_MS = 150
local DOMINATION_PRESENCE_HEARTBEAT_MS = 2000
local DOMINATION_ZONE_DEBUG_DRAW_DISTANCE = 350.0
local DOMINATION_HUD_MODE = 'FREE_FOR_ALL'
local DOMINATION_HUD_UPDATE_INTERVAL_MS = 200
local DOMINATION_HUD_STATUS_INTERVAL_MS = 500
local DOMINATION_CAPTURE_HUD_COMPLETION_MS = 5000
local DOMINATION_FALLBACK_DEATH_DURATION_SECONDS = 150
local DOMINATION_SAFE_GHOST_REFRESH_INTERVAL_MS = 1000
local DOMINATION_SAFE_COLLISION_REFRESH_INTERVAL_MS = 250
local DOMINATION_SAFE_COLLISION_DISTANCE = 60.0
local DOMINATION_VEHICLE_COLLISION_REFRESH_INTERVAL_MS = 250
local DOMINATION_VEHICLE_COLLISION_DISTANCE = 60.0
local DOMINATION_SAFE_INVINCIBILITY_OWNER = 'domination_safe'
local DOMINATION_PREVIEW_CAMERA_TRANSITION_MS = 650
local DOMINATION_PREVIEW_CAMERA_MIN_HEIGHT = 190.0
local DOMINATION_PREVIEW_CAMERA_RADIUS_HEIGHT_MULTIPLIER = 1.85
local DOMINATION_PREVIEW_CAMERA_RADIUS_OFFSET_MULTIPLIER = 0.65
local DOMINATION_SELECTOR_RADAR_DEFAULT_DISTANCE = 300.0
local DOMINATION_SELECTOR_RADAR_RADIUS_MULTIPLIER = 3.0
local DOMINATION_REVIVE_CONTROL = 38
local DOMINATION_REVIVE_SCAN_INTERVAL_MS = 150
local DOMINATION_REVIVE_DISTANCE = 2.75
local DOMINATION_REVIVE_DISTANCE_SQUARED = DOMINATION_REVIVE_DISTANCE
    * DOMINATION_REVIVE_DISTANCE
local DOMINATION_REVIVE_COMPLETE_DISPLAY_MS = 650
local DOMINATION_LOOT_DURATION_MS = 1800
local DOMINATION_LOOT_DISTANCE = 2.0
local DOMINATION_LOOT_DISTANCE_SQUARED = DOMINATION_LOOT_DISTANCE
    * DOMINATION_LOOT_DISTANCE
local DOMINATION_LOOT_RED = 249
local DOMINATION_LOOT_GREEN = 178
local DOMINATION_LOOT_BLUE = 51
local DOMINATION_REVIVE_ANIMATION_DICTIONARY = 'mini@cpr@char_a@cpr_str'
local DOMINATION_REVIVE_ANIMATION_NAME = 'cpr_pumpchest'
local DOMINATION_REVIVE_ANIMATION_LOAD_TIMEOUT_MS = 3000
local DOMINATION_TEAM_OUTLINE_REFRESH_INTERVAL_MS = 500
local DOMINATION_TEAM_OUTLINE_RED = 80
local DOMINATION_TEAM_OUTLINE_GREEN = 170
local DOMINATION_TEAM_OUTLINE_BLUE = 255
local gDominationMinigameClient = nil
local gNewHubServer = Tunnel.getInterface( 'new_hub' )
local gGaragesServer = Tunnel.getInterface( 'garages' )
local gPersonalGarageIndex = nil
local gDominationVehicleBoundsByModel = {}
local gDominationExpiringVehicles = {}

---@param warning table
local function RestoreExpiringVehicleAlpha( warning )
    if warning.entity and warning.entity == GetEntityFromStateBagName( warning.bagName )
        and DoesEntityExist( warning.entity )
    then
        SetEntityAlpha( warning.entity, warning.alpha, false )
    end
end

AddStateBagChangeHandler( 'domination:vehicleExpiring', nil, function( bagName, _, value )
    local previous = gDominationExpiringVehicles[ bagName ]
    gDominationExpiringVehicles[ bagName ] = nil
    if previous then
        RestoreExpiringVehicleAlpha( previous )
    end
    if value ~= true then
        return
    end

    local warning = { bagName = bagName, streamDeadline = GetGameTimer() + 5000 }
    gDominationExpiringVehicles[ bagName ] = warning
    CreateThread( function()
        while gDominationExpiringVehicles[ bagName ] == warning do
            local entity = GetEntityFromStateBagName( bagName )
            if entity ~= 0 and DoesEntityExist( entity ) then
                if warning.entity ~= entity then
                    warning.entity = entity
                    warning.alpha = GetEntityAlpha( entity )
                end
                SetEntityAlpha( entity, 102, false )
            elseif warning.entity or GetGameTimer() >= warning.streamDeadline then
                gDominationExpiringVehicles[ bagName ] = nil
                return
            end
            Wait( 250 )
        end
    end )
end )

AddEventHandler( 'onResourceStop', function( resourceName )
    if resourceName == GetCurrentResourceName() then
        for _, warning in pairs( gDominationExpiringVehicles ) do
            RestoreExpiringVehicleAlpha( warning )
        end
        gDominationExpiringVehicles = {}
    end
end )

---@private
---@param stage string
---@param loadState? table
function DominationClient:LogStreaming( stage, loadState )
    loadState = loadState or self.areaLoad or {}
    local now = GetGameTimer()
    local ped = PlayerPedId()
    local hasPed = ped ~= 0 and DoesEntityExist( ped )

--     sx.logger:info( ( '[DominationStreaming] %s t=%d zone=%s rev=%s currentRev=%s elapsedMs=%d ready=%s sceneActive=%s sceneLoaded=%s focusOnPed=%s collision=%s ped=%s cam=%s target=(%.2f,%.2f,%.2f) radius=%.2f preview=%s teleportRev=%s' ):format(
--         stage, now, tostring( loadState.zoneId ),
--         tostring( loadState.revision ), tostring( self.areaLoadRevision ),
--         now - ( loadState.startedAt or now ), tostring( loadState.ready ),
--         tostring( IsNewLoadSceneActive() ), tostring( IsNewLoadSceneLoaded() ),
--         tostring( hasPed and IsEntityFocus( ped ) ),
--         tostring( hasPed and HasCollisionLoadedAroundEntity( ped ) ),
--         tostring( hasPed and GetEntityCoords( ped ) ), tostring( GetFinalRenderedCamCoord() ),
--         loadState.x or 0.0, loadState.y or 0.0, loadState.z or 0.0, loadState.radius or 0.0,
--         tostring( self.previewZoneId ), tostring( self.teleportRevision )
--     ) )
end

---@private
function DominationClient:StopAreaLoad()
    local loadState = self.areaLoad
    self.areaLoadRevision = self.areaLoadRevision + 1
    self.areaLoad = nil
    NewLoadSceneStop()
    ClearFocus()
    self:LogStreaming( 'cleanup', loadState )
end

---@private
---@param zoneId string
---@param x number
---@param y number
---@param z number
---@param radius? number
---@return table? loadState
function DominationClient:StartAreaLoad( zoneId, x, y, z, radius )
    local zoneKey = tostring( zoneId )
    local loadRadius = math.max(
        tonumber( radius ) or DOMINATION_SCENE_LOAD_RADIUS,
        DOMINATION_SCENE_LOAD_RADIUS
    )
    local currentLoad = self.areaLoad

    if currentLoad
        and currentLoad.zoneId == zoneKey
        and currentLoad.radius >= loadRadius
    then
        self:LogStreaming( 'scene_reused', currentLoad )
        return currentLoad
    end

    self:StopAreaLoad()

    local loadState = {
        zoneId = zoneKey,
        x = x,
        y = y,
        z = z,
        radius = loadRadius,
        ready = false,
        revision = self.areaLoadRevision,
        startedAt = GetGameTimer(),
    }

    if not NewLoadSceneStart(
        x,
        y,
        z,
        0.0,
        0.0,
        0.0,
        loadRadius,
        0
    ) then
        self:LogStreaming( 'scene_start_failed', loadState )
        self:StopAreaLoad()
--         sx.logger:warn( ( 'Failed to start Domination scene load zone=%s' ):format( zoneKey ) )
        return nil
    end

    self.areaLoad = loadState
    self:LogStreaming( 'scene_started', loadState )

    -- Uma amostra tardia, sem polling ou mudanca no timeout/comportamento da carga.
    SetTimeout( 5000, function()
        if self.areaLoad == loadState and self.areaLoadRevision == loadState.revision then
            self:LogStreaming( 'scene_snapshot_5s', loadState )
        end
    end )

    CreateThread( function()
        while self.areaLoad == loadState
            and self.areaLoadRevision == loadState.revision
            and not IsNewLoadSceneLoaded()
        do
            Wait( 0 )
        end

        if self.areaLoad ~= loadState
            or self.areaLoadRevision ~= loadState.revision
        then
            self:LogStreaming( 'scene_cancelled', loadState )
            return
        end

        self:LogStreaming( 'scene_loaded', loadState )
        NewLoadSceneStop()
        SetFocusArea( x, y, z, 0.0, 0.0, 0.0 )
        loadState.ready = true
        self:LogStreaming( 'focus_applied', loadState )
    end )

    return loadState
end

local DOMINATION_BIKE_VEHICLE_CLASSES = {
    [ 8 ] = true,
    [ 13 ] = true,
}

local DOMINATION_OTHER_VEHICLE_CLASSES = {
    [ 14 ] = true,
    [ 15 ] = true,
    [ 16 ] = true,
    [ 21 ] = true,
}

local DOMINATION_BIKE_VEHICLE_TYPES = {
    bike = true,
    bicycle = true,
    motorcycle = true,
}

local DOMINATION_CAR_VEHICLE_TYPES = {
    amphibious_automobile = true,
    amphibious_quadbike = true,
    automobile = true,
    car = true,
    quadbike = true,
    submarinecar = true,
}

local DOMINATION_OTHER_VEHICLE_TYPES = {
    blimp = true,
    boat = true,
    heli = true,
    helicopter = true,
    jetski = true,
    plane = true,
    submarine = true,
    trailer = true,
    train = true,
}

---@param model string
---@param vehicleType? string
---@param currentType? string
---@return string category
local function ResolveDominationVehicleCategory( model, vehicleType, currentType )
    vehicleType = type( vehicleType ) == 'string' and vehicleType:lower() or nil
    currentType = type( currentType ) == 'string' and currentType:lower() or nil

    if DOMINATION_BIKE_VEHICLE_TYPES[ vehicleType ] then
        return 'bikes'
    end

    if DOMINATION_CAR_VEHICLE_TYPES[ vehicleType ] then
        return 'cars'
    end

    if DOMINATION_OTHER_VEHICLE_TYPES[ vehicleType ] then
        return 'others'
    end

    if currentType == 'cars' then
        return 'cars'
    end

    if currentType == 'bikes' then
        return 'bikes'
    end

    if currentType == 'others' then
        return 'others'
    end

    local vehicleClass = GetVehicleClassFromName( joaat( model ) )

    if DOMINATION_BIKE_VEHICLE_CLASSES[ vehicleClass ] then
        return 'bikes'
    end

    if vehicleClass == -1 or DOMINATION_OTHER_VEHICLE_CLASSES[ vehicleClass ] then
        return 'others'
    end

    return 'cars'
end

---@return number? garageIndex
local function ResolvePersonalGarageIndex()
    if gPersonalGarageIndex then
        return gPersonalGarageIndex
    end

    if GetResourceState( 'garages' ) ~= 'started' then
        return nil
    end

    local succeeded, garages = pcall( function()
        return exports.garages:GetGarages()
    end )

    if not succeeded or type( garages ) ~= 'table' then
        return nil
    end

    for garageIndex, garage in ipairs( garages ) do
        local info = type( garage ) == 'table' and garage.Info or nil

        if info
            and info.Name == 'Garage'
            and not info.Perm
            and not info.Heli
        then
            gPersonalGarageIndex = garageIndex
            return garageIndex
        end
    end

    return nil
end

---@param zones table[]
---@return table[] capturePointZones
local function BuildCapturePointZones( zones )
    local capturePointZones = {}

    for _, zone in ipairs( zones ) do
        local capturePoint = zone.capturePoint

        if zone.type == 'capture' and capturePoint then
            capturePointZones[ #capturePointZones + 1 ] = {
                id = zone.id,
                type = 'capture_point',
                shape = 'circle',
                center = {
                    x = capturePoint.x or capturePoint[ 1 ],
                    y = capturePoint.y or capturePoint[ 2 ],
                },
                radius = zone.captureRadius,
                minZ = zone.captureMinZ,
                maxZ = zone.captureMaxZ,
            }
        end
    end

    return capturePointZones
end

function DominationClient:__init()
    self.renderer = nil
    self.zoneTracker = SpatialZoneTracker( {
        intervalMs = DOMINATION_ZONE_CLIENT_INTERVAL_MS,
        onEnter = function( zone, position )
            self:OnLocalZoneEnter( zone, position )
        end,
        onExit = function( zone, position )
            self:OnLocalZoneExit( zone, position )
        end,
    } )
    self.capturePointTracker = SpatialZoneTracker( {
        intervalMs = DOMINATION_ZONE_CLIENT_INTERVAL_MS,
        onEnter = function( zone )
            self:OnLocalCapturePointEnter( zone )
        end,
        onExit = function( zone )
            self:OnLocalCapturePointExit( zone )
        end,
    } )
    self.boundaryRenderer = nil
    self.capturePointRenderer = nil
    self.revivePointRenderer = nil
    self.rankingBoardRenderers = {}
    self.snapshot = nil
    self.zoneById = {}
    self.safeZoneById = {}
    self.localInsideById = {}
    self.localInsideCapturePointById = {}
    self.authoritativeInsideById = {}
    self.active = false
    self.lifecycleRevision = 0
    self.selectorOpen = false
    self.respawnToken = nil
    self.respawnChoiceOpen = false
    self.selectorLeavesMatchOnClose = false
    self.previewCamera = nil
    self.previewCameras = {}
    self.previewCameraRevision = 0
    self.previewRequestRevision = 0
    self.previewZoneId = nil
    self.previewMinimapLocked = false
    self.previewRadarDistance = DOMINATION_SELECTOR_RADAR_DEFAULT_DISTANCE
    self.areaLoadRevision = 0
    self.areaLoad = nil
    self.selectorZoneById = {}
    self.exitMatchResponseHandler = nil
    self.zoneDebugEnabled = false
    self.zoneDebugRevision = 0
    self.safeHealingRevision = 0
    self.safeProtectionActive = false
    self.safeCollisionProtectionActive = false
    self.safeProtectionRevision = 0
    self.safeExitProtectionUntil = nil
    self.safeExitProtectionRevision = 0
    self.safeCollisionEntities = {}
    self.vehicleCollisionEntities = {}
    self.hudVisible = false
    self.hudRevision = 0
    self.hudWeaponName = nil
    self.hudStatusSignature = nil
    self.hudWeaponSignature = nil
    self.hudPlayerCount = 0
    self.deathHudVisible = false
    self.deathDurationSeconds = nil
    self.captureHudZoneId = nil
    self.captureHudCompletionZoneId = nil
    self.captureHudCompletionRevision = 0
    self.selectorFadeOwned = false
    self.teleportFadeOwned = false
    self.teleportFrozenPed = nil
    self.teleportRevision = 0
    self.selectorCayoPreviewOwned = false
    self.selectorPreviewFreezeRevision = 0
    self.selectorPreviewFrozenPed = nil
    self.selectorPreviewFrozenVehicle = nil
    self.selectorPreviewOrigin = nil
    self.gameplayActive = false
    self.presenceHeartbeatRevision = 0
    self.revivablePlayerBySource = {}
    self.reviveCandidateSource = nil
    self.reviveCandidateMode = nil
    self.reviveRequestTargetSource = nil
    self.reviveRequestReleased = false
    self.reviveAttemptId = nil
    self.reviveAttemptTargetSource = nil
    self.reviveAttemptFinishAt = nil
    self.reviveCompletionPending = false
    self.reviveLoopRevision = 0
    self.reviveCompletionRevision = 0
    self.reviveAnimationRevision = 0
    self.reviveAnimationPed = nil
    self.lootHoldTargetSource = nil
    self.lootHoldFinishAt = nil
    self.lootCompletionRevision = 0
    self.teamPlayerBySource = {}
    self.outlinedTeamPedBySource = {}
    self.teamOutlineRevision = 0
    self.headquartersFreezeRevision = 0
    self.headquartersFrozenPed = nil
    self.storeAvailable = false
    self.storeOpen = false
    self.storeRequestInFlight = false
    self.vehiclesOpen = false
    self.vehiclesAvailable = false
    self.vehiclesRequestInFlight = false
    self.vehicles = {}
end

function DominationClient:CreateRenderers()
    if self.renderer then
        return
    end

    self.renderer = MapZoneRenderer( {
        textureDictionaryPrefix = 'dmg_domination_zones',
        canvasSize = 2048, -- Resolucao aprovada em QA: evita o custo da superficie 4096.
        maxWindowSpan = math.huge, -- Todas as zonas compartilham uma unica DUI do mapa.
        projectionZones = DOMINATION_ZONES, -- Janela fixa; o snapshot define somente quais zonas desenhar.
        circleSegments = 32,
    } )
    self.boundaryRenderer = SpatialZoneBoundaryRenderer( {
        drawDistance = 180.0,
        wallBottomZ = -1000.0,
        wallTopZ = 1000.0,
        wallAlpha = 210,
        textureState = 'neutral',
        useBoundaryProfiles = false,
        useFullTexture = true,
        textureImage = 'web/domination-zone-boundary.png',
        textureDictionaryPrefix = 'domination_boundary',
        textureName = 'atlas',
        textureSize = 1024,
        textureRepeatDistance = 100.0,
        visualWallHeight = 100.0,
        circleSegments = 12,
        cylinderZoneIds = true,
        cylinderWallHeight = 500.0,
        cylinderTextureImage = 'web/domination-zone-boundary-cylinder.png',
    } )
    self.capturePointRenderer = DominationCapturePointRenderer( {
        textureSize = 512,
        shouldRender = function( zone )
            return self.gameplayActive
                and self.localInsideById[ tostring( zone.id ) ] == true
        end,
    } )
    self.revivePointRenderer = DominationCapturePointRenderer( {
        textureDictionaryPrefix = 'domination_revive_point',
        textureName = 'revive_point',
        textureSize = 512,
        drawDistance = DOMINATION_REVIVE_DISTANCE,
    } )

    if DOMINATION_LOOT.enabled then
        self.lootRenderer = DominationLootRenderer( self )
        self.lootRenderer:Start()
    else
        self.lootDuiProbe = DominationLootDuiProbe()
        self.lootDuiProbe:Start()
    end

    local shouldRenderRankingBoards = function()
        return self.gameplayActive
    end
    local shouldInteractWithRankingBoards = function()
        return self.gameplayActive
            and not self.selectorOpen
            and not self.storeOpen
            and not self.vehiclesOpen
            and not IsNuiFocused()
    end

    self.rankingBoardRenderers = {
        DominationRankingBoardRenderer( {
            rankingScope = 'organizations',
            horizontalOffset = -2.05,
            shouldRender = shouldRenderRankingBoards,
            shouldInteract = shouldInteractWithRankingBoards,
        } ),
        DominationRankingBoardRenderer( {
            rankingScope = 'players',
            horizontalOffset = 2.05,
            shouldRender = shouldRenderRankingBoards,
            shouldInteract = shouldInteractWithRankingBoards,
        } ),
    }
    self:AttachRenderDiagnostics()
    DminigamesRenderDiagnostics.Snapshot( 'renderers-created' )
end

function DominationClient:AttachRenderDiagnostics()

    DminigamesRenderDiagnostics.Attach( self.renderer, 'minimap' )
    DminigamesRenderDiagnostics.Attach( self.boundaryRenderer, 'boundary' )
    DminigamesRenderDiagnostics.Attach( self.capturePointRenderer, 'interactions' )
    DminigamesRenderDiagnostics.Attach( self.revivePointRenderer, 'interactions' )
    DminigamesRenderDiagnostics.Attach( self.lootDuiProbe, 'loot', 'StartDrawing', 'StopDrawing' )
    DminigamesRenderDiagnostics.Attach( self.lootRenderer, 'loot' )

    if self.lootRenderer then self.lootRenderer:show() end

    for _, renderer in ipairs( self.rankingBoardRenderers or {} ) do
        DminigamesRenderDiagnostics.Attach( renderer, 'rankings' )
    end
end

function DominationClient:DestroyRenderers()
    DminigamesRenderDiagnostics.Snapshot( 'before-destroy-renderers' )
    local renderer = self.renderer
    local boundaryRenderer = self.boundaryRenderer
    local capturePointRenderer = self.capturePointRenderer
    local revivePointRenderer = self.revivePointRenderer
    local lootDuiProbe = self.lootDuiProbe
    local lootRenderer = self.lootRenderer
    local rankingBoardRenderers = self.rankingBoardRenderers

    self.renderer = nil
    self.boundaryRenderer = nil
    self.capturePointRenderer = nil
    self.revivePointRenderer = nil
    self.lootDuiProbe = nil
    self.lootRenderer = nil
    self.rankingBoardRenderers = {}

    if lootDuiProbe then
        lootDuiProbe:Destroy()
    end

    if lootRenderer then lootRenderer:destroy() end

    if boundaryRenderer then
        boundaryRenderer:destroy()
    end

    if capturePointRenderer then
        capturePointRenderer:destroy()
    end

    if revivePointRenderer then
        revivePointRenderer:destroy()
    end

    for _, rankingBoardRenderer in ipairs( rankingBoardRenderers ) do
        rankingBoardRenderer:destroy()
    end

    if renderer then
        renderer:destroy()
    end
    DminigamesRenderDiagnostics.DetachAll()
    DminigamesRenderDiagnostics.Snapshot( 'after-destroy-renderers' )
end

---@private
---@param action string
---@param payload? any
function DominationClient:SendHudEvent( action, payload )
    TriggerEvent( ('pvp.hud:%s'):format( action ), payload )
end

---@private
---@param ped number
---@param enabled boolean
function DominationClient:SetTeamOutline( ped, enabled )
    if ped == 0 or not DoesEntityExist( ped ) then
        return
    end

    SetEntityDrawOutline( ped, enabled == true )

    if enabled then
        SetEntityDrawOutlineColor(
            DOMINATION_TEAM_OUTLINE_RED,
            DOMINATION_TEAM_OUTLINE_GREEN,
            DOMINATION_TEAM_OUTLINE_BLUE,
            255
        )
        SetEntityDrawOutlineShader( 1 )
        Citizen.InvokeNative( 1759507165, 'waterreflection' )
    end
end

---@private
function DominationClient:ClearTeamOutlines()
    for _, ped in pairs( self.outlinedTeamPedBySource ) do
        self:SetTeamOutline( ped, false )
    end

    self.outlinedTeamPedBySource = {}
end

---@private
function DominationClient:RefreshTeamOutlines()
    if not self.active or not self.gameplayActive then
        self:ClearTeamOutlines()
        return
    end

    local nextOutlinedPedBySource = {}

    for targetSource in pairs( self.teamPlayerBySource ) do
        local targetPlayer = GetPlayerFromServerId( targetSource )
        local previousPed = self.outlinedTeamPedBySource[ targetSource ]
        local targetPed = targetPlayer ~= -1 and GetPlayerPed( targetPlayer ) or 0

        if previousPed and previousPed ~= targetPed then
            self:SetTeamOutline( previousPed, false )
        end

        if targetPlayer ~= -1
            and NetworkIsPlayerActive( targetPlayer )
            and targetPed ~= 0
            and DoesEntityExist( targetPed )
        then
            if previousPed ~= targetPed then
                self:SetTeamOutline( targetPed, true )
            end

            nextOutlinedPedBySource[ targetSource ] = targetPed
        end
    end

    for targetSource, previousPed in pairs( self.outlinedTeamPedBySource ) do
        if not nextOutlinedPedBySource[ targetSource ] then
            self:SetTeamOutline( previousPed, false )
        end
    end

    self.outlinedTeamPedBySource = nextOutlinedPedBySource
end

---@param sources table
function DominationClient:SetTeamPlayers( sources )
    self.teamPlayerBySource = {}

    local localSource = GetPlayerServerId( PlayerId() )

    for _, targetSource in ipairs( type( sources ) == 'table' and sources or {} ) do
        targetSource = tonumber( targetSource )

        if targetSource and targetSource ~= localSource then
            self.teamPlayerBySource[ targetSource ] = true
        end
    end

    self:RefreshTeamOutlines()
end

---@private
function DominationClient:StartTeamOutlineLoop()
    self.teamOutlineRevision = self.teamOutlineRevision + 1

    local revision = self.teamOutlineRevision

    self:RefreshTeamOutlines()

    CreateThread( function()
        while self.active
            and self.gameplayActive
            and self.teamOutlineRevision == revision
        do
            Wait( DOMINATION_TEAM_OUTLINE_REFRESH_INTERVAL_MS )

            if self.teamOutlineRevision == revision then
                self:RefreshTeamOutlines()
            end
        end
    end )
end

---@private
function DominationClient:ClearTeamPlayers()
    self.teamOutlineRevision = self.teamOutlineRevision + 1
    self.teamPlayerBySource = {}
    self:ClearTeamOutlines()
end

---@private
function DominationClient:StopReviveAnimation()
    self.reviveAnimationRevision = self.reviveAnimationRevision + 1

    local ped = self.reviveAnimationPed

    self.reviveAnimationPed = nil

    if ped
        and DoesEntityExist( ped )
        and IsEntityPlayingAnim(
            ped,
            DOMINATION_REVIVE_ANIMATION_DICTIONARY,
            DOMINATION_REVIVE_ANIMATION_NAME,
            3
        )
    then
        StopAnimTask(
            ped,
            DOMINATION_REVIVE_ANIMATION_DICTIONARY,
            DOMINATION_REVIVE_ANIMATION_NAME,
            1.0
        )
    end

    if HasAnimDictLoaded( DOMINATION_REVIVE_ANIMATION_DICTIONARY ) then
        RemoveAnimDict( DOMINATION_REVIVE_ANIMATION_DICTIONARY )
    end
end

---@private
function DominationClient:StartReviveAnimation()
    self:StopReviveAnimation()

    local revision = self.reviveAnimationRevision

    CreateThread( function()
        local timeoutAt = GetGameTimer() + DOMINATION_REVIVE_ANIMATION_LOAD_TIMEOUT_MS

        RequestAnimDict( DOMINATION_REVIVE_ANIMATION_DICTIONARY )

        while self.reviveAnimationRevision == revision
            and self.reviveAttemptId
            and not HasAnimDictLoaded( DOMINATION_REVIVE_ANIMATION_DICTIONARY )
            and GetGameTimer() < timeoutAt
        do
            Wait( 0 )
        end

        if self.reviveAnimationRevision ~= revision
            or not self.reviveAttemptId
            or not HasAnimDictLoaded( DOMINATION_REVIVE_ANIMATION_DICTIONARY )
        then
            return
        end

        local ped = PlayerPedId()

        if ped == 0 or not DoesEntityExist( ped ) or IsEntityDead( ped ) then
            return
        end

        self.reviveAnimationPed = ped

        TaskPlayAnim(
            ped,
            DOMINATION_REVIVE_ANIMATION_DICTIONARY,
            DOMINATION_REVIVE_ANIMATION_NAME,
            8.0,
            -8.0,
            -1,
            1,
            0.0,
            false,
            false,
            false
        )
    end )
end

---@private
---@return boolean downed
function DominationClient:IsLocalPlayerDowned()
    if not gDominationMinigameClient then
        return false
    end

    local localSource = GetPlayerServerId( PlayerId() )

    return gDominationMinigameClient.deadPlayers[ localSource ] ~= nil
end

---@private
---@return boolean alive
function DominationClient:IsLocalPlayerAliveForRevive()
    if not self.active or not self.gameplayActive then
        return false
    end

    if not gDominationMinigameClient
        or gDominationMinigameClient.currentState
            ~= MinigameClient.GameState.MATCH_GAMEPLAY
    then
        return false
    end

    local localSource = GetPlayerServerId( PlayerId() )

    if gDominationMinigameClient.deadPlayers[ localSource ] then
        return false
    end

    if LocalPlayer.state.Inspect then
        return false
    end

    local ped = PlayerPedId()

    return ped ~= 0
        and DoesEntityExist( ped )
        and not IsEntityDead( ped )
        and not IsPedDeadOrDying( ped, true )
        and GetEntityHealth( ped ) > DOMINATION_PED_BASE_HEALTH
end

---@private
---@return boolean allowed
function DominationClient:CanLocalPlayerInteractWithBody()
    if not self:IsLocalPlayerAliveForRevive() then
        return false
    end

    return not IsPedInAnyVehicle( PlayerPedId(), false )
end

---@private
---@param targetSource number
---@param maximumDistanceSquared? number
---@return number? targetPed
---@return number? distanceSquared
function DominationClient:GetDownedTargetInRange( targetSource, maximumDistanceSquared )
    targetSource = tonumber( targetSource )

    if not targetSource then
        return nil, nil
    end

    if not gDominationMinigameClient
        or not gDominationMinigameClient.deadPlayers[ targetSource ]
    then
        return nil, nil
    end

    local targetPlayer = GetPlayerFromServerId( targetSource )

    if targetPlayer == -1 or not NetworkIsPlayerActive( targetPlayer ) then
        return nil, nil
    end

    local targetPed = GetPlayerPed( targetPlayer )
    local localPed = PlayerPedId()

    if targetPed == 0
        or targetPed == localPed
        or not DoesEntityExist( targetPed )
        or not DoesEntityExist( localPed )
    then
        return nil, nil
    end

    local targetPosition = GetEntityCoords( targetPed )
    local localPosition = GetEntityCoords( localPed )
    local deltaX = targetPosition.x - localPosition.x
    local deltaY = targetPosition.y - localPosition.y
    local deltaZ = targetPosition.z - localPosition.z
    local distanceSquared = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ

    if distanceSquared > ( maximumDistanceSquared or DOMINATION_REVIVE_DISTANCE_SQUARED ) then
        return nil, distanceSquared
    end

    return targetPed, distanceSquared
end

---@private
---@param targetSource number
---@return number? targetPed
---@return number? distanceSquared
function DominationClient:GetReviveTargetInRange( targetSource )
    targetSource = tonumber( targetSource )

    if not targetSource or not self.revivablePlayerBySource[ targetSource ] then
        return nil, nil
    end

    return self:GetDownedTargetInRange(
        targetSource,
        DOMINATION_REVIVE_DISTANCE_SQUARED
    )
end

---@private
---@param targetSource number
---@return number? targetPed
---@return number? distanceSquared
function DominationClient:GetLootTargetInRange( targetSource )
    if DOMINATION_LOOT.enabled then return nil, nil end
    targetSource = tonumber( targetSource )

    if not targetSource or self.revivablePlayerBySource[ targetSource ] then
        return nil, nil
    end

    return self:GetDownedTargetInRange(
        targetSource,
        DOMINATION_LOOT_DISTANCE_SQUARED
    )
end

---@private
---@return number? targetSource
---@return number? targetPed
---@return string? interactionMode
function DominationClient:FindNearestBodyTarget()
    if not self:CanLocalPlayerInteractWithBody() then
        return nil, nil, nil
    end

    local nearestSource
    local nearestPed
    local nearestMode
    local nearestDistanceSquared = DOMINATION_REVIVE_DISTANCE_SQUARED
    local localSource = GetPlayerServerId( PlayerId() )

    for targetSource in pairs( gDominationMinigameClient.deadPlayers ) do
        targetSource = tonumber( targetSource )

        if targetSource and targetSource ~= localSource then
            local interactionMode = self.revivablePlayerBySource[ targetSource ]
                and 'revive'
                or 'loot'
            local targetPed, distanceSquared

            if interactionMode == 'revive' then
                targetPed, distanceSquared = self:GetReviveTargetInRange( targetSource )
            else
                targetPed, distanceSquared = self:GetLootTargetInRange( targetSource )
            end

            if targetPed and distanceSquared <= nearestDistanceSquared then
                nearestSource = targetSource
                nearestPed = targetPed
                nearestMode = interactionMode
                nearestDistanceSquared = distanceSquared
            end
        end
    end

    return nearestSource, nearestPed, nearestMode
end

---@private
---@param targetSource number?
---@param targetPed number?
---@param interactionMode? string
function DominationClient:SetReviveCandidate( targetSource, targetPed, interactionMode )
    if self.vehicleRemovalWarning then
        return
    end
    targetSource = tonumber( targetSource )
    interactionMode = interactionMode == 'loot' and 'loot' or 'revive'

    if not targetSource or not targetPed then
        self.reviveCandidateSource = nil
        self.reviveCandidateMode = nil

        if not self.reviveAttemptId
            and not self.reviveRequestTargetSource
            and not self.lootHoldTargetSource
            and not self.reviveCompletionPending
            and self.revivePointRenderer
        then
            self.revivePointRenderer:hide()
        end

        return
    end

    self.reviveCandidateSource = targetSource
    self.reviveCandidateMode = interactionMode

    if not self.revivePointRenderer then
        return
    end

    self.revivePointRenderer:show()
    self.revivePointRenderer:setReviveTarget( {
        mode = interactionMode,
        source = targetSource,
        entity = targetPed,
        color = interactionMode == 'loot'
            and { DOMINATION_LOOT_RED, DOMINATION_LOOT_GREEN, DOMINATION_LOOT_BLUE }
            or nil,
    } )

    if not self.reviveAttemptId
        and not self.reviveRequestTargetSource
        and not self.lootHoldTargetSource
    then
        self.revivePointRenderer:setReviveState( 'idle' )
    end
end

---@private
---@param notifyServer boolean
function DominationClient:CancelReviveAttempt( notifyServer )
    local attemptId = self.reviveAttemptId
    local targetSource = self.reviveAttemptTargetSource
        or self.reviveRequestTargetSource

    self:StopReviveAnimation()
    self.reviveRequestTargetSource = nil
    self.reviveRequestReleased = false
    self.reviveAttemptId = nil
    self.reviveAttemptTargetSource = nil
    self.reviveAttemptFinishAt = nil
    self.reviveCompletionPending = false

    if notifyServer and targetSource then
        TriggerServerEvent(
            'pvp.domination:cancelRevive',
            attemptId or 0,
            targetSource
        )
    end

    local candidatePed = self.reviveCandidateSource
        and self.reviveCandidateMode == 'revive'
        and self:GetReviveTargetInRange( self.reviveCandidateSource )

    if candidatePed then
        self.revivePointRenderer:setReviveState( 'idle' )
    else
        self:SetReviveCandidate( nil, nil )
    end
end

---@private
function DominationClient:CancelLootAttempt()
    local targetSource = self.lootHoldTargetSource

    self.lootHoldTargetSource = nil
    self.lootHoldFinishAt = nil

    local targetPed = targetSource and self:GetLootTargetInRange( targetSource )

    if targetPed then
        self:SetReviveCandidate( targetSource, targetPed, 'loot' )
        self.revivePointRenderer:setReviveState( 'idle' )
    else
        self:SetReviveCandidate( nil, nil )
    end
end

---@private
---@param targetSource number
function DominationClient:CompleteLootInteraction( targetSource )
    self.lootHoldTargetSource = nil
    self.lootHoldFinishAt = nil
    self.reviveCandidateSource = nil
    self.reviveCandidateMode = nil
    self.reviveCompletionPending = true
    self.lootCompletionRevision = self.lootCompletionRevision + 1
    self.revivePointRenderer:setReviveState( 'complete', nil, 1.0 )

    TriggerServerEvent( 'pvp.domination:requestLoot', targetSource )

    local revision = self.lootCompletionRevision

    SetTimeout( DOMINATION_REVIVE_COMPLETE_DISPLAY_MS, function()
        if self.lootCompletionRevision ~= revision then
            return
        end

        self.reviveCompletionPending = false
        self.revivePointRenderer:hide()
    end )
end

---@private
---@param notifyServer boolean
function DominationClient:ClearReviveState( notifyServer )
    self.vehicleRemovalWarning = nil
    self:CancelReviveAttempt( notifyServer )
    self:CancelLootAttempt()
    self.reviveLoopRevision = self.reviveLoopRevision + 1
    self.reviveCompletionRevision = self.reviveCompletionRevision + 1
    self.lootCompletionRevision = self.lootCompletionRevision + 1
    self.reviveCandidateSource = nil
    self.reviveCandidateMode = nil
    self.revivablePlayerBySource = {}

    if self.revivePointRenderer then
        self.revivePointRenderer:hide()
    end
end

---@param targetSource number
---@param eligible boolean
function DominationClient:SetReviveEligibility( targetSource, eligible )
    targetSource = tonumber( targetSource )

    if not targetSource then
        return
    end

    if eligible then
        self.revivablePlayerBySource[ targetSource ] = true

        if self.reviveCandidateSource == targetSource
            and self.reviveCandidateMode == 'loot'
            and not self.lootHoldTargetSource
        then
            local targetPed = self:GetReviveTargetInRange( targetSource )

            if targetPed then
                self:SetReviveCandidate( targetSource, targetPed, 'revive' )
            end
        end

        return
    end

    self.revivablePlayerBySource[ targetSource ] = nil

    if self.reviveCandidateSource == targetSource
        and self.reviveCandidateMode == 'revive'
        and self.reviveAttemptTargetSource ~= targetSource
        and not self.reviveCompletionPending
    then
        self:SetReviveCandidate( nil, nil )
    end
end

---@param sources table
function DominationClient:SetRevivablePlayers( sources )
    self.revivablePlayerBySource = {}

    for _, targetSource in ipairs( type( sources ) == 'table' and sources or {} ) do
        targetSource = tonumber( targetSource )

        if targetSource then
            self.revivablePlayerBySource[ targetSource ] = true
        end
    end

    if self.reviveCandidateSource
        and self.reviveCandidateMode == 'revive'
        and not self.revivablePlayerBySource[ self.reviveCandidateSource ]
        and not self.reviveAttemptId
    then
        self:SetReviveCandidate( nil, nil )
    end
end

---@param data table
function DominationClient:OnReviveStarted( data )
    local attemptId = type( data ) == 'table' and tonumber( data.attemptId ) or nil
    local targetSource = type( data ) == 'table' and tonumber( data.targetSource ) or nil
    local durationMs = type( data ) == 'table' and tonumber( data.durationMs ) or nil

    if not attemptId or not targetSource or not durationMs then
        return
    end

    local targetPed = self:GetReviveTargetInRange( targetSource )
    local requestMatches = self.reviveRequestTargetSource == targetSource
    local stillHolding = IsDisabledControlPressed( 0, DOMINATION_REVIVE_CONTROL )

    if not requestMatches
        or self.reviveRequestReleased
        or not stillHolding
        or not targetPed
        or not self:CanLocalPlayerInteractWithBody()
    then
        TriggerServerEvent( 'pvp.domination:cancelRevive', attemptId, targetSource )
        self.reviveRequestTargetSource = nil
        self.reviveRequestReleased = false
        return
    end

    self.reviveRequestTargetSource = nil
    self.reviveRequestReleased = false
    self.reviveAttemptId = attemptId
    self.reviveAttemptTargetSource = targetSource
    self.reviveAttemptFinishAt = GetGameTimer() + durationMs
    self.reviveCompletionPending = false
    self:SetReviveCandidate( targetSource, targetPed )
    self.revivePointRenderer:setReviveState( 'holding', durationMs, 0.0 )
    self:StartReviveAnimation()
end

---@param data table
function DominationClient:OnReviveCancelled( data )
    local attemptId = type( data ) == 'table' and tonumber( data.attemptId ) or nil
    local targetSource = type( data ) == 'table' and tonumber( data.targetSource ) or nil

    if attemptId
        and self.reviveAttemptId
        and attemptId ~= self.reviveAttemptId
    then
        return
    end

    if targetSource
        and self.reviveRequestTargetSource
        and targetSource ~= self.reviveRequestTargetSource
    then
        return
    end

    self:CancelReviveAttempt( false )
end

---@param data table
function DominationClient:OnReviveFinished( data )
    local attemptId = type( data ) == 'table' and tonumber( data.attemptId ) or nil

    if not attemptId or attemptId ~= self.reviveAttemptId then
        return
    end

    self:StopReviveAnimation()
    self.reviveAttemptId = nil
    self.reviveAttemptTargetSource = nil
    self.reviveAttemptFinishAt = nil
    self.reviveCompletionPending = true
    self.reviveCompletionRevision = self.reviveCompletionRevision + 1
    self.revivePointRenderer:setReviveState( 'complete', nil, 1.0 )

    local revision = self.reviveCompletionRevision

    SetTimeout( DOMINATION_REVIVE_COMPLETE_DISPLAY_MS, function()
        if self.reviveCompletionRevision ~= revision then
            return
        end

        self.reviveCompletionPending = false
        self.reviveCandidateSource = nil
        self.reviveCandidateMode = nil
        self.revivePointRenderer:hide()
    end )
end

---@param resumeGameplay? boolean
function DominationClient:ReviveLocalPlayer( resumeGameplay )
    if resumeGameplay == nil then
        resumeGameplay = true
    end

    if not self.active or ( resumeGameplay and not self.gameplayActive ) then
        return
    end

    self.respawnToken = nil
    self:SetRespawnChoiceVisible( false )

    if gDominationMinigameClient then
        gDominationMinigameClient:setDownedState( false )
    end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return
    end

    local position = GetEntityCoords( ped )
    local heading = GetEntityHeading( ped )

    if IsEntityDead( ped )
        or IsPedDeadOrDying( ped, true )
        or GetEntityHealth( ped ) <= DOMINATION_PED_BASE_HEALTH
    then
        NetworkResurrectLocalPlayer( position.x, position.y, position.z, heading )
        Wait( 0 )
        ped = PlayerPedId()
    end

    if GetResourceState( 'survival' ) == 'started' then
        exports[ 'survival' ]:Revive( DOMINATION_PED_MAX_HEALTH )
        TriggerServerEvent( 'net.player.revive_status_changed' )
    end

    SetPedMaxHealth( ped, DOMINATION_PED_MAX_HEALTH )
    SetEntityHealth( ped, DOMINATION_PED_MAX_HEALTH )
    self:SetSafeProtectionActive( false )
    SetEntityInvincible( ped, false )
    LocalPlayer.state.Invincible = false
    FreezeEntityPosition( ped, false )
    SetEntityCollision( ped, true, true )
    SetEntityVisible( ped, true, false )
    ResetEntityAlpha( ped )
    ClearPedTasksImmediately( ped )

    if resumeGameplay and gDominationMinigameClient then
        gDominationMinigameClient:transitionToState(
            MinigameClient.GameState.MATCH_GAMEPLAY,
            'domination ally revived'
        )
    end

    self:HideDeathHud()

    if resumeGameplay then
        self:StartReviveLoop()
        self:RefreshSafeProtectionState()
        self:ShowHud()
        self:SendZonePresenceSync()
        self:RefreshSafeZoneActionAvailability()
    end
end

---@param nowMs integer
---@return boolean visible
function DominationClient:UpdateVehicleRemovalPrompt( nowMs )
    local warning = self.vehicleRemovalWarning
    if not warning then
        return false
    end

    if nowMs >= warning.finishAt or not self:IsLocalPlayerAliveForRevive() then
        self.vehicleRemovalWarning = nil
        if self.revivePointRenderer then
            self.revivePointRenderer:hide()
        end
        return false
    end

    local vehicle = NetworkDoesEntityExistWithNetworkId( warning.networkId )
        and NetToVeh( warning.networkId ) or 0
    if vehicle ~= 0 and self.revivePointRenderer then
        self.revivePointRenderer:setReviveTarget( {
            mode = 'vehicle', source = warning.networkId, entity = vehicle,
            removalReason = warning.reason,
            color = { 255, 255, 255 },
        } )
        self.revivePointRenderer:setReviveState( 'holding', warning.durationMs,
            1.0 - ( warning.finishAt - nowMs ) / warning.durationMs )
        self.revivePointRenderer:show()
    end
    return true
end

function DominationClient:StartReviveLoop()
    self.reviveLoopRevision = self.reviveLoopRevision + 1

    local revision = self.reviveLoopRevision

    CreateThread( function()
        local nextScanAt = 0

        while self.active
            and self.gameplayActive
            and self.reviveLoopRevision == revision
        do
            local nowMs = GetGameTimer()
            local vehicleWarningActive = self:UpdateVehicleRemovalPrompt( nowMs )

            if not vehicleWarningActive and not self.reviveAttemptId
                and not self.reviveRequestTargetSource
                and not self.lootHoldTargetSource
                and not self.reviveCompletionPending
                and nowMs >= nextScanAt
            then
                local targetSource, targetPed, interactionMode = self:FindNearestBodyTarget()

                self:SetReviveCandidate( targetSource, targetPed, interactionMode )
                nextScanAt = nowMs + DOMINATION_REVIVE_SCAN_INTERVAL_MS
            end

            local interactionTarget = self.reviveAttemptTargetSource
                or self.reviveRequestTargetSource
                or self.lootHoldTargetSource
                or self.reviveCandidateSource
            local interactionMode = self.reviveAttemptTargetSource
                and 'revive'
                or self.reviveRequestTargetSource
                and 'revive'
                or self.lootHoldTargetSource
                and 'loot'
                or self.reviveCandidateMode

            if vehicleWarningActive or not interactionTarget or self.reviveCompletionPending then
                Wait( DOMINATION_REVIVE_SCAN_INTERVAL_MS )
            else
                local targetPed

                if interactionMode == 'loot' then
                    targetPed = self:GetLootTargetInRange( interactionTarget )
                else
                    targetPed = self:GetReviveTargetInRange( interactionTarget )
                end

                if targetPed then
                    self.revivePointRenderer:setReviveTarget( {
                        mode = interactionMode,
                        source = interactionTarget,
                        entity = targetPed,
                        color = interactionMode == 'loot'
                            and {
                                DOMINATION_LOOT_RED,
                                DOMINATION_LOOT_GREEN,
                                DOMINATION_LOOT_BLUE,
                            }
                            or nil,
                    } )
                end

                DisableControlAction( 0, DOMINATION_REVIVE_CONTROL, true )

                if self.reviveAttemptId then
                    local shouldCancel = not targetPed
                        or not self:CanLocalPlayerInteractWithBody()
                        or not IsDisabledControlPressed( 0, DOMINATION_REVIVE_CONTROL )

                    if shouldCancel and not self.reviveCompletionPending then
                        self:CancelReviveAttempt( true )
                    elseif not self.reviveCompletionPending
                        and self.reviveAttemptFinishAt
                        and nowMs >= self.reviveAttemptFinishAt
                    then
                        self.reviveCompletionPending = true
                        TriggerServerEvent(
                            'pvp.domination:completeRevive',
                            self.reviveAttemptId,
                            self.reviveAttemptTargetSource
                        )
                    end
                elseif self.reviveRequestTargetSource then
                    if not targetPed
                        or not self:CanLocalPlayerInteractWithBody()
                        or not IsDisabledControlPressed( 0, DOMINATION_REVIVE_CONTROL )
                    then
                        self.reviveRequestReleased = true
                        self:CancelReviveAttempt( true )
                    end
                elseif self.lootHoldTargetSource then
                    local shouldCancel = not targetPed
                        or not self:CanLocalPlayerInteractWithBody()
                        or not IsDisabledControlPressed( 0, DOMINATION_REVIVE_CONTROL )

                    if shouldCancel then
                        self:CancelLootAttempt()
                    elseif self.lootHoldFinishAt and nowMs >= self.lootHoldFinishAt then
                        self:CompleteLootInteraction( interactionTarget )
                    end
                elseif targetPed
                    and IsDisabledControlJustPressed( 0, DOMINATION_REVIVE_CONTROL )
                then
                    if interactionMode == 'loot' then
                        self.lootHoldTargetSource = interactionTarget
                        self.lootHoldFinishAt = nowMs + DOMINATION_LOOT_DURATION_MS
                        self.revivePointRenderer:setReviveState(
                            'holding',
                            DOMINATION_LOOT_DURATION_MS,
                            0.0
                        )
                    else
                        self.reviveRequestTargetSource = interactionTarget
                        self.reviveRequestReleased = false
                        TriggerServerEvent(
                            'pvp.domination:requestRevive',
                            interactionTarget
                        )
                    end
                elseif not targetPed then
                    self:SetReviveCandidate( nil, nil )
                end

                Wait( 0 )
            end
        end

        if self.reviveLoopRevision == revision then
            self:ClearReviveState( true )
        end
    end )
end

---@private
---@param zone table
---@return integer remainingMs
function DominationClient:GetCaptureRemainingMs( zone )
    local remainingMs = math.max( 0, math.floor( tonumber( zone.remainingMs ) or 0 ) )

    if zone.state ~= 'capturing' or not zone.captureRemainingSyncedAt then
        return remainingMs
    end

    return math.max( 0, remainingMs - math.max( 0, GetGameTimer() - zone.captureRemainingSyncedAt ) )
end

---@private
---@param color table?
---@return string? cssColor
function DominationClient:GetCaptureHudColor( color )
    if type( color ) ~= 'table' then
        return nil
    end

    local red = math.floor( tonumber( color[ 1 ] or color.r ) or 255 )
    local green = math.floor( tonumber( color[ 2 ] or color.g ) or 255 )
    local blue = math.floor( tonumber( color[ 3 ] or color.b ) or 255 )

    return ( 'rgb(%d, %d, %d)' ):format(
        math.max( 0, math.min( 255, red ) ),
        math.max( 0, math.min( 255, green ) ),
        math.max( 0, math.min( 255, blue ) )
    )
end

---@private
---@return table? zone
function DominationClient:GetCaptureHudZone()
    if not self.gameplayActive then
        return nil
    end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return nil
    end

    local playerPosition = GetEntityCoords( ped )
    local closestZone
    local closestDistanceSquared

    for zoneId in pairs( self.localInsideById ) do
        local zone = self.zoneById[ zoneId ]
        local state = zone and zone.state
        local isCaptureActive = state == 'capturing' or state == 'contested'
        local isCaptureCompleted = state == 'controlled'
            and self.captureHudCompletionZoneId == zoneId

        if zone
            and zone.type == 'capture'
            and ( isCaptureActive or isCaptureCompleted )
        then
            local capturePoint = zone.capturePoint
            local pointX = capturePoint and ( capturePoint.x or capturePoint[ 1 ] )
            local pointY = capturePoint and ( capturePoint.y or capturePoint[ 2 ] )

            if pointX and pointY then
                local deltaX = playerPosition.x - pointX
                local deltaY = playerPosition.y - pointY
                local distanceSquared = deltaX * deltaX + deltaY * deltaY

                if not closestDistanceSquared or distanceSquared < closestDistanceSquared then
                    closestZone = zone
                    closestDistanceSquared = distanceSquared
                end
            end
        end
    end

    return closestZone
end

---@private
---@param zoneId string
function DominationClient:ShowCaptureCompletion( zoneId )
    local zone = self.zoneById[ zoneId ]

    self.captureHudCompletionRevision = self.captureHudCompletionRevision + 1
    self.captureHudCompletionZoneId = zoneId
    -- Rotacao: a zona dominada some logo depois; o aviso segue com esta copia.
    self.captureHudCompletion = zone and {
        zoneId = zoneId,
        payload = self:BuildCaptureHudPayload( zone ),
    } or nil

    local revision = self.captureHudCompletionRevision

    SetTimeout( DOMINATION_CAPTURE_HUD_COMPLETION_MS, function()
        if not self.active or revision ~= self.captureHudCompletionRevision then
            return
        end

        self.captureHudCompletionZoneId = nil
        self.captureHudCompletion = nil
        self:RefreshCaptureHud()
    end )
end

---@private
---@param zone table
---@return table payload
function DominationClient:BuildCaptureHudPayload( zone )
    local organization = zone.state == 'controlled'
        and zone.ownerOrganization
        or zone.state == 'capturing' and zone.capturingOrganization

    return {
        state = zone.state,
        zoneName = zone.name,
        organizationName = organization and organization.name or '',
        remainingMs = self:GetCaptureRemainingMs( zone ),
        durationMs = zone.captureDurationMs,
        stateLabel = zone.hudStateLabel,
        timerLabel = zone.hudTimerLabel,
        color = self:GetCaptureHudColor( zone.color ),
    }
end

---@private
function DominationClient:RefreshCaptureHud()
    if self:IsLocalPlayerDowned() then
        if self.captureHudZoneId then
            self.captureHudZoneId = nil
            self:SendHudEvent( 'hideDominationCapture' )
        end

        return
    end

    local zone = self:GetCaptureHudZone()

    if not zone then
        local completion = self.captureHudCompletion

        -- A zona dominada ja saiu da lista (rotacao): o aviso de conquista fica na
        -- tela pelo tempo normal com a copia tirada na conclusao.
        if completion and completion.zoneId == self.captureHudCompletionZoneId then
            if self.captureHudZoneId ~= completion.zoneId then
                self.captureHudZoneId = completion.zoneId
                self:SendHudEvent( 'showDominationCapture', completion.payload )
            end

            return
        end

        if self.captureHudZoneId then
            self.captureHudZoneId = nil
            self:SendHudEvent( 'hideDominationCapture' )
        end

        return
    end

    self.captureHudZoneId = tostring( zone.id )
    self:SendHudEvent( 'showDominationCapture', self:BuildCaptureHudPayload( zone ) )
end

---@private
---@param ped number
---@return number healthPercent
function DominationClient:GetHealthPercent( ped )
    local health = math.max( 0, GetEntityHealth( ped ) - DOMINATION_PED_BASE_HEALTH )
    local healthRange = DOMINATION_PED_MAX_HEALTH - DOMINATION_PED_BASE_HEALTH

    return math.min( 100, math.floor( health / healthRange * 100 ) )
end

---@private
---@param ped number
---@return string? weaponName
function DominationClient:GetEquippedWeaponName( ped )
    if GetResourceState( 'inventory' ) ~= 'started' then
        return nil
    end

    local success, weaponName = pcall( function()
        return exports.inventory:Weapons()
    end )

    if not success or type( weaponName ) ~= 'string' or weaponName == '' then
        return nil
    end

    if GetSelectedPedWeapon( ped ) ~= joaat( weaponName ) then
        return nil
    end

    return weaponName
end

---@private
---@param weaponName string
---@return string displayName
function DominationClient:GetWeaponDisplayName( weaponName )
    local displayName = itemName( weaponName )

    if type( displayName ) == 'string' and displayName ~= '' and displayName ~= 'Deletado' then
        return displayName
    end

    displayName = weaponName:gsub( '^WEAPON_', '' ):gsub( '_', ' ' ):lower()

    return ( displayName:gsub( '(%a)([%w]*)', function( firstLetter, remainingLetters )
        return ( '%s%s' ):format( firstLetter:upper(), remainingLetters )
    end ) )
end

---@private
---@param ped number
---@param weaponHash number
---@return number ammo
---@return number maxAmmo
function DominationClient:GetWeaponHudAmmo( ped, weaponHash )
    local _, ammo = GetAmmoInClip( ped, weaponHash )
    local maxAmmo = GetMaxAmmoInClip( ped, weaponHash, true )

    ammo = tonumber( ammo ) or 0
    maxAmmo = tonumber( maxAmmo ) or ammo

    return ammo, math.max( ammo, maxAmmo )
end

---@private
---@param weaponName string?
function DominationClient:SetHudWeaponSlot( weaponName )
    if self.hudWeaponName == weaponName then
        return
    end

    self.hudWeaponName = weaponName

    if not weaponName then
        self:SendHudEvent( 'updateHudSlotItems', {} )
        return
    end

    self:SendHudEvent( 'updateHudSlotItems', {
        {
            slot = 1,
            name = weaponName,
            active = true,
        },
    } )
end

---@private
---@param players table?
function DominationClient:UpdateHudPlayerCount( players )
    local playerCount = 0

    for _ in pairs( type( players ) == 'table' and players or {} ) do
        playerCount = playerCount + 1
    end

    local changed = self.hudPlayerCount ~= playerCount

    self.hudPlayerCount = playerCount

    if self.hudVisible and changed then
        self:SendHudEvent( 'updateHudPlayerCount', playerCount )
    end
end

---@private
function DominationClient:StartHudLoop()
    self.hudRevision = self.hudRevision + 1

    local revision = self.hudRevision

    CreateThread( function()
        local nextStatusUpdate = 0

        while self.active and self.hudVisible and self.hudRevision == revision do
            local ped = PlayerPedId()

            if ped ~= 0 and DoesEntityExist( ped ) then
                local now = GetGameTimer()

                if now >= nextStatusUpdate then
                    local health = self:GetHealthPercent( ped )
                    local armor = GetPedArmour( ped )
                    local statusSignature = ( '%d:%d' ):format( health, armor )

                    if self.hudStatusSignature ~= statusSignature then
                        self.hudStatusSignature = statusSignature
                        self:SendHudEvent( 'updateHudStatus', {
                            health = health,
                            armor = armor,
                        } )
                    end

                    nextStatusUpdate = now + DOMINATION_HUD_STATUS_INTERVAL_MS
                end

                local weaponName = self:GetEquippedWeaponName( ped )

                if weaponName then
                    self:SetHudWeaponSlot( weaponName )

                    local weaponHash = joaat( weaponName )
                    local ammo, maxAmmo = self:GetWeaponHudAmmo( ped, weaponHash )
                    local weaponSignature = ( '%s:%d:%d' ):format(
                        weaponName,
                        ammo,
                        maxAmmo
                    )

                    if self.hudWeaponSignature ~= weaponSignature then
                        self.hudWeaponSignature = weaponSignature
                        self:SendHudEvent( 'updateHudWeapon', {
                            name = self:GetWeaponDisplayName( weaponName ),
                            ammo = ammo,
                            maxAmmo = maxAmmo,
                        } )
                    end
                else
                    self:SetHudWeaponSlot( nil )

                    if self.hudWeaponSignature ~= 'none' then
                        self.hudWeaponSignature = 'none'
                        self:SendHudEvent( 'updateHudWeapon', nil )
                    end
                end
            end

            Wait( DOMINATION_HUD_UPDATE_INTERVAL_MS )
        end
    end )
end

function DominationClient:ShowHud()
    self:HideDeathHud()
    self.hudVisible = true
    self.hudWeaponName = nil
    self.hudStatusSignature = nil
    self.hudWeaponSignature = nil
    self:SendHudEvent( 'setHudMode', DOMINATION_HUD_MODE )
    self:SendHudEvent( 'setPauseHintVisible', { visible = false } )
    self:SendHudEvent( 'clearKillFeed' )
    self:SendHudEvent( 'updateHudKills', 0 )
    self:SendHudEvent( 'updateHudPlayerCount', self.hudPlayerCount )
    self:SendHudEvent( 'updateHudSlotItems', {} )
    self:SendHudEvent( 'showHud' )
    self:StartHudLoop()
    self:RefreshCaptureHud()
end

---@param durationSeconds number?
function DominationClient:ShowDeathHud( durationSeconds )
    durationSeconds = math.max( 1, math.floor(
        tonumber( durationSeconds )
            or self.deathDurationSeconds
            or tonumber( GlobalState[ 'DeathTimer' ] )
            or DOMINATION_FALLBACK_DEATH_DURATION_SECONDS
    ) )
    self.deathDurationSeconds = durationSeconds

    self.hudVisible = false
    self.hudRevision = self.hudRevision + 1
    self.hudWeaponName = nil
    self.hudStatusSignature = nil
    self.hudWeaponSignature = nil
    self.captureHudZoneId = nil
    self.captureHudCompletionZoneId = nil
    self.captureHudCompletionRevision = self.captureHudCompletionRevision + 1
    self.deathHudVisible = true
    self:SendHudEvent( 'hideDominationCapture' )
    self:SendHudEvent( 'hideHud' )
    self:SendHudEvent( 'updateHudWeapon', nil )
    self:SendHudEvent( 'updateHudSlotItems', {} )
    self:SendHudEvent( 'showDominationDeath', {
        durationSeconds = durationSeconds,
        remainingSeconds = durationSeconds,
        stateLabel = PvpTranslations.get( 'domination_death_state' ),
        respawnLabel = PvpTranslations.get( 'domination_death_wait' ),
        timerLabel = PvpTranslations.get( 'domination_death_timer' ),
    } )
end

function DominationClient:HideDeathHud()
    if not self.deathHudVisible then
        return
    end

    self.deathHudVisible = false
    self:SendHudEvent( 'hideDominationDeath' )
end

function DominationClient:OnPlayerDeath()
    if not self.active or not self.gameplayActive then
        return
    end

    if self.selectorOpen and not self.selectorLeavesMatchOnClose then
        self:CloseSelector()
    end

    self:SetStoreAvailable( false )
    self:ClearReviveState( false )
    self:ClearSafeExitProtection()
    self:RefreshSafeProtectionState()
    self:SendZonePresenceSync()
end

function DominationClient:HideHud()
    self.hudVisible = false
    self.hudRevision = self.hudRevision + 1
    self.hudWeaponName = nil
    self.hudStatusSignature = nil
    self.hudWeaponSignature = nil
    self.captureHudZoneId = nil
    self.captureHudCompletionZoneId = nil
    self.captureHudCompletionRevision = self.captureHudCompletionRevision + 1
    self:HideDeathHud()
    self:SendHudEvent( 'hideDominationCapture' )
    self:SendHudEvent( 'hideHud' )
    self:SendHudEvent( 'setPauseHintVisible', { visible = true } )
    self:SendHudEvent( 'clearKillFeed' )
    self:SendHudEvent( 'updateHudWeapon', nil )
    self:SendHudEvent( 'updateHudSlotItems', {} )
end

---@return boolean
function DominationClient:IsLocallyInsideSafeZone()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return false
    end

    local zones = self.zoneTracker.zoneSet:resolveMembership( GetEntityCoords( ped ) )

    for _, zone in pairs( zones ) do
        if zone and zone.type == 'safe' then
            return true
        end
    end

    return false
end

---@private
---@param firstEntity number
---@param secondEntity number
function DominationClient:DisableEntityPairCollision( firstEntity, secondEntity )
    if firstEntity == 0
        or secondEntity == 0
        or firstEntity == secondEntity
        or not DoesEntityExist( firstEntity )
        or not DoesEntityExist( secondEntity )
    then
        return
    end

    SetEntityNoCollisionEntity( firstEntity, secondEntity, true )
    SetEntityNoCollisionEntity( secondEntity, firstEntity, true )
end

---@private
function DominationClient:ApplySafeCollisionProtection()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return
    end

    local vehicle = GetVehiclePedIsIn( ped, false )
    local protectedEntity = vehicle ~= 0 and vehicle or ped

    for entity in pairs( self.safeCollisionEntities ) do
        self:DisableEntityPairCollision( protectedEntity, entity )
    end
end

---@private
function DominationClient:RefreshSafeCollisionEntities()
    local playerId = PlayerId()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        self.safeCollisionEntities = {}
        return
    end

    local position = GetEntityCoords( ped )
    local maxDistanceSquared = DOMINATION_SAFE_COLLISION_DISTANCE
        * DOMINATION_SAFE_COLLISION_DISTANCE
    local entities = {}

    for _, otherPlayerId in ipairs( GetActivePlayers() ) do
        if otherPlayerId ~= playerId then
            local otherPed = GetPlayerPed( otherPlayerId )

            if otherPed ~= 0 and DoesEntityExist( otherPed ) then
                local otherPosition = GetEntityCoords( otherPed )
                local deltaX = position.x - otherPosition.x
                local deltaY = position.y - otherPosition.y
                local deltaZ = position.z - otherPosition.z
                local distanceSquared = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ

                if distanceSquared <= maxDistanceSquared then
                    if GetVehiclePedIsIn( otherPed, false ) == 0 then
                        entities[ otherPed ] = true
                    end
                end
            end
        end
    end

    self.safeCollisionEntities = entities
end

---@private
---@param ped number
function DominationClient:ApplyVehicleCollisionProtection( ped )
    local vehicle = GetVehiclePedIsIn( ped, false )
    local protectedEntity = vehicle ~= 0 and vehicle or ped
    local position = vehicle == 0 and not self.safeProtectionActive and GetEntityCoords( ped )
    local insideVehicle = false

    for _, entity in ipairs( self.vehicleCollisionEntities ) do
        if DoesEntityExist( entity ) then
            if not self.safeCollisionProtectionActive
                or not self.safeCollisionEntities[ entity ]
            then
                self:DisableEntityPairCollision( protectedEntity, entity )
            end

            if position and not insideVehicle and IsEntityAVehicle( entity ) then
                local model = GetEntityModel( entity )
                local bounds = gDominationVehicleBoundsByModel[ model ]

                if not bounds then
                    local minimum, maximum = GetModelDimensions( model )
                    bounds = { minimum = minimum, maximum = maximum }
                    gDominationVehicleBoundsByModel[ model ] = bounds
                end

                local offset = GetOffsetFromEntityGivenWorldCoords(
                    entity, position.x, position.y, position.z
                )

                insideVehicle = offset.x >= bounds.minimum.x and offset.x <= bounds.maximum.x
                    and offset.y >= bounds.minimum.y and offset.y <= bounds.maximum.y
                    and offset.z >= bounds.minimum.z and offset.z <= bounds.maximum.z
            end
        end
    end

    if insideVehicle then
        DisablePlayerFiring( PlayerId(), true )
    end
end

---@private
function DominationClient:RefreshVehicleCollisionEntities()
    local playerId = PlayerId()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        self.vehicleCollisionEntities = {}
        return
    end

    local position = GetEntityCoords( ped )
    local localVehicle = GetVehiclePedIsIn( ped, false )
    local maxDistanceSquared = DOMINATION_VEHICLE_COLLISION_DISTANCE
        * DOMINATION_VEHICLE_COLLISION_DISTANCE
    local entities = {}
    local addedEntity = {}

    for _, vehicle in ipairs( GetGamePool( 'CVehicle' ) ) do
        if vehicle ~= localVehicle and DoesEntityExist( vehicle ) then
            local vehiclePosition = GetEntityCoords( vehicle )
            local deltaX = position.x - vehiclePosition.x
            local deltaY = position.y - vehiclePosition.y
            local deltaZ = position.z - vehiclePosition.z
            local distanceSquared = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ

            if distanceSquared <= maxDistanceSquared then
                entities[ #entities + 1 ] = vehicle
                addedEntity[ vehicle ] = true
            end
        end
    end

    if localVehicle ~= 0 then
        for _, otherPlayerId in ipairs( GetActivePlayers() ) do
            if otherPlayerId ~= playerId then
                local otherPed = GetPlayerPed( otherPlayerId )

                if otherPed ~= 0
                    and DoesEntityExist( otherPed )
                    and GetVehiclePedIsIn( otherPed, false ) == 0
                    and not addedEntity[ otherPed ]
                then
                    local otherPosition = GetEntityCoords( otherPed )
                    local deltaX = position.x - otherPosition.x
                    local deltaY = position.y - otherPosition.y
                    local deltaZ = position.z - otherPosition.z
                    local distanceSquared = deltaX * deltaX
                        + deltaY * deltaY
                        + deltaZ * deltaZ

                    if distanceSquared <= maxDistanceSquared then
                        entities[ #entities + 1 ] = otherPed
                        addedEntity[ otherPed ] = true
                    end
                end
            end
        end
    end

    self.vehicleCollisionEntities = entities
end

---@return boolean
function DominationClient:IsInsideSafeZone()
    for zoneId in pairs( self.localInsideById ) do
        local zone = self.zoneById[ zoneId ]

        if zone
            and zone.type == 'safe'
            and self.authoritativeInsideById[ zoneId ]
        then
            return true
        end
    end

    return false
end

function DominationClient:HealPlayerInSafeZone()
    if not self:IsInsideSafeZone() then
        return
    end

    local ped = PlayerPedId()

    if ped == 0
        or not DoesEntityExist( ped )
        or IsEntityDead( ped )
        or IsPedDeadOrDying( ped, true )
    then
        return
    end

    if GetEntityMaxHealth( ped ) ~= DOMINATION_PED_MAX_HEALTH then
        SetPedMaxHealth( ped, DOMINATION_PED_MAX_HEALTH )
    end

    local health = GetEntityHealth( ped )

    if health <= DOMINATION_PED_BASE_HEALTH
        or health >= DOMINATION_PED_MAX_HEALTH
    then
        return
    end

    local healthRange = DOMINATION_PED_MAX_HEALTH - DOMINATION_PED_BASE_HEALTH
    local healAmount = math.max(
        1,
        math.floor( healthRange * DOMINATION_SAFE_HEAL_PERCENT_PER_TICK / 100 )
    )

    SetEntityHealth(
        ped,
        math.min( DOMINATION_PED_MAX_HEALTH, health + healAmount )
    )
end

function DominationClient:StartSafeHealingLoop()
    self.safeHealingRevision = self.safeHealingRevision + 1

    local revision = self.safeHealingRevision

    CreateThread( function()
        while self.active and self.safeHealingRevision == revision do
            self:HealPlayerInSafeZone()
            Wait( DOMINATION_SAFE_HEAL_INTERVAL_MS )
        end
    end )
end

---@private
---@param active boolean
---@param collisionActive? boolean
function DominationClient:SetSafeProtectionActive( active, collisionActive )
    active = active == true
    collisionActive = active and collisionActive == true

    if self.safeProtectionActive == active
        and self.safeCollisionProtectionActive == collisionActive
    then
        return
    end

    self.safeProtectionActive = active
    self.safeCollisionProtectionActive = collisionActive

    if active then
        if collisionActive then
            self:RefreshSafeCollisionEntities()
            SetLocalPlayerAsGhost( true )
            SetGhostedEntityAlpha( 254 )
        else
            self.safeCollisionEntities = {}
            SetLocalPlayerAsGhost( false )
            SetGhostedEntityAlpha( 255 )
        end

        local stateManager = PlayerStateManager:getInstance()
        local makeTransparent = not collisionActive

        if stateManager.invincibilityOwner == DOMINATION_SAFE_INVINCIBILITY_OWNER
            and stateManager.invincibilityTransparent
            and not makeTransparent
        then
            local ped = PlayerPedId()

            if ped ~= 0 and DoesEntityExist( ped ) then
                SetEntityAlpha( ped, 255, false )
                ResetEntityAlpha( ped )
            end
        end

        stateManager:setInvincibility(
            true,
            DOMINATION_SAFE_INVINCIBILITY_OWNER,
            85,
            nil,
            makeTransparent
        )

        return
    end

    self.safeCollisionEntities = {}
    DisablePlayerFiring( PlayerId(), false )
    SetLocalPlayerAsGhost( false )
    SetGhostedEntityAlpha( 255 )

    local stateManager = PlayerStateManager:getInstance()

    if stateManager.invincibilityOwner == DOMINATION_SAFE_INVINCIBILITY_OWNER then
        stateManager:removeInvincibility( DOMINATION_SAFE_INVINCIBILITY_OWNER )
    end
end

---@private
function DominationClient:ClearSafeExitProtection()
    self.safeExitProtectionUntil = nil
    self.safeExitProtectionRevision = self.safeExitProtectionRevision + 1
end

---@private
function DominationClient:StartSafeExitProtection()
    if not self.active or not self.gameplayActive or self:IsLocalPlayerDowned() then
        return
    end

    self.safeExitProtectionRevision = self.safeExitProtectionRevision + 1

    local revision = self.safeExitProtectionRevision

    self.safeExitProtectionUntil = GetGameTimer() + DOMINATION_SAFE_EXIT_PROTECTION_MS
    self:SetSafeProtectionActive( true, false )

    SetTimeout( DOMINATION_SAFE_EXIT_PROTECTION_MS, function()
        if self.safeExitProtectionRevision ~= revision then
            return
        end

        self.safeExitProtectionUntil = nil
        self:RefreshSafeProtectionState()
    end )
end

---@private
---@return boolean active
function DominationClient:IsSafeExitProtectionActive()
    if not self.safeExitProtectionUntil then
        return false
    end

    if GetGameTimer() < self.safeExitProtectionUntil then
        return true
    end

    self.safeExitProtectionUntil = nil

    return false
end

---@private
function DominationClient:RefreshSafeProtectionState()
    local insideSafeZone = self.active and self:IsLocallyInsideSafeZone()
    local protected = insideSafeZone
        or ( self.active and self.gameplayActive and self:IsSafeExitProtectionActive() )

    self:SetSafeProtectionActive( protected, insideSafeZone )
end

function DominationClient:StartSafeProtectionLoop()
    self.safeProtectionRevision = self.safeProtectionRevision + 1

    local revision = self.safeProtectionRevision

    CreateThread( function()
        local nextGhostRefresh = 0
        local nextCollisionRefresh = 0
        local nextVehicleCollisionRefresh = 0

        while self.active and self.safeProtectionRevision == revision do
            local ped = PlayerPedId()
            local vehicleCollisionProtectionActive = self.gameplayActive
                and ped ~= 0
                and DoesEntityExist( ped )

            if self.safeProtectionActive or vehicleCollisionProtectionActive then
                local now = GetGameTimer()
                local needsFrameLoop = self.safeProtectionActive

                if self.safeProtectionActive then
                    local playerId = PlayerId()

                    DisablePlayerFiring( playerId, true )
                    DisableControlAction( 0, 24, true ) -- INPUT_ATTACK
                    DisableControlAction( 0, 69, true ) -- INPUT_VEH_ATTACK
                    DisableControlAction( 0, 70, true ) -- INPUT_VEH_ATTACK2
                    DisableControlAction( 0, 92, true ) -- INPUT_VEH_PASSENGER_ATTACK
                    DisableControlAction( 0, 114, true ) -- INPUT_VEH_FLY_ATTACK
                    DisableControlAction( 0, 140, true ) -- INPUT_MELEE_ATTACK_LIGHT
                    DisableControlAction( 0, 141, true ) -- INPUT_MELEE_ATTACK_HEAVY
                    DisableControlAction( 0, 142, true ) -- INPUT_MELEE_ATTACK_ALTERNATE
                    DisableControlAction( 0, 257, true ) -- INPUT_ATTACK2
                    DisableControlAction( 0, 263, true ) -- INPUT_MELEE_ATTACK1
                    DisableControlAction( 0, 264, true ) -- INPUT_MELEE_ATTACK2
                    DisableControlAction( 0, 331, true ) -- INPUT_VEH_FLY_ATTACK2

                    if self.safeCollisionProtectionActive then
                        if now >= nextCollisionRefresh then
                            self:RefreshSafeCollisionEntities()
                            nextCollisionRefresh = now
                                + DOMINATION_SAFE_COLLISION_REFRESH_INTERVAL_MS
                        end

                        self:ApplySafeCollisionProtection()

                        if now >= nextGhostRefresh then
                            SetLocalPlayerAsGhost( true )
                            SetGhostedEntityAlpha( 254 )
                            nextGhostRefresh = now + DOMINATION_SAFE_GHOST_REFRESH_INTERVAL_MS
                        end
                    end
                end

                if vehicleCollisionProtectionActive then
                    if now >= nextVehicleCollisionRefresh then
                        self:RefreshVehicleCollisionEntities()
                        nextVehicleCollisionRefresh = now
                            + DOMINATION_VEHICLE_COLLISION_REFRESH_INTERVAL_MS
                    end

                    if #self.vehicleCollisionEntities > 0 then
                        self:ApplyVehicleCollisionProtection( ped )
                        needsFrameLoop = true
                    end
                else
                    if #self.vehicleCollisionEntities > 0 then
                        self.vehicleCollisionEntities = {}
                    end

                    nextVehicleCollisionRefresh = 0
                end

                Wait( needsFrameLoop and 0 or DOMINATION_ZONE_CLIENT_INTERVAL_MS )
            else
                if #self.vehicleCollisionEntities > 0 then
                    self.vehicleCollisionEntities = {}
                end

                nextVehicleCollisionRefresh = 0
                Wait( DOMINATION_ZONE_CLIENT_INTERVAL_MS )
            end
        end

        if self.safeProtectionRevision == revision then
            self.vehicleCollisionEntities = {}
            self:SetSafeProtectionActive( false )
        end
    end )
end

---@private
---@return boolean hasPresence
function DominationClient:HasLocalZonePresence()
    return next( self.localInsideById ) ~= nil
        or next( self.localInsideCapturePointById ) ~= nil
end

---@private
function DominationClient:SendZonePresenceSync()
    if self.active and self.gameplayActive then
        TriggerServerEvent( 'pvp.domination:syncZonePresence' )
    end
end

---@private
---@param revision integer
function DominationClient:ContinuePresenceHeartbeat( revision )
    if self.presenceHeartbeatRevision ~= revision
        or not self.active
        or not self.gameplayActive
        or not self:HasLocalZonePresence()
    then
        return
    end

    self:SendZonePresenceSync()

    SetTimeout( DOMINATION_PRESENCE_HEARTBEAT_MS, function()
        self:ContinuePresenceHeartbeat( revision )
    end )
end

---@private
function DominationClient:RefreshPresenceHeartbeat()
    self.presenceHeartbeatRevision = self.presenceHeartbeatRevision + 1

    if not self.active or not self.gameplayActive then
        return
    end

    self:SendZonePresenceSync()

    if not self:HasLocalZonePresence() then
        return
    end

    local revision = self.presenceHeartbeatRevision

    SetTimeout( DOMINATION_PRESENCE_HEARTBEAT_MS, function()
        self:ContinuePresenceHeartbeat( revision )
    end )
end

---@param zone SpatialZone
function DominationClient:OnLocalCapturePointEnter( zone )
    self.localInsideCapturePointById[ tostring( zone.id ) ] = true
    self:RefreshPresenceHeartbeat()
end

---@param zone SpatialZone
function DominationClient:OnLocalCapturePointExit( zone )
    self.localInsideCapturePointById[ tostring( zone.id ) ] = nil
    self:RefreshPresenceHeartbeat()
end

---@param zone SpatialZone
---@param position vector3
function DominationClient:OnLocalZoneEnter( zone, position )
    local zoneId = tostring( zone.id )

    self.localInsideById[ zoneId ] = true

    if zone.type == 'safe' then
        self:ClearSafeExitProtection()
    end

    self:RefreshSafeProtectionState()
    self:RefreshSafeZoneActionAvailability()
    self.capturePointRenderer:updateNow()
    self:RefreshCaptureHud()
    self:RefreshPresenceHeartbeat()

    TriggerEvent( 'pvp.domination:localZoneEntered', {
        zoneId = zone.id,
        zoneType = zone.type,
        position = position,
    } )

    if self.zoneDebugEnabled then
        print( ('[DominationZoneDebug] CLIENT ENTER zone=%s shape=%s'):format(
            zoneId,
            tostring( zone.shape )
        ) )
    end
end

---@param zone SpatialZone
---@param position vector3?
function DominationClient:OnLocalZoneExit( zone, position )
    local zoneId = tostring( zone.id )

    self.localInsideById[ zoneId ] = nil

    -- Zona removida pela rotacao tambem dispara saida; o aviso so some quando a
    -- pessoa sai de uma zona que continua existindo.
    if self.captureHudCompletionZoneId == zoneId and self.zoneById[ zoneId ] then
        self.captureHudCompletionZoneId = nil
        self.captureHudCompletionRevision = self.captureHudCompletionRevision + 1
    end

    if zone.type == 'safe' and not self:IsLocallyInsideSafeZone() then
        self:StartSafeExitProtection()
    end

    self:RefreshSafeProtectionState()
    self:RefreshSafeZoneActionAvailability()
    self.capturePointRenderer:updateNow()
    self:RefreshCaptureHud()
    self:RefreshPresenceHeartbeat()

    TriggerEvent( 'pvp.domination:localZoneExited', {
        zoneId = zone.id,
        zoneType = zone.type,
        position = position,
    } )

    if self.zoneDebugEnabled then
        print( ('[DominationZoneDebug] CLIENT EXIT zone=%s shape=%s'):format(
            zoneId,
            tostring( zone.shape )
        ) )
    end
end

---@param data table
function DominationClient:OnAuthoritativeZonePresenceChanged( data )
    if not self.active or type( data ) ~= 'table' or data.zoneId == nil then
        return
    end

    local zoneId = tostring( data.zoneId )

    if data.inside == true then
        self.authoritativeInsideById[ zoneId ] = true
    else
        self.authoritativeInsideById[ zoneId ] = nil
    end

    if data.zoneType == 'safe' then
        if data.inside == true then
            self:ClearSafeExitProtection()
        elseif not self:IsLocallyInsideSafeZone() then
            self:StartSafeExitProtection()
        end
    end

    self:RefreshSafeProtectionState()
    self:RefreshSafeZoneActionAvailability()

    if not self.zoneDebugEnabled then
        return
    end

    local zone = self.zoneById[ zoneId ]
    local zoneName = zone and zone.name or zoneId
    local action = data.inside == true and 'ENTER' or 'EXIT'

    print( ('[DominationZoneDebug] SERVER %s zone=%s'):format( action, zoneId ) )
    TriggerEvent(
        'Notify',
        data.inside == true and 'verde' or 'amarelo',
        ('SERVIDOR %s: %s'):format( action, zoneName ),
        3000,
        'DOMINACAO'
    )
end

---@param zone SpatialZone
---@param playerPosition vector3
function DominationClient:DrawDebugZone( zone, playerPosition )
    local bounds = zone.bounds
    local deltaX = math.max( bounds.minX - playerPosition.x, 0.0, playerPosition.x - bounds.maxX )
    local deltaY = math.max( bounds.minY - playerPosition.y, 0.0, playerPosition.y - bounds.maxY )

    if deltaX * deltaX + deltaY * deltaY
        > DOMINATION_ZONE_DEBUG_DRAW_DISTANCE * DOMINATION_ZONE_DEBUG_DRAW_DISTANCE
    then
        return
    end

    local color = zone.color or { 255, 255, 255 }
    local red = tonumber( color[ 1 ] ) or 255
    local green = tonumber( color[ 2 ] ) or 255
    local blue = tonumber( color[ 3 ] ) or 255
    local bottomZ = self.boundaryRenderer.wallBottomZ
    local topZ = self.boundaryRenderer.wallTopZ
    local boundaryHeight = tonumber( zone.boundaryHeight )

    for pointIndex, point in ipairs( zone.outline ) do
        local nextIndex = pointIndex % #zone.outline + 1
        local nextPoint = zone.outline[ nextIndex ]
        local pointBottomZ = bottomZ
        local pointTopZ = topZ
        local nextBottomZ = bottomZ
        local nextTopZ = topZ

        if self.boundaryRenderer.useBoundaryProfiles
            and boundaryHeight
            and boundaryHeight > 0.0
            and point.z
            and nextPoint.z
        then
            pointBottomZ = point.z - 0.1
            pointTopZ = point.z + boundaryHeight
            nextBottomZ = nextPoint.z - 0.1
            nextTopZ = nextPoint.z + boundaryHeight
        end

        DrawPoly(
            point.x, point.y, pointBottomZ,
            nextPoint.x, nextPoint.y, nextBottomZ,
            nextPoint.x, nextPoint.y, nextTopZ,
            red, green, blue, 36
        )
        DrawPoly(
            point.x, point.y, pointBottomZ,
            nextPoint.x, nextPoint.y, nextTopZ,
            point.x, point.y, pointTopZ,
            red, green, blue, 36
        )
        DrawPoly(
            nextPoint.x, nextPoint.y, nextTopZ,
            nextPoint.x, nextPoint.y, nextBottomZ,
            point.x, point.y, pointBottomZ,
            red, green, blue, 36
        )
        DrawPoly(
            point.x, point.y, pointTopZ,
            nextPoint.x, nextPoint.y, nextTopZ,
            point.x, point.y, pointBottomZ,
            red, green, blue, 36
        )
    end
end

function DominationClient:StartZoneDebugDrawLoop()
    self.zoneDebugRevision = self.zoneDebugRevision + 1

    local revision = self.zoneDebugRevision

    CreateThread( function()
        while self.active and self.zoneDebugEnabled and self.zoneDebugRevision == revision do
            local ped = PlayerPedId()

            if ped ~= 0 and DoesEntityExist( ped ) then
                local playerPosition = GetEntityCoords( ped )

                for _, zone in ipairs( self.zoneTracker.zoneSet:getZones() ) do
                    self:DrawDebugZone( zone, playerPosition )
                end
            end

            Wait( 0 )
        end
    end )
end

---@return boolean enabled
function DominationClient:ToggleZoneDebug()
    if not self.active then
        print( '[DominationZoneDebug] entre no modo Domination antes de ativar o debug' )
        return false
    end

    self.zoneDebugEnabled = not self.zoneDebugEnabled
    self.zoneDebugRevision = self.zoneDebugRevision + 1

    print( ('[DominationZoneDebug] %s'):format(
        self.zoneDebugEnabled and 'ENABLED' or 'DISABLED'
    ) )

    if self.zoneDebugEnabled then
        local localZoneIds = {}
        local authoritativeZoneIds = {}

        for zoneId in pairs( self.localInsideById ) do
            localZoneIds[ #localZoneIds + 1 ] = zoneId
        end

        for zoneId in pairs( self.authoritativeInsideById ) do
            authoritativeZoneIds[ #authoritativeZoneIds + 1 ] = zoneId
        end

        table.sort( localZoneIds )
        table.sort( authoritativeZoneIds )

        print( ('[DominationZoneDebug] CURRENT client=%s server=%s'):format(
            #localZoneIds > 0 and table.concat( localZoneIds, ',' ) or 'none',
            #authoritativeZoneIds > 0 and table.concat( authoritativeZoneIds, ',' ) or 'none'
        ) )

        self:StartZoneDebugDrawLoop()
    end

    return self.zoneDebugEnabled
end

---@private
function DominationClient:ClearExitConfirmation()
    if not self.exitMatchResponseHandler then
        return
    end

    RemoveEventHandler( self.exitMatchResponseHandler )
    self.exitMatchResponseHandler = nil
end

---@param callback fun(confirmed: boolean)
function DominationClient:ConfirmLeave( callback )
    if not self:IsLocalPlayerAliveForRevive() then
        callback( false )
        return
    end

    self:ClearExitConfirmation()

    self.exitMatchResponseHandler = AddEventHandler( 'pvp.callback:exitMatchResponse', function( data )
        self:ClearExitConfirmation()
        callback( self.active and type( data ) == 'table' and data.confirmed == true )
    end )

    TriggerEvent( 'pvp.hud:openExitMatch', {
        title = PvpTranslations.get( 'exit_match_title' ),
        description = PvpTranslations.get( 'exit_match_description' ),
        confirmLabel = PvpTranslations.get( 'exit_match_confirm' ),
        cancelLabel = PvpTranslations.get( 'exit_match_cancel' ),
    } )
end

---@private
---@param payload table
function DominationClient:SendSelectorMessage( payload )
    SendNUIMessage( {
        action = DOMINATION_SELECTOR_EVENT,
        type = DOMINATION_SELECTOR_EVENT,
        data = payload,
    } )
end

---@private
---@param payload table
function DominationClient:SendStoreMessage( payload )
    SendNUIMessage( {
        action = DOMINATION_STORE_EVENT,
        type = DOMINATION_STORE_EVENT,
        data = payload,
    } )
end

---@private
---@param payload table
function DominationClient:SendVehiclesMessage( payload )
    SendNUIMessage( {
        action = DOMINATION_VEHICLES_EVENT,
        type = DOMINATION_VEHICLES_EVENT,
        data = payload,
    } )
end

---@return boolean closed
function DominationClient:ClosePersonalChest()
    if GetResourceState( 'inventory' ) ~= 'started' then
        return false
    end

    local succeeded, closed = pcall( function()
        return exports.inventory:ClosePersonalChest()
    end )

    if not succeeded then
--         sx.logger:warn( ( 'Failed to close Domination personal chest: %s' ):format(
--             tostring( closed )
--         ) )
        return false
    end

    return closed == true
end

---@param available boolean
---@param vehiclesAvailable? boolean
function DominationClient:SetStoreAvailable( available, vehiclesAvailable )
    available = available == true
    self.storeAvailable = available
    self.vehiclesAvailable = vehiclesAvailable == true
    self:SendHudEvent( 'setDominationStoreHintVisible', {
        visible = available, vehiclesVisible = self.vehiclesAvailable,
    } )

    if not available then
        self:CloseStore()
        self:ClosePersonalChest()
    end

    if not self.vehiclesAvailable then
        self:CloseVehicles()
    end

    self:SendStoreMessage( {
        available = available,
        show = available and self.storeOpen,
    } )
    self:SendVehiclesMessage( {
        available = self.vehiclesAvailable,
        show = self.vehiclesAvailable and self.vehiclesOpen,
    } )
end

function DominationClient:RefreshSafeZoneActionAvailability()
    local vehiclesAvailable = self.active
        and self.gameplayActive
        and self:IsLocalPlayerAliveForRevive()
    local available = vehiclesAvailable and self:IsLocallyInsideSafeZone()

    self:SetStoreAvailable( available, vehiclesAvailable )

    if not available
        and self.selectorOpen
        and not self.selectorLeavesMatchOnClose
        and not self.respawnToken
    then
        self:CloseSelector()
    end
end

function DominationClient:CloseStore()
    local wasOpen = self.storeOpen

    self.storeOpen = false
    self.storeRequestInFlight = false
    self:SendStoreMessage( {
        available = self.storeAvailable,
        show = false,
    } )

    if not wasOpen then
        return
    end

    SetNuiFocus( false, false )

    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end
end

function DominationClient:CloseVehicles()
    local wasOpen = self.vehiclesOpen

    self.vehiclesOpen = false
    self.vehiclesRequestInFlight = false
    self:SendVehiclesMessage( {
        available = self.vehiclesAvailable,
        show = false,
    } )

    if not wasOpen then
        return
    end

    SetNuiFocus( false, false )

    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end
end

---@return table[]? vehicles
---@return table? vehicleState
function DominationClient:LoadVehicles()
    local garageIndex = ResolvePersonalGarageIndex()

    if not garageIndex then
        return nil
    end

    local vehiclesSucceeded, vehicles = pcall( function()
        return gGaragesServer.Vehicles( garageIndex )
    end )
    local stateSucceeded, vehicleState = pcall( function()
        return RPC.GameModeGetDominationVehicleState()
    end )

    if not vehiclesSucceeded
        or type( vehicles ) ~= 'table'
        or not stateSucceeded
        or type( vehicleState ) ~= 'table'
        or vehicleState.success ~= true
    then
        return nil, vehicleState
    end

    local models = {}

    for _, vehicle in ipairs( vehicles ) do
        if type( vehicle.model ) == 'string' then
            models[ #models + 1 ] = vehicle.model
        end
    end

    local typesSucceeded, vehicleTypes = pcall( function()
        return exports.garages:GetVehicleTypes( models )
    end )

    if not typesSucceeded or type( vehicleTypes ) ~= 'table' then
        vehicleTypes = {}
    end

    local activeModel = type( vehicleState.activeModel ) == 'string'
        and vehicleState.activeModel
        or nil

    for _, vehicle in ipairs( vehicles ) do
        vehicle.type = ResolveDominationVehicleCategory(
            vehicle.model,
            vehicleTypes[ vehicle.model ],
            vehicle.type
        )
        vehicle.spawned = activeModel ~= nil and vehicle.model == activeModel
    end

    self.vehicles = vehicles

    return vehicles, vehicleState
end

function DominationClient:OpenVehicles()
    if self.vehiclesOpen
        or self.vehiclesRequestInFlight
        or not self.vehiclesAvailable
        or self.selectorOpen
        or self.storeOpen
        or self.storeRequestInFlight
        or not self:IsLocalPlayerAliveForRevive()
        or IsNuiFocused()
    then
        return
    end

    self.vehiclesRequestInFlight = true

    CreateThread( function()
        local vehicles, vehicleState = self:LoadVehicles()

        self.vehiclesRequestInFlight = false

        if not self.vehiclesAvailable
            or not self:IsLocalPlayerAliveForRevive()
        then
            return
        end

        if not vehicles then
            TriggerEvent(
                'Notify',
                'vermelho',
                type( vehicleState ) == 'table' and vehicleState.message
                    or PvpTranslations.get( 'domination_vehicles_unavailable' ),
                5000,
                PvpTranslations.get( 'domination_vehicles_title' )
            )
            return
        end

        self.vehiclesOpen = true
        SetNuiFocus( true, true )

        if type( SetNuiFocusKeepInput ) == 'function' then
            SetNuiFocusKeepInput( false )
        end

        self:SendVehiclesMessage( {
            available = true,
            show = true,
            vehicles = vehicles,
        } )
    end )
end

function DominationClient:ToggleVehicles()
    if self.vehiclesOpen then
        self:CloseVehicles()
        return
    end

    self:OpenVehicles()
end

function DominationClient:OpenStore()
    if self.storeOpen
        or self.storeRequestInFlight
        or not self.storeAvailable
        or self.selectorOpen
        or self.vehiclesOpen
        or self.vehiclesRequestInFlight
        or not self:IsLocalPlayerAliveForRevive()
        or not self:IsLocallyInsideSafeZone()
        or IsNuiFocused()
    then
        return
    end

    self.storeRequestInFlight = true

    CreateThread( function()
        local succeeded, store = pcall( function()
            return gNewHubServer.GetStore()
        end )

        self.storeRequestInFlight = false

        if not self.storeAvailable
            or not self:IsLocalPlayerAliveForRevive()
            or not self:IsLocallyInsideSafeZone()
        then
            return
        end

        if not succeeded or type( store ) ~= 'table' then
            TriggerEvent(
                'Notify',
                'vermelho',
                PvpTranslations.get( 'domination_store_unavailable' ),
                5000,
                PvpTranslations.get( 'domination_store_title' )
            )
            return
        end

        self.storeOpen = true
        SetNuiFocus( true, true )

        if type( SetNuiFocusKeepInput ) == 'function' then
            SetNuiFocusKeepInput( false )
        end

        self:SendStoreMessage( {
            available = true,
            show = true,
            balance = tonumber( store.balance ) or 0,
            buyDiamondsUrl = store.buyDiamondsUrl,
            allowedCategoryIds = DOMINATION_STORE_CATEGORY_IDS,
        } )
    end )
end

function DominationClient:ToggleStore()
    if self.storeOpen then
        self:CloseStore()
        return
    end

    self:OpenStore()
end

---@return boolean opened
function DominationClient:OpenPersonalChest()
    if not self.storeAvailable
        or self.selectorOpen
        or self.storeOpen
        or self.storeRequestInFlight
        or self.vehiclesOpen
        or self.vehiclesRequestInFlight
        or not self:IsLocalPlayerAliveForRevive()
        or not self:IsLocallyInsideSafeZone()
        or IsNuiFocused()
    then
        return false
    end

    if GetResourceState( 'inventory' ) ~= 'started' then
--         sx.logger:warn( 'Inventory unavailable while opening Domination personal chest' )
        return false
    end

    local succeeded, opened = pcall( function()
        return exports.inventory:OpenPersonalChest()
    end )

    if not succeeded then
--         sx.logger:warn( ( 'Failed to open Domination personal chest: %s' ):format(
--             tostring( opened )
--         ) )
        return false
    end

    return opened == true
end

---@private
---@param forced boolean
function DominationClient:SetMinimapForced( forced )
    if GetResourceState( 'hud' ) ~= 'started' then
        if forced then
            DisplayRadar( true )
        end

        return
    end

    exports.hud:SetMinimapForced( DOMINATION_MINIMAP_OWNER, forced )
end

---@private
---@param hidden boolean
function DominationClient:SetWorldBlipsHidden( hidden )
    if GetResourceState( 'hud' ) ~= 'started' then
        return
    end

    exports.hud:SetBlipsHidden( DOMINATION_MINIMAP_OWNER, hidden )
end

---@private
---@param forced boolean
---@param distance? number
function DominationClient:SetBigmapForced( forced, distance )
    if distance then
        self.previewRadarDistance = distance
    end

    if GetResourceState( 'hud' ) ~= 'started' then
        SetBigmapActive( forced, false )

        if forced then
            SetRadarZoomToDistance( self.previewRadarDistance )
        else
            SetRadarZoom( 0 )
        end

        return
    end

    exports.hud:SetBigmapForced(
        DOMINATION_MINIMAP_OWNER,
        forced,
        self.previewRadarDistance
    )
end

---@private
---@param enabled boolean?
---@return boolean success
function DominationClient:SetCayoPericoPreview( enabled )
    if GetResourceState( 'player' ) ~= 'started' then
        return false
    end

    local called, success = pcall( function()
        return exports.player:SetCayoPericoPreview( enabled )
    end )

    return called and success == true
end

---@private
function DominationClient:HoldSelectorPreviewFreeze()
    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return
    end

    if self.selectorPreviewFrozenPed == ped then
        self.selectorPreviewFreezeRevision = self.selectorPreviewFreezeRevision + 1
        return
    end

    self:ReleaseSelectorPreviewFreeze( false )
    self:ReleaseHeadquartersReturnFreeze()
    self.selectorPreviewFrozenPed = ped
    FreezeEntityPosition( ped, true )

    local vehicle = GetVehiclePedIsIn( ped, false )

    if vehicle ~= 0 then
        self.selectorPreviewFrozenVehicle = vehicle
        FreezeEntityPosition( vehicle, true )
    end
end

---@private
---@param x number
---@param y number
---@param z number
---@return boolean success
function DominationClient:MoveSelectorPreviewPed( x, y, z )
    local ped = self.selectorPreviewFrozenPed

    if not ped or not DoesEntityExist( ped ) then
        return false
    end

    local vehicle = GetVehiclePedIsIn( ped, false )

    if not self.selectorPreviewOrigin then
        local origin = {
            ped = ped,
            coords = GetEntityCoords( ped ),
            heading = GetEntityHeading( ped ),
            visible = IsEntityVisible( ped ),
            vehicle = vehicle,
        }

        if vehicle ~= 0 then
            for seat = -1, GetVehicleMaxNumberOfPassengers( vehicle ) - 1 do
                if GetPedInVehicleSeat( vehicle, seat ) == ped then
                    origin.seat = seat
                    break
                end
            end
        end

        self.selectorPreviewOrigin = origin
    end

    -- Carrega com o ped no destino, sem levar o veiculo ou seus passageiros.
    SetEntityVisible( ped, false, false )
    SetEntityCoordsNoOffset( ped, x, y, z, vehicle == 0, true, false )
    RequestCollisionAtCoord( x, y, z )
    return true
end

---@private
---@param restorePosition boolean
function DominationClient:RestoreSelectorPreviewPed( restorePosition )
    local origin = self.selectorPreviewOrigin
    self.selectorPreviewOrigin = nil

    if not origin then
        return
    end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        return
    end

    if restorePosition then
        local coords = origin.coords
        SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, true, true, false )
        SetEntityHeading( ped, origin.heading )
        RequestCollisionAtCoord( coords.x, coords.y, coords.z )

        if origin.seat ~= nil
            and DoesEntityExist( origin.vehicle )
            and IsVehicleSeatFree( origin.vehicle, origin.seat, false )
        then
            SetPedIntoVehicle( ped, origin.vehicle, origin.seat )
        end
    end

    if ped == origin.ped then
        SetEntityVisible( ped, origin.visible, false )
    end
end

---@private
---@param waitForAreaLoad boolean
function DominationClient:ReleaseSelectorPreviewFreeze( waitForAreaLoad )
    self.selectorPreviewFreezeRevision = self.selectorPreviewFreezeRevision + 1

    local revision = self.selectorPreviewFreezeRevision
    local areaLoadRevision = self.areaLoadRevision
    local ped = self.selectorPreviewFrozenPed

    if not waitForAreaLoad or not ped or not DoesEntityExist( ped ) then
        self.selectorPreviewFrozenPed = nil

        if ped and DoesEntityExist( ped ) then
            FreezeEntityPosition( ped, false )
        end

        local vehicle = self.selectorPreviewFrozenVehicle
        self.selectorPreviewFrozenVehicle = nil

        if vehicle and DoesEntityExist( vehicle ) then
            FreezeEntityPosition( vehicle, false )
        end

        return
    end

    CreateThread( function()
        if self.selectorPreviewFreezeRevision ~= revision
            or self.areaLoadRevision ~= areaLoadRevision
        then
            return
        end

        if not DoesEntityExist( ped ) then
            self:ReleaseSelectorPreviewFreeze( false )
            return
        end

        local coords = GetEntityCoords( ped )
        local loadState = self:StartAreaLoad(
            ( 'selector-restore:%d' ):format( revision ),
            coords.x,
            coords.y,
            coords.z
        )

        if not loadState then
            self:ReleaseSelectorPreviewFreeze( false )
            return
        end

        while self.selectorPreviewFreezeRevision == revision
            and DoesEntityExist( ped )
            and self.areaLoad == loadState
            and ( not loadState.ready or not HasCollisionLoadedAroundEntity( ped ) )
        do
            Wait( 0 )
        end

        if self.selectorPreviewFreezeRevision ~= revision
            or self.areaLoad ~= loadState
        then
            return
        end

        self:StopAreaLoad()
        self:ReleaseSelectorPreviewFreeze( false )
    end )
end

---@private
---@param zoneId string|number
function DominationClient:ApplySafeZonePreviewEnvironment( zoneId )
    local isCayoPreview = tostring( zoneId ) == DOMINATION_CAYO_SAFE_ZONE_ID

    self:HoldSelectorPreviewFreeze()

    if self:SetCayoPericoPreview( isCayoPreview ) then
        self.selectorCayoPreviewOwned = true
    end
end

---@private
---@param waitForAreaLoad? boolean
function DominationClient:RestoreSafeZonePreviewEnvironment( waitForAreaLoad )
    self:RestoreSelectorPreviewPed( true )

    if self.selectorCayoPreviewOwned then
        self:SetCayoPericoPreview( nil )
        self.selectorCayoPreviewOwned = false
    end

    self:ReleaseSelectorPreviewFreeze( waitForAreaLoad ~= false )
end

---@private
function DominationClient:IndexZones()
    self.zoneById = {}
    self.safeZoneById = {}
    self.selectorZoneById = {}

    for _, zone in ipairs( self.snapshot.zones ) do
        zone.captureRemainingSyncedAt = GetGameTimer()
        self.zoneById[ tostring( zone.id ) ] = zone

        if zone.type == 'safe' then
            self.safeZoneById[ tostring( zone.id ) ] = zone
        end
    end

    for _, selectorZone in ipairs( self.snapshot.selector.zones ) do
        self.selectorZoneById[ tostring( selectorZone.id ) ] = selectorZone
    end
end

---@private
---@param preserveAreaLoad? boolean
function DominationClient:StopPreviewCamera( preserveAreaLoad )
    self.previewCameraRevision = self.previewCameraRevision + 1
    self.previewRequestRevision = self.previewRequestRevision + 1
    self.previewZoneId = nil

    if self.previewMinimapLocked then
        UnlockMinimapPosition()
        self.previewMinimapLocked = false
    end

    self:SetBigmapForced( false )

    for camera in pairs( self.previewCameras ) do
        if DoesCamExist( camera ) then
            DestroyCam( camera, true )
        end
    end

    self.previewCameras = {}
    self.previewCamera = nil
    RenderScriptCams( false, true, DOMINATION_PREVIEW_CAMERA_TRANSITION_MS, true, true )
    self:LogStreaming( 'preview_stopped' )

    if not preserveAreaLoad then
        self:StopAreaLoad()
    end
end

---@private
---@param selectorZone table
---@param immediate? boolean
---@return boolean success
function DominationClient:SetPreviewCameraZone( selectorZone, immediate )
    local preview = selectorZone and selectorZone.preview
    local zoneKey = selectorZone and tostring( selectorZone.id ) or nil

    if not zoneKey
        or type( preview ) ~= 'table'
        or type( preview.x ) ~= 'number'
        or type( preview.y ) ~= 'number'
    then
        return false
    end

    if self.previewZoneId == zoneKey
        and self.previewCamera
        and DoesCamExist( self.previewCamera )
    then
        return true
    end

    self:ApplySafeZonePreviewEnvironment( selectorZone.id )

    local radius = math.max( tonumber( preview.radius ) or 80.0, 20.0 )
    local targetZ = tonumber( preview.z ) or 0.0
    local radarDistance = radius * DOMINATION_SELECTOR_RADAR_RADIUS_MULTIPLIER
    local cameraHeight = math.max(
        DOMINATION_PREVIEW_CAMERA_MIN_HEIGHT,
        radius * DOMINATION_PREVIEW_CAMERA_RADIUS_HEIGHT_MULTIPLIER
    )
    local cameraOffset = radius * DOMINATION_PREVIEW_CAMERA_RADIUS_OFFSET_MULTIPLIER
    local nextCamera = CreateCam( 'DEFAULT_SCRIPTED_CAMERA', true )

    if nextCamera == 0 then
        return false
    end

    SetCamCoord(
        nextCamera,
        preview.x - cameraOffset,
        preview.y - cameraOffset,
        targetZ + cameraHeight
    )
    PointCamAtCoord( nextCamera, preview.x, preview.y, targetZ )
    SetCamFov( nextCamera, 42.0 )
    LockMinimapPosition( preview.x, preview.y )
    self.previewMinimapLocked = true
    self:SetBigmapForced( true, radarDistance )

    local previousCamera = self.previewCamera
    self.previewCamera = nextCamera
    self.previewCameras[ nextCamera ] = true
    self.previewZoneId = zoneKey
    self.previewCameraRevision = self.previewCameraRevision + 1

    local revision = self.previewCameraRevision

    if previousCamera and DoesCamExist( previousCamera ) and not immediate then
        SetCamActiveWithInterp(
            nextCamera,
            previousCamera,
            DOMINATION_PREVIEW_CAMERA_TRANSITION_MS,
            1,
            1
        )
    else
        SetCamActive( nextCamera, true )
        RenderScriptCams(
            true,
            not immediate,
            DOMINATION_PREVIEW_CAMERA_TRANSITION_MS,
            true,
            true
        )
    end

    if previousCamera and previousCamera ~= nextCamera then
        CreateThread( function()
            Wait( DOMINATION_PREVIEW_CAMERA_TRANSITION_MS + 50 )

            if revision <= self.previewCameraRevision and DoesCamExist( previousCamera ) then
                DestroyCam( previousCamera, true )
            end

            self.previewCameras[ previousCamera ] = nil
        end )
    end

    if not self:MoveSelectorPreviewPed( preview.x, preview.y, targetZ ) then
        self:StopPreviewCamera()
        self:RestoreSafeZonePreviewEnvironment( false )
        self:RestoreScreenFade()
        return false
    end

    -- Deixa camera e ped entrarem no ciclo de streaming antes de iniciar a carga.
    Wait( 0 )

    if self.previewCameraRevision ~= revision
        or not self.selectorOpen
        or not DoesCamExist( nextCamera )
    then
        return false
    end

    if not self:StartAreaLoad(
        zoneKey,
        preview.x,
        preview.y,
        targetZ,
        radius
    ) then
        self:StopPreviewCamera( true )
        self:RestoreSafeZonePreviewEnvironment( false )
        self:RestoreScreenFade()
        return false
    end

    self:LogStreaming( 'preview_shown' )
    return true
end

---@param zoneId string?
---@return boolean success
function DominationClient:PreviewSafeZone( zoneId )
    if not self.selectorOpen then
        return false
    end

    self.previewRequestRevision = self.previewRequestRevision + 1

    if not zoneId or zoneId == '' then
        return true
    end

    local zoneKey = tostring( zoneId )
    local selectorZone = self.selectorZoneById[ zoneKey ]

    if not selectorZone then
        return false
    end

    if self.previewZoneId == zoneKey then
        return true
    end

    local revision = self.previewRequestRevision

    CreateThread( function()
        Wait( DOMINATION_SELECTOR_PREVIEW_DEBOUNCE_MS )

        if self.selectorOpen
            and self.previewRequestRevision == revision
        then
            self:SetPreviewCameraZone( selectorZone, false )
        end
    end )

    return true
end

---@private
---@return boolean completed
function DominationClient:FadeOutForSelector()
    self.selectorFadeOwned = true

    if not IsScreenFadedOut() then
        DoScreenFadeOut( DOMINATION_SELECTOR_FADE_MS )

        while self.selectorFadeOwned and not IsScreenFadedOut() do
            Wait( 0 )
        end
    end

    return self.selectorFadeOwned
end

---@private
function DominationClient:FadeInForSelector()
    if not self.selectorFadeOwned then
        return
    end

    Wait( DOMINATION_SELECTOR_SETTLE_MS )

    if not self.selectorFadeOwned then
        return
    end

    DoScreenFadeIn( DOMINATION_SELECTOR_FADE_MS )
    self.selectorFadeOwned = false
end

---@private
function DominationClient:RestoreScreenFade()
    self.teleportRevision = self.teleportRevision + 1

    local fadeOwned = self.selectorFadeOwned or self.teleportFadeOwned

    if self.teleportFadeOwned then
        self:RestoreSafeZonePreviewEnvironment( false )
        local ped = self.teleportFrozenPed or PlayerPedId()

        if ped ~= 0 and DoesEntityExist( ped ) then
            FreezeEntityPosition( ped, false )
        end
    end

    if fadeOwned and ( IsScreenFadedOut() or IsScreenFadingOut() ) then
        DoScreenFadeIn( DOMINATION_SELECTOR_FADE_MS )
    end

    self.selectorFadeOwned = false
    self.teleportFadeOwned = false
    self.teleportFrozenPed = nil
end

---@param data table
---@return boolean success
function DominationClient:Open( data )
    if type( data ) ~= 'table'
        or type( data.zones ) ~= 'table'
        or #data.zones == 0
        or type( data.selector ) ~= 'table'
        or type( data.selector.zones ) ~= 'table'
        or #data.selector.zones == 0
    then
        return false
    end

    self.lifecycleRevision = self.lifecycleRevision + 1

    local lifecycleRevision = self.lifecycleRevision

    if not self:FadeOutForSelector() then
        return false
    end

    -- Aguarda uma atualizacao anterior encerrar antes de reutilizar suas DUIs.
    while self.zoneMapRefreshRunning and self.lifecycleRevision == lifecycleRevision do
        Wait( 0 )
    end

    if self.lifecycleRevision ~= lifecycleRevision then
        self:RestoreScreenFade()
        return false
    end

    self:CreateRenderers()

    local renderer = self.renderer

    if self.snapshot and ( self.snapshot.zoneRevision or 0 ) > ( data.zoneRevision or 0 ) then
        data = self.snapshot
    end

    self.snapshot = data
    self.active = true
    self.gameplayActive = false
    self:SetWorldBlipsHidden( true )
    self:SetMinimapForced( true )
    self:SetBigmapForced( true )
    self.selectorOpen = true
    self.selectorLeavesMatchOnClose = true
    self:IndexZones()
    self.zoneTracker:stop( false )
    self.zoneTracker:setZones( data.zones )
    self.capturePointTracker:stop( false )
    self.capturePointTracker:setZones( BuildCapturePointZones( data.zones ) )
    self.boundaryRenderer:hide()
    self.boundaryRenderer:setZones( data.zones )
    self.capturePointRenderer:hide()
    self.revivePointRenderer:hide()
    self.capturePointRenderer:setZones( data.zones )
    for _, rankingBoardRenderer in ipairs( self.rankingBoardRenderers ) do
        rankingBoardRenderer:hide()
        rankingBoardRenderer:setZones( data.zones )
    end
    self.zoneMapRefreshRunning = true
    renderer:setZones( data.zones )
    renderer:show()
    self.zoneMapRefreshRunning = false

    if self.lifecycleRevision == lifecycleRevision and self.zoneMapRefreshPending then
        self:RefreshZoneMap()
    end

    if self.lifecycleRevision ~= lifecycleRevision
        or not self.active
        or not self.selectorOpen
        or self.renderer ~= renderer
    then
        renderer:destroy()
        self:RestoreScreenFade()
        return false
    end

    self:SendSelectorMessage( data.selector )
    SetNuiFocus( true, true )

    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end

    self:SetPreviewCameraZone( data.selector.zones[ 1 ], true )
    self:FadeInForSelector()

    return true
end

---@return boolean success
function DominationClient:OpenSpawnSelector()
    local selector = self.snapshot and self.snapshot.selector
    local respawnToken = self.respawnToken

    if not self.active
        or not self.gameplayActive
        or self.teleportFadeOwned
        or self.selectorFadeOwned
        or self.selectorOpen
        or self.storeOpen
        or self.storeRequestInFlight
        or self.vehiclesOpen
        or self.vehiclesRequestInFlight
        or ( not respawnToken and (
            not self.storeAvailable
            or not self:IsLocalPlayerAliveForRevive()
            or not self:IsLocallyInsideSafeZone()
        ) )
        or ( IsNuiFocused() and not self.respawnChoiceOpen )
        or type( selector ) ~= 'table'
        or type( selector.zones ) ~= 'table'
        or #selector.zones == 0
    then
        return false
    end

    if not self:FadeOutForSelector() then
        return false
    end

    if not self.active
        or not self.gameplayActive
        or self.respawnToken ~= respawnToken
        or ( not respawnToken and (
            not self:IsLocalPlayerAliveForRevive()
            or not self:IsLocallyInsideSafeZone()
        ) )
    then
        self:RestoreScreenFade()
        return false
    end

    self:SetRespawnChoiceVisible( false )
    self.selectorOpen = true
    self.selectorLeavesMatchOnClose = false
    self:SetBigmapForced( true )
    self:SendSelectorMessage( {
        show = true,
        respawn = respawnToken ~= nil,
        eyebrow = selector.eyebrow,
        title = selector.title,
        zones = selector.zones,
        copy = selector.copy,
    } )
    SetNuiFocus( true, true )

    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end

    self:SetPreviewCameraZone( selector.zones[ 1 ], true )
    self:FadeInForSelector()

    return true
end

function DominationClient:ToggleSpawnSelector()
    if self.respawnToken then
        return
    end

    if self.selectorOpen then
        if not self.selectorLeavesMatchOnClose then
            self:CloseSelector()
        end

        return
    end

    self:OpenSpawnSelector()
end

---@private
---@param preservePreviewEnvironment? boolean
---@param waitForAreaLoad? boolean
---@param preserveAreaLoad? boolean
function DominationClient:CloseSelector(
    preservePreviewEnvironment,
    waitForAreaLoad,
    preserveAreaLoad
)
    self.selectorOpen = false
    self.selectorLeavesMatchOnClose = false
    self:SendSelectorMessage( { show = false } )
    self:StopPreviewCamera( preserveAreaLoad )

    if not preservePreviewEnvironment then
        self:RestoreSafeZonePreviewEnvironment( waitForAreaLoad )
    end

    SetNuiFocus( false, false )

    if type( SetNuiFocusKeepInput ) == 'function' then
        SetNuiFocusKeepInput( false )
    end

end

function DominationClient:ReleaseHeadquartersReturnFreeze()
    self.headquartersFreezeRevision = self.headquartersFreezeRevision + 1

    local ped = self.headquartersFrozenPed

    self.headquartersFrozenPed = nil

    if ped and DoesEntityExist( ped ) then
        FreezeEntityPosition( ped, false )
    end
end

---@param ped number
function DominationClient:FreezeForHeadquartersLoad( ped )
    self:ReleaseHeadquartersReturnFreeze()

    local revision = self.headquartersFreezeRevision

    self.headquartersFrozenPed = ped
    FreezeEntityPosition( ped, true )

    SetTimeout( DOMINATION_HEADQUARTERS_LOAD_FREEZE_MS, function()
        if self.headquartersFreezeRevision ~= revision then
            return
        end

        self.headquartersFrozenPed = nil

        if DoesEntityExist( ped ) then
            FreezeEntityPosition( ped, false )
        end
    end )
end

---@param data table?
function DominationClient:ReturnToPvpNpc( data )
    local returnCoords = type( data ) == 'table' and data.returnCoords or nil

    if not ( returnCoords and returnCoords.x and returnCoords.y and returnCoords.z ) then
        returnCoords = PVP_NPC_COORDS
    end

    local ped = PlayerPedId()

    if not DoesEntityExist( ped ) or not returnCoords then
        return
    end

    SetEntityCoordsNoOffset(
        ped,
        returnCoords.x,
        returnCoords.y,
        returnCoords.z,
        false,
        false,
        false
    )
    SetEntityHeading( ped, returnCoords.w or PVP_NPC_COORDS.w )
    self:SetCayoPericoPreview( nil )

    if type( data ) == 'table' and data.reason == 'death_timeout' then
        self:FreezeForHeadquartersLoad( ped )
    end
end

function DominationClient:Close()
    self.lifecycleRevision = self.lifecycleRevision + 1
    self:SetStoreAvailable( false )
    self:ReleaseHeadquartersReturnFreeze()
    self:ClearExitConfirmation()
    TriggerEvent( 'pvp.hud:closeExitMatch' )
    self:HideHud()
    self.respawnToken = nil
    self:SetRespawnChoiceVisible( false )
    self:ClearReviveState( true )
    self:ClearTeamPlayers()
    self.active = false
    self.gameplayActive = false
    self.zoneDebugEnabled = false
    self.zoneDebugRevision = self.zoneDebugRevision + 1
    self.safeHealingRevision = self.safeHealingRevision + 1
    self.safeProtectionRevision = self.safeProtectionRevision + 1
    self.vehicleCollisionEntities = {}
    self:ClearSafeExitProtection()
    self.presenceHeartbeatRevision = self.presenceHeartbeatRevision + 1
    self:SetSafeProtectionActive( false )
    self.zoneTracker:stop( false )
    self.capturePointTracker:stop( false )
    self:StopAreaLoad()
    self:CloseSelector( false, false, true )
    self:RestoreScreenFade()
    self:DestroyRenderers()
    self:SetWorldBlipsHidden( false )
    self:SetMinimapForced( false )
    self.hudPlayerCount = 0
    self.snapshot = nil
    self.zoneById = {}
    self.safeZoneById = {}
    self.selectorZoneById = {}
    self.localInsideById = {}
    self.localInsideCapturePointById = {}
    self.authoritativeInsideById = {}
end

---@param spawn table
function DominationClient:EnterAtSafeZone( spawn )
    if self.lootRenderer then self.lootRenderer:ResetGrid() end
    if not self.active
        or type( spawn ) ~= 'table'
        or type( spawn.x ) ~= 'number'
        or type( spawn.y ) ~= 'number'
        or type( spawn.z ) ~= 'number'
    then
        return
    end

    self.teleportRevision = self.teleportRevision + 1
    self:SetRespawnChoiceVisible( false )

    local revision = self.teleportRevision
    local zoneKey = tostring( spawn.zoneId )
    local isCayoDestination = zoneKey == DOMINATION_CAYO_SAFE_ZONE_ID
    local selectorZone = self.selectorZoneById[ zoneKey ]
    local preview = selectorZone and selectorZone.preview
    local loadX = type( preview ) == 'table' and tonumber( preview.x ) or spawn.x
    local loadY = type( preview ) == 'table' and tonumber( preview.y ) or spawn.y
    local loadZ = type( preview ) == 'table' and tonumber( preview.z ) or spawn.z
    local loadRadius = type( preview ) == 'table'
        and tonumber( preview.radius )
        or DOMINATION_SCENE_LOAD_RADIUS

    self:HoldSelectorPreviewFreeze()

    self.selectorCayoPreviewOwned = self:SetCayoPericoPreview( isCayoDestination )
    local loadState = self:MoveSelectorPreviewPed( loadX, loadY, loadZ ) and self:StartAreaLoad(
        zoneKey,
        loadX,
        loadY,
        loadZ,
        loadRadius
    )

    if not loadState then
        self:StopPreviewCamera( true )
        self:RestoreSafeZonePreviewEnvironment( false )
        self:RestoreScreenFade()

        local success, message = RPC.pvp_leaveRoom(
            eGamemodeTypes.DOMINATION,
            eGamemodeCategories.Pvp
        )

        if not success then
--             sx.logger:warn( ( 'Failed to leave Domination after scene load failure: %s' ):format(
--                 tostring( message )
--             ) )
        end

        return
    end

    self:LogStreaming( 'teleport_begin', loadState )
    self:CloseSelector( true, nil, true )
    self.selectorPreviewFreezeRevision = self.selectorPreviewFreezeRevision + 1
    self.teleportFadeOwned = true
    self.teleportFrozenPed = self.selectorPreviewFrozenPed
    self.selectorPreviewFrozenPed = nil

    CreateThread( function()
        if self.teleportRevision ~= revision then
            return
        end

        if not self.active or not self.teleportFadeOwned then
            if self.areaLoad == loadState then
                self:StopAreaLoad()
            end

            self:RestoreSafeZonePreviewEnvironment( false )
            self:RestoreScreenFade()
            return
        end

        DoScreenFadeOut( DOMINATION_TELEPORT_FADE_MS )

        while self.teleportRevision == revision
            and self.active
            and self.teleportFadeOwned
            and not IsScreenFadedOut()
        do
            Wait( 0 )
        end

        if self.teleportRevision ~= revision then
            return
        end

        if not self.active or not self.teleportFadeOwned then
            if self.areaLoad == loadState then
                self:StopAreaLoad()
            end

            self:RestoreScreenFade()
            return
        end

        local ped = PlayerPedId()

        FreezeEntityPosition( ped, true )
        self.teleportFrozenPed = ped

        while self.teleportRevision == revision
            and self.active
            and self.teleportFadeOwned
            and self.areaLoad == loadState
            and not loadState.ready
        do
            Wait( 0 )
        end

        if self.teleportRevision ~= revision then
            return
        end

        if not self.active
            or not self.teleportFadeOwned
            or self.areaLoad ~= loadState
            or not loadState.ready
        then
            if self.areaLoad == loadState then
                self:StopAreaLoad()
            end

            self:RestoreScreenFade()
            return
        end

        if spawn.respawn then
            self:ReviveLocalPlayer( false )

            if self.teleportRevision ~= revision or not self.active then
                return
            end

            ped = PlayerPedId()
            self.teleportFrozenPed = ped
            FreezeEntityPosition( ped, true )
        end

        SetEntityCoordsNoOffset( ped, spawn.x, spawn.y, spawn.z, false, false, false )
        SetEntityHeading( ped, tonumber( spawn.heading ) or 0.0 )
        self:RestoreSelectorPreviewPed( false )
        self:LogStreaming( 'teleport_positioned', loadState )
        self:SetCayoPericoPreview( nil )
        self.selectorCayoPreviewOwned = false
        Wait( 0 )

        if self.teleportRevision ~= revision then
            return
        end

        self:StopAreaLoad()
        self:ReleaseSelectorPreviewFreeze( false )

        if not self.active or not self.teleportFadeOwned then
            self:RestoreScreenFade()
            return
        end

        self.gameplayActive = true
        self.zoneTracker:updateNow()
        self.capturePointTracker:updateNow()
        self.zoneTracker:start()
        self.capturePointTracker:start()
        self:RefreshPresenceHeartbeat()
        self:RefreshSafeProtectionState()
        self.boundaryRenderer:show()
        self.capturePointRenderer:show()
        for _, rankingBoardRenderer in ipairs( self.rankingBoardRenderers ) do
            rankingBoardRenderer:show()
        end
        self:StartSafeHealingLoop()
        self:StartSafeProtectionLoop()
        self:StartReviveLoop()
        self:StartTeamOutlineLoop()
        self:ShowHud()
        DoScreenFadeIn( DOMINATION_TELEPORT_FADE_MS )

        if gDominationMinigameClient then
            gDominationMinigameClient:transitionToState(
                MinigameClient.GameState.MATCH_GAMEPLAY,
                'domination safe selected'
            )
        end

        self:RefreshSafeZoneActionAvailability()

        Wait( DOMINATION_SAFE_ZONE_TELEPORT_FREEZE_MS )

        while self.teleportRevision == revision
            and self.teleportFadeOwned
            and self.teleportFrozenPed == ped
            and DoesEntityExist( ped )
            and not HasCollisionLoadedAroundEntity( ped )
        do
            Wait( 0 )
        end

        if self.teleportRevision == revision
            and self.teleportFadeOwned
            and self.teleportFrozenPed == ped
        then
            self.teleportFrozenPed = nil

            if DoesEntityExist( ped ) then
                FreezeEntityPosition( ped, false )
            end

            self.teleportFadeOwned = false
            self:LogStreaming( 'teleport_released', loadState )
        end
    end )
end

---@private
function DominationClient:RefreshZoneMap()
    self.zoneMapRefreshPending = true

    if self.zoneMapRefreshRunning then
        return
    end

    self.zoneMapRefreshRunning = true
    local renderer = self.renderer
    local revision = self.lifecycleRevision

    -- O carregamento inicial pode aguardar a DUI. Agrupa atualizacoes intermediarias.
    while self.zoneMapRefreshPending and self.active and self.lifecycleRevision == revision do
        self.zoneMapRefreshPending = false
        renderer:setZones( self.snapshot.zones )
    end

    self.zoneMapRefreshRunning = false
end

---@param data table
function DominationClient:UpdateActiveZones( data )
    if type( data ) ~= 'table' or type( data.zones ) ~= 'table' then
        return
    end

    if self.snapshot and ( self.snapshot.zoneRevision or 0 ) > ( data.zoneRevision or 0 ) then
        return
    end

    self.snapshot = data

    if not self.active then
        return
    end

    self:IndexZones()
    self.capturePointRenderer:setZones( data.zones )
    self.capturePointTracker:setZones( BuildCapturePointZones( data.zones ), true )
    self.zoneTracker:setZones( data.zones, true )

    for zoneId in pairs( self.authoritativeInsideById ) do
        if not self.zoneById[ zoneId ] then
            self.authoritativeInsideById[ zoneId ] = nil
        end
    end

    self:RefreshCaptureHud()
    self.boundaryRenderer:setZones( data.zones )
    self:RefreshZoneMap()
end

---@param zoneId string|number
---@param updates table
function DominationClient:UpdateZone( zoneId, updates )
    if type( updates ) ~= 'table' then
        return
    end

    local zoneKey = tostring( zoneId )
    local zone = self.zoneById[ zoneKey ]

    if not zone and self.snapshot and type( self.snapshot.zones ) == 'table' then
        for _, snapshotZone in ipairs( self.snapshot.zones ) do
            if tostring( snapshotZone.id ) == zoneKey then
                zone = snapshotZone
                break
            end
        end
    end

    local previousState = zone and zone.state

    if zone then
        for key, value in pairs( updates ) do
            zone[ key ] = value
        end

        if updates.remainingMs ~= nil or updates.state ~= nil then
            zone.captureRemainingSyncedAt = GetGameTimer()
        end
    end

    if not self.active then
        return
    end

    self.renderer:updateZone( zoneId, updates )
    self.boundaryRenderer:updateZone( zoneId, updates )
    self.capturePointRenderer:updateZone( zoneId, updates )

    if zone
        and updates.state == 'controlled'
        and previousState ~= 'controlled'
        and self.localInsideById[ zoneKey ]
    then
        self:ShowCaptureCompletion( zoneKey )
    elseif updates.state
        and updates.state ~= 'controlled'
        and self.captureHudCompletionZoneId == zoneKey
    then
        self.captureHudCompletionZoneId = nil
        self.captureHudCompletionRevision = self.captureHudCompletionRevision + 1
    end

    self:RefreshCaptureHud()
end

function DominationClient:Destroy()
    self.lifecycleRevision = self.lifecycleRevision + 1
    self:SetStoreAvailable( false )
    self:ReleaseHeadquartersReturnFreeze()
    self:ClearExitConfirmation()
    TriggerEvent( 'pvp.hud:closeExitMatch' )
    self:HideHud()
    self.respawnToken = nil
    self:SetRespawnChoiceVisible( false )
    self:ClearReviveState( true )
    self:ClearTeamPlayers()
    self.active = false
    self.gameplayActive = false
    self.zoneDebugEnabled = false
    self.zoneDebugRevision = self.zoneDebugRevision + 1
    self.safeHealingRevision = self.safeHealingRevision + 1
    self.safeProtectionRevision = self.safeProtectionRevision + 1
    self.vehicleCollisionEntities = {}
    self:ClearSafeExitProtection()
    self.presenceHeartbeatRevision = self.presenceHeartbeatRevision + 1
    self:SetSafeProtectionActive( false )
    self:StopAreaLoad()
    self:CloseSelector( false, false, true )
    self:RestoreScreenFade()
    self.zoneTracker:destroy()
    self.capturePointTracker:destroy()
    self:DestroyRenderers()
    self:SetWorldBlipsHidden( false )
    self:SetMinimapForced( false )
    self.hudPlayerCount = 0
    self.snapshot = nil
    self.zoneById = {}
    self.safeZoneById = {}
    self.localInsideById = {}
    self.localInsideCapturePointById = {}
    self.authoritativeInsideById = {}
end

local gDominationClient = DominationClient()

local function EnterFromFarmBuffAnnouncement()

    TriggerServerEvent( 'pvp.domination:enterFromFarmBuff' )
end

RegisterNetEvent( 'pvp.domination:farmBuffAnnounce', function( payload )

    PvpEventAnnounce.Show( 'domination', payload, EnterFromFarmBuffAnnouncement )
end )

RegisterCommand( 'dominas.buff.enter', function()

    PvpEventAnnounce.Accept( 'domination' )
end, false )

RegisterKeyMapping(
    'dominas.buff.enter',
    PvpTranslations.get( 'domination_farm_buff_keymap' ),
    'keyboard',
    DOMINATION_FARM_BUFF.announce.key
)

RegisterNetEvent( 'pvp.domination:vehicleRemovalWarning', function( networkId, durationMs, reason )
    if not gDominationClient.active or not gDominationClient.gameplayActive then
        return
    end

    if durationMs <= 0 then
        local warning = gDominationClient.vehicleRemovalWarning
        if warning and warning.networkId == networkId then
            gDominationClient.vehicleRemovalWarning = nil
            if gDominationClient.revivePointRenderer then
                gDominationClient.revivePointRenderer:hide()
            end
        end
        return
    end

    gDominationClient:CancelReviveAttempt( true )
    gDominationClient:CancelLootAttempt()
    gDominationClient:SetReviveCandidate( nil, nil )
    gDominationClient.vehicleRemovalWarning = {
        networkId = networkId, durationMs = durationMs,
        reason = reason == 'abandoned' and 'abandoned' or 'territory',
        finishAt = GetGameTimer() + durationMs,
    }
end )

---@param visible boolean
function DominationClient:SetRespawnChoiceVisible( visible )
    if self.respawnChoiceOpen == visible then
        return
    end

    self.respawnChoiceOpen = visible
    SendNUIMessage( {
        action = 'PVP_DOMINATION_RESPAWN',
        type = 'PVP_DOMINATION_RESPAWN',
        data = { show = visible },
    } )
    SetNuiFocus( visible, visible )
    SetNuiFocusKeepInput( false )
end

---A pose abatida do framework solta o foco da NUI um frame depois da morte. Sem o
---tempo de morte o `respawnReady` chega nesse mesmo frame; abrir antes da pose
---deixaria a escolha na tela sem cursor.
---@param token integer
function DominationClient:OpenRespawnChoiceAfterDownedPose( token )
    CreateThread( function()
        local deadline = GetGameTimer() + DOMINATION_RESPAWN_CHOICE_POSE_TIMEOUT_MS

        while self.active and self.respawnToken == token and self:IsLocalPlayerDowned()
            and gDominationMinigameClient and not gDominationMinigameClient:isDownedPresentationReady()
            and GetGameTimer() < deadline
        do
            Wait( 0 )
        end

        if self.active and self.respawnToken == token and self:IsLocalPlayerDowned() then
            self:SetRespawnChoiceVisible( true )
        end
    end )
end

RegisterNetEvent( 'pvp.domination:respawnReady', function( token )
    if not gDominationClient.active or not gDominationClient:IsLocalPlayerDowned() then
        return
    end

    gDominationClient.respawnToken = token
    gDominationClient:HideDeathHud()
    gDominationClient:OpenRespawnChoiceAfterDownedPose( token )
end )

RegisterNUICallback( 'pvp:dominationRespawnSelect', function( data, cb )
    if not gDominationClient.active or not gDominationClient.respawnChoiceOpen
        or not gDominationClient.respawnToken or type( data ) ~= 'table'
    then
        cb( { success = false } )
        return
    end

    local success, message

    if data.destination == 'safezone' then
        success = gDominationClient:OpenSpawnSelector()
    elseif data.destination == 'headquarters' then
        success, message = RPC.GameModeDominationReturnToHeadquarters( gDominationClient.respawnToken )
    end

    cb( { success = success == true, message = message } )
end )

RegisterNetEvent( 'pvp.domination:snapshot', function( data )
    gDominationClient:UpdateActiveZones( data )
end )

RegisterNetEvent( 'pvp.domination:zonesChanged', function( data )
    gDominationClient:UpdateActiveZones( data )
end )

-- Aviso proprio do modo (troca/abertura/fechamento de zona), ja traduzido pelo servidor.
-- O servidor so manda para quem esta no modo; sem checar `active` porque o aviso de
-- fechamento pendente chega junto com o snapshot, antes da entrada terminar.
RegisterNetEvent( 'pvp.domination:notify', function( payload )
    if type( payload ) ~= 'table' then
        return
    end

    SendNUIMessage( {
        action = 'PVP_DOMINATION_NOTIFY',
        type = 'PVP_DOMINATION_NOTIFY',
        data = payload,
    } )
end )

RegisterNetEvent( 'pvp.domination:enterAtSafeZone', function( spawn )
    gDominationClient:EnterAtSafeZone( spawn )
end )

RegisterNetEvent( 'pvp.domination:updateZone', function( zoneId, updates )
    gDominationClient:UpdateZone( zoneId, updates )
end )

RegisterNetEvent( 'pvp.domination:zonePresenceChanged', function( data )
    gDominationClient:OnAuthoritativeZonePresenceChanged( data )
end )

RegisterNetEvent( 'pvp.domination:setRevivablePlayers', function( sources )
    gDominationClient:SetRevivablePlayers( sources )
end )

RegisterNetEvent( 'pvp.domination:deathTimerStarted', function( data )
    if not gDominationClient.active or not gDominationClient.gameplayActive then
        return
    end

    gDominationClient:ShowDeathHud( data and data.durationSeconds )
end )

RegisterNetEvent( 'pvp.domination:setTeamPlayers', function( sources )
    gDominationClient:SetTeamPlayers( sources )
end )

RegisterNetEvent( 'pvp.domination:reviveEligibilityChanged', function( targetSource, eligible )
    gDominationClient:SetReviveEligibility( targetSource, eligible == true )
end )

RegisterNetEvent( 'pvp.domination:reviveStarted', function( data )
    gDominationClient:OnReviveStarted( data )
end )

RegisterNetEvent( 'pvp.domination:reviveCancelled', function( data )
    gDominationClient:OnReviveCancelled( data )
end )

RegisterNetEvent( 'pvp.domination:reviveFinished', function( data )
    gDominationClient:OnReviveFinished( data )
end )

RegisterNetEvent( 'pvp.domination:revived', function()
    gDominationClient:ReviveLocalPlayer()
end )

RegisterNUICallback( 'pvp:dominationSafeZonePreview', function( data, cb )
    local zoneId = type( data ) == 'table' and data.zoneId or nil

    cb( {
        success = gDominationClient:PreviewSafeZone( zoneId ),
    } )
end )

RegisterNUICallback( 'pvp:dominationSafeZoneSelect', function( data, cb )
    local zoneId = type( data ) == 'table' and data.zoneId or nil

    if not gDominationClient.selectorOpen
        or type( zoneId ) ~= 'string'
        or not gDominationClient.safeZoneById[ zoneId ]
    then
        cb( {
            success = false,
            message = PvpTranslations.get( 'domination_selector_invalid_zone' ),
        } )
        return
    end

    local success, message = RPC.GameModeSelectDominationSafeZone( zoneId, gDominationClient.respawnToken )

    cb( {
        success = success == true,
        message = message,
    } )
end )

RegisterNUICallback( 'pvp:dominationSafeZoneClose', function( _, cb )
    if not gDominationClient.selectorOpen then
        cb( { success = false } )
        return
    end

    if gDominationClient.selectorOpen
        and not gDominationClient.selectorLeavesMatchOnClose
    then
        gDominationClient:CloseSelector()
        if gDominationClient.respawnToken then
            gDominationClient:SetRespawnChoiceVisible( true )
        end
        cb( { success = true } )
        return
    end

    local success, message = RPC.pvp_leaveRoom(
        eGamemodeTypes.DOMINATION,
        eGamemodeCategories.Pvp
    )

    if success then
        gDominationClient:Close()
    end

    cb( {
        success = success == true,
        message = message,
    } )
end )

RegisterNUICallback( 'pvp:dominationStoreClose', function( _, cb )
    gDominationClient:CloseStore()
    cb( { success = true } )
end )

RegisterNUICallback( 'pvp:dominationStoreBuy', function( data, cb )
    if not gDominationClient.storeOpen
        or not gDominationClient.storeAvailable
        or not gDominationClient:IsLocalPlayerAliveForRevive()
        or not gDominationClient:IsLocallyInsideSafeZone()
    then
        cb( {
            success = false,
            message = PvpTranslations.get( 'domination_store_not_available' ),
        } )
        return
    end

    local succeeded, result = pcall( function()
        return gNewHubServer.BuyStore( data )
    end )

    if not succeeded or type( result ) ~= 'table' then
        result = {
            success = false,
            message = PvpTranslations.get( 'domination_store_unavailable' ),
        }
    end

    cb( result )
end )

RegisterNUICallback( 'pvp:dominationVehiclesClose', function( _, cb )
    gDominationClient:CloseVehicles()
    cb( { success = true } )
end )

RegisterNUICallback( 'pvp:dominationVehicleFavorite', function( data, cb )
    local model = type( data ) == 'table' and data.model or nil

    if not gDominationClient.vehiclesOpen
        or not gDominationClient.vehiclesAvailable
        or not gDominationClient:IsLocalPlayerAliveForRevive()
        or type( model ) ~= 'string'
    then
        cb( {
            success = false,
            message = PvpTranslations.get( 'domination_vehicles_not_available' ),
        } )
        return
    end

    local succeeded, favorite = pcall( function()
        return gGaragesServer.SetFavorite( model )
    end )

    if not succeeded then
        cb( {
            success = false,
            message = PvpTranslations.get( 'domination_vehicles_unavailable' ),
        } )
        return
    end

    for _, vehicle in ipairs( gDominationClient.vehicles ) do
        if vehicle.model == model then
            vehicle.favorite = favorite == true
            break
        end
    end

    gDominationClient:SendVehiclesMessage( {
        available = true,
        show = true,
        vehicles = gDominationClient.vehicles,
    } )

    cb( {
        success = true,
        favorite = favorite == true,
    } )
end )

RegisterNUICallback( 'pvp:dominationVehicleAction', function( data, cb )
    local model = type( data ) == 'table' and data.model or nil

    if not gDominationClient.vehiclesOpen
        or not gDominationClient.vehiclesAvailable
        or not gDominationClient:IsLocalPlayerAliveForRevive()
        or type( model ) ~= 'string'
    then
        cb( {
            success = false,
            message = PvpTranslations.get( 'domination_vehicles_not_available' ),
        } )
        return
    end

    local succeeded, result = pcall( function()
        return RPC.GameModeToggleDominationVehicle( model )
    end )

    if not succeeded or type( result ) ~= 'table' then
        result = {
            success = false,
            message = PvpTranslations.get( 'domination_vehicles_unavailable' ),
        }
    end

    if result.success == true then
        for _, vehicle in ipairs( gDominationClient.vehicles ) do
            vehicle.spawned = type( result.activeModel ) == 'string'
                and vehicle.model == result.activeModel
        end

        gDominationClient:CloseVehicles()
    elseif result.message then
        TriggerEvent(
            'Notify',
            'vermelho',
            result.message,
            5000,
            PvpTranslations.get( 'domination_vehicles_title' )
        )
    end

    cb( result )
end )

gDominationMinigameClient = MinigameClient( {
    name = PVP_DOMINATION_MINIGAME_NAME,

    match = {
        enableKillfeed = true,
        downedState = {
            collision = false,
        },

        confirmLeave = function( callback )
            gDominationClient:ConfirmLeave( callback )
        end,

        onStart = function( data )
            gDominationClient:UpdateHudPlayerCount( data and data.players )
            gDominationClient:Open( gDominationClient.snapshot )
            RPC.DominasInvitationReady()
        end,

        onLateJoin = function( data )
            gDominationClient:UpdateHudPlayerCount( data and data.players )
            gDominationClient:Open( gDominationClient.snapshot )
            RPC.DominasInvitationReady()
        end,

        onAdd = function( data )
            gDominationClient:UpdateHudPlayerCount( data and data.players )
        end,

        onRemove = function( data )
            gDominationClient:UpdateHudPlayerCount( data and data.remainingPlayers )
        end,

        onPlayerDeath = function()
            gDominationClient:OnPlayerDeath()
        end,

        onPlayersStateUpdated = function()
            if gDominationClient.gameplayActive then
                gDominationClient:RefreshSafeZoneActionAvailability()
            end
        end,

        onEnd = function( data )
            if gDominationClient.respawnToken then
                gDominationClient:ReviveLocalPlayer( false )
            end

            gDominationClient:Close()
            gDominationClient:ReturnToPvpNpc( data )
        end,

        onLeave = function( data )
            if gDominationClient.respawnToken or ( data and data.reason == 'death_timeout' ) then
                gDominationClient:ReviveLocalPlayer( false )
            end

            gDominationClient:Close()
            gDominationClient:ReturnToPvpNpc( data )
        end,
    },
} )

RegisterCommand( 'testdominationsafeselector', function()
    RPC.GameModeEnterRoom( eGamemodeTypes.DOMINATION, eGamemodeCategories.Pvp )
end, false )

RegisterCommand( 'testdominationzonebounds', function()
    gDominationClient:ToggleZoneDebug()
end, false )

---@param args string[]
local function TestDominationRender( args )

    local mode = args[ 1 ] or 'status'
    local diagnostics = DminigamesRenderDiagnostics

    if mode == 'watch' then
        diagnostics.SetWatching( true )
        gDominationClient:AttachRenderDiagnostics()
        diagnostics.Snapshot( 'watch' )
    elseif mode == 'off' then
        diagnostics.SetWatching( false )
    elseif mode == 'previous' then
        diagnostics.PrintPreviousStop()
    elseif not diagnostics.IsWatching() then
        sx.logger:warn( 'Ative testdominationrender watch antes de entrar na Dominacao.' )
    elseif mode == 'status' then
        diagnostics.Snapshot( 'status' )
    elseif mode == 'clear-overlay' and gDominationClient.gameplayActive then
        if gDominationClient.zoneMapRefreshRunning then
            sx.logger:warn( '[DominationRender] Aguarde a atualizacao do mapa terminar e repita clear-overlay.' )
            return
        end

        diagnostics.ClearMinimapOverlays()
    elseif mode == 'blank-minimap' and gDominationClient.gameplayActive then
        if gDominationClient.zoneMapRefreshRunning then
            sx.logger:warn( '[DominationRender] Aguarde a atualizacao do mapa terminar e repita blank-minimap.' )
            return
        end

        diagnostics.BlankMinimap()
    elseif mode == 'release' and gDominationClient.gameplayActive then
        local group = args[ 2 ] or 'all'

        if ( group == 'all' or group == 'minimap' ) and gDominationClient.zoneMapRefreshRunning then
            sx.logger:warn( '[DominationRender] Aguarde a atualizacao do mapa terminar e repita release.' )
            return
        end

        diagnostics.ReleaseDuis( group )
    elseif (args[ 2 ] == 'off' or args[ 2 ] == 'on') and gDominationClient.gameplayActive then
        if not diagnostics.SetPaused( mode, args[ 2 ] == 'off' ) then
            sx.logger:warn( 'Renderer invalido. Use loot|minimap|rankings|boundary|interactions|all.' )
            return
        end

        diagnostics.Snapshot( 'visibility-changed' )
    else
        sx.logger:warn( 'Uso: testdominationrender watch|off|status|previous|clear-overlay|blank-minimap, release [minimap|rankings|all] ou <loot|minimap|rankings|boundary|interactions|all> on|off durante o gameplay. Clear-overlay e release exigem all off; blank-minimap exige tambem clear-overlay.' )
    end
end

RegisterCommand( 'testdominationrender', function( _, args )

    TestDominationRender( args )
end, false )

RegisterCommand( 'testdominationlootdui', function( _, args )

    local probe = gDominationClient.lootDuiProbe

    if not probe then
        sx.logger:warn( 'Entre na Dominacao antes de testar a DUI.' )
        return
    end

    probe:SetTestMode( args[ 1 ] or 'status' )
end, false )

RegisterCommand( 'testdominationboundary', function( _, args )
    local renderer = gDominationClient.boundaryRenderer

    if not gDominationClient.gameplayActive or not renderer then
        sx.logger:warn( 'Entre na Dominacao antes de testar a boundary.' )
        return
    end

    local mode = args[ 1 ] or 'normal'

    if not renderer:setCylinderDebugMode( mode ) then
        sx.logger:warn( 'Uso: testdominationboundary normal|uv|solid|native|poly|compare' )
        return
    end

    local dictionary = renderer.textureDictionary
    local textureName = mode == 'poly' and renderer.textureName
        or renderer.cylinderTextureName or renderer.textureName

    if mode == 'uv' or mode == 'solid' then
        dictionary, textureName = renderer.cylinderDebugDictionary, mode
    elseif mode == 'native' then
        dictionary, textureName = nil, nil
    end

    local resolution = dictionary and textureName and GetTextureResolution( dictionary, textureName )
    sx.logger:info( ( '[DominationBoundary] mode=%s txd=%s texture=%s resolution=%sx%s ready=%s cylinderLoaded=%s height=%s' )
        :format( mode, tostring( dictionary ), tostring( textureName ),
            resolution and resolution.x or 0, resolution and resolution.y or 0,
            tostring( renderer.textureReady ), tostring( renderer.cylinderTextureName ~= nil ),
            tostring( renderer.cylinderWallHeight ) ) )
end, false )

RegisterCommand( '+dminigames_domination_store', function()
    gDominationClient:ToggleStore()
end, false )

RegisterCommand( '-dminigames_domination_store', function() end, false )

RegisterKeyMapping(
    '+dminigames_domination_store',
    PvpTranslations.get( 'domination_store_key_mapping' ),
    'keyboard',
    'F2'
)

RegisterCommand( '+dminigames_domination_spawns', function()
    gDominationClient:ToggleSpawnSelector()
end, false )

RegisterCommand( '-dminigames_domination_spawns', function() end, false )

RegisterKeyMapping(
    '+dminigames_domination_spawns',
    PvpTranslations.get( 'domination_spawns_key_mapping' ),
    'keyboard',
    'F1'
)

RegisterCommand( '+dminigames_domination_vehicles', function()
    gDominationClient:ToggleVehicles()
end, false )

RegisterCommand( '-dminigames_domination_vehicles', function() end, false )

RegisterKeyMapping(
    '+dminigames_domination_vehicles',
    PvpTranslations.get( 'domination_vehicles_key_mapping' ),
    'keyboard',
    'F3'
)

RegisterCommand( '+dminigames_domination_personal_chest', function()
    gDominationClient:OpenPersonalChest()
end, false )

RegisterCommand( '-dminigames_domination_personal_chest', function() end, false )

RegisterKeyMapping(
    '+dminigames_domination_personal_chest',
    PvpTranslations.get( 'domination_personal_chest_key_mapping' ),
    'keyboard',
    'F4'
)

AddEventHandler( 'onResourceStop', function( resourceName )
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    DminigamesRenderDiagnostics.Snapshot( 'stop-begin', true )
    gDominationClient:Destroy()
    DminigamesRenderDiagnostics.Snapshot( 'stop-end', true )
end )

AddEventHandler( 'onClientResourceStart', function( resourceName )
    if resourceName == 'hud' and gDominationClient.active then
        gDominationClient:SetWorldBlipsHidden( true )
        gDominationClient:SetMinimapForced( true )
        gDominationClient:SendHudEvent(
            'setDominationStoreHintVisible',
            {
                visible = gDominationClient.storeAvailable,
                vehiclesVisible = gDominationClient.vehiclesAvailable,
            }
        )

        if gDominationClient.selectorOpen then
            gDominationClient:SetBigmapForced( true )
        elseif gDominationClient:IsLocalPlayerDowned() and not gDominationClient.respawnToken then
            gDominationClient:ShowDeathHud( gDominationClient.deathDurationSeconds )
        elseif not gDominationClient.respawnToken then
            gDominationClient:ShowHud()
        end
    end
end )
