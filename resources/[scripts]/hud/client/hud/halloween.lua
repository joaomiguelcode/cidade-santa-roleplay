RegisterNetEvent('hud.client.pumpkin:setWaveNotification', function(screenTime)
    SendNUIMessage({
        action = 'HalloweenEvent',
        data = {
            duration = screenTime or 5000
        }
    })
end)

RegisterNetEvent('hud.client.christmas:setWaveNotification', function(screenTime)
    SendNUIMessage({
        action = 'ChristmasEvent',
        data = {
            duration = screenTime or 5000
        }
    })
end)

RegisterNetEvent('hud.client.valentines:setWaveNotification', function(screenTime)
    SendNUIMessage({
        action = 'ValentineEvent',
        data = { duration = screenTime or 5000 }
    })
end)

RegisterNetEvent('hud.client.christmas:newYearNotification', function(screenTime)
    SendNUIMessage({
        action = 'NewYearEvent',
        data = { duration = screenTime or 5000 }
    })
end)

RegisterNetEvent('hud.client.carnival:waveNotification', function(screenTime)
    SendNUIMessage({
        action = 'CarnivalEvent',
        data = { duration = screenTime or 5000 }
    })
end)

RegisterNetEvent('hud.client.easter:setWaveNotification', function(screenTime)
    SendNUIMessage({
        action = 'EasterEvent',
        data = { duration = screenTime or 5000 }
    })
end)

RegisterNetEvent('hud.client.pumpkin:setPotion', function(screenTime, effectName, effectDescription)
    SendNUIMessage({
        action = "HalloweenProgress",
        data = {
            duration = screenTime or 5000,
            effectName = effectName or "Efeito",
            effectDescription = effectDescription or "Você está dominado pelo Padilhao"
        }
    })
end)


RegisterCommand("halloweenaudio",function()
    SendNUIMessage({
        action = 'HalloweenEvent',
        data = {
            duration = 5000
        }
    })
end)