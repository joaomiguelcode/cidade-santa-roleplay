sx.client.nui = { }

-- TODO: Make logger lazy?
local nuiLogger = sx.logger:child({ tag = 'nui' })

local function encodeNuiLogValue(value)
    if value == nil then
        return 'nil'
    end

    local ok, encoded = pcall(json.encode, value)

    if ok then
        return encoded
    end

    return tostring(value)
end

sx.client.http = { }

sx.client.http.transports = { }

sx.client.http.transports.nui = sx.http.transport.create( function( url, options, cb )

    -- Id unico para evitar requests perdidos 
    local requestId = sx.uuidv4()

    local callbackUri = ('%s'):format( requestId )

    -- Ouvir a resposta da NUI
    RegisterNUICallback( callbackUri, function( data, _cb )

        -- Sempre executar antes de tudo!
        _cb({ ok = true })

        -- Sempre executar antes de tudo!
        UnregisterRawNuiCallback( callbackUri )

        assert( data, '"data" parameter is required!' )

        assert( data.status, '"data.status" is required!' )

        if data.status ~= 200 then

            nuiLogger:error( ('Received NUI callback for request "%s" data = %s'):format( callbackUri, json.encode( data.errorData, { indent = true } ) ) )
        end

        cb( data.status, data.body, data.responseHeaders, data.errorData )
    end)

    -- Pedir para que a NUI faça um fetch e nos retorne a resposta!
    exports[ LIB_RESOURCE_NAME ]:nui_proxy_send_message({
        type = 'fetch',

        invokingResource = GetCurrentResourceName(),

        data =
        {
            url = url,
            input = options.input,
            method = options.method,
            headers = options.headers,

            callbackUri = callbackUri,
        }
    })

    -- nuiLogger:debug( ('Sent NUI fetch url="%s" callbackUri="%s" method="%s" input=%s'):format( url, callbackUri, tostring( options.method ), encodeNuiLogValue( options.input ) ) )
end)

sx.client.nui.fetch = sx.client.http.transports.nui

-- ── NUI Bootstrap: convar bridge for nui_loader.js ──────────────

