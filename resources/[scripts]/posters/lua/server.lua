-- posters server-side
local Tunnel = module('vrp', 'lib/Utils')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local posters = {}
local posterIdCounter = 1

lib.callback.register('posters:getImages', function(source)
    return posters
end)

RegisterNetEvent('posters:addNewImage', function(data)
    local source = source
    local passport = vRP.Passport(source)
    if not passport or not vRP.hasPermission(passport, 'Admin') then return end
    
    data.id = posterIdCounter
    posterIdCounter = posterIdCounter + 1
    posters[#posters + 1] = data
    
    TriggerClientEvent('posters:sendAddedImage', -1, data)
end)

RegisterNetEvent('posters:deleteImage', function(id)
    local source = source
    local passport = vRP.Passport(source)
    if not passport or not vRP.hasPermission(passport, 'Admin') then return end
    
    for i = #posters, 1, -1 do
        if posters[i].id == id then
            table.remove(posters, i)
            break
        end
    end
    
    TriggerClientEvent('posters:deleteClientImage', -1, id)
end)
