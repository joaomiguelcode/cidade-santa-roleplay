local gRenderNatives = DminigamesRenderDiagnostics.Natives( 'boundary' )

---@class SpatialZoneBoundaryRendererOptions
---@field zones? table[]
---@field drawDistance? number
---@field wallBottomZ? number
---@field wallTopZ? number
---@field wallAlpha? integer
---@field texturePage? string
---@field textureImage? string
---@field textureDictionaryPrefix? string
---@field textureName? string
---@field textureSize? integer
---@field textureRepeatDistance? number
---@field cullIntervalMs? integer
---@field textureState? string Estado visual fixo opcional usado por todas as zonas
---@field useBoundaryProfiles? boolean Permite usar boundaryPoints/boundaryHeight no Z visual
---@field useFullTexture? boolean Usa a textura inteira em vez de um slot do atlas
---@field visualWallHeight? number Altura efetivamente enviada para a GPU, sem alterar os limites configurados
---@field circleSegments? integer Quantidade de faces usada apenas no visual 3D circular
---@field cylinderZoneIds? boolean|table<string, boolean> true usa DrawMarker em todas as zonas circulares; tabela limita por ID
---@field cylinderWallHeight? number Altura do cilindro a partir da base visual existente
---@field cylinderTextureImage? string PNG especifico do cilindro, sem alterar a textura dos poligonos

---@class SpatialZoneBoundaryRenderer
---@field zoneSet SpatialZoneSet
---@field visible boolean
---@field revision integer
---@field textureDui number?
---@field textureDictionary string?
---@field textureName string
---@field runtimeTxd number?
---@field textureReady boolean
---@field cylinderTextureName? string
---@field cylinderDebugMode? string
---@field cylinderDebugDictionary? string
SpatialZoneBoundaryRenderer = class()

local SPATIAL_ZONE_BOUNDARY_DRAW_DISTANCE = 220.0
local SPATIAL_ZONE_BOUNDARY_WALL_BOTTOM_Z = -50.0
local SPATIAL_ZONE_BOUNDARY_WALL_TOP_Z = 150.0
local SPATIAL_ZONE_BOUNDARY_WALL_ALPHA = 24
local SPATIAL_ZONE_BOUNDARY_CULL_INTERVAL_MS = 250
local SPATIAL_ZONE_BOUNDARY_TEXTURE_SIZE = 2048
local SPATIAL_ZONE_BOUNDARY_TEXTURE_REPEAT_DISTANCE = 200.0
local SPATIAL_ZONE_BOUNDARY_VISUAL_WALL_HEIGHT = 160.0
local SPATIAL_ZONE_BOUNDARY_TEXTURE_TIMEOUT_MS = 5000
local SPATIAL_ZONE_BOUNDARY_TEXTURE_MIN_RESOLUTION = 32
local SPATIAL_ZONE_BOUNDARY_TEXTURE_SETTLE_MS = 150
local SPATIAL_ZONE_BOUNDARY_CAMERA_CULL_MARGIN = 10.0
local SPATIAL_ZONE_BOUNDARY_CIRCLE_MIN_DRAW_DISTANCE = 350.0
local SPATIAL_ZONE_BOUNDARY_CIRCLE_MAX_DRAW_DISTANCE = 1000.0
local SPATIAL_ZONE_BOUNDARY_CIRCLE_DRAW_RADIUS_RATIO = 0.4
local SPATIAL_ZONE_BOUNDARY_CIRCLE_MAX_CHORD_ERROR = 0.2
local SPATIAL_ZONE_BOUNDARY_FULL_TURN = math.pi * 2.0

local gSpatialZoneBoundaryTextureGeneration = 0
local gSpatialZoneBoundaryImageTextures = {}
local gSpatialZoneBoundaryCylinderDebugTextures = nil

local SPATIAL_ZONE_BOUNDARY_UV_BY_STATE = {
    safe = { minU = 0.0, maxU = 0.5, minV = 0.0, maxV = 0.5 },
    neutral = { minU = 0.5, maxU = 1.0, minV = 0.0, maxV = 0.5 },
    contested = { minU = 0.0, maxU = 0.5, minV = 0.5, maxV = 1.0 },
    controlled = { minU = 0.5, maxU = 1.0, minV = 0.5, maxV = 1.0 },
}

local SPATIAL_ZONE_BOUNDARY_FULL_UV = {
    minU = 0.0,
    maxU = 1.0,
    minV = 0.0,
    maxV = 1.0,
}

---@param value number?
---@return integer color
local function ClampColor( value )
    return math.min( 255, math.max( 0, math.floor( tonumber( value ) or 0 ) ) )
end

---@param zone SpatialZone
local function ApplyZoneColors( zone )
    if zone.state == 'contested' then
        zone.boundaryWallColor = { 184, 104, 20 }
        return
    end

    local wallColor = type( zone.color ) == 'table' and zone.color or { 0, 210, 255 }
    wallColor = {
        ClampColor( wallColor[ 1 ] ),
        ClampColor( wallColor[ 2 ] ),
        ClampColor( wallColor[ 3 ] ),
    }

    zone.boundaryWallColor = wallColor
end

