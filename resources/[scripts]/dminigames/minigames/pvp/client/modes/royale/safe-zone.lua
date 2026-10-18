---@class RoyaleSafeZoneClient
---@field matchId? number
---@field snapshot? table Segmento autoritativo; nenhum plano futuro fica no cliente.
---@field mapRenderer? MapZoneRenderer
---@field boundaryRenderer? SpatialZoneBoundaryRenderer
---@field circleCenter table Centro reutilizado no tick para evitar alocacao por frame.
---@field clockOffset? number Relogio do servidor menos relogio local, estimado por RTT.
RoyaleSafeZoneClient = class()

local gMinimapOwner = 'dminigames_royale_safe'
local gSafeMapColor = { 242, 43, 64 }
local gSafeBoundaryTint = { 242, 43, 64 }
local gOutsideWarningKey = 'royale-outside-safe'
local gMapCoverage = { id = 'royale_map_coverage', shape = 'polygon', points = {
    { -9000, -9000 }, { 9000, -9000 }, { 9000, 9000 }, { -9000, 9000 },
} }

---@param value any
---@return boolean
local function IsFinite( value )

    return type( value ) == 'number' and value == value and math.abs( value ) < math.huge
end

---@param circle any
---@return table?
local function CopyCircle( circle )

    if type( circle ) ~= 'table' or type( circle.center ) ~= 'table' or not IsFinite( circle.radius )
        or circle.radius <= 0 then return end

    local center = circle.center

    if not IsFinite( center.x ) or not IsFinite( center.y ) or not IsFinite( center.z ) then return end

    return { center = { x = center.x, y = center.y, z = center.z }, radius = circle.radius }
end

---@param value any
---@return table?
local function CopySnapshot( value )

    if type( value ) ~= 'table' or not IsFinite( value.revision ) or value.revision < 1
        or value.revision % 1 ~= 0 or not IsFinite( value.serverNowMs )
        or not IsFinite( value.durationMs ) or value.durationMs < 0
        or not IsFinite( value.elapsedMs ) or value.elapsedMs < 0
        or ( value.damagePerSecond ~= nil and ( not IsFinite( value.damagePerSecond )
            or value.damagePerSecond % 1 ~= 0 or value.damagePerSecond < 1 or value.damagePerSecond > 13 ) )
        or ( value.phase ~= 'waiting' and value.phase ~= 'closing' and value.phase ~= 'finished' )
        or type( value.paused ) ~= 'boolean' then return end

    local from, target, initial = CopyCircle( value.from ), CopyCircle( value.target ), CopyCircle( value.initial )

    if not from or not target or not initial then return end

    return {
        revision = value.revision, phase = value.phase, paused = value.paused,
        durationMs = value.durationMs, elapsedMs = value.elapsedMs, serverNowMs = value.serverNowMs,
        damagePerSecond = value.damagePerSecond,
        from = from, target = target, initial = initial,
    }
end

---@param enabled boolean
local function SetMinimapForced( enabled )

    if GetResourceState( 'hud' ) == 'started' then
        exports.hud:SetMinimapForced( gMinimapOwner, enabled )
    elseif enabled then
        DisplayRadar( true )
    end
end

function RoyaleSafeZoneClient:__init()

    self.generation = 0
    self.requestCounter = 0
    self.circleCenter = { x = 0.0, y = 0.0, z = 0.0 }
    self.boundaryDebugEnabled = false
    self.lastDamageSequence = 0
    self.outsideSafe = false
    self.nextOutsideCheckAt = 0
end

---@return boolean? enabled
function RoyaleSafeZoneClient:ToggleBoundaryDebug()

    if not self.matchId or not self.snapshot then return nil end

    self.boundaryDebugEnabled = not self.boundaryDebugEnabled
    return self.boundaryDebugEnabled
end

