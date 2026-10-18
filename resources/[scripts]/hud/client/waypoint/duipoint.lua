local USE_PIXEL_PADDING = true

--- Espera (ms) antes de desenhar um slot recém-atribuído, para a DUI repintar a célula.
local SLOT_SETTLE_MS = 100

--- Mesmos nomes que `jobs_discovery.lua` — ícone relido nas ConVars a cada `_sendMarkerUpdate`.
--- Keywords NUI/DUI: faccao | peixe | mask (aliases: emprego→peixe, mascara→mask).
local FACTION_DISCOVERY_CVAR_FACTION = 'hud_faction_discovery_icon_faction'
local FACTION_DISCOVERY_CVAR_JOB     = 'hud_faction_discovery_icon_job'

DUIPoint = {}
DUIPoint.__index = DUIPoint

local function normalizeMarkerIconKeyword(raw)
    if type(raw) ~= 'string' then
        return raw
    end
    local v = raw:gsub('^%s+', ''):gsub('%s+$', '')
    if v == 'emprego' then
        return 'peixe'
    end
    if v == 'mascara' then
        return 'mask'
    end
    return v
end

--- cos(meio-ângulo) por grau; os cones usam poucos valores fixos (25, 35).
local COS_BY_DEG = {}

--- Normaliza `dynamicSkyOffset` ({ pitch, min, max }) e pré-calcula tan(pitch).
---@param t table|nil
---@return table|nil
local function normalizeSkyCfg( t )
    if type( t ) ~= 'table' then return nil end
    local pitch = t.pitch or 12.0
    return {
        pitch    = pitch,
        min      = t.min or 0.0,
        max      = t.max or 9999.0,
        tanPitch = math.tan( math.rad( pitch ) ),
    }
end

---@param role string|nil 'faction' | 'job'
---@return string token enviado ao DUI (`icon`)
function DUIPoint.resolveFactionDiscoveryIcon(role)
    local convar = FACTION_DISCOVERY_CVAR_FACTION
    local default = 'peixe'
    if role == 'job' then
        convar = FACTION_DISCOVERY_CVAR_JOB
        default = 'peixe'
    end

    local v = GetConvar(convar, default)
    if type(v) ~= 'string' then
        return default
    end
    v = normalizeMarkerIconKeyword(v)
    if v == '' then
        return default
    end
    return v
end

--- Normaliza keyword para o contrato NUI (URLs intactas).
function DUIPoint.normalizeIconToken(s)
    if s == nil then
        return ''
    end
    return normalizeMarkerIconKeyword(s)
end

function DUIPoint.beginFrameCtx()
    local cam = GetFinalRenderedCamCoord()
    local rot = GetFinalRenderedCamRot( 2 )
    local pitch = math.rad( rot.x )
    local yaw   = math.rad( rot.z )
    local cosY, sinY = math.cos( yaw ), math.sin( yaw )
    local cosP, sinP = math.cos( pitch ), math.sin( pitch )
    local screenW, screenH = GetActiveScreenResolution()
    local maxPxX, maxPxY
    if USE_PIXEL_PADDING then
        local pixelPadding = 30
        maxPxX = screenW * 0.5 - pixelPadding
        maxPxY = screenH * 0.5 - pixelPadding
    else
        maxPxX = screenW * ( 0.5 - 0.04 )
        maxPxY = screenH * ( 0.5 - 0.04 )
    end
    return {
        cam     = cam,
        fX      = -sinY * cosP, fY = cosY * cosP, fZ = sinP,
        rX      = cosY,         rY = sinY,
        uX      = sinY * sinP,  uY = -cosY * sinP, uZ = cosP,
        screenW = screenW,      screenH = screenH,
        maxPxX  = maxPxX,       maxPxY = maxPxY,
    }
end

function DUIPoint.projectScreen(wx, wy, wz)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(wx, wy, wz)
    local inViewport = onScreen and sx >= 0.0 and sx <= 1.0 and sy >= 0.0 and sy <= 1.0
    return {
        onScreen     = onScreen,
        inViewport   = inViewport,
        offScreen    = not inViewport,
        sx           = sx,
        sy           = sy,
        behindCamera = not onScreen,
    }