---@param zone SpatialZone
---@param targetRepeatDistance number
local function ApplyZoneTextureCoordinates( zone, targetRepeatDistance )
    local cumulativeDistance = 0.0
    local distanceByPointIndex = {}

    for pointIndex, point in ipairs( zone.outline ) do
        local nextPointIndex = pointIndex % #zone.outline + 1
        local nextPoint = zone.outline[ nextPointIndex ]
        local deltaX = nextPoint.x - point.x
        local deltaY = nextPoint.y - point.y

        distanceByPointIndex[ pointIndex ] = cumulativeDistance
        cumulativeDistance = cumulativeDistance + math.sqrt(
            deltaX * deltaX + deltaY * deltaY
        )
    end

    zone.boundaryTextureDistanceByPointIndex = distanceByPointIndex
    zone.boundaryTexturePerimeter = cumulativeDistance
    zone.boundaryTextureRepeatDistance = targetRepeatDistance

    if cumulativeDistance > 0.0 then
        local targetRepeatCount = math.max(
            1,
            math.floor( cumulativeDistance / targetRepeatDistance + 0.5 )
        )
        local repeatCount = targetRepeatCount

        if zone.shape == 'circle' then
            local closestDistance = math.huge

            for candidate = 1, #zone.outline do
                if #zone.outline % candidate == 0 then
                    local candidateDistance = math.abs( candidate - targetRepeatCount )

                    if candidateDistance < closestDistance then
                        closestDistance = candidateDistance
                        repeatCount = candidate
                    end
                end
            end
        end

        zone.boundaryTextureRepeatDistance = cumulativeDistance / repeatCount
    end
end

---@param rotation vector3
---@return number forwardX
---@return number forwardY
local function GetHorizontalCameraForward( rotation )
    local heading = math.rad( rotation.z )

    return -math.sin( heading ), math.cos( heading )
end

---@param segment table
---@param position vector3
---@return number distanceSquared
local function GetSegmentDistanceSquared( segment, position )
    local deltaX = segment.endX - segment.startX
    local deltaY = segment.endY - segment.startY
    local lengthSquared = deltaX * deltaX + deltaY * deltaY
    local ratio = 0.0

    if lengthSquared > 0.001 then
        ratio = (
            ( position.x - segment.startX ) * deltaX
            + ( position.y - segment.startY ) * deltaY
        ) / lengthSquared
        ratio = math.max( 0.0, math.min( 1.0, ratio ) )
    end

    local nearestX = segment.startX + deltaX * ratio
    local nearestY = segment.startY + deltaY * ratio
    local distanceX = position.x - nearestX
    local distanceY = position.y - nearestY

    return distanceX * distanceX + distanceY * distanceY
end

---@param values table
local function ClearArray( values )
    for index = #values, 1, -1 do
        values[ index ] = nil
    end
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

---@param options SpatialZoneBoundaryRendererOptions?
function SpatialZoneBoundaryRenderer:__init( options )
    options = options or {}

    self.zoneSet = SpatialZoneSet( {} )
    self.visible = false
    self.revision = 0
    self.drawDistance = math.max(
        1.0,
        tonumber( options.drawDistance ) or SPATIAL_ZONE_BOUNDARY_DRAW_DISTANCE
    )
    self.drawDistanceSquared = self.drawDistance * self.drawDistance
    self.wallBottomZ = tonumber( options.wallBottomZ )
        or SPATIAL_ZONE_BOUNDARY_WALL_BOTTOM_Z
    self.wallTopZ = math.max(
        self.wallBottomZ + 0.1,
        tonumber( options.wallTopZ ) or SPATIAL_ZONE_BOUNDARY_WALL_TOP_Z
    )
    self.wallAlpha = ClampColor( options.wallAlpha or SPATIAL_ZONE_BOUNDARY_WALL_ALPHA )
    self.textureState = type( options.textureState ) == 'string'
        and options.textureState
        or nil
    self.useBoundaryProfiles = options.useBoundaryProfiles ~= false
    self.useFullTexture = options.useFullTexture == true
    self.visualWallHeight = math.max(
        10.0,
        tonumber( options.visualWallHeight )
            or SPATIAL_ZONE_BOUNDARY_VISUAL_WALL_HEIGHT
    )
    self.circleSegments = math.max(
        3,
        math.floor( tonumber( options.circleSegments ) or 64 )
    )
    self.cylinderZoneIds = options.cylinderZoneIds or {}
    self.cylinderWallHeight = tonumber( options.cylinderWallHeight )
    self.texturePage = type( options.texturePage ) == 'string'
        and options.texturePage
        or nil
    self.textureImage = type( options.textureImage ) == 'string'
        and options.textureImage
        or nil
    self.cylinderTextureImage = type( options.cylinderTextureImage ) == 'string'
        and options.cylinderTextureImage
        or nil
    self.textureDictionaryPrefix = tostring(
        options.textureDictionaryPrefix or 'spatial_zone_boundary'
    )
    self.textureName = tostring( options.textureName or 'boundary' )
    self.textureSize = math.max(
        64,
        math.floor( tonumber( options.textureSize ) or SPATIAL_ZONE_BOUNDARY_TEXTURE_SIZE )
    )
    self.textureRepeatDistance = math.max(
        1.0,
        tonumber( options.textureRepeatDistance )
            or SPATIAL_ZONE_BOUNDARY_TEXTURE_REPEAT_DISTANCE
    )
    self.textureDui = nil
    self.textureDictionary = nil
    self.runtimeTxd = nil
    self.textureReady = false
    self.textureCreating = false
    self.textureRevision = 0
    self.cullIntervalMs = math.max(
        50,
        math.floor(
            tonumber( options.cullIntervalMs ) or SPATIAL_ZONE_BOUNDARY_CULL_INTERVAL_MS
        )
    )

    self:setZones( options.zones or {} )
end

---@private
---@param visible boolean
function SpatialZoneBoundaryRenderer:_setTextureVisible( visible )
    if not self.textureDui then
        return
    end

    SendDuiMessage( self.textureDui, json.encode( {
        action = 'setVisible',
        visible = visible == true,
    } ) )
end

---@private
function SpatialZoneBoundaryRenderer:_destroyTexture()
    self.textureRevision = self.textureRevision + 1
    self.textureCreating = false
    self.textureReady = false
    self:setCylinderDebugMode( 'normal' )

    if self.textureDui then
        gRenderNatives.DestroyDui( self.textureDui )
    end

    if self.textureDictionary then
        SetStreamedTextureDictAsNoLongerNeeded( self.textureDictionary )
    end

    self.textureDui = nil
    self.textureDictionary = nil
    self.runtimeTxd = nil
    self.cylinderTextureName = nil
