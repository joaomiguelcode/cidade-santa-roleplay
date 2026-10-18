---@alias eRequestExtType = 'default' | 'toast'

---@class RequestExt
---@field isValid   boolean
---@field type      eRequestExtType
---@field id        RequestExtId
---@field numAccepted number         É true quando o request ainda está ativo e não foi aceito por nenhum jogador, é false quando já foi aceito por ao menos 1 jogador.
---@field numRefused number
---@field sources   Source[]
---@field message   string
---@field timeoutAt number
---@field opts      RequestExtOptions
---@field done      fun( self, source: Source ): boolean | fun( self, source: nil, failureReason: eRequestFailureReason ): boolean
---@field createdBy request.CreatedBy

---@class RequestContext
---@field numAccepted number

---@class RequestExtOptions
---@field ttl?          number
---@field title?        string
---@field bgColor?      string -- RGBA
---@field subtitle?     string
---@field variant?      string
---@field requesterName? string
---@field requesterId?  integer
---@field declineKey?   "N"|"U"
---@field canAccept?    fun( source: Source, ctx: RequestContext ): boolean
---@field onAccepted?   fun( source: Source ): nil
---@field onRefused?    fun( source: Source, failureReason: eRequestFailureReason ): nil

---@alias RequestExtId number

---@type table<RequestExtId, RequestExt>
local gRequestsExt = { }

---@type number
local gNumRequestsExt = 0

---@type RequestExtId
local gNextRequestId = 1

---@enum eRequestFailureReason
eRequestFailureReason =
{
    Cancelled = 1,
    TimedOut  = 2,
}

---@param id RequestExtId
---@return RequestExt | nil
function GetRequestExt( id )

    local request = gRequestsExt[ id ]

    return request
end

---@alias request.CreatedBy 'server' | 'client'

---@param createdBy         request.CreatedBy -- Esse request é criado pelo client?
---@param sources           SourceLike | { [ string | number ]: SourceLike }
---@param message           string
---@param opts              RequestExtOptions
---@param requestType       eRequestExtType
---@return RequestExt
function StartRequestExt( createdBy, sources, message, opts, requestType )

    message     = message     or ''
    requestType = requestType or 'default'

    opts.ttl = opts.ttl or 30

    sources = type( sources ) == 'table' and sources or { sources }

    assert( next( sources ) ~= nil, 'É necessario ao menos 1 source valida no parametro "sources"' )

    ---@type Source
    sources = table.map( sources, function( source )

        return ToSource( source )
    end)

    -- TODO: Add source status to prevent multiple accepts or cancels
    --[[
    ---@type Request
    local sourcesStatus = table.map( sources, function( source )

        return tostring( source )
    end)
    --]]

    local nextId = gNextRequestId

    gNextRequestId += 1

    ---Queremos sempre um id negativo para sinalizar que é do tipo RequestExt
    ---@type RequestExtId
    local id =
        -- Evitar conflitos de id entre client e server!
        createdBy == 'client'
            and -( 0xFFFFFFF - nextId ) -- Começa em -268435455 e vai aumentando ( -268435454, -268435453, ... )
            or  -(             nextId ) -- Começa em 0          e vai diminuindo (         -1,         -2, ... )

    -- print( 'StartRequestExt', id )

    ---@type RequestExt
    local request =
    {
        isValid = true,

        type = requestType,

        id = id,

        numAccepted = 0,
        numRefused  = 0,

        sources = sources,
        message = message,

        -- TODO: Add source status to prevent multiple accepts or cancels
        --[[
        sourcesStatus = { },
        --]]

        timeoutAt = GetGameTimer() + ( opts.ttl * 1000 ),

        opts = opts,

        delete = function( self )

            self.isValid = false

            gRequestsExt[ self.id ] = nil

            gNumRequestsExt -= 1
        end,

        done = function( self, source, failureReason )

            -- ProfilerEnterScope('Request Done')

            -- print('isValid is=', self.isValid)

            if not self.isValid then
                return false
            end

            assert( self, 'use request:done instead of request.done' )

            -- print( ('done! self.id=%s source="%s" failureReason="%s" self.numAccepted=%d'):format( self.id, source, failureReason, self.numAccepted ) )

            local wasAccepted  = failureReason == nil
            local wasRefused = failureReason ~= nil

            if wasAccepted then

                -- print( ('onAccepted -> source="%s"'):format( source ) )

                self.numAccepted += 1

                if self.opts.onAccepted then

                    xpcall(
                        function()

                            self.opts.onAccepted( source )
                        end,
                        function( err )

                            self.numAccepted -= 1
                        end
                    )
                end
            end

            if wasRefused then

                self.numRefused += 1

                if self.opts.onRefused then

                    xpcall(
                        function()

                            self.opts.onRefused( source, failureReason )
                        end,
                        function( err )

                            self.numRefused -= 1
                        end
                    )
                end

                -- Todos os jogadores recusaram o request, vamos remover-lo
                if self.numRefused >= #self.sources then

                    self:delete()
                end
            end

            -- ProfilerExitScope() -- Request Done

            return true
        end,
    }

    gRequestsExt[ id ] = request

    gNumRequestsExt += 1

    return request
end

CreateThread(function()

    while true do

        Wait( 500 )

        if gNumRequestsExt >= 1 then

            local now = GetGameTimer()

            -- ProfilerEnterScope('Requests Tick')

            for id, request in pairs( gRequestsExt ) do

                -- ProfilerEnterScope('Request Tick')

                if now >= request.timeoutAt then

                    request:delete()

                    if IS_CLIENT then

                        OnRequestExtTimedout( request )
                    end
                end

                -- ProfilerExitScope()
            end

            -- ProfilerExitScope()
        end
    end
end)