---@param ped number
---@param centerX number
---@param centerY number
---@param radius number
function RoyaleSafeZoneClient:DrawBoundaryDebug( ped, centerX, centerY, radius )

    local coords = GetEntityCoords( ped )
    local deltaX, deltaY = coords.x - centerX, coords.y - centerY
    local distance = math.sqrt( deltaX * deltaX + deltaY * deltaY )
    local scale = distance > 0.001 and radius / distance or 0.0
    local boundaryX = distance > 0.001 and centerX + deltaX * scale or centerX + radius
    local boundaryY = distance > 0.001 and centerY + deltaY * scale or centerY
    local crossZ = coords.z + 30.0

    -- Somente no diagnostico: uma haste alta e uma cruz mostram o ponto XY exato no mundo.
    DrawLine( boundaryX, boundaryY, coords.z - 40.0,
        boundaryX, boundaryY, coords.z + 120.0, 35, 255, 95, 255 )
    DrawLine( boundaryX - 10.0, boundaryY, crossZ,
        boundaryX + 10.0, boundaryY, crossZ, 35, 255, 95, 255 )
    DrawLine( boundaryX, boundaryY - 10.0, crossZ,
        boundaryX, boundaryY + 10.0, crossZ, 35, 255, 95, 255 )

    local signedDistance = distance - radius
    local outside = signedDistance > 0.0

    SetTextFont( 4 )
    SetTextScale( 0.0, 0.45 )
    SetTextColour( outside and 255 or 35, outside and 80 or 255, 95, 255 )
    SetTextCentre( true )
    SetTextOutline()
    BeginTextCommandDisplayText( 'STRING' )
    AddTextComponentSubstringPlayerName( PvpTranslations.get( 'royale_test_safe_boundary_distance', signedDistance ) )
    EndTextCommandDisplayText( 0.5, 0.87 )
end

---@param value any
---@return boolean
local function IsInteger( value )

    return IsFinite( value ) and value % 1 == 0
end

---@param now number
---@return number
function RoyaleSafeZoneClient:GetElapsed( now )

    local snapshot = self.snapshot

    if snapshot.paused or snapshot.phase ~= 'closing' then return snapshot.elapsedMs end

    local sampledAt = self.clockOffset and snapshot.serverNowMs - self.clockOffset or self.receivedAt
    return math.max( 0, snapshot.elapsedMs + now - sampledAt )
end

---@param now number
---@return number x
---@return number y
---@return number z
---@return number radius
function RoyaleSafeZoneClient:GetCircle( now )

    local snapshot = self.snapshot
    local progress = 0.0

    if snapshot.phase == 'finished' then
        progress = 1.0
    elseif snapshot.phase == 'closing' then
        progress = snapshot.durationMs == 0 and 1.0 or math.min( 1.0, self:GetElapsed( now ) / snapshot.durationMs )
    end

    local from, target = snapshot.from, snapshot.target
    return from.center.x + ( target.center.x - from.center.x ) * progress,
        from.center.y + ( target.center.y - from.center.y ) * progress,
        from.center.z + ( target.center.z - from.center.z ) * progress,
        from.radius + ( target.radius - from.radius ) * progress
end

function RoyaleSafeZoneClient:PushMapMotion()

    if not self.mapRenderer or not self.snapshot then return end

    local snapshot = self.snapshot
    self.mapRenderer:SetCircleMotion( 'royale_safe', {
        from = snapshot.from, target = snapshot.target, durationMs = snapshot.durationMs,
        elapsedMs = self:GetElapsed( GetGameTimer() ), paused = snapshot.paused, phase = snapshot.phase,
    } )
end

---@param snapshot table
---@return boolean accepted
function RoyaleSafeZoneClient:Apply( snapshot )

    if not self.matchId then return false end

    local copied = CopySnapshot( snapshot )
    local previous = self.snapshot

    if not copied or ( previous and ( copied.revision < previous.revision
        or ( copied.revision == previous.revision and copied.serverNowMs <= previous.serverNowMs ) ) ) then return false end

    -- A janela inicial pertence a ocorrencia e nao acompanha o fechamento.
    if previous then copied.initial = previous.initial end

    self.snapshot = copied
    self.receivedAt = GetGameTimer()
    self:PushMapMotion()

    return true
end