end

---@param mode string normal|uv|solid|native|poly|compare
---@return boolean accepted
function SpatialZoneBoundaryRenderer:setCylinderDebugMode( mode )
    if mode ~= 'normal' and mode ~= 'uv' and mode ~= 'solid'
        and mode ~= 'native' and mode ~= 'poly' and mode ~= 'compare'
    then
        return false
    end

    if mode == 'uv' or mode == 'solid' then
        if not gSpatialZoneBoundaryCylinderDebugTextures then
            local dictionary = 'spatial_zone_boundary_cylinder_debug'
            local txd = gRenderNatives.CreateRuntimeTxd( dictionary )
            local uv = gRenderNatives.CreateRuntimeTexture( txd, 'uv', 32, 32 )
            local solid = gRenderNatives.CreateRuntimeTexture( txd, 'solid', 1, 1 )

            if not uv or uv == 0 or not solid or solid == 0 then
                sx.logger:error( 'SpatialZoneBoundaryRenderer: falha ao criar texturas de diagnostico' )
                return false
            end

            -- Grade 4x4: vermelho aumenta em U, verde em V; alpha sempre 255.
            for y = 0, 31 do
                for x = 0, 31 do
                    local column, row = math.floor( x / 8 ), math.floor( y / 8 )
                    local line = x % 8 == 0 or y % 8 == 0

                    SetRuntimeTexturePixel( uv, x, y,
                        line and 255 or 24 + column * 70,
                        line and 255 or 24 + row * 70,
                        line and 255 or ( ( column + row ) % 2 == 0 and 32 or 224 ),
                        255
                    )
                end
            end

            SetRuntimeTexturePixel( solid, 0, 0, 255, 255, 255, 255 )
            CommitRuntimeTexture( uv )
            CommitRuntimeTexture( solid )
            -- Apenas no teste; reutilizar as duas texturas evita acumulo nas trocas.
            gSpatialZoneBoundaryCylinderDebugTextures = { dictionary = dictionary, txd = txd }
        end

        if not self.cylinderDebugDictionary then
            self.cylinderDebugDictionary = gSpatialZoneBoundaryCylinderDebugTextures.dictionary
            RequestStreamedTextureDict( self.cylinderDebugDictionary, false )
        end
    elseif self.cylinderDebugDictionary then
        SetStreamedTextureDictAsNoLongerNeeded( self.cylinderDebugDictionary )
        self.cylinderDebugDictionary = nil
    end

    self.cylinderDebugMode = mode
    return true
end

---@private
function SpatialZoneBoundaryRenderer:_ensureTexture()
    if not ( self.texturePage or self.textureImage )
        or self.textureReady
        or self.textureCreating
    then
        return
    end

    if self.textureImage then
        local textureKey = ( '%s_%s_%s' ):format(
            self.textureDictionaryPrefix,
            GetHashKey( self.textureImage ),
            self.textureName
        )
        local texture = gSpatialZoneBoundaryImageTextures[ textureKey ]

        if not texture then
            local runtimeTxd = gRenderNatives.CreateRuntimeTxd( textureKey )
            local runtimeTexture = gRenderNatives.CreateRuntimeTextureFromImage(
                runtimeTxd, self.textureName, self.textureImage
            )

            if not runtimeTexture or runtimeTexture == 0 then
                sx.logger:error( ( 'SpatialZoneBoundaryRenderer: falha ao carregar %s' )
                    :format( self.textureImage ) )
                return
            end

            -- Runtime textures nao possuem destroy: reutilizar evita acumulo por entrada.
            texture = { runtimeTxd = runtimeTxd, dictionary = textureKey }
            gSpatialZoneBoundaryImageTextures[ textureKey ] = texture
        end

        self.runtimeTxd = texture.runtimeTxd
        self.textureDictionary = texture.dictionary
        RequestStreamedTextureDict( self.textureDictionary, false )
        self.textureReady = true

        if self.cylinderTextureImage then
            local cylinderTextureName = ( '%s_cylinder_%s' ):format(
                self.textureName, GetHashKey( self.cylinderTextureImage )
            )
            texture.cylinderImages = texture.cylinderImages or {}

            if not texture.cylinderImages[ cylinderTextureName ] then
                local cylinderTexture = gRenderNatives.CreateRuntimeTextureFromImage(
                    texture.runtimeTxd, cylinderTextureName, self.cylinderTextureImage
                )

                if not cylinderTexture or cylinderTexture == 0 then
                    sx.logger:error( ( 'SpatialZoneBoundaryRenderer: falha ao carregar %s; cilindro usa textura padrao' )
                        :format( self.cylinderTextureImage ) )
                    return
                end

                texture.cylinderImages[ cylinderTextureName ] = true
            end

            self.cylinderTextureName = cylinderTextureName
        end

        return
    end

    self.textureCreating = true
    self.textureRevision = self.textureRevision + 1

    local revision = self.textureRevision

    CreateThread( function()
        gSpatialZoneBoundaryTextureGeneration = gSpatialZoneBoundaryTextureGeneration + 1

        local generation = gSpatialZoneBoundaryTextureGeneration
        local textureDictionary = ( '%s_%d' ):format(
            self.textureDictionaryPrefix,
            generation
        )
        local textureUrl = ( 'nui://%s/%s?gen=%d&atlasSize=%d' ):format(
            GetCurrentResourceName(),
            self.texturePage,
            generation,
            self.textureSize
        )
        local dui = gRenderNatives.CreateDui( textureUrl, self.textureSize, self.textureSize )

        if not dui or dui == 0 then
            self.textureCreating = false
            sx.logger:error( 'SpatialZoneBoundaryRenderer: CreateDui falhou' )
            return
        end

        if self.textureRevision ~= revision then
            gRenderNatives.DestroyDui( dui )
            return
        end

        self.textureDui = dui
        self.textureDictionary = textureDictionary

        local duiAvailable = WaitForCondition( function()
            return self.textureRevision ~= revision
                or IsDuiAvailable( dui )
        end, SPATIAL_ZONE_BOUNDARY_TEXTURE_TIMEOUT_MS )

        if self.textureRevision ~= revision then
            return
        end

        if not duiAvailable then
            sx.logger:error( 'SpatialZoneBoundaryRenderer: DUI nao ficou disponivel' )
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
                and width >= SPATIAL_ZONE_BOUNDARY_TEXTURE_MIN_RESOLUTION
                and height >= SPATIAL_ZONE_BOUNDARY_TEXTURE_MIN_RESOLUTION
        end, SPATIAL_ZONE_BOUNDARY_TEXTURE_TIMEOUT_MS )

        if self.textureRevision ~= revision then
            return
        end

        if not textureLoaded then
            sx.logger:error( 'SpatialZoneBoundaryRenderer: runtime texture nao carregou' )
            self:_destroyTexture()
            return
        end

        Wait( SPATIAL_ZONE_BOUNDARY_TEXTURE_SETTLE_MS )

        if self.textureRevision ~= revision then
            return
        end

        self.textureCreating = false
        self.textureReady = true
        self:_setTextureVisible( self.visible )
    end )
