-- Cliente da OnlinePresenceAPI: cada jogador envia seu PRÓPRIO heartbeat de
-- presença direto do client (via NUI fetch). O servidor da cidade não envia
-- snapshots. Contrato em D:/apis/OnlinePresenceAPI_PLAN.md:
--
--   PUT    {base}/v1/players/me/online   Authorization: Bearer <jwt>  body { worldId, coords, profileId, passport }
--   DELETE {base}/v1/players/me/online   Authorization: Bearer <jwt>
--
-- A presença expira por TTL no servidor (~15s); o DELETE no stop é best-effort.
--
-- Config (convars replicadas via `setr`):
--   sx_online_presence_url        base da API; vazio = recurso desligado
--   sx_online_presence_interval   intervalo do heartbeat em ms (default 1000)
--
-- IMPORTANTE: este é um script padrão de `code/client`. A biblioteca `sx`
-- (carregada pelo linker) fica pronta de forma ASSÍNCRONA, então NENHUM acesso
-- a `sx.*`/`eHttp*` pode acontecer no load; tudo fica atrás de readiness/handlers.
gApiUrl = GetConvar("api_url", "")
local DEFAULT_INTERVAL_MS = 1000
local MIN_INTERVAL_MS     = 250
local STATIONARY_HEARTBEAT_MS  = 10000 -- ms; parado, renova presença só a cada 10s
local MOVEMENT_THRESHOLD_SQ    = 1.0   -- envia a cada tick quando moveu mais de 1 unidade


---@type string|nil  JWT atual do jogador (SGS/cloud system, o mesmo do F1)
local gToken = nil
local gProfileId = nil
local gPassport = nil

---@type boolean  token rejeitado pela API (401/403); espera um novo token
local gTokenBlocked = false

---@type string|nil  último token para o qual já pedimos um novo (um pedido por token)
local gRefreshRequestedFor = nil


---@type number|nil
local gLastSentX = nil

---@type number|nil
local gLastSentY = nil

---@type number|nil
local gLastSentZ = nil

---@type number|nil
local gLastSentWorldId = nil

---@type number
local gLastHeartbeatAt = 0

-- ── ciclo de vida do token ──────────────────────────────────────
-- player_auth_token.lua dispara este evento sempre que o token muda. O handler
-- não toca em `sx`, então é seguro registrá-lo no load.
AddEventHandler( 'sx:playerSessionUpdated', function( info )

    gToken        = info and info.accessToken or nil
    gProfileId    = info and info.user and info.user.profileId or nil
    gPassport     = info and info.user and ( info.user.passport or info.user.externalSub ) or nil
    gTokenBlocked = false
    gLastSentWorldId = nil
    gLastHeartbeatAt = 0
end)

---Igual ao F1: token recusado pede um novo ao servidor em vez de ficar mudo até a próxima
---renovação. O tokensystem reenvia o atual se ainda for válido (o que já desbloqueia).
---@param token string
local function requestFreshToken( token )

    if gRefreshRequestedFor == token then return end

    gRefreshRequestedFor = token
    TriggerServerEvent( 'net.sx.requestPlayerToken', true )
end

---@param token string
---@return HttpHeaders
local function authHeaders( token )

    return { [ 'Authorization' ] = ( 'Bearer %s' ):format( token ) }
end

local function hydrateTokenFromLocalExport()

    local ok, info = pcall( function()

        return exports[ GetCurrentResourceName() ]:GetPlayerAuthTokenInfo()
    end)

    if ok and info then

        gToken        = info.accessToken
        gProfileId    = info.user and info.user.profileId or nil
        gPassport     = info.user and ( info.user.passport or info.user.externalSub ) or nil
        gTokenBlocked = false
    end
end

---Base URL configurada, ou nil quando o recurso está desligado.
---@return string|nil
local function readBaseUrl()

    local url = GetConvar( 'sx_online_presence_url', '' )

    if url == '' then

        if gApiUrl == '' then return nil end

        url = ( '%s:4013' ):format( gApiUrl )
    end

    if not url:match( '^%a[%w+%-%.]*://' ) then
        url = ( 'http://%s' ):format( url )
    end

    return url:gsub( '/+$', '' )
end

---@return number
local function readIntervalMs()

    return sx.onlinePresence.resolveIntervalMs(
        GetConvar( 'sx_online_presence_interval', tostring( DEFAULT_INTERVAL_MS ) ),
        MIN_INTERVAL_MS,
        DEFAULT_INTERVAL_MS
    )
end

---@return number
local function readWorldId()

    if vRP and vRP.GetCurrentRoutingBucket then

        return tonumber( vRP.GetCurrentRoutingBucket() ) or 0
    end

    if LocalPlayer and LocalPlayer.state then

        return tonumber( LocalPlayer.state.Route ) or 0
    end

    return 0