end

--- Mesma projeção de `projectScreen`, sem alocar tabela.
---@return boolean onScreen
---@return number sx
---@return number sy
---@return boolean inViewport
function DUIPoint.projectScreenRaw( wx, wy, wz )
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord( wx, wy, wz )
    return onScreen, sx, sy, onScreen and sx >= 0.0 and sx <= 1.0 and sy >= 0.0 and sy <= 1.0
end

--- True quando a direção da câmera aponta razoavelmente em direção ao ponto
--- (dentro do cone de meio-ângulo dado, em graus). Usado por waypoints
--- "globais" (ex.: faction discovery elevados a +Z) para suprimir a seta
--- 2D quando o player já está olhando na direção, mesmo que o ponto
---@param wx number
---@param wy number
---@param wz number
---@param halfAngleDeg number|nil
---@param ctx table|nil
---@return boolean
function DUIPoint.isInForwardCone( wx, wy, wz, halfAngleDeg, ctx )
    halfAngleDeg = halfAngleDeg or 25.0
    ctx = ctx or DUIPoint.beginFrameCtx()

    local cam = ctx.cam
    local fX, fY, fZ = ctx.fX, ctx.fY, ctx.fZ

    local dX, dY, dZ = wx - cam.x, wy - cam.y, wz - cam.z
    local len = math.sqrt( dX * dX + dY * dY + dZ * dZ )
    if len <= 0 then
        return true
    end
    local invLen = 1.0 / len
    local dot = ( dX * fX + dY * fY + dZ * fZ ) * invLen
    local c = COS_BY_DEG[halfAngleDeg]
    if not c then
        c = math.cos( math.rad( halfAngleDeg ) )
        COS_BY_DEG[halfAngleDeg] = c
    end
    return dot >= c
end

---@class EdgeInfo
---@field x number          -- normalized screen X on edge rectangle (0..1)
---@field y number          -- normalized screen Y on edge rectangle (0..1)
---@field angle number      -- arrow rotation in radians; 0 = right, π/2 = down
---@field direction string  -- legacy hint: 'left' | 'right' | 'top' | 'bottom'

--- Mesmo cálculo de `edgePosition`, em múltiplos retornos (sem alocar tabela).
---@param wx number
---@param wy number
---@param wz number
---@param ctx table|nil
---@return number x
---@return number y
---@return number angle
---@return string direction
function DUIPoint.edgeValues( wx, wy, wz, ctx )
    ctx = ctx or DUIPoint.beginFrameCtx()

    local screenW, screenH = ctx.screenW, ctx.screenH
    local maxPxX, maxPxY = ctx.maxPxX, ctx.maxPxY

    local cam = ctx.cam
    local fX, fY, fZ = ctx.fX, ctx.fY, ctx.fZ
    local rX, rY     = ctx.rX, ctx.rY
    local uX, uY, uZ = ctx.uX, ctx.uY, ctx.uZ

    local dX, dY, dZ = wx - cam.x, wy - cam.y, wz - cam.z
    local rightDot = dX * rX + dY * rY
    local upDot    = dX * uX + dY * uY + dZ * uZ
    local fwdDot   = dX * fX + dY * fY + dZ * fZ

    -- Screen-space direction (X right, Y down). Continuous across fwdDot = 0.
    local dirX, dirY

    if fwdDot > 0.1 then
        -- In front: perspective projection
        dirX = rightDot / fwdDot
        dirY = -upDot / fwdDot
    else
        -- Behind or near camera plane: use unprojected direction so the indicator
        -- stays on the same edge as the marker swings around the camera.
        local mag = math.sqrt(rightDot * rightDot + upDot * upDot)
        if mag < 1e-3 then
            dirX, dirY = 0, 1 -- directly behind: default to bottom edge
        else
            dirX = rightDot / mag
            dirY = -upDot / mag
        end
    end

    local absX = math.abs(dirX)
    local absY = math.abs(dirY)

    if absX < 1e-6 and absY < 1e-6 then
        return 0.5, 0.5 - (maxPxY / screenH), -math.pi / 2, 'top'
    end

    -- Clamp in pixel space so diagonals land on the actual rectangle edge.
    -- Doing this in normalized [0,1] space would distort direction by the aspect ratio.
    local scaleX = absX > 1e-6 and (maxPxX / absX) or math.huge
    local scaleY = absY > 1e-6 and (maxPxY / absY) or math.huge
    local scale = math.min(scaleX, scaleY)

    local direction
    if scaleX < scaleY then
        direction = dirX > 0 and 'right' or 'left'
    else
        direction = dirY > 0 and 'bottom' or 'top'
    end

    local pxOffsetX = dirX * scale
    local pxOffsetY = dirY * scale

    return 0.5 + pxOffsetX / screenW, 0.5 + pxOffsetY / screenH, math.atan(dirY, dirX), direction
