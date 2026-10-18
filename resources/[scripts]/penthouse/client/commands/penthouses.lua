---@return void
givePenthouse = function()
    local ok = hasAdminGroup()

    if not ok then return end

    

end

RegisterCommand('penthouses', givePenthouse)
