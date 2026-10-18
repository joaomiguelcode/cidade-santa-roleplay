--- @param posData string | table
---@param reportType number
---@param forceNotification boolean
onReportReceived = function(posData, reportType, forceNotification)
    if LocalPlayer["state"]["minigame:active"] then
        return
    end

    local calltypes = config.callTypes[language] or config.callTypes['DEFAULT']
    if not calltypes[reportType] then
        return print('received unknown report type', reportType)
    end

    local x = posData.x
    local y = posData.y
    local z = posData.z

    pos = vec3(x, y, z)

    handleBlipIndicator(pos, reportType) -- create blip on map

    if (reportType == enum.reportType.gunShots and not config.receiveShotCalls and not forceNotification) then -- should not display the notification, just the map blip
        return print('gun shots call received but receiveShotCalls is false', reportType)
    end

    -- display notification and cache it to notification menu
    local now       = GetGameTimer()
    notificationIdCounter = notificationIdCounter + 1
    local id        = notificationIdCounter
    local data      = {
        id        = id,
        type      = calltypes[reportType].type,
        title     = calltypes[reportType].title,
        location  = getStreetName(pos),
        timestamp = now,
        pos       = pos,
        code      = calltypes[reportType].code,
        action    = calltypes[reportType].action,
    }

    cache[id] = data

    -- print('sending notification to frontend', reportType)

    -- print('notification location', ('%s, %s, %s'):format(x, y, z))

    -- print debug para verificação dos dados enviados pode ser isso a causa do bug (dados incorretos enviados para o frontend)
    -- print('notification data', json.encode(data, { indent = true }), id, json.encode(cache, { indent = true }))

    SendNUIMessage(
        {
            action = 'addNotification',
            data = data
        }
    )
end

RegisterNetEvent('dispatch:onReportReceived', onReportReceived)
