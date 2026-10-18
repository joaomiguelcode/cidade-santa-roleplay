-- new_pets server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('new_pets', server)
vRP.prepare('pets/getUserPets', 'SELECT * FROM player_pets WHERE passport = @passport')
vRP.prepare('pets/updatePetName', 'UPDATE player_pets SET name = @name WHERE id = @id AND passport = @passport')
vRP.prepare('pets/updatePetStats', 'UPDATE player_pets SET hunger = @hunger, happiness = @happiness, xp = @xp WHERE id = @id')

local spawnedPets = {}

RegisterNetEvent('pets.server:selectPet', function(petId, modelName, coords)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    -- Delete previous pet if exists
    if spawnedPets[source] and DoesEntityExist(spawnedPets[source].entity) then
        DeleteEntity(spawnedPets[source].entity)
        spawnedPets[source] = nil
    end
    
    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    local spawnCoords = coords or (pCoords + vec3(1.0, 1.0, 0.0))
    
    local petEntity = CreatePed(28, joaat(modelName or 'a_c_chop'), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
    while not DoesEntityExist(petEntity) do Wait(10) end
    
    local netId = NetworkGetNetworkIdFromEntity(petEntity)
    Entity(petEntity).state:set('pet_owner', passport, true)
    Entity(petEntity).state:set('pet_task', 'follow', true)
    Entity(petEntity).state:set('pet_data', { id = petId, model = modelName, passport = passport }, true)
    
    spawnedPets[source] = {
        entity = petEntity,
        netId = netId,
        id = petId,
        passport = passport
    }
end)

RegisterNetEvent('pets.server:retrieve', function()
    local source = source
    if spawnedPets[source] and DoesEntityExist(spawnedPets[source].entity) then
        DeleteEntity(spawnedPets[source].entity)
        spawnedPets[source] = nil
        TriggerClientEvent('Notify', source, 'sucesso', 'Pet guardado com sucesso.')
    end
end)

RegisterNetEvent('pets.server:warp', function()
    local source = source
    if spawnedPets[source] and DoesEntityExist(spawnedPets[source].entity) then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        SetEntityCoords(spawnedPets[source].entity, coords.x + 1.0, coords.y + 1.0, coords.z, false, false, false, false)
    end
end)

RegisterNetEvent('pets.server:feedPet', function(netId)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    if vRP.tryGetInventoryItem(passport, 'petfood', 1, true) or vRP.tryGetInventoryItem(passport, 'racao', 1, true) then
        TriggerClientEvent('Notify', source, 'sucesso', 'Você alimentou o seu pet!')
    else
        TriggerClientEvent('Notify', source, 'negado', 'Você não tem ração para pet!')
    end
end)

RegisterNetEvent('pets.server:cuddlePet', function(netId)
    local source = source
    TriggerClientEvent('Notify', source, 'sucesso', 'Você acariciou o seu pet!')
end)

RegisterNetEvent('pets.server:setTask', function(netId, task)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        Entity(entity).state:set('pet_task', task, true)
    end
end)

RegisterNetEvent('pets.server:admin.maxLevelUp', function(netId)
    local source = source
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return end
    TriggerClientEvent('Notify', source, 'sucesso', 'Pet maximizado com sucesso!')
end)

function server.RenamePet(netId, name)
    local source = source
    local passport = vRP.Passport(source)
    if not passport or not name or name == '' then return { success = false } end
    return { success = true }
end
