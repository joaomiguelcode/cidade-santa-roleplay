-- Helpers puros da OnlinePresenceAPI (sem natives, testáveis isoladamente).
-- Contrato definido em D:/apis/OnlinePresenceAPI_PLAN.md.

sx.onlinePresence = { }

-- Path do recurso de presença da sessão atual (PUT/DELETE).
sx.onlinePresence.PRESENCE_PATH = '/v1/players/me/online'

local huge = math.huge

---Número finito de verdade: descarta não-números, NaN e ±infinito.
---@param n any
---@return boolean
local function isFiniteNumber( n )

    return type( n ) == 'number' and n == n and n ~= huge and n ~= -huge
end

sx.onlinePresence.isFiniteNumber = isFiniteNumber

---Coords são auto-reportadas pelo cliente; validamos apenas que são números
---finitos (sem NaN/infinito), conforme o plano.
---@param x any
---@param y any
---@param z any
---@return boolean
function sx.onlinePresence.validateCoords( x, y, z )

    return isFiniteNumber( x ) and isFiniteNumber( y ) and isFiniteNumber( z )
end

---Corpo do heartbeat conforme contrato da OnlinePresenceAPI.
---@param x number
---@param y number
---@param z number
---@param worldId number
---@param profileId string|nil
---@param passport string|nil
---@return { worldId: number, coords: { x: number, y: number, z: number }, profileId: string|nil, passport: string|nil }
function sx.onlinePresence.buildHeartbeatBody( x, y, z, worldId, profileId, passport )

    local body = { worldId = worldId, coords = { x = x, y = y, z = z } }

    if profileId and profileId ~= '' then
        body.profileId = profileId
    end

    if passport and passport ~= '' then
        body.passport = passport
    end

    return body
end

---Junta base + path normalizando barra(s) final(is) da base.
---@param baseUrl string
---@param path    string
---@return string
function sx.onlinePresence.buildUrl( baseUrl, path )

    return ( baseUrl:gsub( '/+$', '' ) ) .. path
end

---Resolve o intervalo do heartbeat em ms, com piso de segurança contra
---configuração inválida ou abusiva.
---@param raw      string|number|nil
---@param minMs    number
---@param fallback number
---@return number
function sx.onlinePresence.resolveIntervalMs( raw, minMs, fallback )

    local n = tonumber( raw )

    -- nil/inválido/NaN -> fallback
    if not n or n ~= n then return fallback end

    if n < minMs then return minMs end

    return math.floor( n )
end
