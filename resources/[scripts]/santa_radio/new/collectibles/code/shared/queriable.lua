---@alias QueriableStatus 'idle' | 'loading' | 'loaded' | 'error'

---@class Collection<TData, TInput> : { hasData: boolean, isFetching: boolean, utils: { writeInsert: fun( data: TData ) }, handle: fun( self, handler: fun( source: number, input: TInput ): TData[] ), data: fun( self ): TData[] }

---@type table<string, Collection<any, any>>
local gQueriables = { }

---@param key string
---@return Collection<any, any>
function createCollection( key )

    local netEventNameReq = ('net.queriable.%s'):format( key )
    local netEventNameRes = ('net.queriable.%s_response'):format( key )

    ---@type Collection<any, any>
    local query = setmetatable(
        {
            status = 'idle',
            _data = nil,
            fetchPromise = nil,
            fetchResponseHandlerCookie = nil,

            hasData = nil,
            isFetching = nil,

            handler = nil,

            handle = function( self, handler )

                assert( IS_SERVER, 'Queriable can only be used on the client' )

                self.handler = handler

                RegisterNetEvent( netEventNameReq, function( data, input )

                    local source = ToSource( source )

                    local output = self.handler( source, data, input )

                    TriggerClientEvent( netEventNameRes, source, output, input )
                end)
            end,

            data = function( self )

                assert( IS_CLIENT, 'Queriable can only be used on the client' )

                if self.hasData and not self.isFetching then

                    return self._data
                end

                if not self.hasData and not self.isFetching then

                    TriggerServerEvent( netEventNameReq )

                    function onSuccess( data )

                        self._data   = data
                        self.hasData = true
                    end

                    function onSettled()

                        -- Completou o request ou deu timeout, vamos limpar a promise!

                        self.status = 'idle'

                        self.fetchPromise = nil

                        RemoveEventHandler( self.fetchResponseHandlerCookie )
                        self.fetchResponseHandlerCookie = nil
                    end

                    self.fetchPromise  = promise.new()
                    self.fetchPromise  = sx.async.withTimeout( self.fetchPromise, 1000 )
                    self.fetchPromise:next( onSuccess, nil       )
                    self.fetchPromise:next( onSettled, onSettled )

                    self.fetchResponseHandlerCookie = RegisterNetEvent( netEventNameRes, function( output )

                        self.fetchPromise:resolve( output )
                    end)

                    self.status = 'fetching'
                end

                if self.isFetching then

                    return Citizen.Await( self.fetchPromise )
                end

                return nil
            end
        },
        {
            ---@param self Collection<any, any>
            ---@param key string
            __index = function( self, key )

                if      key == 'hasData'    then

                    return self._data ~= nil

                elseif  key == 'isFetching' then

                    return self.status == 'fetching'
                else

                    return nil
                end
            end
        }
    )

    query.utils =
    {
        writeInsert = function( data )

            query._data = query._data or { }

            table.insert( query._data, data )
        end
    }

    gQueriables[ key ] = query

    return query
end