end

---@param zones table[]
function SpatialZoneBoundaryRenderer:setZones( zones )
    assert( type( zones ) == 'table', 'SpatialZoneBoundaryRenderer precisa de zones' )

    local wasVisible = self.visible

    if wasVisible then
        self:hide()
    end

    local success, errorMessage = self.zoneSet:setZones( zones )

    assert( success, errorMessage )

    for _, zone in ipairs( self.zoneSet:getZones() ) do
        if zone.shape == 'circle'
            and not self.useBoundaryProfiles
            and zone.center
            and zone.radius
        then
            local reducedOutline = {}

            for pointIndex = 1, self.circleSegments do
                local angle = ( pointIndex - 1 ) / self.circleSegments * math.pi * 2.0

                reducedOutline[ pointIndex ] = {
                    x = zone.center.x + math.cos( angle ) * zone.radius,
                    y = zone.center.y + math.sin( angle ) * zone.radius,
                }
            end

            zone.outline = reducedOutline
        elseif zone.shape == 'circle' and #zone.outline > self.circleSegments then
            local sourceOutline = zone.outline
            local reducedOutline = {}

            for pointIndex = 1, self.circleSegments do
                local sourceIndex = math.floor(
                    ( pointIndex - 1 ) * #sourceOutline / self.circleSegments
                ) + 1

                reducedOutline[ pointIndex ] = sourceOutline[ sourceIndex ]
            end

            zone.outline = reducedOutline
        end

        ApplyZoneColors( zone )
        ApplyZoneTextureCoordinates( zone, self.textureRepeatDistance )
        self:_buildZoneRenderSegments( zone )
    end

    if wasVisible then
        self:show()
    end
end

---@param zoneId string|number
---@param updates table
---@return boolean updated
function SpatialZoneBoundaryRenderer:updateZone( zoneId, updates )
    local zoneKey = tostring( zoneId )
    local zone = self.zoneSet:getZone( zoneKey )

    if not zone or type( updates ) ~= 'table' then
        return false
    end

    for key, value in pairs( updates ) do
        if key ~= 'id'
            and key ~= 'shape'
            and key ~= 'points'
            and key ~= 'boundaryPoints'
            and key ~= 'center'
            and key ~= 'radius'
            and key ~= 'minZ'
            and key ~= 'maxZ'
        then
            zone[ key ] = value
        end
    end

    ApplyZoneColors( zone )

    return true
end

---@private
---@param zone SpatialZone
---@param position vector3
---@return boolean near
function SpatialZoneBoundaryRenderer:_isNear( zone, position )
    local bounds = zone.bounds
    local deltaX = math.max( bounds.minX - position.x, 0.0, position.x - bounds.maxX )
    local deltaY = math.max( bounds.minY - position.y, 0.0, position.y - bounds.maxY )

    return deltaX * deltaX + deltaY * deltaY <= self.drawDistanceSquared
end

