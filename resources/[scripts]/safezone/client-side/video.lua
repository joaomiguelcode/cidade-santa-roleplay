--RegisterNUICallback("openAdvertisement",function(Data,Callback)
--    if NewbiePromo then
--        return
--    end
--    SendNUIMessage({
--        action = "setVisible",
--        data = "safezone",
--    })
--    SetNuiFocus(false,false)
--end)

local cityName = GetConvar("cityName", "")

RegisterNetEvent("promotion_button:open")
AddEventHandler("promotion_button:open",function(URL,Image)
    SendNUIMessage({
        action = "setVisible",
        data = "video",
    })
    SendNUIMessage({
        action = "lockVisibility",
        data = true,
    })
    SendNUIMessage({
        action = "getAdvertisement",
        data = { image = { type = URL, image = Image } },
    })
    SetNuiFocus(true,true)
end)

RegisterNUICallback("openAdvertisement",function(Data,Callback)
    SendNUIMessage({
        action = "lockVisibility",
        data = false,
    })
    Wait(250)
    SendNUIMessage({
        action = "setVisible",
        data = false,
    })
    SetNuiFocus(false,false)
    TriggerEvent("player:OpenURL",Data["type"])
end)

RegisterNUICallback("hideFrame",function(Data,Callback)
    LocalPlayer["state"]["isPlayingRandomPromoVideo"] = false
    SendNUIMessage({
        action = "lockVisibility",
        data = false,
    })
    Wait(250)
    SendNUIMessage({
        action = "setVisible",
        data = false,
    })
    SetNuiFocus(false,false)
end)

RegisterNetEvent("promotion_button:openAdvertisement")
AddEventHandler("promotion_button:openAdvertisement",function(url, isOnlyAtSafezone)
    TriggerEvent("player:OpenURL", 'https://santagroup.gg/comboferias')
    -- SendNUIMessage({
    --     action = "setVideo",
    --     data = nil
    -- })
    -- Wait(200)
    -- SendNUIMessage({
    --     action = "setVisible",
    --     data = false,
    -- })
    -- LocalPlayer["state"]["isPlayingRandomPromoVideo"] = false
end)

local RemAudio = false
RegisterNetEvent("promotion_button:RemAudio")
AddEventHandler("promotion_button:RemAudio",function(Boolean)
    RemAudio = Boolean
end)

local CooldownOpenAudio = GetGameTimer()
lang = GetConvar("language", "pt-br") or "pt-br"
RegisterNetEvent("promotion_button:OpenAudio")
AddEventHandler("promotion_button:OpenAudio",function(url)
    print("1")
    if url == "https://youtu.be/B0FWLcXKKow" and lang == "en-us" then
        return
    end
    if RemAudio then
        print("2")
        return
    end
    if CooldownOpenAudio >= GetGameTimer() then
        print("3")
        return
    end
    CooldownOpenAudio = GetGameTimer() + 10000
    url = url:gsub("[<>]","")
    SendNUIMessage({
        action = "setVisible",
        data = "audio",
    })
    print("4",url)
    Wait(300)
    SendNUIMessage({
        action = "setAudio",
        data = {
          url = url,
        }
    })
    print("5")
end)
RegisterNetEvent("promotion_button:OpenVideo")
AddEventHandler("promotion_button:OpenVideo",function(url, isOnlyAtSafezone)
    LocalPlayer["state"]["isPlayingRandomPromoVideo"] = true
    local Ped = PlayerPedId()
    local Vehicle = IsPedInAnyVehicle(Ped)
    local url = url:gsub("[<>]","")
    --if LocalPlayer["state"]["InSafeZone"] and not Vehicle then
        SendNUIMessage({
            action = "setVisible",
            data = "videoFull",
        })
        Wait(100)
        SendNUIMessage({
            action = "setVideoFull",
            data = {
                url = url,
            },
        })
    -- elseif not isOnlyAtSafezone then
    --     if exports["hud"]:Request("Gostaria de assistir o video?", 30) then
    --         SendNUIMessage({
    --             action = "setVisible",
    --             data = "videoFull",
    --         })
    --         Wait(100)
    --         SendNUIMessage({
    --             action = "setVideoFull",
    --             data = {
    --                 url = url,
    --             }
    --         })
    --     end
    -- elseif isOnlyAtSafezone then
    --     SendNUIMessage({
    --         action = "setVisible",
    --         data = "videoFull",
    --     })
    --     Wait(100)
    --     SendNUIMessage({
    --         action = "setVideoFull",
    --         data = {
    --             url = url,
    --         }
    --     })
    -- end
    SendNUIMessage({
        action = "lockVisibility",
        data = true,
    })
end)
RegisterNetEvent("safezone:OpenVideo")
AddEventHandler("safezone:OpenVideo",function(url)
    Wait(7500)
    print("safezone:OpenVideo: ", url)
    SendNUIMessage({
        action = "setVisible",
        data = "videoFull",
    })
    Wait(100)
    SendNUIMessage({
        action = "setVideoFull",
        data = {
            url = url,
        }
    })
end)
