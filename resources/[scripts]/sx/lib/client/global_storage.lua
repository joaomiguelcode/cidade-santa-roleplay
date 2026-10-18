sx.globalstorage = { }

---@generic TValues
---@param prefix        string
---@param defaultValues TValues
---@return TValues | { on: fun( key: TKeys, cb: fun( value: TValues ) ) }
function sx.globalstorage.new( prefix, defaultValues )

    return setmetatable( {
            on = function( key, cb )

                local key = ( '%s:%s' ):format( prefix, key )
            end,
        },
        {

            __index = function( t, key )

                -- sx.logger:debug( 'Getting global state', ( '%s:%s' ):format( prefix, key ) )

                ---@type any | nil
                local value = GlobalState[ ( '%s:%s' ):format( prefix, key ) ]

                if value == nil then

                    return defaultValues[ key ]
                end

                return value
            end,

            __newindex = function( t, key, value )

                -- sx.logger:debug( 'Setting global state', ( '%s:%s' ):format( prefix, key ), value, type( value ) )

                GlobalState:set( ( '%s:%s' ):format( prefix, key ), value, false )
                -- GlobalState[ ( '%s:%s' ):format( prefix, key ) ] = value

                -- sx.logger:debug( 'Global state after', ( '%s:%s' ):format( prefix, key ), value )
            end,
        }
    )
end