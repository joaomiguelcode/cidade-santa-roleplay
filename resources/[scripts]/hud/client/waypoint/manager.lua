WaypointManager = {}
WaypointManager.__index = WaypointManager

local DEFAULT_WORLD_BUCKET = 1

---@return boolean
function IsMissionHudBlocked()

    if LocalPlayer.state['affiliate:inService'] == true then
        return true
    end

    if cityName ~= "CidadeNobre" then
        return false
    end

    local playerGroups = vRP.GetPlayerGroups()

    return playerGroups == nil or playerGroups[ "Special3" ] ~= nil or playerGroups[ "Special5" ] ~= nil
end

--- Gate de exibição em cache: atualizado por state bag / eventos e revalidado a cada GATE_REFRESH_MS.
local GATE_REFRESH_MS = 1000
local OWN_BAG = ( 'player:%d' ):format( GetPlayerServerId( PlayerId() ) )
local gateReady, cachedRoute, cachedBlocked, lastGateRefresh = false, nil, false, 0

local function refreshGate()
    cachedRoute = tonumber( LocalPlayer.state.Route )
    cachedBlocked = IsMissionHudBlocked()
    lastGateRefresh = GetGameTimer()
    gateReady = true
end

local function CanShowWaypoints()
    if not gateReady then refreshGate() end
    return cachedRoute == DEFAULT_WORLD_BUCKET and not cachedBlocked
end

AddStateBagChangeHandler( 'Route', OWN_BAG, function( _, _, value )
    cachedRoute = tonumber( value )
end )

--- O vrp atualiza PlayerData.groups no próprio handler desses eventos; adia um tick para ler o valor novo.
local function deferRefreshBlocked()
    SetTimeout( 0, function()
        cachedBlocked = IsMissionHudBlocked()
    end )
end

RegisterNetEvent( 'playerGroups:Create', deferRefreshBlocked )
RegisterNetEvent( 'playerGroups:AddGroup', deferRefreshBlocked )
RegisterNetEvent( 'playerGroups:RemoveGroup', deferRefreshBlocked )
AddEventHandler( 'dashboard:affiliateServiceChanged', deferRefreshBlocked )

--- Scratch reutilizado por `_syncEdgeIndicators` (nunca faz yield entre limpar e usar).
local edgeSuppressed, edgeWinners, edgeSigParts = {}, {}, {}

function WaypointManager.new()
    local self = setmetatable({
        markers                 = {},
        activeMarkers           = {},
        skyOffsetMarkers        = {},
        edgeEligible            = {},
        nextId                  = 0,
        activeDuiOwner          = nil,
        edgeIndicatorsWereShown = false,
    }, WaypointManager)
    return self
end

--- O servidor dispara `net:routing_bucket_changed` antes de gravar `Route` no state bag:
--- o argumento do evento é o valor confiável.
---@param bucket number|nil
function WaypointManager:setRouteHint( bucket )
    local n = tonumber( bucket )
    if n == nil then return end
    if not gateReady then refreshGate() end
    cachedRoute = n
end

function WaypointManager:create(data)
    self.nextId = self.nextId + 1
    local point = DUIPoint.new(data)
    point._id = self.nextId
    if not point.markerNuiId or point.markerNuiId == '' then
        point.markerNuiId = ('wp_%d'):format(self.nextId)
    end
    point:create()
    self.markers[self.nextId] = point
    self.edgeEligible[self.nextId] = point
    if point.dynamicSkyOffset then
        self.skyOffsetMarkers[self.nextId] = point
    end
    return self.nextId
end

function WaypointManager:_setActive(id, point, on)
    point:setActive( on )
    if on then
        self.activeMarkers[id] = point
    else
        self.activeMarkers[id] = nil
    end
end

function WaypointManager:update(id, data)
    local point = self.markers[id]
    if point then point:update(data) end
end

function WaypointManager:remove(id)
    local point = self.markers[id]
    if not point then return end
    self.markers[id] = nil
    self.activeMarkers[id] = nil
    self.skyOffsetMarkers[id] = nil
    self.edgeEligible[id] = nil
    if id == self.activeDuiOwner then self.activeDuiOwner = nil end
    point:destroy()
    self:syncMarkerIndicator()
end

function WaypointManager:removeAll()
    for i, point in pairs(self.markers) do
        point:destroy()
        self.markers[i] = nil
    end
    self.activeMarkers = {}
    self.skyOffsetMarkers = {}
    self.edgeEligible = {}
    self:syncMarkerIndicator()
end

function WaypointManager:get(id)
    return self.markers[id]
end

function WaypointManager:getScreenState(id)
    local point = self.markers[id]
    if not point then return nil end
    return point:getScreenState()
end

function WaypointManager:clearOnStop()
    for _, point in pairs(self.markers) do
        point:destroy()
    end
    self.markers = {}
    self.activeMarkers = {}
    self.skyOffsetMarkers = {}
    self.edgeEligible = {}
    local hadActive = self.activeDuiOwner ~= nil
    self.activeDuiOwner = nil
    DuiAtlas.destroy()
    DUIPoint.clearMarkerIndicators()
    self.edgeIndicatorsWereShown = false