end

---@param screen table
---@param wx number
---@param wy number
---@param wz number
---@param ctx table|nil
---@return EdgeInfo
function DUIPoint.edgePosition( screen, wx, wy, wz, ctx )
    local x, y, angle, direction = DUIPoint.edgeValues( wx, wy, wz, ctx )
    return { x = x, y = y, angle = angle, direction = direction }
end

--- Envia lista completa de indicadores 2D (substitui estado anterior).
---@param markers table[] ver contrato NUI: id, visible, title, distance, icon, position?, angle?, direction?
function DUIPoint.sendMarkerIndicators(markers)
    SendNUIMessage({
        action = 'markerIndicators',
        data   = { markers = markers or {} },
    })
end

function DUIPoint.clearMarkerIndicators()
    SendNUIMessage({ action = 'markerIndicatorClear' })
end

function DUIPoint.drawTexturedTriangle(pos, width, height, alpha, dict, txn)
    local camPos   = GetFinalRenderedCamCoord()
    local up       = vec3(0.0, 0.0, 1.0)
    local fwd      = norm(vec3((camPos - pos).x, (camPos - pos).y, 0.0))
    local right    = norm(cross(up, fwd))
    local halfW    = width / 2

    local topLeft  = pos - (right * halfW) + (up * height)
    local topRight = pos + (right * halfW) + (up * height)

    DrawTexturedPoly(
        topRight.x, topRight.y, topRight.z,
        topLeft.x, topLeft.y, topLeft.z,
        pos.x, pos.y, pos.z,
        255, 255, 255, alpha, dict, txn,
        1.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.5, 1.0, 0.0
    )
end

