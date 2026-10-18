local isArmed = false
local isUploading = false
local isDebugging = false
local isAskingMic = false
local hasAskedMic = false

--- Log do lado do client.
---
--- Silencioso por padrao: o clipe e automatico e nada dele pode aparecer para o admin,
--- nem no F8. Com o `/clipe-debug` aberto a instrumentacao volta, que e quando alguem
--- esta de fato investigando. Falha sempre chega ao servidor por `clipper:failed`,
--- entao nada se perde para diagnostico.
---@param level string
---@param message string
local function DebugLog( level, message )

    if not isDebugging then
        return
    end

    if level == 'warn' then
        sx.logger:warn( message )
    else
        sx.logger:info( message )
    end
end

--- Liga o buffer retroativo. A partir daqui a NUI grava continuamente em memoria e
--- descarta o que passa da janela; nada sai da maquina ate um ban pedir o clipe.
---@param payload table
local function Arm( payload )

    if type( payload ) ~= 'table' or not payload.durationMs then
        return
    end

    payload.action = 'arm'
    payload.clipper = true

    isArmed = true

    SendNuiMessage( json.encode( payload ) )
end

RegisterNetEvent( 'clipper:arm', function( payload )
    Arm( payload )
end)

--- O prompt nativo do FiveM so pode ser aceito com foco de NUI.
RegisterNetEvent( 'clipper:requestMic', function()

    if isAskingMic then
        return
    end

    isAskingMic = true

    SetNuiFocus( true, true )
    SendNuiMessage( json.encode({ clipper = true, action = 'requestMic' }) )

    CreateThread(function()

        -- Solta o foco mesmo se a NUI nunca responder.
        local deadline = GetGameTimer() + 30000

        while isAskingMic and GetGameTimer() < deadline do
            Wait( 100 )
        end

        isAskingMic = false

        SetNuiFocus( false, false )
        SetNuiFocusKeepInput( false )
    end)
end)

--- Desliga o buffer e solta o encode. Usado ao fim do `/clipe-teste` numa cidade que
--- nao esta habilitada: sem isto o admin ficaria gravando de graca para sempre.
RegisterNetEvent( 'clipper:disarm', function()

    isArmed = false

    SendNuiMessage( json.encode({ clipper = true, action = 'disarm' }) )
end)

RegisterNetEvent( 'clipper:capture', function( payload )

    if type( payload ) ~= 'table' or type( payload.sessionId ) ~= 'string' then
        return
    end

    -- O servidor ja bloqueia sessoes concorrentes; esta guarda protege o cliente
    -- contra um evento duplicado no meio de um upload.
    if isUploading then
        return
    end

    -- Cobre o caso de o resource ter sido reiniciado depois do arm original.
    if not isArmed then
        Arm( payload.buffer )
    end

    isUploading = true

    SendNuiMessage( json.encode({
        clipper   = true,
        action    = 'capture',
        sessionId = payload.sessionId,
        token     = payload.token,
        -- Presentes so no modo `uploadFrom = 'client'`: com eles a NUI posta o clipe
        -- direto na API e o arquivo nao passa pelo servidor da cidade.
        apiUrl    = payload.apiUrl,
        uploadsUrl = payload.uploadsUrl,
        apiKey    = payload.apiKey,
        fileName  = payload.fileName,
        payload   = payload.payload,
    }))
end)

--- Janela deslizante de quem estava falando. Nao guarda audio nenhum: so `serverId` e
--- o instante da fala. O audio em si ja existe no servidor, gravado pelo Zumble, e e
--- por esta lista mais a janela de tempo que a fase de ban vai casar um com o outro.
---@type table<integer, table>
local talkerLog = {}

