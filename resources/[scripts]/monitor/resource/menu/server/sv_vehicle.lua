-- txAdmin sv_vehicle.lua
RegisterNetEvent('txsv:req:vehicle:spawn:fivem', function(model, modelType)
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local hash = GetHashKey(model)
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(10) end
    SetPedIntoVehicle(ped, veh, -1)
end)

RegisterNetEvent('txsv:req:vehicle:spawn:redm', function(model)
    -- RedM stub
end)

RegisterNetEvent('txsv:req:vehicle:delete', function(vehNetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local ent = NetworkGetEntityFromNetworkId(vehNetId)
    if DoesEntityExist(ent) then DeleteEntity(ent) end
end)

RegisterNetEvent('txsv:req:vehicle:fix', function()
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(veh) then
        SetVehicleFixed(veh)
        SetVehicleDirtLevel(veh, 0.0)
    end
end)

RegisterNetEvent('txsv:req:vehicle:boost', function()
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(veh) then
        SetVehicleForwardSpeed(veh, 50.0)
    end
end)