---@private
---@param startX number
---@param startY number
---@param endX number
---@param endY number
---@param startBottomZ number
---@param startTopZ number
---@param endBottomZ number
---@param endTopZ number
---@param wallColor number[]
---@param zoneState string
---@param textureStart number
---@param textureEnd number
---@param textureBottom number
---@param textureTop number
---@param reverseFace boolean
---@param textureOverride? string Textura inteira com UV explicito para a comparacao do cilindro
---@param alphaOverride? integer
function SpatialZoneBoundaryRenderer:_drawSegment(
    startX,
    startY,
    endX,
    endY,
    startBottomZ,
    startTopZ,
    endBottomZ,
    endTopZ,
    wallColor,
    zoneState,
    textureStart,
    textureEnd,
    textureBottom,
    textureTop,
    reverseFace,
    textureOverride,
    alphaOverride
)
    local wallRed = wallColor[ 1 ]
    local wallGreen = wallColor[ 2 ]
    local wallBlue = wallColor[ 3 ]
    local wallAlpha = alphaOverride and ClampColor( alphaOverride ) or self.wallAlpha
    local fallbackAlpha = alphaOverride and wallAlpha or SPATIAL_ZONE_BOUNDARY_WALL_ALPHA

    if self.textureReady and self.textureDictionary then
        local uv = self.useFullTexture
            and SPATIAL_ZONE_BOUNDARY_FULL_UV
            or SPATIAL_ZONE_BOUNDARY_UV_BY_STATE[ zoneState ]
            or SPATIAL_ZONE_BOUNDARY_UV_BY_STATE.neutral
        local halfTexel = 0.5 / self.textureSize
        local usableMinU = uv.minU + halfTexel
        local usableMaxU = uv.maxU - halfTexel
        local usableWidth = usableMaxU - usableMinU
        local minU = usableMinU + usableWidth * textureStart
        local maxU = usableMinU + usableWidth * textureEnd
        local usableMinV = uv.minV + halfTexel
        local usableMaxV = uv.maxV - halfTexel
        local usableHeight = usableMaxV - usableMinV
        local bottomV = usableMaxV - usableHeight * textureBottom
        local topV = usableMaxV - usableHeight * textureTop
        local textureName = textureOverride or self.textureName

        if textureOverride then
            minU, maxU = textureStart, textureEnd
            bottomV, topV = 1.0 - textureBottom, 1.0 - textureTop
        end

        if reverseFace then
            DrawTexturedPoly(
                endX, endY, endTopZ,
                endX, endY, endBottomZ,
                startX, startY, startBottomZ,
                wallRed, wallGreen, wallBlue, wallAlpha,
                self.textureDictionary, textureName,
                maxU, topV, 0.0,
                maxU, bottomV, 0.0,
                minU, bottomV, 0.0
            )
            DrawTexturedPoly(
                startX, startY, startTopZ,
                endX, endY, endTopZ,
                startX, startY, startBottomZ,
                wallRed, wallGreen, wallBlue, wallAlpha,
                self.textureDictionary, textureName,
                minU, topV, 0.0,
                maxU, topV, 0.0,
                minU, bottomV, 0.0
            )
        else
            DrawTexturedPoly(
                startX, startY, startBottomZ,
                endX, endY, endBottomZ,
                endX, endY, endTopZ,
                wallRed, wallGreen, wallBlue, wallAlpha,
                self.textureDictionary, textureName,
                minU, bottomV, 0.0,
                maxU, bottomV, 0.0,
                maxU, topV, 0.0
            )
            DrawTexturedPoly(
                startX, startY, startBottomZ,
                endX, endY, endTopZ,
                startX, startY, startTopZ,
                wallRed, wallGreen, wallBlue, wallAlpha,
                self.textureDictionary, textureName,
                minU, bottomV, 0.0,
                maxU, topV, 0.0,
                minU, topV, 0.0
            )
        end
        return
    end

    if reverseFace then
        DrawPoly(
            endX, endY, endTopZ,
            endX, endY, endBottomZ,
            startX, startY, startBottomZ,
            wallRed, wallGreen, wallBlue, fallbackAlpha
        )
        DrawPoly(
            startX, startY, startTopZ,
            endX, endY, endTopZ,
            startX, startY, startBottomZ,
            wallRed, wallGreen, wallBlue, fallbackAlpha
        )
    else
        DrawPoly(
            startX, startY, startBottomZ,
            endX, endY, endBottomZ,
            endX, endY, endTopZ,
            wallRed, wallGreen, wallBlue, fallbackAlpha
        )
        DrawPoly(
            startX, startY, startBottomZ,
            endX, endY, endTopZ,
            startX, startY, startTopZ,
            wallRed, wallGreen, wallBlue, fallbackAlpha
        )
    end
end

---@private
---@param zone SpatialZone
function SpatialZoneBoundaryRenderer:_buildZoneRenderSegments( zone )
    local renderSegments = {}

    zone.boundaryRenderSegments = renderSegments
    zone.boundaryNearbyRenderSegments = {}

    if #zone.outline < 2 then
        return
    end

    local configuredBottomZ = tonumber( zone.boundaryBottomZ ) or self.wallBottomZ
    local configuredTopZ = math.max(
        configuredBottomZ + 0.1,
        tonumber( zone.boundaryTopZ ) or self.wallTopZ
    )
    local configuredHeight = configuredTopZ - configuredBottomZ
    local visualHeight = math.min( configuredHeight, self.visualWallHeight )
    local visualCenterZ = ( configuredBottomZ + configuredTopZ ) * 0.5
    local visualBottomZ = visualCenterZ - visualHeight * 0.5
    local visualTopZ = visualCenterZ + visualHeight * 0.5
    local boundaryHeight = tonumber( zone.boundaryHeight )
    local textureDistanceByPointIndex = zone.boundaryTextureDistanceByPointIndex or {}
    local repeatDistance = zone.boundaryTextureRepeatDistance
        or self.textureRepeatDistance

    for pointIndex, startPoint in ipairs( zone.outline ) do
        local nextPointIndex = pointIndex % #zone.outline + 1
        local endPoint = zone.outline[ nextPointIndex ]
        local deltaX = endPoint.x - startPoint.x
        local deltaY = endPoint.y - startPoint.y
        local segmentLength = math.sqrt( deltaX * deltaX + deltaY * deltaY )

        if segmentLength > 0.001 then
            local startBottomZ = visualBottomZ
            local startTopZ = visualTopZ
            local endBottomZ = visualBottomZ
            local endTopZ = visualTopZ

            if self.useBoundaryProfiles
                and boundaryHeight
                and boundaryHeight > 0.0
                and startPoint.z
                and endPoint.z
            then
                startBottomZ = startPoint.z - 0.1
                startTopZ = startPoint.z + boundaryHeight
                endBottomZ = endPoint.z - 0.1
                endTopZ = endPoint.z + boundaryHeight
            end

            local bottomDelta = endBottomZ - startBottomZ
            local topDelta = endTopZ - startTopZ
            local startDistance = textureDistanceByPointIndex[ pointIndex ] or 0.0
            local travelled = 0.0

            while travelled < segmentLength - 0.001 do
                local cycleDistance = ( startDistance + travelled ) % repeatDistance
                local availableDistance = repeatDistance - cycleDistance

                if availableDistance <= 0.001 then
                    cycleDistance = 0.0
                    availableDistance = repeatDistance
                end

                local chunkLength = math.min(
                    segmentLength - travelled,
                    availableDistance
                )
                local nextTravelled = travelled + chunkLength
                local startRatio = travelled / segmentLength
                local endRatio = nextTravelled / segmentLength
                local chunkStartX = startPoint.x + deltaX * startRatio
                local chunkStartY = startPoint.y + deltaY * startRatio
                local chunkEndX = startPoint.x + deltaX * endRatio
                local chunkEndY = startPoint.y + deltaY * endRatio
                local halfLength = chunkLength * 0.5

                renderSegments[ #renderSegments + 1 ] = {
                    startX = chunkStartX,
                    startY = chunkStartY,
                    endX = chunkEndX,
                    endY = chunkEndY,
                    edgeDeltaX = chunkEndX - chunkStartX,
                    edgeDeltaY = chunkEndY - chunkStartY,
                    startBottomZ = startBottomZ + bottomDelta * startRatio,
                    startTopZ = startTopZ + topDelta * startRatio,
                    endBottomZ = startBottomZ + bottomDelta * endRatio,
                    endTopZ = startTopZ + topDelta * endRatio,
                    middleX = ( chunkStartX + chunkEndX ) * 0.5,
                    middleY = ( chunkStartY + chunkEndY ) * 0.5,
                    cameraCullRadius = halfLength + SPATIAL_ZONE_BOUNDARY_CAMERA_CULL_MARGIN,
                    textureStart = cycleDistance / repeatDistance,
                    textureEnd = ( cycleDistance + chunkLength ) / repeatDistance,
                }

                travelled = nextTravelled
            end
        end
    end
