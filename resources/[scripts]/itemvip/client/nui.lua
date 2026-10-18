function OpenItemVipFrame(playerItems)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "setVisible",
        data = { visible = true, playerItems = playerItems },
    })
end

function CloseItemVipFrame()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "setVisible", data = { visible = false } })
end

RegisterNUICallback("getCityName", function(_, callback)
    callback(GetConvar("cityName", ""))
end)

RegisterNUICallback("redeemItems", function(data, callback)
    callback(lib.callback.await("itemvip:redeem-items", false, {
        selections = type(data) == "table" and data.selections or nil,
    }))
end)

RegisterNUICallback("hideFrame", function(_, callback)
    CloseItemVipFrame()
    callback({ success = true })
end)
