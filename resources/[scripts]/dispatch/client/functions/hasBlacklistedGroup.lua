--- @return boolean
hasBlacklistedGroup = function()
    local job = vRP.GetPlayerJob()
    return config.groupBlacklist[job]
end