---@param payload table
---@return boolean applied
---@return boolean? fatal
function RoyaleSafeZoneClient:ApplyDamage( payload )

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId or not self.snapshot
        or not IsInteger( payload.sequence ) or payload.sequence <= self.lastDamageSequence
        or not IsInteger( payload.damage ) or payload.damage < 1 or payload.damage > 13
        or not IsFinite( payload.serverNowMs ) or not IsInteger( payload.pedNetId ) or payload.pedNetId < 1
    then
        return false
    end

    -- Consumir a sequencia antes das verificacoes locais impede replay apos sair da safe.
    self.lastDamageSequence = payload.sequence

    local now = GetGameTimer()

    local clockOffset = self.clockOffset or ( self.snapshot.serverNowMs - self.receivedAt )
    local age = now + clockOffset - payload.serverNowMs

    if age > 2000 or age < -2000 then return false end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) or GetEntityHealth( ped ) <= 100
        or NetworkGetNetworkIdFromEntity( ped ) ~= payload.pedNetId
    then
        return false
    end

    local x, y, _, radius = self:GetCircle( now )
    local coords = GetEntityCoords( ped )
    local deltaX, deltaY = coords.x - x, coords.y - y

    if deltaX * deltaX + deltaY * deltaY <= radius * radius then return false end

    local health = math.max( 0, GetEntityHealth( ped ) - payload.damage )
    SetEntityHealth( ped, health )
    return true, health <= 100
end

---@param attempts? number
function RoyaleSafeZoneClient:RequestSync( attempts )

    if not self.matchId or self.pendingSync then return end

    self.requestCounter = self.requestCounter + 1
    local request = { id = self.requestCounter, sentAt = GetGameTimer() }
    local generation = self.generation
    self.pendingSync = request
    TriggerServerEvent( 'pvp.royale:requestSafeSync', self.matchId, request.id )
    SetTimeout( 5000, function()

        if self.generation ~= generation or self.pendingSync ~= request then return end

        self.pendingSync = nil

        if ( attempts or 1 ) < 3 then self:RequestSync( ( attempts or 1 ) + 1 ) end
    end )
end

---@param payload table
---@return boolean accepted
function RoyaleSafeZoneClient:Synchronize( payload )

    local request = self.pendingSync

    if type( payload ) ~= 'table' or payload.matchId ~= self.matchId or not request
        or payload.requestId ~= request.id or not IsFinite( payload.serverNowMs )
        or not CopySnapshot( payload.safe ) then return false end

    local now = GetGameTimer()
    local roundTrip = now - request.sentAt

    if roundTrip < 0 or roundTrip > 2000 then return false end

    self.pendingSync = nil
    self.clockOffset = payload.serverNowMs - ( request.sentAt + now ) / 2
    self:Apply( payload.safe )
    -- Um reply antigo pode calibrar o relogio, mas nunca desfaz uma pausa/fase mais nova.
    self:PushMapMotion()
    return true
end

---@param generation number
function RoyaleSafeZoneClient:ScheduleClockSync( generation )

    -- Calibracao esparsa, com jitter: nenhum snapshot de geometria por frame/segundo.
    SetTimeout( 60000 + math.random( 0, 10000 ), function()

        if self.generation ~= generation or not self.matchId then return end

        self:RequestSync()
        self:ScheduleClockSync( generation )
    end )
end

function RoyaleSafeZoneClient:ClearOutsideWarning()

    if not self.outsideSafe then return end

    self.outsideSafe = false
    SendNUIMessage( {
        action = 'PVP_DOMINATION_NOTIFY_CLEAR',
        type = 'PVP_DOMINATION_NOTIFY_CLEAR',
        data = { key = gOutsideWarningKey },
    } )
end

---@param now number
---@param ped number
---@param x number
---@param y number
---@param radius number
function RoyaleSafeZoneClient:UpdateOutsideWarning( now, ped, x, y, radius )

    if now < self.nextOutsideCheckAt then return end

    -- Reutiliza o tick visual; coordenadas/vida sao lidas no maximo quatro vezes por segundo.
    self.nextOutsideCheckAt = now + 250

    if GetEntityHealth( ped ) <= 100 then self:ClearOutsideWarning(); return end

    local coords = GetEntityCoords( ped )
    local deltaX, deltaY = coords.x - x, coords.y - y

    if deltaX * deltaX + deltaY * deltaY <= radius * radius then
        self:ClearOutsideWarning()
        return
    end

    if self.outsideSafe then return end

    self.outsideSafe = true
    SendNUIMessage( {
        action = 'PVP_DOMINATION_NOTIFY',
        type = 'PVP_DOMINATION_NOTIFY',
        data = {
            key = gOutsideWarningKey,
            kind = 'closing',
            title = PvpTranslations.get( 'royale_name' ),
            message = PvpTranslations.get( 'royale_outside_safe_warning' ),
            durationMs = 5000,
        },
    } )
