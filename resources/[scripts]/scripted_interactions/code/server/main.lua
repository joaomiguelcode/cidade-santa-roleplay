-- scripted_interactions main server-side
local Tunnel = module('vrp', 'lib/Utils')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

RegisterNetEvent('scripted_interactions:server:startScriptedInteraction', function(interactionName, params)
    local source = source
    local ped = GetPlayerPed(source)
    local slot = (params and params.slot) or 1
    local key = ('scripted_interaction_slot_%d'):format(slot)
    
    Entity(ped).state:set(key, {
        name = interactionName,
        params = params,
        active = true,
        startedAt = GetGameTimer()
    }, true)
end)

RegisterNetEvent('scripted_interactions:server:stopScriptedInteraction', function(params)
    local source = source
    local ped = GetPlayerPed(source)
    local slot = (params and params.slot) or 1
    local key = ('scripted_interaction_slot_%d'):format(slot)
    
    Entity(ped).state:set(key, nil, true)
end)