end

function WaypointManager:_groupCandidates()
    local candidates = {}
    local ctx

    for id, m in pairs( self.markers ) do
        if m.parallelDuiLane then goto skip_candidate end
        if m.running and m.currentDist <= m.markerDistance then
            if not m.alwaysVisibleDui then
                local distance = m.showDistance or 50.0
                if m.currentDist > distance then goto skip_candidate end
                ctx = ctx or DUIPoint.beginFrameCtx()
                if not DUIPoint.isInForwardCone( m.coords.x, m.coords.y, m.coords.z, 35.0, ctx ) then
                    goto skip_candidate
                end
                local screen = DUIPoint.projectScreen( m.coords.x, m.coords.y, m.coords.z )
                if not screen.inViewport then goto skip_candidate end
            end
            local g = m.groupId or id
            local cur = candidates[g]
            if not cur
                or m.currentDist < cur.point.currentDist
                or ( m.currentDist == cur.point.currentDist and id < cur.id )
            then
                candidates[g] = { id = id, point = m }
            end
        end
        ::skip_candidate::
    end

    return candidates
end

function WaypointManager:_selectPreferred(candidates)
    if next(candidates) == nil then
        return nil, nil
    end

    local incumbent
    if self.activeDuiOwner then
        local p = self.markers[self.activeDuiOwner]
        if p then
            local g = p.groupId or self.activeDuiOwner
            if candidates[g] and candidates[g].id == self.activeDuiOwner then
                incumbent = candidates[g]
            end
        end
    end

    if incumbent then
        local best = incumbent
        for _, c in pairs(candidates) do
            if c.id ~= best.id then
                if best.point.currentDist - c.point.currentDist >= 5.0 then
                    best = c
                end
            end
        end
        return best.id, best.point
    end

    local best
    for _, c in pairs(candidates) do
        if not best then
            best = c
        else
            local delta = c.point.currentDist - best.point.currentDist
            if math.abs(delta) <= 5.0 then
                local aOrd = c.point.missionOrder
                local bOrd = best.point.missionOrder
                if not aOrd or aOrd <= 0 then aOrd = math.huge end
                if not bOrd or bOrd <= 0 then bOrd = math.huge end
                if aOrd < bOrd then
                    best = c
                end
            elseif delta < 0 then
                best = c
            end
        end
    end
    return best.id, best.point
end

function WaypointManager:_syncDuiOwner()
    if not CanShowWaypoints() then
        for id, m in pairs( self.markers ) do
            if not m.parallelDuiLane then
                self:_setActive( id, m, false )
            end
        end

        self.activeDuiOwner = nil
        return
    end

    local candidates = self:_groupCandidates()

    local activeSet = {}
    for _, c in pairs(candidates) do
        activeSet[c.id] = true
    end

    for id, m in pairs(self.markers) do
        if not m.parallelDuiLane then
            self:_setActive(id, m, activeSet[id] == true)
        end
    end

    local newOwnerId = self:_selectPreferred(candidates)

    if newOwnerId == self.activeDuiOwner then return end

    self.activeDuiOwner = newOwnerId
end

function WaypointManager:_syncParallelLane()
    if not CanShowWaypoints() then
        for id, m in pairs( self.markers ) do
            if m.parallelDuiLane then
                self:_setActive( id, m, false )
            end
        end

        return
    end

    local ctx
    for id, m in pairs( self.markers ) do
        if m.parallelDuiLane then
            local on = m.running and m.currentDist <= m.markerDistance
            if on and not m.alwaysVisibleDui then
                ctx = ctx or DUIPoint.beginFrameCtx()
                on = DUIPoint.isInForwardCone( m.coords.x, m.coords.y, m.coords.z, 35.0, ctx )
                if on then
                    on = DUIPoint.projectScreen( m.coords.x, m.coords.y, m.coords.z ).inViewport
                end
            end
            self:_setActive( id, m, on )
        end
    end
end

