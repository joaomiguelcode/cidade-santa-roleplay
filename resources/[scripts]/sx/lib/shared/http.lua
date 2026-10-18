sx.http = { }

sx.http.transport = { }

---@alias HttpHeaders table<string, string>

---@alias HttpResponse<TData> { status: eHttpStatus, error: any } | { status: eHttpStatus.OK, data: TData }

---@enum eHttpStatus
eHttpStatus =
{
    OK                    = 200,
    BAD_REQUEST           = 400,
    UNAUTHORIZED          = 401,
    FORBIDDEN             = 403,
    NOT_FOUND             = 404,
    CONFLICT              = 409,
    INTERNAL_SERVER_ERROR = 500,
}

---@enum (key) eHttpMethod
eHttpMethod =
{
    GET    = 'GET',
    POST   = 'POST',
    PUT    = 'PUT',
    DELETE = 'DELETE',
    HEAD   = 'HEAD',
}

---@class HttpTransportOptions
---@field input?   any
---@field method?  eHttpMethod = eHttpMethod.POST
---@field headers? HttpHeaders
---@field timeoutMs? integer
---@field omitBody? boolean

---@alias HttpTransportCallback fun( status: eHttpStatus, body: string, responseHeaders: HttpHeaders, errorData: string ): void

---@param state { settled: boolean }
---@param pendingPromise table
---@param result table
local function ResolvePromiseOnce( state, pendingPromise, result )
    if state.settled then
        return
    end

    state.settled = true
    pendingPromise:resolve( result )
end

---@param fetcher fun( url: string, options: HttpTransportOptions, cb: HttpTransportCallback ): HttpResponse
function sx.http.transport.create( fetcher )

    ---@param url      string
    ---@param options  HttpTransportOptions
    ---@param cb       HttpTransportCallback
    ---@return HttpResponse
    return function( url, options, cb )

        options.input = options.input
            or
            (
                -- Only send body for POST and PUT requests
                options.method ~= eHttpMethod.GET and options.method ~= eHttpMethod.HEAD
                and { }
                or  nil
            )

        options.headers = options.headers or { }

        options.headers[ 'Content-Type' ] = 'application/json'

        local p = promise.new()
        local state = { settled = false }

        fetcher( url, options, function( ... )
            ResolvePromiseOnce( state, p, { ... } )
        end)

        local timeoutMs = tonumber( options.timeoutMs )

        if timeoutMs and timeoutMs > 0 then
            SetTimeout( timeoutMs, function()
                ResolvePromiseOnce(
                    state,
                    p,
                    { 0, '', { }, 'request_timeout' }
                )
            end)
        end

        local status, body, responseHeaders, errorData = table.unpack( Citizen.Await( p ) )

        assert( status ~= 5001, ( 'Ocorreu um error enquanto enviava a request! error = %s %s' ):format( errorData, debug.traceback() ), 3 );

        local succeeded = status >= 200 and status < 300
        local data = nil
        local responseError = not succeeded and errorData or nil
        if body and body:find( '%S' ) then
            local decoded
            decoded, data = pcall( json.decode, body )
            if not decoded then
                data = nil
                if succeeded then responseError = 'invalid_json_response' end
            end
        end

        ---@type HttpResponse
        local response =
        {
            status = status,

            data = data,
            error = responseError,
        }

        if cb then
            cb( status, body, responseHeaders, errorData )
        end

        return response
    end
end

-- sx.http.fetch =
    -- IS_SERVER
    --     and sx.server.http.transports.http
    --     or  sx.client.http.transports.nui