end

---@private
---@param zone SpatialZone
---@param cameraPosition vector3
---@param cameraForwardX number
---@param cameraForwardY number
---@param cameraRightX number
---@param cameraRightY number
---@param horizontalFovTangent number
function SpatialZoneBoundaryRenderer:_drawZone(
    zone,
    cameraPosition,
    cameraForwardX,
    cameraForwardY,
    cameraRightX,
    cameraRightY,
    horizontalFovTangent
)
    local wallColor = zone.boundaryWallColor
    local zoneState = self.textureState or tostring( zone.state or 'neutral' )
    local useCylinder = zone.shape == 'circle'
        and ( self.cylinderZoneIds == true or self.cylinderZoneIds[ zone.id ] )
    local compareCylinder = useCylinder and self.cylinderDebugMode == 'compare'

    if useCylinder
        and self.cylinderDebugMode ~= 'poly'
        and not compareCylinder
    then
        local segment = zone.boundaryRenderSegments[ 1 ]
        local diameter = zone.radius * 2.0
        local dictionary = self.textureReady and self.textureDictionary or nil
        local textureName = self.textureReady and ( self.cylinderTextureName or self.textureName ) or nil
        local diagnostic = self.cylinderDebugMode == 'uv' or self.cylinderDebugMode == 'solid'

        if diagnostic then
            dictionary, textureName = self.cylinderDebugDictionary, self.cylinderDebugMode
        elseif self.cylinderDebugMode == 'native' then
            dictionary, textureName = nil, nil
        end

        DrawMarker(
            1, zone.center.x, zone.center.y, segment.startBottomZ,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            diameter, diameter, self.cylinderWallHeight or segment.startTopZ - segment.startBottomZ,
            diagnostic and 255 or wallColor[ 1 ],
            diagnostic and 255 or wallColor[ 2 ],
            diagnostic and 255 or wallColor[ 3 ],
            diagnostic and 255 or self.wallAlpha,
            false, false, 2, false, dictionary, textureName, false
        )
        return
    end

    local renderSegments = zone.boundaryNearbyRenderSegments or {}

    for segmentIndex = 1, #renderSegments do
        local segment = renderSegments[ segmentIndex ]
        local cameraDeltaX = segment.middleX - cameraPosition.x
        local cameraDeltaY = segment.middleY - cameraPosition.y
        local cameraDepth = cameraDeltaX * cameraForwardX
            + cameraDeltaY * cameraForwardY
        local cameraLateral = cameraDeltaX * cameraRightX
            + cameraDeltaY * cameraRightY
        local visibleHalfWidth = math.max( 0.0, cameraDepth )
            * horizontalFovTangent
            + segment.cameraCullRadius

        if cameraDepth >= -segment.cameraCullRadius
            and math.abs( cameraLateral ) <= visibleHalfWidth
        then
            local cameraSide = ( cameraPosition.x - segment.middleX )
                * segment.edgeDeltaY
                - ( cameraPosition.y - segment.middleY ) * segment.edgeDeltaX
            local startBottomZ, startTopZ = segment.startBottomZ, segment.startTopZ
            local endBottomZ, endTopZ = segment.endBottomZ, segment.endTopZ
            local textureStart, textureEnd = segment.textureStart, segment.textureEnd
            local textureOverride

            if compareCylinder then
                -- Uma volta completa em U e 500 m em V; o UV interno do marker deve ser conferido ingame.
                local firstSegment = zone.boundaryRenderSegments[ 1 ]
                local height = self.cylinderWallHeight or firstSegment.startTopZ - firstSegment.startBottomZ
                startBottomZ, endBottomZ = firstSegment.startBottomZ, firstSegment.startBottomZ
                startTopZ, endTopZ = startBottomZ + height, endBottomZ + height
                textureStart = math.atan( segment.startY - zone.center.y, segment.startX - zone.center.x )
                    / ( 2.0 * math.pi ) % 1.0
                textureEnd = math.atan( segment.endY - zone.center.y, segment.endX - zone.center.x )
                    / ( 2.0 * math.pi ) % 1.0
                -- Manter continuidade na emenda 0/1, em qualquer sentido do contorno.
                textureEnd = textureStart + ( textureEnd - textureStart + 0.5 ) % 1.0 - 0.5
                textureOverride = self.cylinderTextureName or self.textureName
            end

            self:_drawSegment(
                segment.startX,
                segment.startY,
                segment.endX,
                segment.endY,
                startBottomZ,
                startTopZ,
                endBottomZ,
                endTopZ,
                wallColor,
                zoneState,
                textureStart,
                textureEnd,
                0.0,
                1.0,
                cameraSide < 0.0,
                textureOverride
            )
        end
    end
