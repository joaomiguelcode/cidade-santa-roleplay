local gRenderNatives = DminigamesRenderDiagnostics.Natives( 'minimap' )

---@class MapZoneRendererZone
---@field id string|number Identificador estável da zona
---@field shape? string 'polygon' | 'circle' (default 'polygon')
---@field points? table Polígono em coordenadas do mundo (vector2 ou {x, y})
---@field center? table Centro do círculo em coordenadas do mundo (vector2/vector3 ou {x, y})
---@field radius? number Raio do círculo em metros
---@field boundaryPoints? table Circunferência visual compartilhada com o boundary 3D
---@field color number[] Cor RGB da zona {r, g, b}
---@field type string 'capture' | 'safe'
---@field state string 'neutral' | 'capturing' | 'contested' | 'controlled' | 'safe'
---@field name string Título pronto para exibição (traduzido no servidor)
---@field status string Texto de status pronto para exibição (traduzido no servidor)
---@field remainingMs? number Tempo restante recebido na última transição do servidor
---@field remainingSyncedAt? number Instante local da última sincronização do cronômetro
---@field circleMotion? MapZoneCircleMotion Movimento opt-in, separado da geometria da projecao
---@field circleMotionSyncedAt? number Instante local da transicao do circulo
---@field fillOutside? boolean Pinta a area externa do circulo, preservando o interior transparente
---@field circleMotionFrameIntervalMs? number Intervalo minimo de pintura do circulo em movimento na DUI

---@class MapZoneCircle
---@field center {x: number, y: number, z: number}
---@field radius number

---@class MapZoneCircleMotion
---@field from MapZoneCircle
---@field target MapZoneCircle
---@field durationMs number
---@field elapsedMs number
---@field paused boolean
---@field phase 'waiting'|'closing'|'finished'

---@class MapZoneRendererOptions
---@field loaderFile string? Arquivo .gfx do loader de overlays (default do framework)
---@field textureDictionaryPrefix string? Prefixo único do runtime TXD (um por consumidor)
---@field canvasSize number? Resolução da DUI de cada página (default 2048)
---@field horizontalPadding number? Folga horizontal por zona em metros (default 64)
---@field bottomPadding number? Folga inferior por zona em metros (default 24)
---@field topPadding number? Folga superior por zona em metros para o título (default 104)
---@field circleSegments number? Quantidade de pontos usada para desenhar círculos (default 64, min 16, max 128)
---@field maxWindowSpan number? Maior lado permitido (em metros) para a janela de uma página; zonas mais distantes que isso ganham outra página/DUI (default 2700)
---@field projectionZones MapZoneRendererZone[]? Pool usado somente para fixar a janela mundial; exige pagina unica (maxWindowSpan=math.huge)

---@class MapZoneRendererPage
---@field zones MapZoneRendererZone[] Zonas atribuídas à página
---@field zoneIdsKey string Assinatura das zonas (ids ordenados) para reuso
---@field windowBounds table Janela mundial coberta pela página
---@field dui number? Handle da DUI
---@field textureDictionary string? Runtime TXD da página
---@field textureName string?
---@field runtimeTxd number?
---@field textureReady boolean
---@field overlayIndex number? Índice do filho no loader Scaleform
---@field overlayBounds table? Ultima janela aplicada ao overlay

local MAP_ZONE_LOADER_FILE = 'files/decibelsz_santagroup_zoneprojector.gfx'
local MAP_ZONE_RENDERER_PAGE = 'web/map-zone-overlay.html'
local MAP_ZONE_LOAD_TIMEOUT_MS = 5000
local MAP_ZONE_OVERLAY_INIT_DELAY_MS = 100
local MAP_ZONE_TEXTURE_SETTLE_MS = 150
local MAP_ZONE_TEXTURE_MIN_RESOLUTION = 32
local MAP_ZONE_FULL_TEXTURE_MODE = 1
local MAP_ZONE_CANVAS_SIZE = 2048
local MAP_ZONE_HORIZONTAL_PADDING = 64.0
local MAP_ZONE_BOTTOM_PADDING = 24.0
local MAP_ZONE_TOP_PADDING = 104.0
local MAP_ZONE_CIRCLE_SEGMENTS = 64
local MAP_ZONE_MIN_CIRCLE_SEGMENTS = 16
local MAP_ZONE_MAX_CIRCLE_SEGMENTS = 128
local MAP_ZONE_MAX_WINDOW_SPAN = 2700.0

