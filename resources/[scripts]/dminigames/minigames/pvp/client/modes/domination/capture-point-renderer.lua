local gRenderNatives = DminigamesRenderDiagnostics.Natives( 'interactions' )

---@class DominationCapturePointRendererOptions
---@field texturePage? string
---@field textureDictionaryPrefix? string
---@field textureName? string
---@field textureSize? integer
---@field drawDistance? number
---@field alpha? integer
---@field cullIntervalMs? integer
---@field spriteWidth? number
---@field reviveSpriteWidth? number
---@field heightOffset? number
---@field reviveHeightOffset? number
---@field markerAlpha? integer
---@field markerHeight? number
---@field shouldRender? fun(zone: table): boolean

---@class DominationCapturePointRenderZone
---@field id string
---@field state string
---@field color number[]
---@field x number
---@field y number
---@field z number
---@field groundZ number
---@field radius number

---@class DominationCapturePointRenderer
---@field zones DominationCapturePointRenderZone[]
---@field zoneById table<string, DominationCapturePointRenderZone>
---@field visibleZone? DominationCapturePointRenderZone
---@field visible boolean
---@field revision integer
---@field textureDui number?
---@field textureDictionary string?
---@field textureName string
---@field textureSize integer
---@field runtimeTxd number?
---@field textureReady boolean
---@field textureCreating boolean
---@field textureRevision integer
---@field textureVisible boolean?
---@field textureMode string?
---@field textureState string?
---@field textureReviveSignature string?
---@field reviveTarget table?
---@field reviveStatus string
---@field reviveDurationMs integer
---@field reviveProgress number
---@field shouldRender? fun(zone: table): boolean
DominationCapturePointRenderer = class()

local CAPTURE_POINT_TEXTURE_SIZE = 1024
local CAPTURE_POINT_DRAW_DISTANCE = 420.0
local CAPTURE_POINT_ALPHA = 235
local CAPTURE_POINT_CULL_INTERVAL_MS = 150
local CAPTURE_POINT_TEXTURE_TIMEOUT_MS = 5000
local CAPTURE_POINT_TEXTURE_SETTLE_MS = 150
local CAPTURE_POINT_MIN_TEXTURE_RESOLUTION = 32
local CAPTURE_POINT_SPRITE_WIDTH = 0.09
local REVIVE_POINT_SPRITE_WIDTH = 0.12
local VEHICLE_REMOVAL_SPRITE_HEIGHT = 0.225
local CAPTURE_POINT_HEIGHT_OFFSET = 1.35
local REVIVE_POINT_HEIGHT_OFFSET = 0.08
local REVIVE_POINT_ANCHOR_BONE = 0x2E28
local CAPTURE_POINT_MARKER_ALPHA = 80
local CAPTURE_POINT_MARKER_HEIGHT = 0.12
local CAPTURE_POINT_MARKER_Z_OFFSET = 0.04

local gDominationCapturePointTextureGeneration = 0

local CAPTURE_POINT_VALID_STATE = {
    neutral = true,
    capturing = true,
    contested = true,
    controlled = true,
    -- Zona travada apos a captura: o ponto mostra o cadeado no lugar da bandeira.
    cooldown = true,
}

local REVIVE_VALID_STATUS = {
    idle = true,
    holding = true,
    complete = true,
}

local BODY_INTERACTION_VALID_MODE = {
    revive = true,
    loot = true,
    vehicle = true,
}

---@param value number?
---@return integer color
local function ClampColor( value )
    return math.min( 255, math.max( 0, math.floor( tonumber( value ) or 0 ) ) )
end

---@param condition fun(): boolean
---@param timeoutMs integer
---@return boolean success
local function WaitForCondition( condition, timeoutMs )
    local timeoutAt = GetGameTimer() + timeoutMs

    while not condition() do
        if GetGameTimer() >= timeoutAt then
            return false
        end

        Wait( 0 )
    end

    return true
end

---@param point table|vector3|vector4
---@return number? x
---@return number? y
---@return number? z
local function ReadPoint( point )
    local pointType = type( point )

    if pointType == 'vector3' or pointType == 'vector4' then
        return point.x, point.y, point.z
    end

    if pointType ~= 'table' then
        return nil, nil, nil
    end

    return tonumber( point.x or point[ 1 ] ),
        tonumber( point.y or point[ 2 ] ),
        tonumber( point.z or point[ 3 ] )
end