end

---@class SpatialZoneBoundaryCircleCenter
---@field x number
---@field y number

---@param center SpatialZoneBoundaryCircleCenter
---@param radius number
---@param color integer[]
---@param bottomZ number
---@param height number
---@param alpha integer
---@return boolean drawn
function SpatialZoneBoundaryRenderer:DrawCircle( center, radius, color, bottomZ, height, alpha )

    if type( center ) ~= 'table' or type( color ) ~= 'table'
        or type( center.x ) ~= 'number' or type( center.y ) ~= 'number'
        or type( radius ) ~= 'number' or radius <= 0
        or type( bottomZ ) ~= 'number' or type( height ) ~= 'number' or height <= 0
    then
        return false
    end

    if not self.textureReady then self:_ensureTexture() end

    DrawMarker(
        1, center.x, center.y, bottomZ,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        radius * 2.0, radius * 2.0, height,
        ClampColor( color[ 1 ] ), ClampColor( color[ 2 ] ), ClampColor( color[ 3 ] ), ClampColor( alpha ),
        false, false, 2, false,
        self.textureReady and self.textureDictionary or nil,
        self.textureReady and ( self.cylinderTextureName or self.textureName ) or nil,
        false
    )

    return true
end

--- Desenha somente o arco proximo da camera sobre o circulo XY real. O marker
--- cilindrico perde precisao visual quando seu diametro chega a varios km.
---@param center SpatialZoneBoundaryCircleCenter
---@param radius number
---@param color integer[]
---@param bottomZ number
---@param height number
---@param alpha integer
---@return boolean drawn
function SpatialZoneBoundaryRenderer:DrawCircleNear( center, radius, color, bottomZ, height, alpha )

    if type( center ) ~= 'table' or type( color ) ~= 'table'
        or type( center.x ) ~= 'number' or type( center.y ) ~= 'number'
        or type( radius ) ~= 'number' or radius <= 0
        or type( bottomZ ) ~= 'number' or type( height ) ~= 'number' or height <= 0
    then
        return false
    end

    local cameraPosition = GetFinalRenderedCamCoord()
    local cameraDeltaX = cameraPosition.x - center.x
    local cameraDeltaY = cameraPosition.y - center.y
    local cameraDistance = math.sqrt( cameraDeltaX * cameraDeltaX + cameraDeltaY * cameraDeltaY )
    local drawDistance = math.min(
        SPATIAL_ZONE_BOUNDARY_CIRCLE_MAX_DRAW_DISTANCE,
        math.max( SPATIAL_ZONE_BOUNDARY_CIRCLE_MIN_DRAW_DISTANCE,
            radius * SPATIAL_ZONE_BOUNDARY_CIRCLE_DRAW_RADIUS_RATIO )
    )

    if math.abs( cameraDistance - radius ) > drawDistance then return false end

    if not self.textureReady then self:_ensureTexture() end

    -- Malha ancorada no angulo zero: mover a camera nao desloca os vertices.
    -- A corda fica a no maximo 0,2 m do arco analitico, inclusive em 8 km.
    local maxAngleByError = 2.0 * math.acos( math.max(
        -1.0, 1.0 - SPATIAL_ZONE_BOUNDARY_CIRCLE_MAX_CHORD_ERROR / radius
    ) )
    local perimeter = SPATIAL_ZONE_BOUNDARY_FULL_TURN * radius
    local textureRepeats = math.max( 1, math.floor(
        perimeter / self.textureRepeatDistance + 0.5
    ) )
    local repeatDistance = perimeter / textureRepeats
    local maxAngleByTexture = repeatDistance / radius
    local segmentCount = math.max( 8, math.ceil(
        SPATIAL_ZONE_BOUNDARY_FULL_TURN / math.min( maxAngleByError, maxAngleByTexture )
    ) )
    local angleStep = SPATIAL_ZONE_BOUNDARY_FULL_TURN / segmentCount
    local startIndex, endIndex

    if cameraDistance + radius <= drawDistance then
        startIndex, endIndex = 0, segmentCount - 1
    else
        local nearestAngle = math.atan( cameraDeltaY, cameraDeltaX )
        local halfAngle = math.acos( math.max( -1.0, math.min( 1.0,
            ( cameraDistance * cameraDistance + radius * radius - drawDistance * drawDistance )
                / ( 2.0 * cameraDistance * radius )
        ) ) )
        startIndex = math.floor( ( nearestAngle - halfAngle ) / angleStep ) - 1
        endIndex = math.ceil( ( nearestAngle + halfAngle ) / angleStep ) + 1

        if endIndex - startIndex + 1 >= segmentCount then
            startIndex, endIndex = 0, segmentCount - 1
        end
    end

    local halfChordLength = radius * math.sin( angleStep * 0.5 )
    local cullRadius = halfChordLength + SPATIAL_ZONE_BOUNDARY_CAMERA_CULL_MARGIN
    local maxSegmentDistanceSquared = ( drawDistance + cullRadius ) ^ 2
    local topZ = bottomZ + height
    local textureName = self.cylinderTextureName or self.textureName
    local drawn = false

    for segmentIndex = startIndex, endIndex do
        local startAngle = segmentIndex * angleStep
        local endAngle = startAngle + angleStep
        local startX = center.x + math.cos( startAngle ) * radius
        local startY = center.y + math.sin( startAngle ) * radius
        local endX = center.x + math.cos( endAngle ) * radius
        local endY = center.y + math.sin( endAngle ) * radius
        local middleX, middleY = ( startX + endX ) * 0.5, ( startY + endY ) * 0.5
        local deltaX, deltaY = middleX - cameraPosition.x, middleY - cameraPosition.y

        if deltaX * deltaX + deltaY * deltaY <= maxSegmentDistanceSquared then
            local reverseFace = ( cameraPosition.x - middleX ) * ( endY - startY )
                - ( cameraPosition.y - middleY ) * ( endX - startX ) < 0.0
            local startTexture = startAngle * radius / repeatDistance
            local endTexture = endAngle * radius / repeatDistance
            local cycle = math.floor( startTexture )
            local startU, endU = startTexture - cycle, endTexture - cycle

            -- Uma face nunca atravessa o wrap U=1/0. A emenda usa outro
            -- ponto no circulo exato, sem deslocar a borda para dentro.
            if endU > 1.0 + 0.000001 then
                local splitAngle = ( cycle + 1 ) * repeatDistance / radius
                local splitX = center.x + math.cos( splitAngle ) * radius
                local splitY = center.y + math.sin( splitAngle ) * radius

                self:_drawSegment(
                    startX, startY, splitX, splitY,
                    bottomZ, topZ, bottomZ, topZ,
                    color, 'controlled', startU, 1.0, 0.0, 1.0,
                    reverseFace, textureName, alpha
                )
                self:_drawSegment(
                    splitX, splitY, endX, endY,
                    bottomZ, topZ, bottomZ, topZ,
                    color, 'controlled', 0.0, endU - 1.0, 0.0, 1.0,
                    reverseFace, textureName, alpha
                )
            else
                self:_drawSegment(
                    startX, startY, endX, endY,
                    bottomZ, topZ, bottomZ, topZ,
                    color, 'controlled', startU, math.min( 1.0, endU ), 0.0, 1.0,
                    reverseFace, textureName, alpha
                )
            end

            drawn = true
        end
    end

    return drawn