end

function RoyaleSafeZoneClient:Draw()

    if not self.snapshot or not self.boundaryRenderer then return end

    if IsPauseMenuActive() or IsScreenFadedOut() then
        Wait( 250 )
        return
    end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then
        self:ClearOutsideWarning()
        Wait( 250 )
        return
    end

    local now = GetGameTimer()
    local x, y, z, radius = self:GetCircle( now )
    self:UpdateOutsideWarning( now, ped, x, y, radius )
    local center = self.circleCenter
    center.x, center.y, center.z = x, y, z

    -- A parede acompanha o circulo XY exato; o cilindro gigante do GTA desloca
    -- visualmente a borda em raios grandes.
    self.boundaryRenderer:DrawCircleNear( center, radius, gSafeBoundaryTint, z - 50.0, 500.0, 255 )
    if self.boundaryDebugEnabled then self:DrawBoundaryDebug( ped, x, y, radius ) end
    -- setTick ja cede um frame; outro Wait(0) aqui faz o marker piscar.
end

---@param matchId number
---@param snapshot table
---@return boolean opened
function RoyaleSafeZoneClient:Open( matchId, snapshot )

    if not CopySnapshot( snapshot ) then return false end
    if self.matchId == matchId then return self:Apply( snapshot ) end

    self:Close()
    self.matchId = matchId
    self:Apply( snapshot )
    local initial = self.snapshot.initial
    local zone = { id = 'royale_safe', shape = 'circle', center = initial.center, radius = initial.radius,
        type = 'capture', state = 'controlled', name = PvpTranslations.get( 'royale_name' ),
        color = gSafeMapColor, fillOutside = true, circleMotionFrameIntervalMs = 250 }
    local renderer = MapZoneRenderer( {
        textureDictionaryPrefix = 'dmg_royale_safe', canvasSize = 2048,
        maxWindowSpan = math.huge, projectionZones = { zone, gMapCoverage },
        circleSegments = 32,
    } )
    self.mapRenderer = renderer
    renderer:setZones( { zone } )
    self:PushMapMotion()
    self.boundaryRenderer = SpatialZoneBoundaryRenderer( {
        textureImage = 'web/domination-zone-boundary.png',
        cylinderTextureImage = 'web/domination-zone-boundary-cylinder.png',
        textureDictionaryPrefix = 'domination_boundary',
        textureName = 'atlas',
        zones = {},
    } )
    local generation = self.generation
    self.tickAbort = sx.script.setTick( function()

        if self.generation == generation then self:Draw() end
    end )
    SetMinimapForced( true )
    self:RequestSync()
    self:ScheduleClockSync( generation )

    CreateThread( function()

        local shown = renderer:show()

        if self.generation ~= generation then return end

        if not shown then sx.logger:warn( 'Royale: nao foi possivel abrir o minimapa da safe' ) end
    end )
    return true
end

function RoyaleSafeZoneClient:Close()

    local wasActive = self.matchId ~= nil
    self:ClearOutsideWarning()
    self.nextOutsideCheckAt = 0
    self.generation = self.generation + 1
    self.matchId, self.snapshot, self.clockOffset, self.pendingSync = nil, nil, nil, nil
    self.lastDamageSequence = 0
    self.boundaryDebugEnabled = false

    if self.tickAbort then self.tickAbort(); self.tickAbort = nil end

    local renderer = self.mapRenderer
    self.mapRenderer = nil

    if renderer then renderer:destroy() end

    local boundaryRenderer = self.boundaryRenderer
    self.boundaryRenderer = nil

    if boundaryRenderer then boundaryRenderer:destroy() end
    if wasActive then SetMinimapForced( false ) end
end
