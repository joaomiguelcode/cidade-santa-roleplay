---@return boolean
closeNUI = function()
    SendNUIMessage(
        {
            action = 'toggleNotificationMenu',
            data = false
        }
    )
    SetNuiFocus(false, false)

    return true
end