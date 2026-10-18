RegisterNetEvent("register:opentos",function()
    print("openTOS")
    DoScreenFadeIn(1000)
    SendNUIMessage({
        action = 'openTOS',
        data = true
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("acceptTerms",function(data,cb)

    -- Daqui a gente vai para a tela dos dados do jogador, então não precisa de fadeout...?
    -- DoScreenFadeOut(1000)

    TriggerServerEvent("register:acceptTerms")
    cb(true)
end)

RegisterNUICallback("acceptTermsInline",function(data,cb)
    cb( vSERVER.acceptTermsInline() == true )
end)

RegisterNUICallback("getTOS",function(data,cb)
    local link = (TosLink and TosLink[cityName]) or (TosLink and TosLink["Santa"]) or ""
    cb(link)
end)

RegisterNUICallback("getTOSLink",function(data,cb)
    local link = (TosLink and TosLink[cityName]) or (TosLink and TosLink["Santa"]) or ""
    cb(link)
end)

-- RegisterCommand("opentos",function()
--     TriggerEvent("register:opentos")
-- end)