do
    local BOOTSTRAP_CONVARS = { 'ui_branch', 'ui_cdn_base' }
    local resourceName   = GetCurrentResourceName()
    local uiPageName     = GetResourceMetadata( resourceName, 'sx_ui_page_name', 0 ) or resourceName
    local uiBranchMeta   = GetResourceMetadata( resourceName, 'sx_ui_branch', 0 )
    local localConvar    = ('ui_local_%s'):format( uiPageName )

    local bootstrapLogger = sx.logger:child({ tag = 'nui:bootstrap' })

    bootstrapLogger:info( ('Initializing convar bridge resource="%s" uiPageName="%s" uiBranchMeta="%s" localConvar="%s"'):format(
        resourceName, uiPageName, uiBranchMeta or '', localConvar
    ) )

    -- ── HyperDX direct logging (correlated with NUI via trace_id) ──
    local HYPERDX_URL        = 'http://api.roleplayrp.com:14318/v1/logs'
    local HYPERDX_INGEST_KEY = '91754ac8-b4b9-47c0-b6c7-b7a2729559d2'
    local SERVICE_NAME       = 'fivem-client'

    -- Adopted from NUI on the first getConvars round-trip. Logs emitted
    -- before that are buffered and flushed once we have the trace.
    local nuiTraceId  = nil
    local pendingLogs = {}

    math.randomseed( GetCloudTimeAsInt() + GetGameTimer() )

    local function randHex( bytes )
        local t = {}
        for i = 1, bytes do
            t[ i ] = ('%02x'):format( math.random( 0, 255 ) )
        end
        return table.concat( t )
    end

    local function attrString( k, v ) return { key = k, value = { stringValue = tostring( v ) } } end
    local function attrInt( k, v )    return { key = k, value = { intValue    = tostring( v ) } } end

    -- Crude OTLP/HTTP log shipper. Fire-and-forget; failures are swallowed
    -- because there's no recovery path and we don't want to spam the console.
    local function clientLog( severity, body, extra )
        if not nuiTraceId then
            pendingLogs[ #pendingLogs + 1 ] = { severity, body, extra }
            return
        end

        local attrs = {
            attrString( 'event.name',     'nui_loader.lua.' .. ( extra and extra.event or 'log' ) ),
            attrString( 'resource',       resourceName ),
            attrString( 'ui_page_name',   uiPageName ),
            attrInt(    'player_source',  GetPlayerServerId( PlayerId() ) ),
            attrString( 'side',           'lua_client' ),
        }

        if extra then
            for k, v in pairs( extra ) do
                if k ~= 'event' then
                    attrs[ #attrs + 1 ] = attrString( k, v )
                end
            end
        end

        local payload = {
            resourceLogs = { {
                resource = { attributes = { attrString( 'service.name', SERVICE_NAME ) } },
                scopeLogs = { {
                    logRecords = { {
                        timeUnixNano = tostring( GetCloudTimeAsInt() ) .. '000000000',
                        severityText = severity,
                        body         = { stringValue = body },
                        traceId      = nuiTraceId,
                        spanId       = randHex( 8 ),
                        attributes   = attrs,
                    } },
                } },
            } },
        }

        -- Route through the NUI proxy transport (sx.client.http.transports.nui).
        -- It blocks on Citizen.Await internally, so spawn a thread to fire-and-forget.
        Citizen.CreateThread( function()
            sx.client.http.transports.nui( HYPERDX_URL, {
                method  = 'POST',
                input   = payload,
                headers = {
                    [ 'Content-Type' ]  = 'application/json',
                    [ 'Authorization' ] = HYPERDX_INGEST_KEY,
                },
            } )
        end )
    end

    local function getBootstrapConvars()

        local result = {
            ui_page_name = uiPageName,
        }

        for _, name in ipairs( BOOTSTRAP_CONVARS ) do
            result[ name ] = GetConvar( name, '' )
        end

        -- fxmanifest `sx_ui_branch` overrides the global ui_branch convar for this resource
        if uiBranchMeta and uiBranchMeta ~= '' then
            result.ui_branch = uiBranchMeta
        end

        result[ localConvar ] = GetConvar( localConvar, '' )

        return result
    end

    -- Initial fetch from nui_loader.js
    RegisterNUICallback( 'getConvars', function( data, cb )

        if data and type( data.traceId ) == 'string' and #data.traceId == 32 and not nuiTraceId then
            nuiTraceId = data.traceId

            -- Flush logs that were emitted before the trace was known
            local flushed = pendingLogs
            pendingLogs = {}
            for _, args in ipairs( flushed ) do
                clientLog( args[ 1 ], args[ 2 ], args[ 3 ] )
            end
        end

        local payload = getBootstrapConvars()

        bootstrapLogger:info( ('NUI requested getConvars traceId=%s payload=%s'):format( nuiTraceId or '<none>', json.encode( payload ) ) )
        clientLog( 'INFO', 'getConvars callback hit', { event = 'get_convars', payload_keys = table.concat( ( function()
            local k = {}; for key in pairs( payload ) do k[ #k + 1 ] = key end; return k
        end )(), ',' ) } )

        cb( payload )
    end)

    -- Tell the NUI loader the callback is registered. The loader has its own
    -- fallback retry loop, but this lets it skip the wait when timing cooperates.
    bootstrapLogger:info( 'Sending bootstrapReady to NUI' )
    SendNUIMessage({ type = 'bootstrapReady' })
    clientLog( 'INFO', 'bootstrapReady sent', { event = 'bootstrap_ready_sent' } )

    -- ── Wide-event meta bridge ─────────────────────────────────────
    -- Push arbitrary key/value pairs into the NUI loader's wide-event
    -- context so every telemetry record carries them.
    local function pushWide( tbl )
        if type( tbl ) ~= 'table' then return end
        SendNUIMessage({ type = 'setWide', data = tbl })
    end

    -- Default meta dumped once at startup. Cheap to compute, very useful for
    -- slicing failures by build / endpoint / player in HyperDX.
    pushWide({
        player_source     = GetPlayerServerId( PlayerId() ),
        game_build        = GetGameBuildNumber and GetGameBuildNumber() or 0,
        cfx_resource      = resourceName,
        ui_branch_meta    = uiBranchMeta or '',
        server_endpoint   = GetCurrentServerEndpoint and GetCurrentServerEndpoint() or '',
    })

    -- Push convar changes to NUI in real time
    for _, name in ipairs( BOOTSTRAP_CONVARS ) do

        AddConvarChangeListener( name, function()

            local value = GetConvar( name, '' )

            -- fxmanifest metadata pins the branch for this resource; ignore live convar changes
            if name == 'ui_branch' and uiBranchMeta and uiBranchMeta ~= '' then
                bootstrapLogger:debug( ('Ignoring ui_branch change="%s" (pinned by fxmanifest sx_ui_branch="%s")'):format( value, uiBranchMeta ) )
                return
            end

            bootstrapLogger:info( ('Pushing convarSet to NUI key="%s" value="%s"'):format( name, value ) )

            SendNUIMessage({
                type  = 'convarSet',
                key   = name,
                value = value,
            })
        end)
    end

    AddConvarChangeListener( localConvar, function()

        local value = GetConvar( localConvar, '' )

        bootstrapLogger:info( ('Pushing convarSet to NUI key="%s" value="%s"'):format( localConvar, value ) )

        SendNUIMessage({
            type  = 'convarSet',
            key   = localConvar,
            value = value,
        })
    end)
end