end

---@param x number
---@param y number
---@param z number
---@return number
local function distanceFromLastSentSq( x, y, z )

    if not gLastSentX or not gLastSentY or not gLastSentZ then

        return math.huge
    end

    local dx = x - gLastSentX
    local dy = y - gLastSentY
    local dz = z - gLastSentZ

    return dx * dx + dy * dy + dz * dz
end

---@param x number
---@param y number
---@param z number
---@param worldId number
---@param now number
---@return boolean
local function shouldSendHeartbeat( x, y, z, worldId, now )

    if not gLastSentWorldId or gLastSentWorldId ~= worldId then return true end

    if distanceFromLastSentSq( x, y, z ) > MOVEMENT_THRESHOLD_SQ then return true end

    return now - gLastHeartbeatAt >= STATIONARY_HEARTBEAT_MS
end

---@param x number
---@param y number
---@param z number
---@param worldId number
---@param now number
local function markHeartbeatSent( x, y, z, worldId, now )

    gLastSentX       = x
    gLastSentY       = y
    gLastSentZ       = z
    gLastSentWorldId = worldId
    gLastHeartbeatAt = now
end

---Envia um heartbeat. Bloqueante (round-trip pela NUI); roda só dentro da thread.
---@param baseUrl string
---@param token string
---@param x number
---@param y number
---@param z number
---@param worldId number
---@param profileId string|nil
---@param passport string|nil
---@return boolean
local function sendHeartbeat( baseUrl, token, x, y, z, worldId, profileId, passport )

    local url = sx.onlinePresence.buildUrl( baseUrl, sx.onlinePresence.PRESENCE_PATH )

    -- O transporte NUI dá assert() em erro de rede (status 5001); o pcall
    -- impede que isso derrube a thread de heartbeat.
    local ok, response = pcall( sx.client.nui.fetch, url, {
        method  = eHttpMethod.PUT,
        headers = authHeaders( token ),
        input   = sx.onlinePresence.buildHeartbeatBody( x, y, z, worldId, profileId, passport ),
    })

    if not ok then
        return false
    end

    if response.status == eHttpStatus.UNAUTHORIZED or response.status == eHttpStatus.FORBIDDEN then

        gTokenBlocked = true
        requestFreshToken( token )
    end

    return true
end

---Espera a biblioteca `sx` (carregada async pelo linker) expor tudo que usamos.
local function waitForLibrary()

    while not (
        sx and sx.onlinePresence
        and sx.client and sx.client.nui and sx.client.nui.fetch
        and eHttpMethod and eHttpStatus
    ) do
        Wait( 100 )
    end
end

-- ── loop de heartbeat ───────────────────────────────────────────
CreateThread( function()

    waitForLibrary()

    hydrateTokenFromLocalExport()

    while true do

        local baseUrl = readBaseUrl()

        if baseUrl and gToken and not gTokenBlocked then

            local ped = PlayerPedId()

            if ped ~= 0 and DoesEntityExist( ped ) then

                local coords = GetEntityCoords( ped )

                local x, y, z = coords.x, coords.y, coords.z

                local worldId = readWorldId()

                if sx.onlinePresence.validateCoords( x, y, z ) and sx.onlinePresence.isFiniteNumber( worldId ) then

                    local now = GetGameTimer()

                    if shouldSendHeartbeat( x, y, z, worldId, now ) and sendHeartbeat( baseUrl, gToken, x, y, z, worldId, gProfileId, gPassport ) then

                        markHeartbeatSent( x, y, z, worldId, now )
                    end
                end
            end
        end

        Wait( readIntervalMs() )
    end
end)

-- ── cleanup best-effort no stop ─────────────────────────────────
-- Fire-and-forget: a NUI pode já estar sendo destruída, então não dá pra
-- garantir entrega. A presença expira por TTL de qualquer forma; isto só
-- acelera a limpeza quando o recurso para com o jogador ainda conectado.
AddEventHandler( 'onResourceStop', function( resource )

    if resource ~= GetCurrentResourceName() then return end

    if not ( sx and sx.onlinePresence ) then return end

    local baseUrl = readBaseUrl()

    if not baseUrl or not gToken then return end

    pcall( function()

        exports[ GetCurrentResourceName() ]:nui_proxy_send_message({
            type             = 'fetch',
            invokingResource = GetCurrentResourceName(),
            data             = {
                url         = sx.onlinePresence.buildUrl( baseUrl, sx.onlinePresence.PRESENCE_PATH ),
                method      = eHttpMethod.DELETE,
                headers     = authHeaders( gToken ),
                callbackUri = 'sx_online_presence_delete_noop',
            },
        })
    end)
end)
