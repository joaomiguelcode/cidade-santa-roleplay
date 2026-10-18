local SPRAY_PROP = `prop_cs_spray_can`
local SPRAY_ANIM_DICT = "anim@scripted@freemode@postertag@graffiti_spray@heeled@"
local SPRAY_ANIM_NAME = "spray_can_var_02_female"
local SPRAY_DURATION_MS = 5000
local SPRAY_VEHICLE_RANGE = 5.0
local BONE_RIGHT_HAND = 28422

local function getClosestVehicle(coords, maxDistance)
    local closest = nil
    local best = maxDistance or SPRAY_VEHICLE_RANGE
    for _, veh in ipairs(GetGamePool("CVehicle")) do
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local d = #(GetEntityCoords(veh) - coords)
            if d < best then
                best = d
                closest = veh
            end
        end
    end
    return closest, best
end

local function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local timeout = 0
        while not HasAnimDictLoaded(dict) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
    end
    return HasAnimDictLoaded(dict)
end

local function loadModel(hash)
    if not IsModelInCdimage(hash) then
        return false
    end
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    return HasModelLoaded(hash)
end

local function applySprayColorIndexes(vehicle, primaryIndex, secondaryIndex)
    ClearVehicleCustomPrimaryColour(vehicle)
    ClearVehicleCustomSecondaryColour(vehicle)
    SetVehicleColours(vehicle, primaryIndex, secondaryIndex)
end

RegisterNetEvent("admin:sprayCar:use", function(color)
    local primary, secondary = color[1], color[2]
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if IsPedInAnyVehicle(ped, false) then
        TriggerEvent("Notify2", "#sprayCarInVehicle")
        return
    end

    local vehicle, dist = getClosestVehicle(coords, SPRAY_VEHICLE_RANGE)
    if not vehicle or not DoesEntityExist(vehicle) then
        TriggerEvent("Notify2", "#sprayCarNoVehicle")
        return
    end

    if not loadAnimDict(SPRAY_ANIM_DICT) then
        sx.logger:warn( ('Spray car: anim dict "%s" não carregou'):format( SPRAY_ANIM_DICT ) )
    end
    if not loadModel(SPRAY_PROP) then
        sx.logger:warn( 'Spray car: prop spray can não carregou' )
    end

    local prop = CreateObject(SPRAY_PROP, coords.x, coords.y, coords.z, true, true, false)
    if not prop or prop == 0 or not DoesEntityExist(prop) then
        if HasAnimDictLoaded(SPRAY_ANIM_DICT) then
            RemoveAnimDict(SPRAY_ANIM_DICT)
        end
        TriggerEvent("Notify2", "#sprayCarError")
        return
    end

    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, BONE_RIGHT_HAND), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, SPRAY_ANIM_DICT, SPRAY_ANIM_NAME, 8.0, -8.0, SPRAY_DURATION_MS / 1000, 0, 0, false, false, false)

    TriggerEvent("Progress", "Pintando veículo", SPRAY_DURATION_MS)

    CreateThread(function()
        Wait(SPRAY_DURATION_MS)
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
        if DoesEntityExist(ped) then
            ClearPedTasks(ped)
        end
        if HasAnimDictLoaded(SPRAY_ANIM_DICT) then
            RemoveAnimDict(SPRAY_ANIM_DICT)
        end
    end)

    Wait(SPRAY_DURATION_MS)

    if not DoesEntityExist(vehicle) then
        TriggerEvent("Notify2", "#sprayCarNoVehicle")
        return
    end

    local primaryIndex = tonumber(primary)
    local secondaryIndex = tonumber(secondary)

    if primaryIndex == nil or secondaryIndex == nil then
        TriggerEvent("Notify2", "#sprayCarError")
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if not netId or netId == 0 then
        TriggerEvent("Notify2", "#sprayCarNoVehicle")
        return
    end

    applySprayColorIndexes(vehicle, primaryIndex, secondaryIndex)
    TriggerServerEvent("admin:sprayCar:apply", netId, primaryIndex, secondaryIndex)
end)

AddStateBagChangeHandler("sprayColor", nil, function(bagName, key, value, reserved, replicated)
    if not value or type(value) ~= "table" then
        return
    end
    local success, vehicle = pcall(GetEntityFromStateBagName, bagName)
    if not success or not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return
    end
    if not IsEntityAVehicle(vehicle) then
        return
    end

    local primaryIndex = tonumber(value.primary)
    local secondaryIndex = tonumber(value.secondary)

    if primaryIndex == nil or secondaryIndex == nil then
        return
    end

    applySprayColorIndexes(vehicle, primaryIndex, secondaryIndex)
end)
