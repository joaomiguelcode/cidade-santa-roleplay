actionButtonsLoaded = false

---@return boolean
sendConfigActionsToNui = function()
    if (actionButtonsLoaded) then
        return actionButtonsLoaded
    end

    local callTypeData = {}
    local calltypes    = config.callTypes[language] or config.callTypes['DEFAULT']

    print('registering action buttons', language)

    for _, data in pairs(calltypes) do
        if (data.isPoliceOption) then
            callTypeData[#callTypeData + 1] = {
                action = data.code
            }
        end
    end

    SendNUIMessage(
        {
            action = 'setActionButtons',
            data = callTypeData
        }
    )

    for callType, data in pairs(calltypes) do
        if (data.isPoliceOption) then
            local callback = callbacks(data.code, function()
                local position  = getClosestCoord()
                local grid      = getGridzone(position.x, position.y)
                TriggerServerEvent('dispatch:send', position, callType, grid, true)
    
            end, data.cooldown, {'OK', 'HUD_FRONTEND_DEFAULT_SOUNDSET'})
    
            callback:register()
        end
    end

    actionButtonsLoaded = true

    return actionButtonsLoaded
end