local lang = GetConvar("language", "pt-br") or "pt-br"

CreateThread(function()
    Wait(1000)
    SendNUIMessage({
        type = "setLocale",
        lang = lang
    })
end)