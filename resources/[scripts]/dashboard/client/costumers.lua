RegisterNuiCallback('customer:attend', function(data, cb)
    local userId = data.passport
    local status = data.status -- 'cancel' | 'attend'
    TriggerServerEvent("dashboard:attendCostumer", userId, status)
    Debug.print("customer:attend: "..json.encode(data, { indent = true }))
    cb(true)
end)

RegisterNuiCallback('customer:cancel', function(data, cb)
    local userId = data.passport
    TriggerServerEvent("dashboard:cancelCostumer", userId)
    Debug.print("customer:cancel: "..json.encode(data, { indent = true }))
    cb(true)
end)

RegisterNuiCallback('customer:updateDesc', function(data, cb)
    local userId = data.passport
    local description = data.description
    TriggerServerEvent("dashboard:updateDesc", userId, description)
    Debug.print("customer:updateDesc: "..json.encode(data, { indent = true }))
    cb(true)
end)

RegisterNetEvent("dashboard:updateCostumers", function()
    Debug.print("dashboard:updateCostumers")
    SendNUIMessage({
        action = "updateCostumers",
        data = true
    })
end)



--#endregion
---@param player number
function OnCreateProfilePictureBlack(player)
    local handle = RegisterPedheadshot(player)
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end

    local txd = GetPedheadshotTxdString(handle)

    UnregisterPedheadshot(handle)
    return txd
end

RegisterNuiCallback('get:costumer:picture', function(data, cb)
    print('get:costumer:picture', json.encode(data, { indent = true }))
    local Passport = tonumber(data.passport)
    if not Passport or Passport == 0 then
        cb(nil)
        return
    end
    local playerPicture = nil
    while not playerPicture do
        local Players = GetActivePlayers()
        for _, player in ipairs(Players) do
            local source = GetPlayerServerId(player)
            local PlayerPassport = Player(source).state.Passport
            if tonumber(PlayerPassport) == Passport then
                local picture = OnCreateProfilePictureBlack(GetPlayerPed(player))
                playerPicture = ('https://nui-img/%s/%s'):format(picture, picture)
                break
            end    
        end
        Wait(100)
    end
    print('get:costumer:picture: done', playerPicture)
    cb(playerPicture)
end)