---@param color any
---@return number[] normalizedColor
local function NormalizeColor( color )
    if type( color ) ~= 'table' then
        return { 255, 255, 255 }
    end

    return {
        ClampColor( color[ 1 ] or color.r ),
        ClampColor( color[ 2 ] or color.g ),
        ClampColor( color[ 3 ] or color.b ),
    }
end

---@param options DominationCapturePointRendererOptions?
function DominationCapturePointRenderer:__init( options )
    options = options or {}

    self.zones = {}
    self.zoneById = {}
    self.visibleZone = nil
    self.visible = false
    self.revision = 0
    self.texturePage = tostring(
        options.texturePage or 'web/domination-capture-point.html'
    )
    self.textureDictionaryPrefix = tostring(
        options.textureDictionaryPrefix or 'domination_capture_point'
    )
    self.textureName = tostring( options.textureName or 'capture_point' )
    self.textureSize = math.max(
        256,
        math.floor( tonumber( options.textureSize ) or CAPTURE_POINT_TEXTURE_SIZE )
    )
    self.drawDistance = math.max(
        10.0,
        tonumber( options.drawDistance ) or CAPTURE_POINT_DRAW_DISTANCE
    )
    self.drawDistanceSquared = self.drawDistance * self.drawDistance
    self.alpha = ClampColor( options.alpha or CAPTURE_POINT_ALPHA )
    self.cullIntervalMs = math.max(
        50,
        math.floor( tonumber( options.cullIntervalMs ) or CAPTURE_POINT_CULL_INTERVAL_MS )
    )
    self.spriteWidth = math.max(
        0.005,
        tonumber( options.spriteWidth ) or CAPTURE_POINT_SPRITE_WIDTH
    )
    self.reviveSpriteWidth = math.max(
        0.005,
        tonumber( options.reviveSpriteWidth ) or REVIVE_POINT_SPRITE_WIDTH
    )
    self.heightOffset = tonumber( options.heightOffset ) or CAPTURE_POINT_HEIGHT_OFFSET
    self.reviveHeightOffset = tonumber( options.reviveHeightOffset )
        or REVIVE_POINT_HEIGHT_OFFSET
    self.markerAlpha = ClampColor( options.markerAlpha or CAPTURE_POINT_MARKER_ALPHA )
    self.markerHeight = math.max(
        0.02,
        tonumber( options.markerHeight ) or CAPTURE_POINT_MARKER_HEIGHT
    )
    self.shouldRender = options.shouldRender
    self.textureDui = nil
    self.textureDictionary = nil
    self.runtimeTxd = nil
    self.textureReady = false
    self.textureCreating = false
    self.textureRevision = 0
    self.textureVisible = nil
    self.textureMode = nil
    self.textureState = nil
    self.textureReviveSignature = nil
    self.reviveTarget = nil
    self.reviveStatus = 'idle'
    self.reviveDurationMs = 3200
    self.reviveProgress = 0.0
end

---@private
---@param visible boolean
---@param force? boolean
function DominationCapturePointRenderer:_setTextureVisible( visible, force )
    visible = visible == true

    if not self.textureDui or ( not force and self.textureVisible == visible ) then
        return
    end

    self.textureVisible = visible

    SendDuiMessage( self.textureDui, json.encode( {
        action = 'setVisible',
        visible = visible,
    } ) )
end

---@private
---@param state string
---@param force? boolean
function DominationCapturePointRenderer:_setTextureState( state, force )
    state = CAPTURE_POINT_VALID_STATE[ state ] and state or 'neutral'

    if not self.textureDui
        or ( not force and self.textureMode == 'capture' and self.textureState == state )
    then
        return
    end

    self.textureMode = 'capture'
    self.textureState = state
    self.textureReviveSignature = nil

    SendDuiMessage( self.textureDui, json.encode( {
        action = 'setState',
        state = state,
    } ) )
end

---@private
---@param force? boolean
function DominationCapturePointRenderer:_setTextureRevive( force )
    local interactionMode = self.reviveTarget and self.reviveTarget.mode or 'revive'
    -- O aviso conta na DUI; reenviar progresso periodicamente faria o relogio recuar.
    local signature = ( '%s:%s:%s:%d:%.3f' ):format(
        interactionMode,
        self.reviveTarget and self.reviveTarget.removalReason or '',
        self.reviveStatus,
        self.reviveDurationMs,
        interactionMode == 'vehicle' and 0.0 or self.reviveProgress
    )

    if not self.textureDui
        or ( not force
            and self.textureMode == interactionMode
            and self.textureReviveSignature == signature )
    then
        return
    end

    self.textureMode = interactionMode
    self.textureReviveSignature = signature

    SendDuiMessage( self.textureDui, json.encode( {
        action = 'setInteraction',
        mode = interactionMode,
        status = self.reviveStatus,
        durationMs = self.reviveDurationMs,
        progress = self.reviveProgress,
        localization = interactionMode == 'vehicle' and {
            title = PvpTranslations.get( 'domination_vehicle_removal_title' ),
            hint = PvpTranslations.get( self.reviveTarget.removalReason == 'abandoned'
                and 'domination_vehicle_abandoned_hint' or 'domination_vehicle_removal_hint' ),
        } or nil,
    } ) )