function DUIPoint.new(data)
    local self           = setmetatable({}, DUIPoint)

    self.coords             = vec3(data.coords.x, data.coords.y, data.coords.z)
    self.title              = data.title or ''
    self.type               = data.type or 'marker'
    self.icon               = data.icon or ''
    self.indicatorDistance  = data.indicatorDistance
    self.width              = data.width or 3.0
    self.height             = data.height or 3.0
    self.spriteWidth        = data.spriteWidth or data.spriteScale or 0.12
    self.spriteHeight       = data.spriteHeight or data.spriteScale or 0.21
    self.seeThroughWalls   = data.seeThroughWalls or false
    self.fadeDistance       = data.fadeDistance or 0.0

    self.missionId          = data.missionId
    self.missionOrder       = data.missionOrder or 0
    self.groupId            = data.groupId or data.missionId
    self.markerDistance     = data.markerDistance or 9999.0
    self.showDistance       = data.showDistance or 50.0
    self.isActiveDui        = false
    --- Pista paralela: não compete pelo owner do grupo; vários pontos paralelos ativos ao mesmo tempo.
    self.parallelDuiLane    = data.parallelDuiLane == true
    --- Ignora gates de cone/viewport/50m; sempre ativo quando running + dentro de markerDistance.
    self.alwaysVisibleDui   = data.alwaysVisibleDui == true
    --- Família para o edge indicator 2D: um único arrow por família (ex.: 'faction', 'mission').
    self.family             = data.family or 'default'
    --- Cor CSS aplicada ao edge indicator 2D (override de --main-500 no root do marker).
    self.customBorderColors = data.customBorderColors
    --- Multiplicador aplicado ao DUI in-world E ao edge indicator 2D via CSS var --marker-scale (default 1).
    self.markerScale        = data.markerScale
    --- Multiplicador aplicado apenas ao ícone interno via CSS var --marker-icon-scale (default 1).
    self.markerIconScale    = data.markerIconScale
    --- Overrides aplicados APENAS ao edge indicator 2D (quando o player NÃO está olhando).
    --- Default: cai de volta em markerScale / markerIconScale.
    self.indicatorScale       = data.indicatorScale
    self.indicatorIconScale   = data.indicatorIconScale
    --- Waypoint "global" (ex.: faction discovery elevado): suprime a seta 2D
    --- quando a câmera está apontando razoavelmente em direção ao ponto, mesmo
    --- que o ponto não caia dentro do retângulo de viewport — evita o flicker
    --- de seta quando o ícone está alto no céu mas dentro do campo de visão.
    self.suppressIndicatorWhenAimed = data.suppressIndicatorWhenAimed == true
    --- Offset dinâmico em Z para manter o ícone na mesma altura visual
    --- independentemente da distância. `baseZ` é o solo natural do ponto;
    --- a cada tick, Z = baseZ + clamp(horizontalDist * tan(pitch), min, max).
    --- Use {pitch=12, min=30, max=200} para um efeito "torre no céu" suave.
    self.baseZ                      = data.coords.z
    self.dynamicSkyOffset           = normalizeSkyCfg( data.dynamicSkyOffset )
    --- Jobs discovery: ícone vem sempre das ConVars (`resolveFactionDiscoveryIcon`), não do valor fixo em `self.icon`.
    self.factionDiscoveryIconRole = data.factionDiscoveryIconRole
    --- ID estável para NUI (`markerIndicators` / markerIndicatorRemove); default wp_<num> no WaypointManager.
    self.markerNuiId             = data.markerNuiId

    self.onWaypointEnter = data.onWaypointEnter -- { distance, action }
    self.onWaypointExit  = data.onWaypointExit  -- { distance, action }
    self.inside          = false -- estado atual do player

    --- Slot no DuiAtlas (uma DUI para todos os waypoints); nil enquanto inativo.
    self.slot            = nil
    self.running         = false
    self.currentDist     = 9999.0

    return self
end

--- Ícone para DUI / NUI: estático (`self.icon`) ou dinâmico (ConVars por `factionDiscoveryIconRole`).
function DUIPoint:displayIcon()
    if self.factionDiscoveryIconRole then
        return DUIPoint.resolveFactionDiscoveryIcon(self.factionDiscoveryIconRole)
    end
    return self.icon or ''
end

function DUIPoint:create()
    self.running = true
    local pPos = GetEntityCoords( PlayerPedId() )
    self.currentDist = #( pPos - vec3( self.coords.x, self.coords.y, self.coords.z ) )
end

---@param pPos vector3
function DUIPoint:tickProximity( pPos )
    if not self.running then return end
    self.currentDist = #( pPos - vec3( self.coords.x, self.coords.y, self.coords.z ) )

    if self.isActiveDui and self.slot == nil then
        -- Atlas estava cheio quando ativou: tenta de novo.
        self:_acquireSlot()
    end

    if self.isActiveDui and self.slot and self.currentDist <= self.markerDistance then
        self:_sendMarkerUpdate()
    end

    local dist = self.currentDist

    if self.onWaypointEnter and not self.inside and dist <= self.onWaypointEnter.distance then
        self.inside = true
        self.onWaypointEnter.action( self._id )
    elseif self.onWaypointExit and self.inside and dist >= self.onWaypointExit.distance then
        self.inside = false
        self.onWaypointExit.action( self._id )
    end
end

---@param pPos vector3
function DUIPoint:tickSkyOffset( pPos )
    if not self.running or not self.dynamicSkyOffset then return end
    self:_applyDynamicSkyOffset( pPos )
end