local mapZoneTextureGeneration = 0

---@param value any
---@return boolean finite
local function IsFiniteNumber( value )

    return type( value ) == 'number' and value == value and value > -math.huge and value < math.huge
end

---@param circle any
---@return MapZoneCircle? normalized
local function NormalizeMotionCircle( circle )

    if type( circle ) ~= 'table' or type( circle.center ) ~= 'table' then return nil end

    local center = circle.center

    if not IsFiniteNumber( center.x ) or not IsFiniteNumber( center.y ) or not IsFiniteNumber( center.z )
        or not IsFiniteNumber( circle.radius ) or circle.radius < 0
    then
        return nil
    end

    return { center = { x = center.x, y = center.y, z = center.z }, radius = circle.radius }
end

---@param first MapZoneCircle
---@param second MapZoneCircle
---@return boolean equal
local function AreMotionCirclesEqual( first, second )

    return first.radius == second.radius and first.center.x == second.center.x
        and first.center.y == second.center.y and first.center.z == second.center.z
end

---@param condition fun(): boolean
---@param timeoutMs number
---@return boolean success
local function waitForCondition(condition, timeoutMs)
    local timeoutAt = GetGameTimer() + timeoutMs

    while not condition() do
        if GetGameTimer() >= timeoutAt then
            return false
        end

        Wait(0)
    end

    return true
end

---@param boundsA table
---@param boundsB table
---@return table merged
local function mergeBounds(boundsA, boundsB)
    return {
        minX = math.min(boundsA.minX, boundsB.minX),
        minY = math.min(boundsA.minY, boundsB.minY),
        maxX = math.max(boundsA.maxX, boundsB.maxX),
        maxY = math.max(boundsA.maxY, boundsB.maxY),
    }
end

---@param bounds table
---@return number span Maior lado da janela em metros
local function boundsSpan(bounds)
    return math.max(bounds.maxX - bounds.minX, bounds.maxY - bounds.minY)
end

---@param zones MapZoneRendererZone[]
---@return string key
local function buildZoneIdsKey(zones)
    local ids = {}

    for zoneIndex, zone in ipairs(zones) do
        ids[zoneIndex] = tostring(zone.id)
    end

    table.sort(ids)
    return table.concat(ids, ',')
end

---Renderer de zonas animadas no radar e no mapa de pausa.
---As zonas são agrupadas automaticamente em páginas por proximidade
---geográfica: cada página tem a própria DUI cobrindo somente a sua janela
---mundial e um overlay do minimapa esticando essa textura sobre a janela.
---Assim regiões distantes (cidade, Sandy, Paleto...) mantêm nitidez no zoom.
---Os textos (name/status) chegam prontos do servidor; a classe não traduz.
---@class MapZoneRenderer
---@field zones MapZoneRendererZone[] Zonas normalizadas atuais
---@field visible boolean Se as zonas estão visíveis no mapa
---@field lifecycleRevision integer
---@field projectionBounds table? Janela fixa calculada do pool de referencia
MapZoneRenderer = class()

