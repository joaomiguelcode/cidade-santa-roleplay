local gTempoVipOpen = false
local gTempoVipSession = 0

local function CloseTempoVip()

    gTempoVipOpen = false
    gTempoVipSession = gTempoVipSession + 1
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeTempoVip" })
end

local function QueryTempoVip(callback)

    if not gTempoVipOpen then
        callback({ success = false })
        return
    end

    local session = gTempoVipSession
    local success, result = pcall(function() return vSERVER.GetTempoVip() end)

    if session ~= gTempoVipSession or not gTempoVipOpen then
        callback({ success = false })
        return
    end

    callback(success and type(result) == "table" and result or { success = false })
end

RegisterNetEvent("new_hub:openTempoVip", function()

    if gTempoVipOpen then
        return
    end

    gTempoVipSession = gTempoVipSession + 1
    gTempoVipOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openTempoVip", data = { standalone = true, cityId = cityName } })
end)

RegisterNUICallback("getTempoVip", function(_, callback)
    QueryTempoVip(callback)
end)

RegisterNUICallback("retryTempoVip", function(_, callback)
    QueryTempoVip(callback)
end)

RegisterNUICallback("closeTempoVip", function(_, callback)
    CloseTempoVip()
    callback({ success = true })
end)

RegisterNUICallback("tempoVipOpenStore", function(data, callback)

    if not gTempoVipOpen then
        callback({ success = false })
        return
    end

    local session = gTempoVipSession
    local success, result = pcall(function()
        if type(data) ~= "table" then
            return { success = false }
        end

        return vSERVER.GetTempoVipStoreTarget(data.vipId, data.checkout)
    end)

    if session ~= gTempoVipSession or not gTempoVipOpen or not success or type(result) ~= "table" or result.success ~= true then
        callback({ success = false })
        return
    end

    gTempoVipOpen = false
    gTempoVipSession = gTempoVipSession + 1
    SetNuiFocus(true, true)
    callback(result)
end)

RegisterNUICallback("tempoVipOpenTebex", function(_, callback)
    callback({ url = TebexStoreLink[cityName] or "" })
end)

RegisterNUICallback("store.getProduct", function(data, callback)

    local success, result = pcall(function()
        return vSERVER.GetTempoVipStoreProduct(type(data) == "table" and data.productId)
    end)
    callback(success and result or { success = false })
end)

AddEventHandler("onResourceStop", function(resourceName)

    if resourceName == GetCurrentResourceName() and gTempoVipOpen then
        SetNuiFocus(false, false)
    end
end)