function DUIPoint:tickRender()
    if not self.running or not self.slot or not self.isActiveDui then return end
    if not DuiAtlas.isReady() then return end

    -- Slot recém-atribuído: a célula ainda pode ter o marker do dono anterior até a DUI repintar.
    local drawAfter = self._drawAfter
    if drawAfter then
        if GetGameTimer() < drawAfter then return end
        self._drawAfter = nil
    end

    local dist = self.currentDist
    if dist > self.markerDistance then return end
    if self.inWorldSpriteDistance and dist > self.inWorldSpriteDistance then return end

    local alpha = 255
    if self.fadeDistance > 0 and dist < self.fadeDistance then
        local f = dist / self.fadeDistance
        alpha = math.max( 0, math.floor( 255 * f * f ) )
    end

    local onScreen, scx, scy = GetScreenCoordFromWorldCoord( self.coords.x, self.coords.y, self.coords.z )
    if onScreen then
        local dict, texture = DuiAtlas.textures()
        local u1, v1, u2, v2 = DuiAtlas.uv( self.slot )
        DrawSpriteUv( dict, texture, scx, scy, self.spriteWidth, self.spriteHeight, u1, v1, u2, v2, 0.0, 255, 255, 255, alpha )
    end
end

--- Reserva um slot no DuiAtlas (a DUI compartilhada nasce no primeiro acquire). Idempotente.
function DUIPoint:_acquireSlot()
    if self.slot ~= nil then return end

    self.slot = DuiAtlas.acquire( self )
    if self.slot == nil then return end

    self._lastMarkerSig = nil
    self._drawAfter = GetGameTimer() + SLOT_SETTLE_MS

    -- Atlas já pronto: um updateMarker completo (com rect) monta o slot. Página nova é
    -- coberta pelo prime por geração em `duiatlas.lua`.
    if DuiAtlas.isReady() then
        self:_sendMarkerUpdate()
    end
end

function DUIPoint:_releaseSlot()
    if self.slot == nil then return end

    DuiAtlas.release( self.slot )
    self.slot = nil
    self._lastMarkerSig = nil
end

--- DuiAtlas deu o slot para um ponto mais próximo (atlas no tamanho máximo).
--- Continua ativo; `tickProximity` tenta pegar slot de novo.
function DUIPoint:_onSlotEvicted()
    self.slot = nil
    self._lastMarkerSig = nil
end

--- DuiAtlas compactou os slots ao encolher; a DUI é recriada e `_onAtlasReady` reenvia.
---@param slot integer
function DUIPoint:_onSlotMoved( slot )
    self.slot = slot
    self._lastMarkerSig = nil
    self._drawAfter = GetGameTimer() + SLOT_SETTLE_MS
end

--- Chamado pelo DuiAtlas quando a DUI (página nova) fica disponível.
--- O reenvio de primeiro paint roda uma vez por geração em `duiatlas.lua`.
function DUIPoint:_onAtlasReady()
    if not self.running or not self.isActiveDui or self.slot == nil then return end

    self._lastMarkerSig = nil
    self:_sendMarkerUpdate()
end

function DUIPoint:destroy()
    self.running = false
    self.isActiveDui = false
    self:_releaseSlot()
end