end

---@private
---@param force? boolean
function DominationCapturePointRenderer:_syncTexture( force )
    local visibleZone = self.visible and self.visibleZone or nil

    if visibleZone and BODY_INTERACTION_VALID_MODE[ visibleZone.mode ] then
        self:_setTextureRevive( force )
    else
        self:_setTextureState( visibleZone and visibleZone.state or 'neutral', force )
    end

    self:_setTextureVisible( visibleZone ~= nil, force )
end

---@private
function DominationCapturePointRenderer:_destroyTexture()
    self.textureRevision = self.textureRevision + 1
    self.textureCreating = false
    self.textureReady = false
    self.textureVisible = nil
    self.textureMode = nil
    self.textureState = nil
    self.textureReviveSignature = nil

    if self.textureDui then
        gRenderNatives.DestroyDui( self.textureDui )
    end

    if self.textureDictionary then
        SetStreamedTextureDictAsNoLongerNeeded( self.textureDictionary )
    end

    self.textureDui = nil
    self.textureDictionary = nil
    self.runtimeTxd = nil
end

---@private
function DominationCapturePointRenderer:_ensureTexture()
    if self.textureReady or self.textureCreating then
        return
    end

    self.textureCreating = true
    self.textureRevision = self.textureRevision + 1

    local revision = self.textureRevision

    CreateThread( function()
        gDominationCapturePointTextureGeneration =
            gDominationCapturePointTextureGeneration + 1

        local generation = gDominationCapturePointTextureGeneration
        local textureDictionary = ( '%s_%d' ):format(
            self.textureDictionaryPrefix,
            generation
        )
        local renderScale = self.textureSize <= 512 and 1 or 2
        local textureUrl = ( 'nui://%s/%s?gen=%d&renderScale=%d' ):format(
            GetCurrentResourceName(),
            self.texturePage,
            generation,
            renderScale
        )
        local dui = gRenderNatives.CreateDui(
            textureUrl,
            self.textureSize,
            self.textureSize
        )

        if not dui or dui == 0 then
            self.textureCreating = false
            sx.logger:error( 'DominationCapturePointRenderer: CreateDui falhou' )
            return
        end

        if self.textureRevision ~= revision then
            gRenderNatives.DestroyDui( dui )
            return
        end

        self.textureDui = dui
        self.textureDictionary = textureDictionary

        local duiAvailable = WaitForCondition( function()
            return self.textureRevision ~= revision or IsDuiAvailable( dui )
        end, CAPTURE_POINT_TEXTURE_TIMEOUT_MS )

        if self.textureRevision ~= revision then
            return
        end

        if not duiAvailable then
            sx.logger:error( 'DominationCapturePointRenderer: DUI nao ficou disponivel' )
            self:_destroyTexture()
            return
        end

        local runtimeTxd = gRenderNatives.CreateRuntimeTxd( textureDictionary )

        gRenderNatives.CreateRuntimeTextureFromDuiHandle(
            runtimeTxd,
            self.textureName,
            GetDuiHandle( dui )
        )
        RequestStreamedTextureDict( textureDictionary, false )
        self.runtimeTxd = runtimeTxd

        local textureLoaded = WaitForCondition( function()
            if self.textureRevision ~= revision then
                return true
            end

            local width, height = table.unpack( GetTextureResolution(
                textureDictionary,
                self.textureName
            ) )

            return HasStreamedTextureDictLoaded( textureDictionary )
                and width >= CAPTURE_POINT_MIN_TEXTURE_RESOLUTION
                and height >= CAPTURE_POINT_MIN_TEXTURE_RESOLUTION
        end, CAPTURE_POINT_TEXTURE_TIMEOUT_MS )

        if self.textureRevision ~= revision then
            return
        end

        if not textureLoaded then
            sx.logger:error( 'DominationCapturePointRenderer: runtime texture nao carregou' )
            self:_destroyTexture()
            return
        end

        Wait( CAPTURE_POINT_TEXTURE_SETTLE_MS )

        if self.textureRevision ~= revision then
            return
        end

        self.textureCreating = false
        self.textureReady = true
        self:_syncTexture( true )
    end )
