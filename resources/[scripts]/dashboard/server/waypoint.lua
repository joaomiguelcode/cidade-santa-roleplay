RegisterNetEvent('dashboard:setWaypoint', function(coords)
    local src = source
    TriggerClientEvent('dashboard:client:setWaypoint', src, coords)
end)
