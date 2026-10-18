local gRenderNatives = DminigamesRenderDiagnostics.Natives( 'rankings' )

---@class DominationRankingBoardRendererOptions
---@field shouldRender? fun(): boolean
---@field shouldInteract? fun(): boolean
---@field texturePage? string
---@field textureDictionaryPrefix? string
---@field rankingScope? 'organizations'|'players'
---@field placementKey? string
---@field horizontalOffset? number
---@field drawDistance? number
---@field interactionDistance? number
---@field heightOffset? number

---@class DominationRankingBoardZone
---@field id string
---@field x number
---@field y number
---@field z number
---@field heightReady boolean
---@field fixedHeight boolean
---@field heading? number
---@field horizontalOffset number

---@class DominationRankingBoardQuad
---@field centerX number
---@field centerY number
---@field centerZ number
---@field rightX number
---@field rightY number
---@field normalX number
---@field normalY number
---@field leftX number
---@field leftY number
---@field rightEdgeX number
---@field rightEdgeY number
---@field topZ number
---@field bottomZ number

---@class DominationRankingBoardRenderer
---@field zones DominationRankingBoardZone[]
---@field visibleZone? DominationRankingBoardZone
---@field visible boolean
---@field revision integer
---@field textureDui number?
---@field textureDictionary string?
---@field runtimeTxd number?
---@field textureReady boolean
---@field textureCreating boolean
---@field textureRevision integer
---@field textureVisible boolean?
---@field rankingScope 'organizations'|'players'
---@field placementKey string
---@field horizontalOffset number
---@field rankingEntries table[]
---@field rankingExpiresAt integer
---@field rankingRequestInFlight boolean
---@field mouseActive boolean
---@field mouseDown boolean
---@field mouseInside boolean
---@field mouseX integer?
---@field mouseY integer?
---@field visibleZoneDistanceSquared number
---@field interactionDistanceSquared number
---@field renderQuad DominationRankingBoardQuad
---@field renderQuadZone? DominationRankingBoardZone
---@field renderQuadCameraX number
---@field renderQuadCameraY number
---@field screenWidth integer
---@field screenHeight integer
---@field screenResolutionExpiresAt integer
---@field shouldRender? fun(): boolean
---@field shouldInteract? fun(): boolean
DominationRankingBoardRenderer = class()

local RANKING_BOARD_TEXTURE_WIDTH = 768
local RANKING_BOARD_TEXTURE_HEIGHT = 1024
local RANKING_BOARD_TEXTURE_TIMEOUT_MS = 5000
local RANKING_BOARD_TEXTURE_SETTLE_MS = 180
local RANKING_BOARD_MIN_TEXTURE_RESOLUTION = 32
local RANKING_BOARD_DRAW_DISTANCE = 50.0
local RANKING_BOARD_INTERACTION_DISTANCE = 6.0
local RANKING_BOARD_HEIGHT_OFFSET = 1.0
local RANKING_BOARD_HEIGHT_SAMPLE_DELAY_MS = 1000
local RANKING_BOARD_CULL_INTERVAL_MS = 250
local RANKING_BOARD_REFRESH_MS = 60 * 1000
local RANKING_BOARD_REFRESH_JITTER_MS = 15 * 1000
local RANKING_BOARD_RETRY_MS = 10 * 1000
local RANKING_BOARD_WORLD_WIDTH = 3.6
local RANKING_BOARD_WORLD_HEIGHT = RANKING_BOARD_WORLD_WIDTH
    * ( RANKING_BOARD_TEXTURE_HEIGHT / RANKING_BOARD_TEXTURE_WIDTH )
local RANKING_BOARD_FACING_MIN_DOT = 0.30
local RANKING_BOARD_TEXTURE_NAME = 'ranking_board'
local RANKING_BOARD_PER_PAGE = 50
local RANKING_BOARD_MOUSE_WHEEL_STEP = 120

local gDominationRankingBoardTextureGeneration = 0
local gDominationRankingBoardRenderers = {}
local gDominationRankingBoardBaseZByZoneId = {}
local gDominationRankingBoardHeightSamplePendingByZoneId = {}
local gDominationRankingBoardInteractionFrame = -1
local gDominationRankingBoardInteractionCursorX = -1.0
local gDominationRankingBoardInteractionCursorY = -1.0
local gDominationRankingBoardInteractionTarget = nil
local gDominationRankingBoardInteractionTextureX = nil
local gDominationRankingBoardInteractionTextureY = nil

---@param zoneId string
---@param baseZ number
local function ApplyRankingBoardBaseZ( zoneId, baseZ )
    gDominationRankingBoardBaseZByZoneId[ zoneId ] = baseZ

    for _, renderer in ipairs( gDominationRankingBoardRenderers ) do
        for _, zone in ipairs( renderer.zones ) do
            if zone.id == zoneId and not zone.fixedHeight then
                zone.z = baseZ + renderer.heightOffset
                zone.heightReady = true
                renderer.renderQuadZone = nil
            end
        end
    end
end

