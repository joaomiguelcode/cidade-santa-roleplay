sx.client.spatial = { }

---@param radius            number - Use -1 para procurar no raio máximo
---@param maxPlayersNearby  number - Use -1 para procurar o número máximo de players
---@return Source[]
function sx.client.spatial.findPlayersNearby( radius, maxPlayersNearby )

    radius           = radius           == -1 and SPATIAL_MAX_RADIUS       or radius
    maxPlayersNearby = maxPlayersNearby == -1 and SPATIAL_MAX_NUM_ENTITIES or maxPlayersNearby

    local playersWithDistance = { }

    local centerPos = GetEntityCoords( PlayerPedId() )

    local localPlayerIdx = PlayerId()

    for _, playerIdx in ipairs( GetActivePlayers() ) do

        if playerIdx ~= localPlayerIdx then

            local pedId = GetPlayerPed( playerIdx )
            local pedPos = GetEntityCoords( pedId )
            local distance = #( pedPos - centerPos )

            if distance <= radius then

                local source = GetPlayerServerId( playerIdx )

                playersWithDistance[ #playersWithDistance + 1 ] = {
                    source = source,
                    distance = distance
                }
            end
        end
    end

    table.sort( playersWithDistance, function( a, b )
        return a.distance < b.distance
    end)

    local maxPlayersNearby = math.min( #playersWithDistance, maxPlayersNearby )
    
    local inArea = table.create( maxPlayersNearby, 0 )
    for i = 1, maxPlayersNearby do
        inArea[ i ] = playersWithDistance[ i ].source
    end

    return inArea
end