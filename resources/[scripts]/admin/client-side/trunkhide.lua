local adminInTrunk = false
local trunkVehicle = nil
local trunkCam = nil
local trunkEntryCoords = nil

local function getClosestVehicle(coords, maxDistance)
    local closest = nil
    local best = maxDistance or 5.0
    for _, veh in ipairs(GetGamePool("CVehicle")) do
        if DoesEntityExist(veh) then
            local d = #(GetEntityCoords(veh) - coords)
            if d < best then
                best = d
                closest = veh
            end
        end
    end
    return closest, best
end

local function exitTrunk()
    if not adminInTrunk then
        return
    end
    local ped = PlayerPedId()
    local veh = trunkVehicle
    adminInTrunk = false
    trunkVehicle = nil

    if trunkCam and DoesCamExist(trunkCam) then
        RenderScriptCams(false, true, 300, true, true)
        DestroyCam(trunkCam, true)
        trunkCam = nil
    end
    DetachEntity(ped, false, false)
    if veh and DoesEntityExist(veh) then
        local backCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.5, 0.0)
        SetEntityCoords(ped, backCoords.x, backCoords.y, backCoords.z, false, false, false, false)
    end
    if veh and DoesEntityExist(veh) then
        local s = Entity(veh).state
        if s and s["adminTrunk"] then
            Entity(veh).state:set("adminTrunk", nil, true)
        end
    end
    SetEntityVisible(ped, true, false)
    LocalPlayer["state"]["Invisible"] = false
    LocalPlayer["state"]["Commands"] = false
end

RegisterNetEvent("net.admin.trunkhide", function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if adminInTrunk then
        exitTrunk()
        TriggerEvent("Notify2", "#trunkhideExit")
        return
    end

    if IsPedInAnyVehicle(ped, false) then
        TriggerEvent("Notify2", "#trunkhideInVehicle")
        return
    end

    local veh, dist = getClosestVehicle(coords, 4.0)
    if not veh or not DoesEntityExist(veh) then
        TriggerEvent("Notify2", "#trunkhideNoVehicle")
        return
    end

    local vState = Entity(veh).state
    if vState and vState["inTrunk"] then
        TriggerEvent("Notify2", "#trunkhideAlreadyUsed")
        return
    end

    LocalPlayer["state"]["Commands"] = true
    LocalPlayer["state"]["Invisible"] = true
    SetEntityVisible(ped, false, false)
    Entity(veh).state:set("adminTrunk", true, true)
    AttachEntityToEntity(ped, veh, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
    adminInTrunk = true
    trunkVehicle = veh
    trunkEntryCoords = vector3(coords.x, coords.y, coords.z)

    trunkCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    -- Visão de trás do carro, como motorista (chase cam): atrás e um pouco acima, olhando pra frente
    AttachCamToEntity(trunkCam, veh, 0.0, -5.5, 1.2, true)
    PointCamAtEntity(trunkCam, veh, 0.0, 4.0, 0.3, true)
    SetCamFov(trunkCam, 65.0)
    RenderScriptCams(true, true, 400, true, true)

    TriggerEvent("Notify2", "#trunkhideSuccess")
end)

CreateThread(function()
    while true do
        local wait = 500
        if adminInTrunk and trunkVehicle then
            wait = 0
            local ped = PlayerPedId()
            if not DoesEntityExist(trunkVehicle) then
                exitTrunk()
            else
                DisablePlayerFiring(ped, true)
                if IsControlJustPressed(0, 38) then
                    exitTrunk()
                    TriggerEvent("Notify2", "#trunkhideExit")
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler("entityRemoved", function(entity)
    if adminInTrunk and trunkVehicle == entity then
        exitTrunk()
    end
end)
