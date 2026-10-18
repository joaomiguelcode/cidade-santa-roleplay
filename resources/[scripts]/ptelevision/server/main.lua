-- ptelevision server-side
local Tunnel = module('vrp', 'lib/utils')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local activeScreens = {}

RegisterNetEvent('ptelevision:requestSync', function()
    local source = source
    TriggerClientEvent('ptelevision:requestUpdate', source, activeScreens)
end)

RegisterNetEvent('ptelevision:broadcast', function(data, index)
    activeScreens[index] = data
    TriggerClientEvent('ptelevision:broadcast', -1, data, index)
end)

RegisterNetEvent('ptelevision:event', function(index, key, value, creationCoords)
    if activeScreens[index] then
        activeScreens[index][key] = value
    end
    TriggerClientEvent('ptelevision:event', -1, index, key, value, creationCoords)
end)

RegisterNetEvent('ptelevision:setVolume', function(coords, volume)
    TriggerClientEvent('ptelevision:syncVolume', -1, coords, volume)
end)
