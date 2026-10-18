sx.table = { }

--@generic TKey
--@generic TValue
--@generic A
--@param t table<`TKey`, `TValue`>
--@param fn fun( value: TValue, index: TKey, table: table<`TKey`, `TValue`> ): A
--@param initialValue `A`
--@return A

---@generic K
---@generic V
---@generic A
---@param t table<`K`, `V`>
---@param fn fun( acc: `A`, value: V, index: K, t: table<K, V> ): `A`
---@param initialValue A
---@return A
function sx.table.reduce( t, fn, initialValue )

    local accumulator = initialValue

    for i, v in each( t ) do

        accumulator = fn( accumulator, v, i, t )
    end

    return accumulator
end

---@generic V
---@generic R
---@param t V[]
---@param predicate fun(value: V, index: number, t: V[]): `R`
---@return Array<R>
function sx.table.map(t, predicate)
    local mapped = { }

    for index, value in ipairs(t) do
        local newvalue = predicate(value, index, t)

        table.insert(mapped, newvalue)
    end

    return mapped
end

function sx.table.find_index(t, callbackFn)
    for index, element in each(t) do
        if callbackFn(element, index, t) then
            return index
        end
    end

    return -1
end

---@generic K
---@generic V
---@param t table<`K`, `V`>
---@param fn fun( value: V, index: K, table: table<`K`, `V`> ): boolean
---@return V | nil
function sx.table.find( t, fn )

    for i, v in each( t ) do

        if fn( v, i, t ) then

            return v
        end
    end

    return nil
end

---@generic A
---@generic B
---@param tA A[]
---@param tB B[]
---@return A[] | B[]
function sx.table.join( tA, tB )

    for _, v in each( tB ) do

        table.insert( tA, v )
    end

    return tA
end

---@generic T
---@param t T[]
---@param fn fun( value: T ): boolean
---@return T[]
function sx.table.filter( t, fn )

    return sx.table.reduce( t, function( acc, value, index, table )

        if fn( value ) then

            table.insert( acc, value )
        end

        return acc
    end, { } )
end

---@generic K
---@generic V
---@param t table<`K`, `V`>
---@param value V
---@return boolean
function sx.table.includes(t, value)

    local index = table.find_index(
        t, function (v)
            return v == value
        end
    )

    return index ~= -1
end