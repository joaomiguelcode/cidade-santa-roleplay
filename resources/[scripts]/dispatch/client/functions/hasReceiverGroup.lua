--- @return boolean
hasReceiverGroup = function()
    local job = vRP.GetPlayerJob()
    return config.receiverGroups[job]
end