end

function SpatialZoneBoundaryRenderer:show()
    if self.visible or #self.zoneSet:getZones() == 0 then
        return
    end

    self.visible = true
    self.revision = self.revision + 1
    self:_setTextureVisible( true )
    self:_ensureTexture()

    local revision = self.revision
    local diagnosticLoop = DminigamesRenderDiagnostics.LoopStarted( 'boundary', self )

    CreateThread( function()
        local nearbyZones = {}
        local nextCullAt = 0
        local screenWidth, screenHeight = GetActiveScreenResolution()
        local screenAspect = screenHeight > 0 and screenWidth / screenHeight or 16.0 / 9.0

        while self.visible and self.revision == revision do
            local ped = PlayerPedId()
            local waitTime = self.cullIntervalMs

            if not IsPauseMenuActive()
                and not IsScreenFadedOut()
                and ped ~= 0
                and DoesEntityExist( ped )
            then
                local playerPosition = GetEntityCoords( ped )
                local now = GetGameTimer()

                if now >= nextCullAt then
                    ClearArray( nearbyZones )

                    for _, zone in ipairs(
                        self.zoneSet:getNearbyZones( playerPosition, self.drawDistance )
                    ) do
                        if self:_isNear( zone, playerPosition ) then
                            local nearbySegments = zone.boundaryNearbyRenderSegments

                            ClearArray( nearbySegments )

                            for segmentIndex = 1, #zone.boundaryRenderSegments do
                                local segment = zone.boundaryRenderSegments[ segmentIndex ]

                                if GetSegmentDistanceSquared( segment, playerPosition )
                                    <= self.drawDistanceSquared
                                then
                                    nearbySegments[ #nearbySegments + 1 ] = segment
                                end
                            end

                            if #nearbySegments > 0 then
                                nearbyZones[ #nearbyZones + 1 ] = zone
                            end
                        end
                    end

                    nextCullAt = now + self.cullIntervalMs
                end

                if #nearbyZones > 0 then
                    local cameraPosition = GetFinalRenderedCamCoord()
                    local cameraRotation = GetFinalRenderedCamRot( 2 )
                    local cameraForwardX, cameraForwardY = GetHorizontalCameraForward(
                        cameraRotation
                    )
                    local cameraRightX = cameraForwardY
                    local cameraRightY = -cameraForwardX
                    local verticalHalfFov = math.rad( GetFinalRenderedCamFov() * 0.5 )
                    local horizontalFovTangent = math.tan( verticalHalfFov ) * screenAspect

                    for zoneIndex = 1, #nearbyZones do
                        local zone = nearbyZones[ zoneIndex ]

                        self:_drawZone(
                            zone,
                            cameraPosition,
                            cameraForwardX,
                            cameraForwardY,
                            cameraRightX,
                            cameraRightY,
                            horizontalFovTangent
                        )
                    end

                    waitTime = 0
                end
            end

            Wait( waitTime )
        end
        DminigamesRenderDiagnostics.LoopFinished( diagnosticLoop )
    end )
end

function SpatialZoneBoundaryRenderer:hide()
    DminigamesRenderDiagnostics.LoopsStopping( self )
    self.visible = false
    self.revision = self.revision + 1
    self:_setTextureVisible( false )
end

function SpatialZoneBoundaryRenderer:destroy()
    self:hide()
    self:setZones( {} )
    self:_destroyTexture()
end
