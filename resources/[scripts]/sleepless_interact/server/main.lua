-- sleepless_interact server-side bridge
local interactions = {}

exports('addInteraction', function(data)
    if not data or not data.id then return end
    interactions[data.id] = data
    TriggerClientEvent('sleepless_interact:addInteraction', -1, data)
end)

exports('removeInteraction', function(id)
    interactions[id] = nil
    TriggerClientEvent('sleepless_interact:removeInteraction', -1, id)
end)

RegisterNetEvent('sleepless_interact:requestSync', function()
    local src = source
    TriggerClientEvent('sleepless_interact:syncInteractions', src, interactions)
end)
