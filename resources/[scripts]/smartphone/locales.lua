lang = GetConvar("language", "pt-br") or "pt-br"
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    SendNUIMessage({
        type = "setLocale",
        lang = lang
    })
end)

-- Also send it whenever the focus is gained or NUI is visible if possible
-- But usually once is enough for initialization