---@param options MapZoneRendererOptions?
function MapZoneRenderer:__init(options)
    options = options or {}

    local circleSegments = tonumber(options.circleSegments) or MAP_ZONE_CIRCLE_SEGMENTS

    self.loaderFile = options.loaderFile or MAP_ZONE_LOADER_FILE
    self.textureDictionaryPrefix = options.textureDictionaryPrefix or 'dmg_zonemap'
    self.canvasSize = options.canvasSize or MAP_ZONE_CANVAS_SIZE
    self.horizontalPadding = options.horizontalPadding or MAP_ZONE_HORIZONTAL_PADDING
    self.bottomPadding = options.bottomPadding or MAP_ZONE_BOTTOM_PADDING
    self.topPadding = options.topPadding or MAP_ZONE_TOP_PADDING
    self.maxWindowSpan = tonumber(options.maxWindowSpan) or MAP_ZONE_MAX_WINDOW_SPAN
    self.circleSegments = math.min(
        MAP_ZONE_MAX_CIRCLE_SEGMENTS,
        math.max(MAP_ZONE_MIN_CIRCLE_SEGMENTS, math.floor(circleSegments))
    )

    self.overlayHandle = -1
    self.nextOverlayIndex = 0
    self.zones = {}
    self.pages = {}
    self.visible = false
    self.lifecycleRevision = 0

    if options.projectionZones then
        assert(self.maxWindowSpan == math.huge, 'projectionZones requires a single map page')

        for _, definition in ipairs(options.projectionZones) do
            local zone = self:_normalizeZone(definition)

            if #zone.points >= 3 then
                local bounds = self:_computeZoneBounds(zone)
                self.projectionBounds = self.projectionBounds and mergeBounds(self.projectionBounds, bounds) or bounds
            end
        end
    end
end

