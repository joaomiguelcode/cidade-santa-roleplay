-- claymore main server-side
local resourceName = GetCurrentResourceName()
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local api = {}
Tunnel.bindInterface(resourceName, api)

local placedClaymores = {}

RegisterNetEvent('net.claymore.createClaymore', function(coords, heading)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    local obj = CreateObjectNoOffset(joaat('claymore_pru'), coords.x, coords.y, coords.z, true, true, false)
    while not DoesEntityExist(obj) do Wait(10) end
    SetEntityHeading(obj, heading)
    
    local netId = NetworkGetNetworkIdFromEntity(obj)
    local entity = NetworkGetEntityFromNetworkId(netId)
    
    Entity(entity).state:set('claymoreData', {
        active = true,
        netId = netId,
        owner = source,
        coords = coords
    }, true)
    
    placedClaymores[netId] = {
        entity = obj,
        netId = netId,
        owner = source,
        passport = passport,
        coords = coords
    }
end)

RegisterNetEvent('net.claymore.explode', function(netId, ownerSource)
    local source = source
    local data = placedClaymores[netId]
    if not data then return end
    
    placedClaymores[netId] = nil
    
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        Entity(entity).state:set('claymoreData', { active = false }, true)
        DeleteEntity(entity)
    end
    
    TriggerClientEvent('net.claymore.clientExplode', -1, data.coords, data.owner)
end)

function api.deleteClaymore()
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    local ped = GetPlayerPed(source)
    local pedCoords = GetEntityCoords(ped)
    
    for netId, data in pairs(placedClaymores) do
        local dist = #(pedCoords - data.coords)
        if dist <= 5.0 then
            placedClaymores[netId] = nil
            local entity = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(entity) then
                Entity(entity).state:set('claymoreData', { active = false }, true)
                DeleteEntity(entity)
            end
            TriggerClientEvent('Notify', source, 'sucesso', 'Claymore removida com sucesso.')
            return true
        end
    end
    
    return false
end
