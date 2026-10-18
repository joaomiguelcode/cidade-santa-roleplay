local HotbarAPI = Tunnel.getInterface("inventory/hotbar")
RegisterCommand("+openHotbar",function()
    if not LocalPlayer["state"]["Active"] then
        return
    end

    if exports["new_hub"]:IsAffiliateWorldClientActive() then 
        return
    end

    if LocalPlayer['state']['snowball:match'] then 
        return
    end

    if LocalPlayer["state"]["minigame:active"] then
        return
    end


    if not IsPauseMenuActive() and GetEntityHealth(PlayerPedId()) > 100 and not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not IsPlayerFreeAiming(PlayerId()) then
        SendNUIMessage({ page = "hot-bar", action = "showHotbar" })
    end
end)

RegisterCommand("-openHotbar",function()
    SendNUIMessage({ page = "hot-bar", action = "hideHotbar" })
end)
RegisterKeyMapping("+openHotbar", _t("openHotbar"), "keyboard", "TAB")
RegisterNUICallback('getHotbar',function(data,cb)
    local rawData = HotbarAPI.getHotbar()
    local data = {}
    for i=1,#rawData do
        local v = rawData[i]
        data[i] = v
        if (not v["item"]) then
            goto skip
        end
        data[i]["name"] = itemName(v["item"])
        data[i]["peso"] = itemWeight(v["item"])
        data[i]["index"] = itemIndex(v["item"])
        data[i]["max"] = itemMaxAmount(v["item"])
        data[i]["desc"] = itemDescription(v["item"])
        data[i]["economy"] = parseFormat(itemEconomy(v["item"]))
        ::skip::
    end
    async(function()
        cb(data)
    end)
end)