---@param zoneId string
local function ScheduleRankingBoardHeightSample( zoneId )
    local cachedBaseZ = gDominationRankingBoardBaseZByZoneId[ zoneId ]

    if cachedBaseZ ~= nil then
        ApplyRankingBoardBaseZ( zoneId, cachedBaseZ )
        return
    end

    if gDominationRankingBoardHeightSamplePendingByZoneId[ zoneId ] then
        return
    end

    gDominationRankingBoardHeightSamplePendingByZoneId[ zoneId ] = true

    CreateThread( function()
        Wait( RANKING_BOARD_HEIGHT_SAMPLE_DELAY_MS )
        gDominationRankingBoardHeightSamplePendingByZoneId[ zoneId ] = nil

        local shouldSample = false

        for _, renderer in ipairs( gDominationRankingBoardRenderers ) do
            if renderer.visible
                and renderer.visibleZone
                and renderer.visibleZone.id == zoneId
                and ( not renderer.shouldRender or renderer.shouldRender() )
            then
                shouldSample = true
                break
            end
        end

        if not shouldSample then
            return
        end

        local ped = PlayerPedId()

        if ped == 0 or not DoesEntityExist( ped ) then
--             sx.logger:warn( ( 'DominationRankingBoardRenderer: ped invalido ao fixar altura da zona %s' ):format(
--                 zoneId
--             ) )
            return
        end

        local position = GetEntityCoords( ped )

        ApplyRankingBoardBaseZ( zoneId, position.z )
    end )
end

---@return string cityName
local function GetRankingBoardCityName()
    local configuredCityName = CURRENT_CITY_NAME
        or cityName
        or GetConvar( 'cityName', '' )

    return tostring( configuredCityName or '' )
end

---@return table<string, string> localization
local function GetRankingBoardLocalization()
    return {
        locale = TranslationManager.getLocale(),
        kicker = PvpTranslations.get( 'domination_name' ),
        ariaLabel = PvpTranslations.get( 'domination_ranking_aria_label' ),
        title = PvpTranslations.get( 'domination_ranking_title' ),
        organizations = PvpTranslations.get( 'domination_ranking_organizations' ),
        players = PvpTranslations.get( 'domination_ranking_players' ),
        playerAriaLabel = PvpTranslations.get( 'domination_ranking_player_aria_label' ),
        filterGeneral = PvpTranslations.get( 'domination_ranking_filter_general' ),
        filterKills = PvpTranslations.get( 'domination_ranking_filter_kills' ),
        filterAssists = PvpTranslations.get( 'domination_ranking_filter_assists' ),
        filterRevives = PvpTranslations.get( 'domination_ranking_filter_revives' ),
        filterCaptures = PvpTranslations.get( 'domination_ranking_filter_captures' ),
        filterControl = PvpTranslations.get( 'domination_ranking_filter_control' ),
        filtersLabel = PvpTranslations.get( 'domination_ranking_filters_label' ),
        podiumLabel = PvpTranslations.get( 'domination_ranking_podium_label' ),
        listLabel = PvpTranslations.get( 'domination_ranking_list_label' ),
        topOrganizations = PvpTranslations.get( 'domination_ranking_top_organizations' ),
        topPlayers = PvpTranslations.get( 'domination_ranking_top_players' ),
        scrollMore = PvpTranslations.get( 'domination_ranking_scroll_more' ),
        currentOrganization = PvpTranslations.get( 'domination_ranking_current_organization' ),
        currentPlayer = PvpTranslations.get( 'domination_ranking_current_player' ),
        defaultOrganization = PvpTranslations.get( 'domination_ranking_default_organization' ),
        defaultPlayer = PvpTranslations.get( 'domination_ranking_default_player' ),
        playerPodiumLabel = PvpTranslations.get( 'domination_ranking_player_podium_label' ),
        playerListLabel = PvpTranslations.get( 'domination_ranking_player_list_label' ),
        pointsSuffix = PvpTranslations.get( 'domination_ranking_points_suffix' ),
        hoursShort = PvpTranslations.get( 'domination_ranking_hours_short' ),
        minutesShort = PvpTranslations.get( 'domination_ranking_minutes_short' ),
    }
end

---@param condition fun(): boolean
---@param timeoutMs integer
---@return boolean success
local function WaitForRankingBoardCondition( condition, timeoutMs )
    local timeoutAt = GetGameTimer() + timeoutMs

    while not condition() do
        if GetGameTimer() >= timeoutAt then
            return false
        end

        Wait( 0 )
    end

    return true
end

---@param point any
---@return number? x
---@return number? y
---@return number? z
---@return number? heading
local function ReadRankingBoardPoint( point )
    local pointType = type( point )

    if pointType == 'vector2' then
        return point.x, point.y, nil, nil
    end

    if pointType == 'vector4' then
        return point.x, point.y, point.z, point.w
    end

    if pointType == 'vector3' then
        return point.x, point.y, point.z, nil
    end

    if pointType ~= 'table' then
        return nil, nil, nil, nil
    end

    return tonumber( point.x or point[ 1 ] ),
        tonumber( point.y or point[ 2 ] ),
        tonumber( point.z or point[ 3 ] ),
        tonumber( point.w or point.heading or point[ 4 ] )
