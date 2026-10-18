function setVisible(status)
    SendNUIMessage({
        action = "setVisible",
        data = status
    })
    SetNuiFocus(status, status)
end
