---@param group string
local onGroupRemove = function(group)
    if (not config.receiverGroups[group] ) then
        return
    end

    SendNUIMessage(
        {
            action = 'toggleNotificationMenu',
            data = false
        }
    )
end

RegisterNetEvent('playerGroups:RemoveGroup', onGroupRemove)