end

---@param zones table[]
function DominationCapturePointRenderer:setZones( zones )
    assert( type( zones ) == 'table', 'DominationCapturePointRenderer precisa de zones' )

    self.zones = {}
    self.zoneById = {}
    self.visibleZone = nil

    for _, zone in ipairs( zones ) do
        local x, y, z = ReadPoint( zone.capturePoint )

        if zone.type == 'capture'
            and zone.id ~= nil
            and x
            and y
            and z
        then
            local normalizedZone = {
                id = tostring( zone.id ),
                state = CAPTURE_POINT_VALID_STATE[ zone.state ]
                    and zone.state
                    or 'neutral',
                color = NormalizeColor( zone.color ),
                x = x,
                y = y,
                z = z + self.heightOffset,
                groundZ = z,
                radius = math.max( 0.1, tonumber( zone.captureRadius ) or 0.1 ),
            }

            self.zones[ #self.zones + 1 ] = normalizedZone
            self.zoneById[ normalizedZone.id ] = normalizedZone
        end
    end

    self:updateNow()
end

---@param zoneId string|number
---@param updates table
function DominationCapturePointRenderer:updateZone( zoneId, updates )
    local zone = self.zoneById[ tostring( zoneId ) ]

    if not zone or type( updates ) ~= 'table' then
        return
    end

    if CAPTURE_POINT_VALID_STATE[ updates.state ] then
        zone.state = updates.state
    end

    if updates.color then
        zone.color = NormalizeColor( updates.color )
    end

    if self.visibleZone == zone then
        self:_setTextureState( zone.state )
    end
end

---@param target table?
function DominationCapturePointRenderer:setReviveTarget( target )
    if type( target ) ~= 'table' then
        self:clearReviveTarget()
        return
    end

    local entity = tonumber( target.entity )
    local source = tonumber( target.source )
    local mode = BODY_INTERACTION_VALID_MODE[ target.mode ] and target.mode or 'revive'

    if not entity or entity == 0 or not DoesEntityExist( entity ) or not source then
        self:clearReviveTarget()
        return
    end

    if self.reviveTarget
        and self.reviveTarget.source == source
        and self.reviveTarget.mode == mode
    then
        self.reviveTarget.entity = entity
        self.reviveTarget.color = NormalizeColor( target.color or self.reviveTarget.color )
        self.reviveTarget.removalReason = target.removalReason
        return
    end

    self.reviveTarget = {
        mode = mode,
        source = source,
        entity = entity,
        removalReason = target.removalReason,
        color = NormalizeColor( target.color or { 40, 220, 184 } ),
    }
    self.reviveStatus = 'idle'
    self.reviveDurationMs = 3200
    self.reviveProgress = 0.0
    self:updateNow()
end

function DominationCapturePointRenderer:clearReviveTarget()
    if not self.reviveTarget then
        return
    end

    self.reviveTarget = nil
    self.reviveStatus = 'idle'
    self.reviveProgress = 0.0
    self:updateNow()
end

---@param status string
---@param durationMs? integer
---@param progress? number
function DominationCapturePointRenderer:setReviveState( status, durationMs, progress )
    self.reviveStatus = REVIVE_VALID_STATUS[ status ] and status or 'idle'
    self.reviveDurationMs = math.max( 250, math.floor(
        tonumber( durationMs ) or self.reviveDurationMs
    ) )
    self.reviveProgress = math.min( 1.0, math.max( 0.0, tonumber( progress ) or 0.0 ) )

    if self.visibleZone and BODY_INTERACTION_VALID_MODE[ self.visibleZone.mode ] then
        self:_setTextureRevive()
    end
end

---@private
function DominationCapturePointRenderer:_refreshVisibleZone()
    self.visibleZone = nil

    if not self.visible then
        self:_syncTexture()
        return
    end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        self:_syncTexture()
        return
    end

    local position = GetEntityCoords( ped )
    local nearestDistanceSquared = self.drawDistanceSquared

    if self.reviveTarget then
        local targetEntity = self.reviveTarget.entity

        if targetEntity ~= 0 and DoesEntityExist( targetEntity ) then
            local targetPosition = GetEntityCoords( targetEntity )
            local deltaX = targetPosition.x - position.x
            local deltaY = targetPosition.y - position.y
            local distanceSquared = deltaX * deltaX + deltaY * deltaY

            local interactionDistanceSquared = self.reviveTarget.mode == 'vehicle'
                and 10000.0 or nearestDistanceSquared
            if distanceSquared <= interactionDistanceSquared then
                self.visibleZone = self.reviveTarget
                self:_ensureTexture()
                self:_syncTexture()
                return
            end
        end
    end

    for _, zone in ipairs( self.zones ) do
        local deltaX = zone.x - position.x
        local deltaY = zone.y - position.y
        local distanceSquared = deltaX * deltaX + deltaY * deltaY
        local allowed = not self.shouldRender or self.shouldRender( zone )

        if allowed and distanceSquared <= nearestDistanceSquared then
            nearestDistanceSquared = distanceSquared
            self.visibleZone = zone
        end
    end

    if self.visibleZone then
        self:_ensureTexture()
    end

    self:_syncTexture()
end

function DominationCapturePointRenderer:updateNow()
    self:_refreshVisibleZone()
end

---@private
---@param zone DominationCapturePointRenderZone
function DominationCapturePointRenderer:_drawZone( zone )
    local color = zone.color
    local drawX = zone.x
    local drawY = zone.y
    local drawZ = zone.z
    local spriteWidth = self.spriteWidth

    if BODY_INTERACTION_VALID_MODE[ zone.mode ] then
        if zone.entity == 0 or not DoesEntityExist( zone.entity ) then
            return
        end

        local targetPosition = zone.mode == 'vehicle' and GetEntityCoords( zone.entity ) or GetPedBoneCoords(
            zone.entity,
            REVIVE_POINT_ANCHOR_BONE,
            0.0,
            0.0,
            0.0
        )

        drawX = targetPosition.x
        drawY = targetPosition.y
        drawZ = zone.mode == 'vehicle' and targetPosition.z
            or targetPosition.z + self.reviveHeightOffset
        spriteWidth = self.reviveSpriteWidth
    else
        DrawMarker(
            1,
            zone.x,
            zone.y,
            zone.groundZ + CAPTURE_POINT_MARKER_Z_OFFSET,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            zone.radius * 2.0,
            zone.radius * 2.0,
            self.markerHeight,
            color[ 1 ],
            color[ 2 ],
            color[ 3 ],
            self.markerAlpha,
            false,
            false,
            2,
            false,
            nil,
            nil,
            false
        )
    end

    if not self.textureReady or not self.textureDictionary then
        return
    end

    local aspectRatio = GetAspectRatio( true )

    if zone.mode == 'vehicle' then
        if not GetScreenCoordFromWorldCoord( drawX, drawY, drawZ ) then
            return
        end

        -- Tamanho legivel independente da distancia/FOV da camera do veiculo.
        spriteWidth = VEHICLE_REMOVAL_SPRITE_HEIGHT / aspectRatio
    end

    SetDrawOrigin( drawX, drawY, drawZ, 0 )
    DrawSprite(
        self.textureDictionary,
        self.textureName,
        0.0,
        0.0,
        spriteWidth,
        spriteWidth * aspectRatio,
        0.0,
        color[ 1 ],
        color[ 2 ],
        color[ 3 ],
        self.alpha
    )
    ClearDrawOrigin()
end

function DominationCapturePointRenderer:show()
    if self.visible then
        return
    end

    self.visible = true
    self.revision = self.revision + 1
    self:_refreshVisibleZone()

    local revision = self.revision
    local diagnosticLoop = DminigamesRenderDiagnostics.LoopStarted( 'interactions', self )

    CreateThread( function()
        local nextCullAt = 0

        while self.visible and self.revision == revision do
            local now = GetGameTimer()

            if now >= nextCullAt then
                self:_refreshVisibleZone()
                nextCullAt = now + self.cullIntervalMs
            end

            if not self.visibleZone then
                Wait( self.cullIntervalMs )
            else
                self:_drawZone( self.visibleZone )
                Wait( 0 )
            end
        end
        DminigamesRenderDiagnostics.LoopFinished( diagnosticLoop )
    end )
end

function DominationCapturePointRenderer:hide()
    DminigamesRenderDiagnostics.LoopsStopping( self )
    if not self.visible then
        return
    end

    self.visible = false
    self.revision = self.revision + 1
    self.visibleZone = nil
    self.reviveTarget = nil
    self:_syncTexture()
end

function DominationCapturePointRenderer:destroy()
    self:hide()
    self:_destroyTexture()
    self.zones = {}
    self.zoneById = {}
    self.reviveTarget = nil
end
