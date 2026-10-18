---@param data table
---@return boolean
deleteNotification = function(data)
    if (not cache[data.id]) then
        return false
    end

    cache[data.id] = nil

    return true
end