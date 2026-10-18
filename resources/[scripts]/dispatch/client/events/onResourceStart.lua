AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    -- Clear the notification cache
    cache = {}
    notificationIdCounter = 0

    -- Clear notifications from the NUI frontend
    SendNUIMessage({
        action = 'clearNotifications'
    })

    print('Dispatch: All notifications cleared on resource start')
end)
