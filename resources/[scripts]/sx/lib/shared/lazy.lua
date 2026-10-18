---@class LazyInner
---@field public __lazy true
---@field public value  any

---@class PrivateLazyInner : LazyInner
---@field private __lazy true
---@field private value  any

---@alias Lazy<T> PrivateLazyInner | T

local Lazy =
{
}

---@generic T
---@param constructor fun(): T
---@return Lazy<T>
function Lazy:new( constructor )

    ---@type Lazy<T>
    local self =
    {
        __lazy = true,
    }

    setmetatable( self, {

        __index = function( self, key )

            -- sx.logger:debug( ('lazy index: %s'):format( key ) )

            fast_assert( key == 'value' or 'Invalid key: ' .. key )

            local value = constructor()

            rawset( self, key, value )

            return value
        end,
    })

    return self
end

---@generic T
---@param constructor fun(): T
---@return T
function sx.lazy( constructor )

    return Lazy:new( constructor )
end
