sx.spatial = { }

SPATIAL_MAX_RADIUS = 424
SPATIAL_MAX_NUM_ENTITIES = 127

---@generic R
---@param centerPos vector3
---@param radius float
---@param entityIds number[]
---@param maxEntitiesInArea number
---@param _entityIdToAnyMap? table<number, `R`>  -- Melhorar a performance mapeando o id da entidade para outro mapa ao invés de ter que fazer outro loop e array para isso
---@return number[] | R[]
function sx.spatial.validateEntitiesInArea( centerPos, radius, entityIds, maxEntitiesInArea, _entityIdToAnyMap )

    radius            = radius            == -1 and SPATIAL_MAX_RADIUS       or radius
    maxEntitiesInArea = maxEntitiesInArea == -1 and SPATIAL_MAX_NUM_ENTITIES or maxEntitiesInArea

    local inArea = table.create( maxEntitiesInArea, 0 )

    for _, entityId in ipairs( entityIds ) do

        local entityPos = GetEntityCoords( entityId )

        if #( entityPos - centerPos ) <= radius then

            -- table.insert( inArea, entityId )
            inArea[ #inArea + 1 ] =
                _entityIdToAnyMap
                    and  ( assert( _entityIdToAnyMap[ entityId ] ) or _entityIdToAnyMap[ entityId ] )
                    or  entityId

            if #inArea >= maxEntitiesInArea then

                break
            end
        end
    end

    --print('#inArea', #inArea)

    return inArea
end

---@param centerPos         vector3
---@param radius            float
---@param sources           Source[]
---@param maxPlayersInArea  number
---@return number[]
function sx.spatial.validatePlayersInArea( centerPos, radius, sources, maxPlayersInArea )

    radius           = radius           == -1 and SPATIAL_MAX_RADIUS       or radius
    maxPlayersInArea = maxPlayersInArea == -1 and SPATIAL_MAX_NUM_ENTITIES or maxPlayersInArea

    ---@type number[]
    local entityIds = table.create( maxPlayersInArea, 0 )

    ---@type table<number, { a: string }>
    local entityIdToSource = table.create( 0, maxPlayersInArea )

    for _, source in ipairs( sources ) do

        local entityId = GetPlayerPed( source )

        if entityId ~= 0 then

            -- table.insert( entityIds, entityId )

            entityIds[ #entityIds + 1 ] = entityId

            entityIdToSource[ entityId ] = source

            if #entityIds >= maxPlayersInArea then

                break
            end
        end
    end

    -- print('#entityIds', #entityIds)

    local playersInArea = sx.spatial.validateEntitiesInArea( centerPos, radius, entityIds, maxPlayersInArea, entityIdToSource )

    --print('#playersInArea', #playersInArea )

    return playersInArea
end

---@param source            Source
---@param radius            float
---@param sources           Source[]
---@param maxPlayersInArea  number
function sx.spatial.validatePlayersNearPlayer( source, radius, sources, maxPlayersInArea )

    radius           = radius           == -1 and SPATIAL_MAX_RADIUS       or radius
    maxPlayersInArea = maxPlayersInArea == -1 and SPATIAL_MAX_NUM_ENTITIES or maxPlayersInArea

    local pedId = GetPlayerPed( source )

    assert( DoesEntityExist( pedId ) )

    local pedPos = GetEntityCoords( pedId )

    return sx.spatial.validatePlayersInArea( pedPos, radius, sources, maxPlayersInArea )
end