---@param nowMs integer
local function PruneTalkerLog( nowMs )

    local horizon = nowMs - Clipper.SegmentMs() - 5000
    local kept = {}

    for _, entry in ipairs( talkerLog ) do

        if entry.at >= horizon then
            kept[ #kept + 1 ] = entry
        end
    end

    talkerLog = kept
end

--- Monta a lista de falantes da janela do clipe, em segundos a partir do inicio dele.
---@param clipSeconds number
---@return table
local function CollectTalkers( clipSeconds )

    local endsAt = GetGameTimer()
    local startsAt = endsAt - math.floor( clipSeconds * 1000 )

    ---@type table<integer, table>
    local byServerId = {}

    for _, entry in ipairs( talkerLog ) do

        if entry.at >= startsAt and entry.at <= endsAt then

            local bucket = byServerId[ entry.serverId ]

            if not bucket then

                bucket = { serverId = entry.serverId, offsets = {} }

                byServerId[ entry.serverId ] = bucket
            end

            bucket.offsets[ #bucket.offsets + 1 ] = math.floor( ( entry.at - startsAt ) / 100 ) / 10
        end
    end

    local talkers = {}

    for _, bucket in pairs( byServerId ) do
        talkers[ #talkers + 1 ] = bucket
    end

    return talkers
end

CreateThread(function()

    while true do

        if isArmed and Clipper.recordTalkers then

            local me = PlayerId()
            local now = GetGameTimer()

            -- `GetActivePlayers` ja devolve so quem esta em escopo, que e a mesma
            -- vizinhanca que o Mumble usa para a voz por proximidade.
            for _, player in ipairs( GetActivePlayers() ) do

                if MumbleIsPlayerTalking( player ) then

                    talkerLog[ #talkerLog + 1 ] = {
                        serverId = GetPlayerServerId( player ),
                        at       = now,
                        isSelf   = player == me,
                    }
                end
            end

            PruneTalkerLog( now )
        end

        Wait( Clipper.talkerSampleMs )
    end
end)

RegisterNUICallback( 'clipper:uploaded', function( data, cb )

    TriggerServerEvent( 'clipper:uploaded', data and data.sessionId, data and data.token, {
        status  = tonumber( data and data.status ) or 0,
        bytes   = tonumber( data and data.bytes ) or 0,
        seconds = tonumber( data and data.seconds ) or 0,
        body    = type( data and data.body ) == 'string' and data.body:sub( 1, 4096 ) or '',
    })

    cb( { ok = true } )
end)

--- Repassa a duracao real do clipe e quem estava falando nela.
RegisterNUICallback( 'clipper:meta', function( data, cb )

    local clipSeconds = tonumber( data and data.clipSeconds ) or 0

    TriggerServerEvent( 'clipper:meta', data and data.sessionId, data and data.token, {
        clipSeconds = clipSeconds,
        -- Clipe curto: o ban saiu antes de o buffer encher. Segue para o servidor
        -- porque muda como o suporte deve ler aquele arquivo.
        partial     = data and data.partial == true,
        drawFps     = tonumber( data and data.drawFps ) or 0,
        gameFps     = tonumber( data and data.gameFps ) or 0,
        talkers     = Clipper.recordTalkers and CollectTalkers( clipSeconds ) or {},
    })

    cb( { ok = true } )
end)

--- Alimenta o HUD com FPS e frame time do jogo. A thread so existe enquanto o HUD
--- esta aberto, entao o custo do debug e zero quando desligado.
---@param sampleMs integer
local function StartDebugSampler( sampleMs )

    CreateThread(function()

        while isDebugging do

            local frameTime = GetFrameTime()

            SendNuiMessage( json.encode({
                clipper     = true,
                action      = 'sample',
                fps         = frameTime > 0.0 and ( 1.0 / frameTime ) or 0.0,
                frameTimeMs = frameTime * 1000.0,
            }))

            Wait( sampleMs )
        end
    end)
end

RegisterNetEvent( 'clipper:toggleDebug', function( sampleMs )

    isDebugging = not isDebugging

    SendNuiMessage( json.encode({
        clipper = true,
        action  = 'debug',
        enabled = isDebugging,
    }))

    if not isDebugging then
        return
    end

    StartDebugSampler( tonumber( sampleMs ) or 500 )
end)

RegisterNUICallback( 'clipper:sha256Probe', function( data, cb )

    TriggerServerEvent( 'clipper:sha256Probe', type( data ) == 'table' and data or {} )

    cb( { ok = true } )
end)

RegisterNUICallback( 'clipper:micPending', function( _data, cb )

    cb( { ok = true } )

    if isAskingMic or hasAskedMic then
        return
    end

    hasAskedMic = true

    CreateThread(function()

        Wait( Clipper.micPrimeDelayMs or 15000 )

        if not isArmed then
            return
        end

        TriggerEvent( 'clipper:requestMic' )
    end)
end)

RegisterNUICallback( 'clipper:micResult', function( data, cb )

    isAskingMic = false

    local granted = type( data ) == 'table' and data.granted == true
    local loopback = type( data ) == 'table' and data.loopback == true

    DebugLog( 'info', ('clipper: microfone concedido=%s loopback=%s motivo=%s'):format(
        tostring( granted ), tostring( loopback ),
        type( data ) == 'table' and tostring( data.reason ) or 'nil'
    ))

    TriggerServerEvent( 'clipper:micResult', granted, loopback,
        type( data ) == 'table' and data.reason or nil,
        type( data ) == 'table' and data.devices or nil )

    cb( { ok = true } )
end)

RegisterNUICallback( 'clipper:finished', function( data, cb )

    isUploading = false

    cb( { ok = true } )
end)

RegisterNUICallback( 'clipper:failed', function( data, cb )

    isUploading = false

    local reason = type( data ) == 'table' and data.reason or 'unknown'
    local sessionId = type( data ) == 'table' and data.sessionId or nil

    -- Uma falha ao armar derruba o buffer inteiro; sem isso o proximo /clipe
    -- acharia que ainda ha gravacao em memoria.
    if type( reason ) == 'string' and reason:find( '^arm_failed' ) then
        isArmed = false
    end

    DebugLog( 'warn', ('clipper: capture failed reason=%s'):format( tostring( reason ) ) )

    TriggerServerEvent( 'clipper:failed', sessionId, reason )

    cb( { ok = true } )
end)

AddEventHandler( 'playerSpawned', function()

    if isArmed then
        return
    end

    TriggerServerEvent( 'clipper:requestArm' )
end)

AddEventHandler( 'onClientResourceStart', function( resource )

    if resource ~= GetCurrentResourceName() then
        return
    end

    isArmed = false
    isUploading = false

    CreateThread(function()

        -- Espera o jogador existir de fato: armar antes disso desperdicaria encode
        -- gravando a tela de loading.
        while not NetworkIsSessionStarted() do
            Wait( 1000 )
        end

        TriggerServerEvent( 'clipper:requestArm' )
    end)
end)

AddEventHandler( 'onResourceStop', function( resource )

    if resource ~= GetCurrentResourceName() then
        return
    end

    isArmed = false
    isUploading = false
    isDebugging = false
end)

--- Escada de rede: mede ate que tamanho o `fetch` da NUI entrega o corpo inteiro.
RegisterNetEvent( 'clipper:netLadder', function( payload )

    if type( payload ) ~= 'table' then
        return
    end

    payload.clipper = true
    payload.action = 'netladder'

    SendNuiMessage( json.encode( payload ) )
end)

RegisterNUICallback( 'clipper:netladder', function( data, cb )

    TriggerServerEvent( 'clipper:netLadderResult', {
        size    = tonumber( data and data.size ) or 0,
        status  = tonumber( data and data.status ) or 0,
        seconds = tonumber( data and data.seconds ) or 0,
        cut     = data and data.cut == true,
        body    = type( data and data.body ) == 'string' and data.body or '',
    })

    cb( { ok = true } )
end)
