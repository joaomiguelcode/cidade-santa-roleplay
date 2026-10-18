local resource = GetCurrentResourceName()

local waypointManager = WaypointManager.new()
waypointManager:startIndicatorThread()

exports('waypointCreate', function(data)
    return waypointManager:create(data)
end)

exports('waypointUpdate', function(id, data)
    waypointManager:update(id, data)
end)

exports('waypointRemove', function(id)
    waypointManager:remove(id)
end)

exports('waypointRemoveAll', function()
    waypointManager:removeAll()
end)

exports('waypointGet', function(id)
    return waypointManager:get(id)
end)

exports('waypointGetScreenState', function(id)
    return waypointManager:getScreenState(id)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= resource then return end
    waypointManager:clearOnStop()
end)

RegisterNetEvent( 'net:routing_bucket_changed', function( bucket )
    waypointManager:setRouteHint( bucket )
    waypointManager:syncMarkerIndicator()
end)