function WaypointManager:_syncEdgeIndicators()
    if not CanShowWaypoints() then
        if self.edgeIndicatorsWereShown then
            DUIPoint.clearMarkerIndicators()
            self.edgeIndicatorsWereShown = false
            self._lastIndicatorsPayloadSig = nil
        end

        return
    end

    local ctx = DUIPoint.beginFrameCtx()

    for k in pairs( edgeSuppressed ) do edgeSuppressed[k] = nil end
    for k in pairs( edgeWinners ) do edgeWinners[k] = nil end

    -- Passo 1: família suprimida quando algum ponto dela está em tela (ou mirado, se configurado).
    for _, m in pairs( self.edgeEligible ) do
        if m.running then
            local c = m.coords
            local _, _, _, inView = DUIPoint.projectScreenRaw( c.x, c.y, c.z )
            m._edgeInView = inView
            if inView or ( m.suppressIndicatorWhenAimed and DUIPoint.isInForwardCone( c.x, c.y, c.z, nil, ctx ) ) then
                edgeSuppressed[m.family or 'default'] = true
            end
        end
    end

    -- Passo 2: um vencedor por família (menor currentDist, desempate pelo id).
    for id, m in pairs( self.edgeEligible ) do
        if m.running and not m._edgeInView then
            local family = m.family or 'default'
            if not edgeSuppressed[family] then
                local cur = edgeWinners[family]
                if not cur
                    or m.currentDist < cur.currentDist
                    or ( m.currentDist == cur.currentDist and id < cur._id )
                then
                    edgeWinners[family] = m
                end
            end
        end
    end

    -- Passo 3: só a assinatura (mesmo formato/quantização de antes); payload só quando muda.
    local n = 0
    for _, m in pairs( edgeWinners ) do
        local c = m.coords
        local x, y, angle, direction = DUIPoint.edgeValues( c.x, c.y, c.z, ctx )
        m._edgeX, m._edgeY, m._edgeAngle, m._edgeDir = x, y, angle, direction
        n = n + 1
        edgeSigParts[n] = ( '%s|%d|%d,%d|%dm|%s' ):format(
            m.markerNuiId or ( 'wp_%d' ):format( m._id ),
            math.floor( angle * 100 ),
            math.floor( x * 4 ), math.floor( y * 4 ),
            math.floor( m.currentDist ),
            direction
        )
    end
    for i = n + 1, #edgeSigParts do edgeSigParts[i] = nil end

    if n == 0 then
        if self.edgeIndicatorsWereShown then
            DUIPoint.clearMarkerIndicators()
            self.edgeIndicatorsWereShown = false
            self._lastIndicatorsPayloadSig = nil
        end
        return
    end

    table.sort( edgeSigParts )
    local sigStr = table.concat( edgeSigParts, ';' )

    self.edgeIndicatorsWereShown = true
    if sigStr == self._lastIndicatorsPayloadSig then return end
    self._lastIndicatorsPayloadSig = sigStr

    local markers = {}
    for _, m in pairs( edgeWinners ) do
        markers[#markers + 1] = {
            id                 = m.markerNuiId or ( 'wp_%d' ):format( m._id ),
            visible            = true,
            title              = m.title,
            distance           = math.floor( m.currentDist ) .. 'm',
            icon               = DUIPoint.normalizeIconToken( m:displayIcon() ),
            position           = { x = m._edgeX, y = m._edgeY },
            angle              = m._edgeAngle,
            direction          = m._edgeDir,
            customBorderColors = m.customBorderColors,
            markerScale        = m.indicatorScale or m.markerScale,
            markerIconScale    = m.indicatorIconScale or m.markerIconScale,
        }
    end

    DUIPoint.sendMarkerIndicators( markers )
end

function WaypointManager:syncMarkerIndicator()
    self:_syncDuiOwner()
    self:_syncParallelLane()
    self:_syncEdgeIndicators()
end

function WaypointManager:startIndicatorThread()
    CreateThread( function()
        while true do
            Wait( 100 )

            if GetGameTimer() - lastGateRefresh >= GATE_REFRESH_MS then
                refreshGate()
            end

            if next( self.markers ) ~= nil then
                self:_syncDuiOwner()
                self:_syncParallelLane()
            end
        end
    end)

    CreateThread( function()
        while true do
            if next( self.edgeEligible ) == nil then
                Wait( 250 )
            else
                Wait( 16 )
                self:_syncEdgeIndicators()
            end
        end
    end)

    CreateThread( function()
        while true do
            Wait( 500 )
            local pPos = GetEntityCoords( PlayerPedId() )
            for id, m in pairs( self.markers ) do
                m:tickProximity( pPos )
                if m.running and m:_withinIndicatorDistance( m.currentDist ) then
                    self.edgeEligible[id] = m
                else
                    self.edgeEligible[id] = nil
                end
            end
        end
    end)

    -- Sky offset + render no mesmo frame. O sky não fica atrás do gate de activeMarkers:
    -- pontos fora de tela/inativos ainda precisam de Z fresco (setas, currentDist, cones).
    CreateThread( function()
        while true do
            if next( self.activeMarkers ) == nil and next( self.skyOffsetMarkers ) == nil then
                Wait( 100 )
            else
                Wait( 0 )

                -- Relê após o Wait: removeAll/clearOnStop trocam as tabelas.
                local sky = self.skyOffsetMarkers
                if next( sky ) ~= nil then
                    local pPos = GetEntityCoords( PlayerPedId() )
                    for _, m in pairs( sky ) do
                        if m.running then
                            m:tickSkyOffset( pPos )
                        end
                    end
                end

                for _, m in pairs( self.activeMarkers ) do
                    m:tickRender()
                end
            end
        end
    end)
end
