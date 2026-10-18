---@param data table
---@return boolean
markWaypoint = function(data)
    local id           = tonumber(data.id)
    local notification = cache[id]
    print('markWaypoint', json.encode(notification, { indent = true }))

    if (not notification) then
        SendNUIMessage({
            action = 'deleteNotification',
            data   = id
        })

        return true
    end

    local x,y,z = notification.pos.x, notification.pos.y, notification.pos.z

    SetNewWaypoint(x, y)

    TriggerEvent("missions:client:policeQruStarted", vec3(x, y, z))

    return true
end
