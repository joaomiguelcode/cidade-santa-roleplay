sx.player = { }

---@param sourceLike SourceLike
---@return Source
function ToSource( sourceLike )

    local source = tonumber( sourceLike )

    fast_assert( source ~= nil or ('Invalid source: %s'):format( sourceLike ) )

    ---@cast source -?

    return source
end

---@param source number
function sx.player.isPlayerWithinDistance( source, position, maxDistance )

    local pedId = GetPlayerPed( source )
    local pedPos = GetEntityCoords( pedId )

    local distance = #( pedPos - position )

    if distance > maxDistance then
        return false
    end

    return true
end

---@param source                 Source
---@param otherSource            Source
---@param maxDistance            number -- Distancia máxima em que o jogador deve estar para ser considerado relevante
---@param cachedRoutingBucketId? number -- Caso não seja especificado, será usado o routing bucket de "source"
---@param cachedPosition?        vector3
---@return boolean
function sx.player.isPlayerRelevantToPlayer( source, otherSource, maxDistance, cachedRoutingBucketId, cachedPosition )

    local routingBucketId = cachedRoutingBucketId or GetPlayerRoutingBucket( source )

    if routingBucketId ~= GetPlayerRoutingBucket( otherSource ) then
        return false
    end

    local position = cachedPosition or GetEntityCoords( GetPlayerPed( source ) )

    if not sx.player.isPlayerWithinDistance( source, position, maxDistance ) then
        return false
    end

    return true
end

---@param source                 Source
---@param otherSources Source[]
---@param maxDistance            number
---@return Source[]
function sx.player.filterPlayersRelevantToPlayer( source, otherSources, maxDistance )

    local routingBucketId = GetPlayerRoutingBucket( source )

    local position = GetEntityCoords( GetPlayerPed( source ) )

    ---@type Source[]
    local filtered = { }

    for _, otherSource in ipairs( otherSources ) do

        if sx.player.isPlayerRelevantToPlayer( source, otherSource, maxDistance, routingBucketId, position ) then

            table.insert( filtered, otherSource )
        end
    end

    return filtered
end

RegisterNetEvent('net:show_nearest_player_passport', function( otherSource )

    local source = ToSource( source )

    if not sx.player.isPlayerRelevantToPlayer( source, otherSource, 2.0 ) then
        return
    end

    local passport = vRP.Passport( otherSource )

    TriggerClientEvent( 'Notify2', source, "#id", { msg = passport } )
end)

function sx.ping()

    print( 'sx.ping says -> pong2!' ) 
end