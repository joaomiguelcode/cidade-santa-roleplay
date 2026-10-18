local debugWhatsapp = true
local Debug = function(...)
    if not debugWhatsapp then return end
    local info = debug.getinfo(2, "Sl") 
    local side = IsDuplicityVersion() and "SERVER" or "CLIENT"
    local debugMsg = string.format("[%s] %s:%d", side, info.short_src, info.currentline)
    debugMsg = debugMsg:gsub("@", "")

    print(debugMsg, ...)
end

RegisterNetEvent("WhatsappFunnel:Show", function()
    -- local WhatsappConfig = GetWhatsAppConfig()
    -- local number = "https://api.whatsapp.com/send?phone="..WhatsappConfig["cities"]["numbers"][cityName]
    -- local Data = {
    --     passport = LocalPlayer["state"]["Passport"],
    --     title = WhatsappConfig["title"],
    --     rewardText = WhatsappConfig["rewardText"],
    --     number = number
    -- }
    -- Debug("WhatsappFunnel:Show", json.encode(Data, {indent = true}))
    -- SendNUIMessage({ 
    --     action = "WhatsappInvite", 
    --     data = Data
    -- })
    -- SetNuiFocus(true, true)
end)

RegisterNetEvent("WhatsappFunnel:Close", function()
    Debug("WhatsappFunnel:Close")
    SendNUIMessage({ 
        action = "WhatsappInviteClose", 
        data = true
    })
    SetNuiFocus(false, false)
end)

RegisterNetEvent("WhatsappFunnel:CanShow", function(canShow)
    -- local ped = PlayerPedId()
    -- Debug("WhatsappFunnel:CanShow", canShow)
    -- LocalPlayer.state:set("WhatsappInvite", canShow, false)
    -- if canShow and LocalPlayer["state"]["InSafeZone"] then
    --     if not IsPedInAnyVehicle(ped) then
    --         Debug("WhatsappFunnel:CanShow", "InSafeZone", "Not in vehicle")
    --         TriggerEvent("WhatsappFunnel:CanShow", false)
    --         TriggerServerEvent("WhatsappFunnel:ShowServer")
    --     end
    -- end
end)

RegisterNuiCallback("Close", function(data, cb)
    Debug("Close")
    SetNuiFocus(false, false)
    cb(true)
end)