---@generic T
---@param t T
---@return T
function WithLazyholder( t )

    local mt = getmetatable( t ) or { }

    if mt.__call then

        return t
    end

    if type( mt.__index ) == 'table' then

        return t
    end

    if type( mt.__newindex ) == 'table' then

        return t
    end

    t.__lazyRegistry = { }

    -- que putaria porque __index pode ser referencia para uma tabela, crazy
    local origIndex = ( mt.__index and type( mt.__index ) == 'function' ) and mt.__index or function( self, key )

        return rawget( self, key )
    end

    mt.__index = function( self, key )

        local value = nil

        local lazyRegistry = rawget( self, '__lazyRegistry' )

        if lazyRegistry and lazyRegistry[ key ] then

            -- sx.logger:debug( ('lazy index: %s'):format( key ) )

            local lazy = lazyRegistry[ key ]

            ---@cast lazy LazyInner

            value = lazy.value

            rawset( self, key, value )

            lazyRegistry[ key ] = nil
        end

        if origIndex then

            return origIndex( self, key )
        end
    end

    local origNewindex = ( mt.__newindex and type( mt.__newindex ) == 'function' ) and mt.__newindex or function( self, key, value )

        rawset( self, key, value )
    end

    mt.__newindex = function( self, key, value )

        if type( value ) == 'table' then

            if value.__lazy then

                ---@cast value LazyInner

                local lazy = value

                self.__lazyRegistry[ key ] = lazy

                -- sx.logger:debug( ('lazy index: %s'):format( key ) )

                return
            end

            value = WithLazyholder( value )
        end

        if origNewindex then

            return origNewindex( self, key, value )
        end
    end

    return setmetatable( t, mt )
end