function DUIPoint:update(data)
    if data.coords then
        self.coords = data.coords
        self.baseZ  = data.coords.z
        -- Novo alvo: permitir disparar onWaypointEnter de novo no novo ponto.
        self.inside = false
    end
    if data.title then self.title = data.title end
    if data.type then self.type = data.type end
    if data.icon then self.icon = data.icon end
    if data.indicatorDistance ~= nil then self.indicatorDistance = data.indicatorDistance end
    if data.width then self.width = data.width end
    if data.height then self.height = data.height end
    if data.spriteWidth then self.spriteWidth = data.spriteWidth end
    if data.spriteHeight then self.spriteHeight = data.spriteHeight end
    if data.seeThroughWalls ~= nil then self.seeThroughWalls = data.seeThroughWalls end
    if data.fadeDistance then self.fadeDistance = data.fadeDistance end
    if data.missionId ~= nil then self.missionId = data.missionId end
    if data.missionOrder ~= nil then self.missionOrder = data.missionOrder end
    if data.groupId ~= nil then self.groupId = data.groupId end
    if data.markerDistance then self.markerDistance = data.markerDistance end
    if data.parallelDuiLane ~= nil then self.parallelDuiLane = data.parallelDuiLane == true end
    if data.suppressIndicatorWhenAimed ~= nil then self.suppressIndicatorWhenAimed = data.suppressIndicatorWhenAimed == true end
    if data.factionDiscoveryIconRole ~= nil then self.factionDiscoveryIconRole = data.factionDiscoveryIconRole end
    if data.markerNuiId ~= nil then self.markerNuiId = data.markerNuiId end
    if data.onWaypointEnter then self.onWaypointEnter = data.onWaypointEnter end
    if data.onWaypointExit then self.onWaypointExit = data.onWaypointExit end
    if data.customBorderColors ~= nil then self.customBorderColors = data.customBorderColors end
    if data.markerScale ~= nil then self.markerScale = data.markerScale end
    if data.markerIconScale ~= nil then self.markerIconScale = data.markerIconScale end
    if data.dynamicSkyOffset ~= nil then self.dynamicSkyOffset = normalizeSkyCfg( data.dynamicSkyOffset ) end
    -- Visuais (título/border/escala) não fazem parte do dedupe de `_sendMarkerUpdate`; força re-envio.
    self._lastMarkerSig = nil
end

function DUIPoint:getScreenState()
    return DUIPoint.projectScreen(self.coords.x, self.coords.y, self.coords.z)
end

function DUIPoint:_withinIndicatorDistance(dist)
    if self.indicatorDistance and dist > self.indicatorDistance then return false end
    return true
end

function DUIPoint:_send(payload)
    if self.slot == nil then return end
    DuiAtlas.send(self.slot, payload)
end

--- Dedupe no que a DUI desenha (distância inteira + ícone). `_lastMarkerSig = nil`
--- (update/acquire/release/evict/move/atlas pronto/prime) continua significando "força reenvio".
function DUIPoint:_sendMarkerUpdate()
    if self.slot == nil or not DuiAtlas.isReady() then return end
    local distInt = math.floor( self.currentDist )
    local icon = self:displayIcon()
    if not self.factionDiscoveryIconRole then
        icon = normalizeMarkerIconKeyword( icon ) or icon
    end

    if self._lastMarkerSig ~= nil and distInt == self._lastSentDist and icon == self._lastSentIcon then return end
    self._lastMarkerSig = true
    self._lastSentDist  = distInt
    self._lastSentIcon  = icon

    -- `visible` fica no default do front (true); screen/type/markerIconScale não são lidos pela DUI.
    self:_send({
        action             = 'updateMarker',
        distance           = distInt .. 'm',
        title              = self.title,
        icon               = icon,
        city               = cityName,
        customBorderColors = self.customBorderColors,
        markerScale        = self.markerScale,
    })
end

--- Ativo = o manager decidiu que o ponto deve ser desenhado (dentro da distância e,
--- salvo alwaysVisibleDui, em tela). Só pontos ativos ocupam slot no atlas.
function DUIPoint:setActive(active)
    if self.isActiveDui == active then return end
    self.isActiveDui = active

    if active then
        self:_acquireSlot()
    else
        self:_releaseSlot()
    end
end

--- Recalcula self.coords.z mantendo um pitch constante acima do horizonte
--- visto da posição do player. Garante que markers globais "no céu" sintam-se
--- na mesma altura visual, perto ou longe.
function DUIPoint:_applyDynamicSkyOffset(pPos)
    local cfg = self.dynamicSkyOffset
    if not cfg then return end
    local dx = self.coords.x - pPos.x
    local dy = self.coords.y - pPos.y
    local horiz = math.sqrt(dx * dx + dy * dy)
    local raw = horiz * ( cfg.tanPitch or math.tan( math.rad( cfg.pitch ) ) )
    if raw < cfg.min then raw = cfg.min end
    if raw > cfg.max then raw = cfg.max end
    self.coords = vec3(self.coords.x, self.coords.y, self.baseZ + raw)
end

