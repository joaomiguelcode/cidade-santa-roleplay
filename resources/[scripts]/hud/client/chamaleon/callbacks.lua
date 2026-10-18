-- Fired when user clicks a color in the list
RegisterNUICallback("chameleon:select", function(data, cb)
    local colourId = data.id

    ApplyChamaleonColour(gVehicleChamaleonEntityId, colourId)
    cb("ok")
end)

-- Fired when user clicks "Concluir" (confirm)
RegisterNUICallback("chameleon:confirm", function(data, cb)
    if gVehicleChamaleonColorData.colourId == data.id then
        CloseChamaleonUI()
        return cb("ok")
    end

    local response = lib.callback.await('chamaleon.use', false, data.id) --[[@as hud.chamaleon.route.useChamaleon]]

    if not response.success then
        ResetChamaleonColourVisual()
    end

    if response.message then
        TriggerEvent("Notify", "warning", response.message)
    end

    CloseChamaleonUI()
    cb("ok")
end)

-- Fired when user clicks "Cancelar" or presses Escape
RegisterNUICallback("chameleon:close", function(data, cb)
    ResetChamaleonColourVisual()
    CloseChamaleonUI()

    cb("ok")
end)

RegisterNUICallback("chameleon:rotate", function(data, cb)
    (data.direction == "left" and ChamaleonCameraRotateRight or ChamaleonCameraRotateLeft)()
    cb("ok")
end)