end

---@param rotation vector3
---@return number directionX
---@return number directionY
---@return number directionZ
local function GetRankingBoardCameraDirection( rotation )
    local yaw = math.rad( rotation.z )
    local pitch = math.rad( rotation.x )
    local horizontal = math.abs( math.cos( pitch ) )
    local directionX = -math.sin( yaw ) * horizontal
    local directionY = math.cos( yaw ) * horizontal
    local directionZ = math.sin( pitch )

    return directionX, directionY, directionZ
end

---@param quad DominationRankingBoardQuad
---@param zone DominationRankingBoardZone
---@param camCoords vector3
---@return boolean success
local function UpdateRankingBoardQuad( quad, zone, camCoords )
    local normalX
    local normalY

    if zone.heading ~= nil then
        local headingRadians = math.rad( zone.heading )

        normalX = -math.sin( headingRadians )
        normalY = math.cos( headingRadians )
    else
        local directionX = camCoords.x - zone.x
        local directionY = camCoords.y - zone.y
        local directionLength = math.sqrt(
            directionX * directionX + directionY * directionY
        )

        if directionLength < 0.001 then
            return false
        end

        normalX = directionX / directionLength
        normalY = directionY / directionLength
    end

    local rightX = -normalY
    local rightY = normalX
    local halfWidth = RANKING_BOARD_WORLD_WIDTH * 0.5
    local halfHeight = RANKING_BOARD_WORLD_HEIGHT * 0.5
    local centerX = zone.x + rightX * zone.horizontalOffset
    local centerY = zone.y + rightY * zone.horizontalOffset

    quad.centerX = centerX
    quad.centerY = centerY
    quad.centerZ = zone.z
    quad.rightX = rightX
    quad.rightY = rightY
    quad.normalX = normalX
    quad.normalY = normalY
    quad.leftX = centerX - rightX * halfWidth
    quad.leftY = centerY - rightY * halfWidth
    quad.rightEdgeX = centerX + rightX * halfWidth
    quad.rightEdgeY = centerY + rightY * halfWidth
    quad.topZ = zone.z + halfHeight
    quad.bottomZ = zone.z - halfHeight

    return true
end

---@param cursorX number
---@param cursorY number
---@param quad DominationRankingBoardQuad
---@return number? textureX
---@return number? textureY
---@return number? rayDistance
local function MapRankingBoardCursor( cursorX, cursorY, quad )
    local rayOrigin, rayDirection = GetWorldCoordFromScreenCoord(
        cursorX,
        cursorY
    )

    if not rayOrigin or not rayDirection then
        return nil, nil
    end

    local denominator = rayDirection.x * quad.normalX
        + rayDirection.y * quad.normalY

    if math.abs( denominator ) < 0.000001 then
        return nil, nil
    end

    local toPlaneX = quad.centerX - rayOrigin.x
    local toPlaneY = quad.centerY - rayOrigin.y
    local rayDistance = (
        toPlaneX * quad.normalX
        + toPlaneY * quad.normalY
    ) / denominator

    if rayDistance < 0.0 then
        return nil, nil
    end

    local hitX = rayOrigin.x + rayDirection.x * rayDistance
    local hitY = rayOrigin.y + rayDirection.y * rayDistance
    local hitZ = rayOrigin.z + rayDirection.z * rayDistance
    local localX = ( hitX - quad.centerX ) * quad.rightX
        + ( hitY - quad.centerY ) * quad.rightY
    local localZ = hitZ - quad.centerZ
    local textureX = localX / RANKING_BOARD_WORLD_WIDTH + 0.5
    local textureY = 0.5 - localZ / RANKING_BOARD_WORLD_HEIGHT

    if textureX < 0.0
        or textureX > 1.0
        or textureY < 0.0
        or textureY > 1.0
    then
        return nil, nil
    end

    return textureX, textureY, rayDistance
end

---@param cursorX number
---@param cursorY number
---@return DominationRankingBoardRenderer? renderer
---@return number? textureX
---@return number? textureY
local function GetRankingBoardInteractionTarget( cursorX, cursorY )
    local frame = GetFrameCount()

    if frame == gDominationRankingBoardInteractionFrame
        and cursorX == gDominationRankingBoardInteractionCursorX
        and cursorY == gDominationRankingBoardInteractionCursorY
    then
        return gDominationRankingBoardInteractionTarget,
            gDominationRankingBoardInteractionTextureX,
            gDominationRankingBoardInteractionTextureY
    end

    local targetRenderer = nil
    local targetTextureX = nil
    local targetTextureY = nil
    local nearestRayDistance = math.huge

    for _, renderer in ipairs( gDominationRankingBoardRenderers ) do
        local canInteract = renderer.visible
            and renderer.textureReady
            and renderer.textureDui ~= nil
            and renderer.visibleZone ~= nil
            and renderer.renderQuadZone == renderer.visibleZone
            and renderer.visibleZoneDistanceSquared <= renderer.interactionDistanceSquared
            and ( not renderer.shouldInteract or renderer.shouldInteract() )

        if canInteract then
            local textureX, textureY, rayDistance = MapRankingBoardCursor(
                cursorX,
                cursorY,
                renderer.renderQuad
            )

            if rayDistance and rayDistance < nearestRayDistance then
                targetRenderer = renderer
                targetTextureX = textureX
                targetTextureY = textureY
                nearestRayDistance = rayDistance
            end
        end
    end

    gDominationRankingBoardInteractionFrame = frame
    gDominationRankingBoardInteractionCursorX = cursorX
    gDominationRankingBoardInteractionCursorY = cursorY
    gDominationRankingBoardInteractionTarget = targetRenderer
    gDominationRankingBoardInteractionTextureX = targetTextureX
    gDominationRankingBoardInteractionTextureY = targetTextureY

    return targetRenderer, targetTextureX, targetTextureY