---Define o conjunto completo de zonas exibidas. Pode ser chamado com o
---renderer ativo: páginas compatíveis são reutilizadas e redesenhadas; se o
---agrupamento mudar, as páginas são reconstruídas.
---@param zones MapZoneRendererZone[]
function MapZoneRenderer:setZones(zones)
    self.zones = {}

    for zoneIndex = 1, #(zones or {}) do
        local zone = self:_normalizeZone(zones[zoneIndex])

        if #zone.points >= 3 then
            self.zones[#self.zones + 1] = zone
        end
    end

    local clusters = self:_computeClusters()

    if #self.pages > 0 and self:_reusePagesForClusters(clusters) then
        return
    end

    local wasVisible = self.visible

    self:_teardownPages()
    self.pendingClusters = clusters

    if wasVisible then
        self:show()
    end
end

---Atualiza campos de uma zona existente (state, status, name, color) sem
---recriar DUI ou overlay. Ideal para mudanças de estado durante a partida.
---@param zoneId string|number
---@param updates table Campos a sobrescrever
---@return boolean updated
function MapZoneRenderer:updateZone(zoneId, updates)
    for _, zone in ipairs(self.zones) do
        if zone.id == zoneId then
            local shouldSyncRemaining = updates
                and (updates.remainingMs ~= nil or updates.state ~= nil)

            for key, value in pairs(updates or {}) do
                if key ~= 'id'
                    and key ~= 'shape'
                    and key ~= 'points'
                    and key ~= 'boundaryPoints'
                    and key ~= 'center'
                    and key ~= 'radius'
                    and key ~= 'circleMotion'
                    and key ~= 'circleMotionSyncedAt'
                then
                    zone[key] = value
                end
            end

            if shouldSyncRemaining then
                zone.remainingSyncedAt = GetGameTimer()
            end

            self:_pushPageOfZone(zoneId)
            return true
        end
    end

    return false
end

---Move somente o desenho do circulo dentro da projecao fixa existente.
---O caller envia transicoes, nunca snapshots por frame nem novas geometrias.
---@param zoneId string|number
---@param motion MapZoneCircleMotion
---@return boolean updated
function MapZoneRenderer:SetCircleMotion( zoneId, motion )

    if self.maxWindowSpan ~= math.huge or type( motion ) ~= 'table'
        or not IsFiniteNumber( motion.durationMs ) or motion.durationMs < 0
        or not IsFiniteNumber( motion.elapsedMs ) or motion.elapsedMs < 0
        or type( motion.paused ) ~= 'boolean'
        or ( motion.phase ~= 'waiting' and motion.phase ~= 'closing' and motion.phase ~= 'finished' )
    then
        return false
    end

    local from = NormalizeMotionCircle( motion.from )
    local target = NormalizeMotionCircle( motion.target )

    if not from or not target then return false end

    local elapsedMs = math.min( motion.elapsedMs, motion.durationMs )

    for _, zone in ipairs( self.zones ) do
        if zone.id == zoneId and zone.shape == 'circle' then
            local previous = zone.circleMotion

            if previous and previous.durationMs == motion.durationMs and previous.elapsedMs == elapsedMs
                and previous.paused == motion.paused and previous.phase == motion.phase
                and AreMotionCirclesEqual( previous.from, from ) and AreMotionCirclesEqual( previous.target, target )
            then
                return true
            end

            zone.circleMotion = {
                from = from, target = target, durationMs = motion.durationMs, elapsedMs = elapsedMs,
                paused = motion.paused, phase = motion.phase,
            }
            zone.circleMotionSyncedAt = GetGameTimer()
            self:_pushPageOfZone( zoneId )
            return true
        end
    end

    return false
end

---Cria (se necessário) as páginas, DUIs e overlays, e exibe as zonas.
---@return boolean success
function MapZoneRenderer:show()
    if #self.zones == 0 then
        self:_logError('show() chamado sem zonas definidas')
        return false
    end

    local lifecycleRevision = self.lifecycleRevision

    if not self:_ensureOverlayHandle() then
        return false
    end

    if self.lifecycleRevision ~= lifecycleRevision then
        self:destroy()
        return false
    end

    if not self:_ensurePages() then
        return false
    end

    if self.lifecycleRevision ~= lifecycleRevision then
        self:destroy()
        return false
    end

    for _, page in ipairs(self.pages) do
        self:_pushPage(page)
        self:_setPageAnimationVisible(page, true)
        self:_syncPageOverlay(page)
    end

    self:_setOverlaysVisible(true)
    self:_ensureDisplayWatcher()

    self.visible = true
    return true
end

---Oculta as zonas sem destruir DUIs, texturas ou overlays.
function MapZoneRenderer:hide()
    if not self.visible then
        return
    end

    for _, page in ipairs(self.pages) do
        self:_setPageAnimationVisible(page, false)
    end

    self:_setOverlaysVisible(false)
    self.visible = false
end

---Libera DUIs, texturas e limpa os overlays. A instância pode ser
---reutilizada com um novo show().
function MapZoneRenderer:destroy()
    DminigamesRenderDiagnostics.LoopsStopping( self )
    self.lifecycleRevision = self.lifecycleRevision + 1
    self:hide()
    self:_teardownPages()

    self._displayWatcherActive = false
    self.overlayHandle = -1
    self.visible = false
end

---@private
---@param zone table
---@return MapZoneRendererZone
function MapZoneRenderer:_normalizeZone(zone)
    local points = {}
    local shape = zone.shape == 'circle' and 'circle' or 'polygon'
    local visualPoints = zone.boundaryPoints

    if type(visualPoints) == 'table' and #visualPoints >= 3 then
        for _, point in ipairs(visualPoints) do
            local x = tonumber(point.x or point[1])
            local y = tonumber(point.y or point[2])

            if x and y then
                points[#points + 1] = { x, y }
            end
        end
    end

    if #points < 3 then
        points = {}
    end

    if #points >= 3 then
        -- boundaryPoints e a discretizacao visual autoritativa para mapa e parede.
    elseif shape == 'circle' then
        local center = zone.center or {}
        local centerX = tonumber(center.x or center[1])
        local centerY = tonumber(center.y or center[2])
        local radius = tonumber(zone.radius) or 0.0

        if centerX and centerY and radius > 0.0 then
            for pointIndex = 1, self.circleSegments do
                local angle = ((pointIndex - 1) / self.circleSegments) * math.pi * 2.0

                points[pointIndex] = {
                    centerX + math.cos(angle) * radius,
                    centerY + math.sin(angle) * radius,
                }
            end
        end
    else
        for _, point in ipairs(zone.points or {}) do
            local x = tonumber(point.x or point[1])
            local y = tonumber(point.y or point[2])

            if x and y then
                points[#points + 1] = { x, y }
            end
        end
    end

    return {
        id = zone.id,
        shape = shape,
        points = points,
        fillOutside = zone.fillOutside == true or nil,
        circleMotionFrameIntervalMs = tonumber(zone.circleMotionFrameIntervalMs),
        color = zone.color,
        type = zone.type,
        state = zone.state,
        name = zone.name,
        status = zone.status,
        label = zone.label,
        remainingMs = tonumber(zone.remainingMs),
        remainingSyncedAt = GetGameTimer(),
    }
end

---@private
---@param zone MapZoneRendererZone
---@return table bounds
function MapZoneRenderer:_computeZoneBounds(zone)
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge

    for _, point in ipairs(zone.points) do
        minX = math.min(minX, point[1] - self.horizontalPadding)
        minY = math.min(minY, point[2] - self.bottomPadding)
        maxX = math.max(maxX, point[1] + self.horizontalPadding)
        maxY = math.max(maxY, point[2] + self.topPadding)
    end

    return {
        minX = minX,
        minY = minY,
        maxX = maxX,
        maxY = maxY,
    }
end

---Agrupa as zonas em janelas cuja maior dimensão não passa de
---maxWindowSpan, unindo sempre o par de janelas mais compacto primeiro.
---@private
---@return table clusters Lista de { zones, bounds }
function MapZoneRenderer:_computeClusters()
    -- Uma projecao fixa separa a janela da textura das zonas atualmente visiveis.
    if self.projectionBounds then
        if #self.zones == 0 then
            return {}
        end

        return {{ zones = self.zones, bounds = self.projectionBounds }}
    end

    local clusters = {}

    for _, zone in ipairs(self.zones) do
        clusters[#clusters + 1] = {
            zones = { zone },
            bounds = self:_computeZoneBounds(zone),
        }
    end

    while #clusters > 1 do
        local bestFirst = nil
        local bestSecond = nil
        local bestBounds = nil
        local bestSpan = nil

        for firstIndex = 1, #clusters - 1 do
            for secondIndex = firstIndex + 1, #clusters do
                local merged = mergeBounds(clusters[firstIndex].bounds, clusters[secondIndex].bounds)
                local span = boundsSpan(merged)

                if span <= self.maxWindowSpan and (bestSpan == nil or span < bestSpan) then
                    bestFirst = firstIndex
                    bestSecond = secondIndex
                    bestBounds = merged
                    bestSpan = span
                end
            end
        end

        if bestFirst == nil then
            break
        end

        local firstCluster = clusters[bestFirst]
        local secondCluster = clusters[bestSecond]

        for _, zone in ipairs(secondCluster.zones) do
            firstCluster.zones[#firstCluster.zones + 1] = zone
        end

        firstCluster.bounds = bestBounds
        table.remove(clusters, bestSecond)
    end

    return clusters
end

---Reaproveita as páginas atuais quando o agrupamento não mudou (mesmos ids
---por página): atualiza zonas/janela, redesenha e reposiciona os overlays.
---@private
---@param clusters table
---@return boolean reused
function MapZoneRenderer:_reusePagesForClusters(clusters)
    if #clusters ~= #self.pages then
        return false
    end

    -- Consumidor de pagina unica pode trocar zonas sem recriar sua DUI/textura.
    local singlePage = self.maxWindowSpan == math.huge and #clusters == 1

    for pageIndex, page in ipairs(self.pages) do
        if not page.textureReady
            or (not singlePage and page.zoneIdsKey ~= buildZoneIdsKey(clusters[pageIndex].zones))
        then
            return false
        end
    end

    for pageIndex, page in ipairs(self.pages) do
        page.zones = clusters[pageIndex].zones
        page.zoneIdsKey = buildZoneIdsKey(page.zones)
        page.windowBounds = clusters[pageIndex].bounds
        self:_pushPage(page)
        self:_syncPageOverlay(page)
    end

    return true
end

---@private
---@return boolean success
function MapZoneRenderer:_ensureOverlayHandle()
    if self.overlayHandle >= 0 then
        return true
    end

    local overlayHandle = AddMinimapOverlay(self.loaderFile)

    if type(overlayHandle) ~= 'number' or overlayHandle < 0 then
        self:_logError('AddMinimapOverlay retornou um handle inválido')
        return false
    end

    local loaded = waitForCondition(function()
        return HasMinimapOverlayLoaded(overlayHandle)
    end, MAP_ZONE_LOAD_TIMEOUT_MS)

    if not loaded then
        self:_logError(('o loader "%s" não carregou em %d ms'):format(self.loaderFile, MAP_ZONE_LOAD_TIMEOUT_MS))
        return false
    end

    SetMinimapOverlayDisplay(overlayHandle, 0.0, 0.0, 100.0, 100.0, 0.0)
    Wait(MAP_ZONE_OVERLAY_INIT_DELAY_MS)

    self.overlayHandle = overlayHandle
    return true
end

---@private
---@return boolean success
function MapZoneRenderer:_ensurePages()
    if #self.pages > 0 then
        return true
    end

    local clusters = self.pendingClusters or self:_computeClusters()
    self.pendingClusters = nil

    for _, cluster in ipairs(clusters) do
        local page = self:_createPage(cluster)

        if not page then
            self:_teardownPages()
            return false
        end

        self.pages[#self.pages + 1] = page
    end

    return #self.pages > 0
end

---@private
---@param cluster table
---@return MapZoneRendererPage? page
function MapZoneRenderer:_createPage(cluster)
    local lifecycleRevision = self.lifecycleRevision

    mapZoneTextureGeneration = mapZoneTextureGeneration + 1

    local textureDictionary = ('%s_%d'):format(self.textureDictionaryPrefix, mapZoneTextureGeneration)
    local duiUrl = ('nui://%s/%s?gen=%d'):format(GetCurrentResourceName(), MAP_ZONE_RENDERER_PAGE, mapZoneTextureGeneration)
    local dui = gRenderNatives.CreateDui(duiUrl, self.canvasSize, self.canvasSize)

    if not dui or dui == 0 then
        self:_logError('CreateDui falhou')
        return nil
    end

    local available = waitForCondition(function()
        return self.lifecycleRevision ~= lifecycleRevision or IsDuiAvailable(dui)
    end, MAP_ZONE_LOAD_TIMEOUT_MS)

    if self.lifecycleRevision ~= lifecycleRevision then
        gRenderNatives.DestroyDui(dui)
        return nil
    end

    if not available then
        self:_logError(('a DUI não ficou disponível em %d ms'):format(MAP_ZONE_LOAD_TIMEOUT_MS))
        gRenderNatives.DestroyDui(dui)
        return nil
    end

    ---@type MapZoneRendererPage
    local page = {
        zones = cluster.zones,
        zoneIdsKey = buildZoneIdsKey(cluster.zones),
        windowBounds = cluster.bounds,
        dui = dui,
        textureDictionary = textureDictionary,
        textureName = 'zones',
        textureReady = false,
        overlayIndex = nil,
    }

    self:_pushPage(page)
    self:_setPageAnimationVisible(page, true)

    local runtimeTxd = gRenderNatives.CreateRuntimeTxd(textureDictionary)
    gRenderNatives.CreateRuntimeTextureFromDuiHandle(runtimeTxd, page.textureName, GetDuiHandle(dui))
    RequestStreamedTextureDict(textureDictionary, false)

    local textureLoaded = waitForCondition(function()
        if self.lifecycleRevision ~= lifecycleRevision then
            return true
        end

        local width, height = table.unpack(GetTextureResolution(textureDictionary, page.textureName))
        return HasStreamedTextureDictLoaded(textureDictionary)
            and width >= MAP_ZONE_TEXTURE_MIN_RESOLUTION
            and height >= MAP_ZONE_TEXTURE_MIN_RESOLUTION
    end, MAP_ZONE_LOAD_TIMEOUT_MS)

    if self.lifecycleRevision ~= lifecycleRevision then
        gRenderNatives.DestroyDui(dui)
        SetStreamedTextureDictAsNoLongerNeeded(textureDictionary)
        return nil
    end

    if not textureLoaded then
        self:_logError(('a textura da DUI não carregou em %d ms'):format(MAP_ZONE_LOAD_TIMEOUT_MS))
        gRenderNatives.DestroyDui(dui)
        SetStreamedTextureDictAsNoLongerNeeded(textureDictionary)
        return nil
    end

    Wait(MAP_ZONE_TEXTURE_SETTLE_MS)

    if self.lifecycleRevision ~= lifecycleRevision then
        gRenderNatives.DestroyDui(dui)
        SetStreamedTextureDictAsNoLongerNeeded(textureDictionary)
        return nil
    end

    page.runtimeTxd = runtimeTxd
    page.textureReady = true
    return page
end

---@private
function MapZoneRenderer:_teardownPages()
    if self.overlayHandle >= 0 and HasMinimapOverlayLoaded(self.overlayHandle) then
        CallMinimapScaleformFunction(self.overlayHandle, 'CLEAR_ALL')
        EndScaleformMovieMethod()
    end

    for _, page in ipairs(self.pages) do
        if page.dui then
            gRenderNatives.DestroyDui(page.dui)
        end

        if page.textureReady then
            SetStreamedTextureDictAsNoLongerNeeded(page.textureDictionary)
        end
    end

    self.pages = {}
    self.nextOverlayIndex = 0
end

---@private
---@param zone MapZoneRendererZone
---@param nowMs number
---@return table payload
function MapZoneRenderer:_buildZoneDuiPayload(zone, nowMs)
    local payload = {}

    for key, value in pairs(zone) do
        if key ~= 'remainingSyncedAt' and key ~= 'circleMotion' and key ~= 'circleMotionSyncedAt' then
            payload[key] = value
        end
    end

    if zone.remainingMs ~= nil then
        local remainingMs = math.max(0, tonumber(zone.remainingMs) or 0)

        if ( zone.state == 'capturing' or zone.state == 'cooldown' ) and zone.remainingSyncedAt then
            remainingMs = math.max(0, remainingMs - math.max(0, nowMs - zone.remainingSyncedAt))
        end

        payload.remainingMs = math.floor(remainingMs)
    end

    local motion = zone.circleMotion

    if motion then
        local elapsedMs = motion.elapsedMs

        if motion.phase == 'closing' and not motion.paused then
            elapsedMs = math.min( motion.durationMs, elapsedMs + math.max( 0, nowMs - zone.circleMotionSyncedAt ) )
        end

        payload.circleMotion = {
            from = motion.from, target = motion.target, durationMs = motion.durationMs, elapsedMs = elapsedMs,
            paused = motion.paused, phase = motion.phase,
        }
    end

    return payload
end

---@private
---@param page MapZoneRendererPage
function MapZoneRenderer:_pushPage(page)
    if not page.dui then
        return
    end

    local nowMs = GetGameTimer()
    local zones = {}

    for zoneIndex, zone in ipairs(page.zones) do
        zones[zoneIndex] = self:_buildZoneDuiPayload(zone, nowMs)
    end

    SendDuiMessage(page.dui, json.encode({
        action = 'drawZones',
        zones = zones,
        bounds = page.windowBounds,
        labelScale = 1.0,
    }))
end

---@private
---@param zoneId string|number
function MapZoneRenderer:_pushPageOfZone(zoneId)
    for _, page in ipairs(self.pages) do
        for _, zone in ipairs(page.zones) do
            if zone.id == zoneId then
                self:_pushPage(page)
                return
            end
        end
    end
end

---@private
---@param page MapZoneRendererPage
---@param visible boolean
function MapZoneRenderer:_setPageAnimationVisible(page, visible)
    if not page.dui then
        return
    end

    SendDuiMessage(page.dui, json.encode({
        action = 'setVisible',
        visible = visible,
    }))
end

---@private
---@param page MapZoneRendererPage
function MapZoneRenderer:_syncPageOverlay(page)
    if self.overlayHandle < 0 or not page.textureReady then
        return
    end

    local bounds = page.windowBounds
    local previous = page.overlayBounds

    if previous
        and previous.minX == bounds.minX and previous.maxX == bounds.maxX
        and previous.minY == bounds.minY and previous.maxY == bounds.maxY
    then
        return
    end

    local centerX = (bounds.minX + bounds.maxX) / 2.0
    local centerY = (bounds.minY + bounds.maxY) / 2.0
    local worldWidth = bounds.maxX - bounds.minX
    local worldHeight = bounds.maxY - bounds.minY

    if page.overlayIndex == nil then
        CallMinimapScaleformFunction(self.overlayHandle, 'ADD_UV_OVERLAY')
        ScaleformMovieMethodAddParamTextureNameString(page.textureDictionary)
        ScaleformMovieMethodAddParamTextureNameString(page.textureName)
        ScaleformMovieMethodAddParamFloat(centerX)
        ScaleformMovieMethodAddParamFloat(centerY)
        ScaleformMovieMethodAddParamFloat(0.0)
        ScaleformMovieMethodAddParamFloat(worldWidth)
        ScaleformMovieMethodAddParamFloat(worldHeight)
        ScaleformMovieMethodAddParamTextureNameString(('0:0:%d:%d:%d:%d'):format(
            self.canvasSize,
            self.canvasSize,
            self.canvasSize,
            self.canvasSize
        ))
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(MAP_ZONE_FULL_TEXTURE_MODE)
        EndScaleformMovieMethod()

        page.overlayIndex = self.nextOverlayIndex
        self.nextOverlayIndex = self.nextOverlayIndex + 1
        page.overlayBounds = bounds
        return
    end

    CallMinimapScaleformFunction(self.overlayHandle, 'UPDATE_OVERLAY_POSITION')
    ScaleformMovieMethodAddParamInt(page.overlayIndex)
    ScaleformMovieMethodAddParamFloat(centerX)
    ScaleformMovieMethodAddParamFloat(centerY)
    EndScaleformMovieMethod()

    CallMinimapScaleformFunction(self.overlayHandle, 'UPDATE_OVERLAY_SIZE_OR_SCALE')
    ScaleformMovieMethodAddParamInt(page.overlayIndex)
    ScaleformMovieMethodAddParamFloat(worldWidth)
    ScaleformMovieMethodAddParamFloat(worldHeight)
    EndScaleformMovieMethod()

    page.overlayBounds = bounds
end

---@private
---@param visible boolean
function MapZoneRenderer:_setOverlaysVisible(visible)
    if self.overlayHandle < 0 then
        return
    end

    for _, page in ipairs(self.pages) do
        if page.overlayIndex ~= nil then
            CallMinimapScaleformFunction(self.overlayHandle, 'SET_OVERLAY_ALPHA')
            ScaleformMovieMethodAddParamInt(page.overlayIndex)
            ScaleformMovieMethodAddParamInt(visible and 255 or 0)
            EndScaleformMovieMethod()
        end
    end

    SetMinimapOverlayDisplay(
        self.overlayHandle,
        0.0,
        0.0,
        100.0,
        100.0,
        visible and 100.0 or 0.0
    )
end

---O retangulo de composicao do overlay pode ficar defasado quando o radar
---troca de modo (bigmap/expandido <-> normal), recortando as zonas dentro da
---janela nova; re-aplicar o display na troca atualiza o retangulo.
---@private
function MapZoneRenderer:_ensureDisplayWatcher()
    if self._displayWatcherActive then
        return
    end

    self._displayWatcherActive = true
    local diagnosticLoop = DminigamesRenderDiagnostics.LoopStarted( 'minimap-watcher', self )

    CreateThread(function()
        local lastBigmapActive = IsBigmapActive()

        while self._displayWatcherActive and self.overlayHandle >= 0 do
            local bigmapActive = IsBigmapActive()

            if bigmapActive ~= lastBigmapActive then
                lastBigmapActive = bigmapActive
                self:_setOverlaysVisible(self.visible)
            end

            Wait(250)
        end
        DminigamesRenderDiagnostics.LoopFinished( diagnosticLoop )
    end)
end

---@private
---@param message string
function MapZoneRenderer:_logError(message)
    if sx and sx.logger then
        sx.logger:error(('[MapZoneRenderer] %s'):format(message))
    end
end
