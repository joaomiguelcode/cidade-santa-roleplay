---@param group string
local onGroupAdd = function(group)
    if (not config.receiverGroups[group] ) then
        return
    end
end
RegisterNetEvent('playerGroups:AddGroup', onGroupAdd)