end

---@param value any
---@return number normalizedValue
local function NormalizeRankingValue( value )
    return math.max( 0, tonumber( value ) or 0 )
end

---@param result table?
---@return table[] organizations
local function BuildRankingBoardOrganizations( result )
    if type( result ) ~= 'table' then
        return {}
    end

    local organizations = {}
    local entryById = {}
    local currentEntryId = result.currentEntryId and tostring( result.currentEntryId ) or nil

    ---@param entry table?
    ---@param forceCurrent? boolean
    local function appendOrganization( entry, forceCurrent )
        if type( entry ) ~= 'table' or entry.id == nil then
            return
        end

        local id = tostring( entry.id )
        local existing = entryById[ id ]

        if existing then
            if forceCurrent or id == currentEntryId then
                existing.isCurrent = true
            end

            return
        end

        local organization = {
            id = id,
            name = tostring( entry.name or 'Organizacao' ),
            shortName = type( entry.shortName ) == 'string' and entry.shortName or nil,
            banner = type( entry.banner ) == 'string' and entry.banner or nil,
            position = math.floor( NormalizeRankingValue( entry.position or entry.rank ) ),
            points = NormalizeRankingValue( entry.score or entry.points ),
            kills = NormalizeRankingValue( entry.kills ),
            captures = NormalizeRankingValue( entry.captures or entry.victories ),
            controlTimeSeconds = NormalizeRankingValue( entry.controlTimeSeconds ),
            isCurrent = forceCurrent == true or id == currentEntryId,
        }

        organizations[ #organizations + 1 ] = organization
        entryById[ id ] = organization
    end

    for _, entry in ipairs( result.players or {} ) do
        appendOrganization( entry, false )
    end

    appendOrganization( result.currentPlayer, true )

    return organizations
end

---@param result table?
---@return table[] players
local function BuildRankingBoardPlayers( result )
    if type( result ) ~= 'table' then
        return {}
    end

    local players = {}
    local entryById = {}
    local currentEntryId = result.currentEntryId and tostring( result.currentEntryId ) or nil

    ---@param entry table?
    ---@param forceCurrent? boolean
    local function appendPlayer( entry, forceCurrent )
        if type( entry ) ~= 'table' or entry.id == nil then
            return
        end

        local id = tostring( entry.id )
        local existing = entryById[ id ]

        if existing then
            if forceCurrent or id == currentEntryId then
                existing.isCurrent = true
            end

            return
        end

        local player = {
            id = id,
            name = tostring( entry.name or 'Jogador' ),
            avatar = type( entry.avatar ) == 'string' and entry.avatar or nil,
            position = math.floor( NormalizeRankingValue( entry.position or entry.rank ) ),
            points = NormalizeRankingValue( entry.score or entry.points ),
            kills = NormalizeRankingValue( entry.kills ),
            assists = NormalizeRankingValue( entry.assists ),
            revives = NormalizeRankingValue( entry.revives ),
            captures = NormalizeRankingValue( entry.captures or entry.victories ),
            isCurrent = forceCurrent == true or id == currentEntryId,
        }

        players[ #players + 1 ] = player
        entryById[ id ] = player
    end

    for _, entry in ipairs( result.players or {} ) do
        appendPlayer( entry, false )
    end

    appendPlayer( result.currentPlayer, true )

    return players
end

---@param scope 'organizations'|'players'
---@param result table?
---@return table[] entries
local function BuildRankingBoardEntries( scope, result )
    if scope == 'players' then
        return BuildRankingBoardPlayers( result )
    end

    return BuildRankingBoardOrganizations( result )
end

---@param options DominationRankingBoardRendererOptions?
function DominationRankingBoardRenderer:__init( options )
    options = options or {}

    self.zones = {}
    self.visibleZone = nil
    self.visible = false
    self.revision = 0
    self.texturePage = tostring(
        options.texturePage or 'web/domination-capture-point.html'
    )
    self.rankingScope = options.rankingScope == 'players'
        and 'players'
        or 'organizations'
    self.placementKey = tostring( options.placementKey or self.rankingScope )
    self.horizontalOffset = tonumber( options.horizontalOffset ) or 0.0
    self.textureDictionaryPrefix = tostring(
        options.textureDictionaryPrefix
            or ( 'domination_ranking_board_%s' ):format( self.rankingScope )
    )
    self.drawDistance = math.max(
        10.0,
        tonumber( options.drawDistance ) or RANKING_BOARD_DRAW_DISTANCE
    )
    self.drawDistanceSquared = self.drawDistance * self.drawDistance
    self.visibleZoneDistanceSquared = self.drawDistanceSquared
    self.interactionDistance = math.max(
        1.0,
        tonumber( options.interactionDistance ) or RANKING_BOARD_INTERACTION_DISTANCE
    )
    self.interactionDistanceSquared = self.interactionDistance
        * self.interactionDistance
    self.heightOffset = tonumber( options.heightOffset ) or RANKING_BOARD_HEIGHT_OFFSET
    self.shouldRender = options.shouldRender
    self.shouldInteract = options.shouldInteract
    self.textureDui = nil
    self.textureDictionary = nil
    self.runtimeTxd = nil
    self.textureReady = false
    self.textureCreating = false
    self.textureRevision = 0
    self.textureVisible = nil
    self.rankingEntries = {}
    self.rankingExpiresAt = 0
    self.rankingRequestInFlight = false
    self.mouseActive = false
    self.mouseDown = false
    self.mouseInside = false
    self.mouseX = nil
    self.mouseY = nil
    self.screenWidth = 0
    self.screenHeight = 0
    self.screenResolutionExpiresAt = 0
    self.renderQuad = {
        centerX = 0.0,
        centerY = 0.0,
        centerZ = 0.0,
        rightX = 0.0,
        rightY = 0.0,
        normalX = 0.0,
        normalY = 0.0,
        leftX = 0.0,
        leftY = 0.0,
        rightEdgeX = 0.0,
        rightEdgeY = 0.0,
        topZ = 0.0,
        bottomZ = 0.0,
    }
    self.renderQuadZone = nil
    self.renderQuadCameraX = 0.0
    self.renderQuadCameraY = 0.0
    gDominationRankingBoardRenderers[ #gDominationRankingBoardRenderers + 1 ] = self
end

---@private
---@param payload table
function DominationRankingBoardRenderer:_sendMessage( payload )
    if self.textureDui then
        SendDuiMessage( self.textureDui, json.encode( payload ) )
    end
end

---@private
---@param visible boolean
---@param force? boolean
function DominationRankingBoardRenderer:_setTextureVisible( visible, force )
    visible = visible == true

    if not self.textureDui or ( not force and self.textureVisible == visible ) then
        return
    end

    self.textureVisible = visible
    self:_sendMessage( { action = 'setVisible', visible = visible } )
end

---@private
function DominationRankingBoardRenderer:_sendRankingData()
    self:_sendMessage( {
        action = 'setRankingData',
        rankingScope = self.rankingScope,
        entries = self.rankingEntries,
    } )
end

---@private
function DominationRankingBoardRenderer:_syncTexture()
    if not self.textureDui then
        return
    end

    self:_sendMessage( {
        action = 'setMode',
        mode = 'ranking',
        rankingScope = self.rankingScope,
        cityName = GetRankingBoardCityName(),
        localization = GetRankingBoardLocalization(),
    } )
    self:_sendRankingData()
    self:_setTextureVisible( self.visible and self.visibleZone ~= nil, true )
end

---@private
function DominationRankingBoardRenderer:_clearMouseInteraction()
    if self.textureDui and self.mouseDown then
        SendDuiMouseUp( self.textureDui, 'left' )
    end

    if self.textureDui and self.mouseInside then
        SendDuiMouseMove( self.textureDui, -1, -1 )
    end

    self.mouseDown = false
    self.mouseInside = false
    self.mouseX = nil
    self.mouseY = nil
end

---@private
function DominationRankingBoardRenderer:_releaseMouse()
    self:_clearMouseInteraction()
    self.mouseActive = false
end

---@private
function DominationRankingBoardRenderer:_destroyTexture()
    self:_releaseMouse()
    self.textureRevision = self.textureRevision + 1
    self.textureCreating = false
    self.textureReady = false
    self.textureVisible = nil

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
function DominationRankingBoardRenderer:_ensureTexture()
    if self.textureReady or self.textureCreating then
        return
    end

    self.textureCreating = true
    self.textureRevision = self.textureRevision + 1

    local revision = self.textureRevision

    CreateThread( function()
        gDominationRankingBoardTextureGeneration =
            gDominationRankingBoardTextureGeneration + 1

        local generation = gDominationRankingBoardTextureGeneration
        local textureDictionary = ( '%s_%d' ):format(
            self.textureDictionaryPrefix,
            generation
        )
        local textureUrl = ( 'nui://%s/%s?gen=%d' ):format(
            GetCurrentResourceName(),
            self.texturePage,
            generation
        )
        local dui = gRenderNatives.CreateDui(
            textureUrl,
            RANKING_BOARD_TEXTURE_WIDTH,
            RANKING_BOARD_TEXTURE_HEIGHT
        )

        if not dui or dui == 0 then
            self.textureCreating = false
            sx.logger:error( 'DominationRankingBoardRenderer: CreateDui falhou' )
            return
        end

        if self.textureRevision ~= revision then
            gRenderNatives.DestroyDui( dui )
            return
        end

        self.textureDui = dui
        self.textureDictionary = textureDictionary

        local duiAvailable = WaitForRankingBoardCondition( function()
            return self.textureRevision ~= revision or IsDuiAvailable( dui )
        end, RANKING_BOARD_TEXTURE_TIMEOUT_MS )

        if self.textureRevision ~= revision then
            return
        end

        if not duiAvailable then
            sx.logger:error( 'DominationRankingBoardRenderer: DUI nao ficou disponivel' )
            self:_destroyTexture()
            return
        end

        local runtimeTxd = gRenderNatives.CreateRuntimeTxd( textureDictionary )

        gRenderNatives.CreateRuntimeTextureFromDuiHandle(
            runtimeTxd,
            RANKING_BOARD_TEXTURE_NAME,
            GetDuiHandle( dui )
        )
        RequestStreamedTextureDict( textureDictionary, false )
        self.runtimeTxd = runtimeTxd

        local textureLoaded = WaitForRankingBoardCondition( function()
            if self.textureRevision ~= revision then
                return true
            end

            local width, height = table.unpack( GetTextureResolution(
                textureDictionary,
                RANKING_BOARD_TEXTURE_NAME
            ) )

            return HasStreamedTextureDictLoaded( textureDictionary )
                and width >= RANKING_BOARD_MIN_TEXTURE_RESOLUTION
                and height >= RANKING_BOARD_MIN_TEXTURE_RESOLUTION
        end, RANKING_BOARD_TEXTURE_TIMEOUT_MS )

        if self.textureRevision ~= revision then
            return
        end

        if not textureLoaded then
            sx.logger:error( 'DominationRankingBoardRenderer: runtime texture nao carregou' )
            self:_destroyTexture()
            return
        end

        Wait( RANKING_BOARD_TEXTURE_SETTLE_MS )

        if self.textureRevision ~= revision then
            return
        end

        self.textureCreating = false
        self.textureReady = true
        self:_syncTexture()
    end )
end

---@private
function DominationRankingBoardRenderer:_requestRanking()
    local now = GetGameTimer()

    if self.rankingRequestInFlight or now < self.rankingExpiresAt then
        return
    end

    self.rankingRequestInFlight = true
    self.rankingExpiresAt = now + RANKING_BOARD_RETRY_MS

    CreateThread( function()
        local succeeded, result = pcall( function()
            return RPC.pvp_getRanking(
                'domination',
                1,
                RANKING_BOARD_PER_PAGE,
                self.rankingScope
            )
        end )

        self.rankingRequestInFlight = false

        if not succeeded or type( result ) ~= 'table' then
--             sx.logger:warn( ( 'DominationRankingBoardRenderer: falha ao buscar ranking scope=%s error=%s' ):format(
--                 self.rankingScope,
--                 tostring( result )
--             ) )
            return
        end

        self.rankingEntries = BuildRankingBoardEntries( self.rankingScope, result )
        self.rankingExpiresAt = GetGameTimer()
            + RANKING_BOARD_REFRESH_MS
            + math.random( 0, RANKING_BOARD_REFRESH_JITTER_MS )
        self:_sendRankingData()
    end )
end

---@param zones table[]
function DominationRankingBoardRenderer:setZones( zones )
    assert( type( zones ) == 'table', 'DominationRankingBoardRenderer precisa de zones' )

    self.zones = {}
    self.visibleZone = nil
    self.visibleZoneDistanceSquared = self.drawDistanceSquared

    for _, zone in ipairs( zones ) do
        if zone.type == 'safe' and zone.id ~= nil then
            local zoneId = tostring( zone.id )
            local placement = type( zone.rankingBoards ) == 'table'
                and zone.rankingBoards[ self.placementKey ]
                or nil
            local anchor = placement or zone.rankingBoardAnchor or zone.center
            local centerX, centerY, centerZ, heading = ReadRankingBoardPoint( anchor )
            local cachedBaseZ = gDominationRankingBoardBaseZByZoneId[ zoneId ]
            local fixedHeight = placement ~= nil and centerZ ~= nil
            local heightReady = fixedHeight or cachedBaseZ ~= nil

            if centerX and centerY then
                self.zones[ #self.zones + 1 ] = {
                    id = zoneId,
                    x = centerX,
                    y = centerY,
                    z = fixedHeight
                        and ( centerZ + self.heightOffset )
                        or ( heightReady and ( cachedBaseZ + self.heightOffset ) or 0.0 ),
                    heightReady = heightReady,
                    fixedHeight = fixedHeight,
                    heading = placement and heading or nil,
                    horizontalOffset = placement and 0.0 or self.horizontalOffset,
                }
            end
        end
    end

    self:_refreshVisibleZone()
end

---@private
function DominationRankingBoardRenderer:_refreshVisibleZone()
    local previousZone = self.visibleZone

    self.visibleZone = nil
    self.visibleZoneDistanceSquared = self.drawDistanceSquared

    if not self.visible or ( self.shouldRender and not self.shouldRender() ) then
        self:_setTextureVisible( false )
        self:_releaseMouse()
        return
    end

    local ped = PlayerPedId()

    if ped == 0
        or not DoesEntityExist( ped )
        or IsPedInAnyVehicle( ped, false )
    then
        self:_setTextureVisible( false )
        self:_releaseMouse()
        return
    end

    local position = GetEntityCoords( ped )
    local nearestDistanceSquared = self.drawDistanceSquared

    for _, zone in ipairs( self.zones ) do
        local deltaX = zone.x - position.x
        local deltaY = zone.y - position.y
        local distanceSquared = deltaX * deltaX + deltaY * deltaY

        if distanceSquared <= nearestDistanceSquared then
            nearestDistanceSquared = distanceSquared
            self.visibleZone = zone
        end
    end

    if self.visibleZone then
        self.visibleZoneDistanceSquared = nearestDistanceSquared
        self:_ensureTexture()
        self:_requestRanking()

        if self.visibleZone.heightReady then
            self:_setTextureVisible( true )
        else
            ScheduleRankingBoardHeightSample( self.visibleZone.id )
            self:_setTextureVisible( false )
            self:_releaseMouse()
        end
    else
        self:_setTextureVisible( false )
        self:_releaseMouse()
    end

    if previousZone ~= self.visibleZone then
        self:_releaseMouse()
    end
end

---@private
---@param now integer
---@return number? cursorX
---@return number? cursorY
function DominationRankingBoardRenderer:_getCursorPosition( now )
    if now >= self.screenResolutionExpiresAt then
        local screenWidth, screenHeight = GetActualScreenResolution()

        if screenWidth <= 0 or screenHeight <= 0 then
            return nil, nil
        end

        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.screenResolutionExpiresAt = now + 1000
    end

    local cursorPixelX, cursorPixelY = GetNuiCursorPosition()

    return cursorPixelX / self.screenWidth, cursorPixelY / self.screenHeight
end

---@private
---@param zone DominationRankingBoardZone
---@param distanceSquared number
---@param quad DominationRankingBoardQuad
---@param camCoords vector3
---@param now integer
function DominationRankingBoardRenderer:_updateMouse(
    zone,
    distanceSquared,
    quad,
    camCoords,
    now
)
    local interactionAllowed = distanceSquared <= self.interactionDistanceSquared
        and ( not self.shouldInteract or self.shouldInteract() )

    if not interactionAllowed then
        self:_releaseMouse()
        return
    end

    local toBoardX = quad.centerX - camCoords.x
    local toBoardY = quad.centerY - camCoords.y
    local toBoardZ = quad.centerZ - camCoords.z
    local toBoardLengthSquared = toBoardX * toBoardX
        + toBoardY * toBoardY
        + toBoardZ * toBoardZ
    local camForwardX, camForwardY, camForwardZ =
        GetRankingBoardCameraDirection( GetFinalRenderedCamRot( 2 ) )
    local facing = toBoardLengthSquared > 0.0
        and (
            toBoardX * camForwardX
            + toBoardY * camForwardY
            + toBoardZ * camForwardZ
        ) / math.sqrt( toBoardLengthSquared )
        or 1.0
    local onScreen = GetScreenCoordFromWorldCoord(
        quad.centerX,
        quad.centerY,
        quad.centerZ
    )

    if not onScreen or facing < RANKING_BOARD_FACING_MIN_DOT then
        self:_releaseMouse()
        return
    end

    local mouseOpening = not self.mouseActive

    SetMouseCursorActiveThisFrame()

    if mouseOpening then
        SetCursorLocation( 0.5, 0.5 )
        self.mouseActive = true
    end

    DisableControlAction( 0, 24, true )
    DisableControlAction( 0, 25, true )
    DisableControlAction( 0, 106, true )
    DisableControlAction( 0, 241, true )
    DisableControlAction( 0, 242, true )
    DisableControlAction( 0, 257, true )
    DisablePlayerFiring( PlayerId(), true )
    BlockWeaponWheelThisFrame()

    local cursorX, cursorY = self:_getCursorPosition( now )

    if not cursorX or not cursorY then
        self:_releaseMouse()
        return
    end

    local interactionTarget, textureX, textureY = GetRankingBoardInteractionTarget(
        cursorX,
        cursorY
    )

    if interactionTarget ~= self then
        self:_clearMouseInteraction()
        return
    end

    local inside = textureX ~= nil and textureY ~= nil

    if inside then
        local duiX = math.floor( math.max( 0.0, math.min( 1.0, textureX ) )
            * ( RANKING_BOARD_TEXTURE_WIDTH - 1 ) )
        local duiY = math.floor( math.max( 0.0, math.min( 1.0, textureY ) )
            * ( RANKING_BOARD_TEXTURE_HEIGHT - 1 ) )

        if duiX ~= self.mouseX or duiY ~= self.mouseY then
            SendDuiMouseMove( self.textureDui, duiX, duiY )
            self.mouseX = duiX
            self.mouseY = duiY
        end
    elseif self.mouseInside then
        SendDuiMouseMove( self.textureDui, -1, -1 )
        self.mouseX = nil
        self.mouseY = nil
    end

    self.mouseInside = inside

    if inside and IsDisabledControlJustPressed( 0, 24 ) then
        self.mouseDown = true
        SendDuiMouseDown( self.textureDui, 'left' )
    elseif self.mouseDown and IsDisabledControlJustReleased( 0, 24 ) then
        self.mouseDown = false
        SendDuiMouseUp( self.textureDui, 'left' )
    end

    if inside and IsDisabledControlJustPressed( 0, 241 ) then
        SendDuiMouseWheel( self.textureDui, RANKING_BOARD_MOUSE_WHEEL_STEP, 0 )
    elseif inside and IsDisabledControlJustPressed( 0, 242 ) then
        SendDuiMouseWheel( self.textureDui, -RANKING_BOARD_MOUSE_WHEEL_STEP, 0 )
    end
end

---@private
---@param quad DominationRankingBoardQuad
function DominationRankingBoardRenderer:_drawQuad( quad )
    DrawTexturedPoly(
        quad.leftX,
        quad.leftY,
        quad.bottomZ,
        quad.rightEdgeX,
        quad.rightEdgeY,
        quad.bottomZ,
        quad.rightEdgeX,
        quad.rightEdgeY,
        quad.topZ,
        255,
        255,
        255,
        255,
        self.textureDictionary,
        RANKING_BOARD_TEXTURE_NAME,
        0.0,
        1.0,
        0.0,
        1.0,
        1.0,
        0.0,
        1.0,
        0.0,
        0.0
    )
    DrawTexturedPoly(
        quad.leftX,
        quad.leftY,
        quad.bottomZ,
        quad.rightEdgeX,
        quad.rightEdgeY,
        quad.topZ,
        quad.leftX,
        quad.leftY,
        quad.topZ,
        255,
        255,
        255,
        255,
        self.textureDictionary,
        RANKING_BOARD_TEXTURE_NAME,
        0.0,
        1.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
    )
end

---@private
---@param zone DominationRankingBoardZone
---@param now integer
function DominationRankingBoardRenderer:_drawZone( zone, now )
    if not zone.heightReady or not self.textureReady or not self.textureDictionary then
        return
    end

    local camCoords = GetFinalRenderedCamCoord()
    local shouldUpdateQuad = self.renderQuadZone ~= zone
        or self.renderQuad.centerZ ~= zone.z
        or (
            zone.heading == nil
            and (
                math.abs( camCoords.x - self.renderQuadCameraX ) > 0.001
                or math.abs( camCoords.y - self.renderQuadCameraY ) > 0.001
            )
        )

    if shouldUpdateQuad then
        if not UpdateRankingBoardQuad( self.renderQuad, zone, camCoords ) then
            self:_releaseMouse()
            return
        end

        self.renderQuadZone = zone
        self.renderQuadCameraX = camCoords.x
        self.renderQuadCameraY = camCoords.y
    end

    self:_drawQuad( self.renderQuad )
    self:_updateMouse(
        zone,
        self.visibleZoneDistanceSquared,
        self.renderQuad,
        camCoords,
        now
    )
end

function DominationRankingBoardRenderer:show()
    if self.visible then
        return
    end

    self.visible = true
    self.revision = self.revision + 1
    self:_refreshVisibleZone()

    local revision = self.revision
    local diagnosticLoop = DminigamesRenderDiagnostics.LoopStarted( 'rankings', self )

    CreateThread( function()
        local nextCullAt = 0

        while self.visible and self.revision == revision do
            local now = GetGameTimer()

            if now >= nextCullAt then
                self:_refreshVisibleZone()
                nextCullAt = now + RANKING_BOARD_CULL_INTERVAL_MS
            end

            if not self.visibleZone or not self.visibleZone.heightReady then
                Wait( RANKING_BOARD_CULL_INTERVAL_MS )
            else
                self:_drawZone( self.visibleZone, now )
                Wait( 0 )
            end
        end

        self:_releaseMouse()
        DminigamesRenderDiagnostics.LoopFinished( diagnosticLoop )
    end )
end

function DominationRankingBoardRenderer:hide()
    DminigamesRenderDiagnostics.LoopsStopping( self )
    self.visible = false
    self.revision = self.revision + 1
    self.visibleZone = nil
    self.renderQuadZone = nil
    self:_setTextureVisible( false )
    self:_releaseMouse()
end

function DominationRankingBoardRenderer:destroy()
    self:hide()
    self:_destroyTexture()
    self.zones = {}
    self.rankingEntries = {}
    self.rankingExpiresAt = 0
    self.rankingRequestInFlight = false

    for index = #gDominationRankingBoardRenderers, 1, -1 do
        if gDominationRankingBoardRenderers[ index ] == self then
            table.remove( gDominationRankingBoardRenderers, index )
            break
        end
    end
end
