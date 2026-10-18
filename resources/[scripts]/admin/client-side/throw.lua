function GetClosestVehicleToPlayer()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1

    for _, vehicle in ipairs(vehicles) do
        local vehiclePos = GetEntityCoords(vehicle)
        local distance = #(playerPos - vehiclePos)

        if closestDistance == -1 or distance < closestDistance then
            closestVehicle = vehicle
            closestDistance = distance
        end
    end

    return closestVehicle, closestDistance
end

function getClosestNPCToPlayer()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local peds = GetGamePool('CPed')
    local closestDistance = -1

    for _, ped in ipairs(peds) do
        if ped ~= playerPed and not IsPedAPlayer(ped) then
            local pedPos = GetEntityCoords(ped)
            local distance = #(playerPos - pedPos)

            if closestDistance == -1 or distance < closestDistance then
                closestPed = ped
                closestDistance = distance
            end
        end
    end

    return closestPed, closestDistance
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function vehicleHasOccupants(vehicle)
    if not DoesEntityExist(vehicle) then
        return false
    end

    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) - 1 do
        local ped = GetPedInVehicleSeat(vehicle, seat)

        if ped ~= 0 and DoesEntityExist(ped) then
            return true
        end
    end

    return false
end

local function RequestVehicleControl(entity, timeoutMs)
    if not DoesEntityExist(entity) then
        return false
    end

    if NetworkHasControlOfEntity(entity) then
        return true
    end

    TriggerServerEvent("admin:requestControl", VehToNet(entity))
    Wait(50)

    local deadline = GetGameTimer() + (timeoutMs or 2000)

    while not NetworkHasControlOfEntity(entity) and GetGameTimer() <= deadline do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end

    return NetworkHasControlOfEntity(entity)
end

function RotToDirection(rotation)
    local radZ = math.rad(rotation.z)
    local radX = math.rad(rotation.x)
    local cosX = math.cos(radX)
    local cosZ = math.cos(radZ)
    local sinZ = math.sin(radZ)
    local sinX = math.sin(radX)

    local direction = vector3(
        -sinZ * cosX,
        cosZ * cosX,
        sinX
    )

    return direction
end
-----------------------------------------------------------------------------------
---
-----------------------------------------------------------------------------------
Config = {
    throwForce = 400000 -- default = 500000
}
local sleep = 1000
local handsUp = false
local vehicleAttached = false
local closestVehicle = nil
local npcAttached = false
local closestPed = nil

local activated = false
RegisterNetEvent("admin:Superman")
AddEventHandler("admin:Superman",function()
    local playerPed = PlayerPedId()
    activated = not activated
    print(activated)
    if activated then
        CreateThread(function()
            while activated do
                Wait(sleep)
                local playerPed = PlayerPedId()
                closestVehicle, vehicleDistance = GetClosestVehicleToPlayer()
                closestPed, pedDistance = getClosestNPCToPlayer()
        
        
                if closestVehicle and vehicleDistance < 5.0 then
                    if not vehicleAttached then
                        sleep = 1
                        local vehiclePos = GetEntityCoords(closestVehicle)

                        if not vehicleHasOccupants(closestVehicle) then
                            Draw3DText(vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.0, "[E] SEGURAR")
                        end
                    elseif vehicleAttached then
                        sleep = 1
                        -- Get the position of the vehicle and draw text on it
                        local vehiclePos = GetEntityCoords(closestVehicle)
                        Draw3DText(vehiclePos.x, vehiclePos.y, vehiclePos.z + 1.0, "[E] JOGAR CARRO")
                    else
                        sleep = 1000
                    end
                end

                if LocalPlayer["state"]["Special2"] and LocalPlayer["state"]["Route"] ~= 50 then
                    activated = false
                    break
                end
        
                -- Check if the player presses the "E" key
                if IsControlJustReleased(0, 38) then -- 38 is the control code for "E"
                    if not vehicleAttached and closestVehicle and vehicleDistance < 5.0 then
                        if vehicleHasOccupants(closestVehicle) then
                            TriggerEvent("Notify2", "#supermanVehicleOccupied")
                        elseif RequestVehicleControl(closestVehicle) then
                            local offset = vector3(1.2, 0.0, 0.0)
                            SetEntityAsMissionEntity(closestVehicle, true, true)
                            NetworkAllowRemoteAttachmentModification(playerPed, true)
                            NetworkAllowRemoteAttachmentModification(closestVehicle, true)
                            AttachEntityToEntity(
                                closestVehicle,
                                playerPed,
                                GetPedBoneIndex(playerPed, 57005),
                                offset.x, offset.y, offset.z,
                                0.0, 0.0, 0.0,
                                false, false, false, false, 2, true
                            )

                            if not HasAnimDictLoaded('missminuteman_1ig_2') then
                                RequestAnimDict('missminuteman_1ig_2')
                                while not HasAnimDictLoaded('missminuteman_1ig_2') do
                                    Wait(10)
                                end
                            end

                            TaskPlayAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)

                            vehicleAttached = true
                        end
                    elseif vehicleAttached then
                        local playerPed = PlayerPedId()
                        local camRot = GetGameplayCamRot(2)
                        local forwardVector = RotToDirection(camRot)

                        RequestVehicleControl(closestVehicle)

                        SetEntityNoCollisionEntity(closestVehicle, playerPed, false)
                        DetachEntity(closestVehicle, true, true)

                        local forceVector = forwardVector * Config.throwForce
                        ApplyForceToEntity(
                            closestVehicle,
                            1,
                            forceVector.x,
                            forceVector.y,
                            forceVector.z
                        )

                        vehicleAttached = false
                        ClearPedTasks(playerPed)
                    elseif not npcAttached and closestPed and pedDistance < 5.0 and not IsPedInAnyVehicle(closestPed, false)then
                        -- Attach the vehicle to the player's hands
                        local playerCoords = GetEntityCoords(playerPed)
                        local offset = vector3(0.5, 0.0, 0.0) -- Adjust this to change the vehicle's position relative to the player's hands
        
                        -- Attach the vehicle to the player's hand
                        AttachEntityToEntity(
                            closestPed,
                            playerPed,
                            GetPedBoneIndex(playerPed, 57005), -- 57005 is the bone index for the right hand
                            offset.x, offset.y, offset.z,
                            0.0, 0.0, 0.0,
                            false, false, false, false, 2, true
                        )
        
                        -- Raise the player's hand (animation)
                        if not HasAnimDictLoaded('missminuteman_1ig_2') then
                            RequestAnimDict('missminuteman_1ig_2')
                            while not HasAnimDictLoaded('missminuteman_1ig_2') do
                                Wait(10)
                            end
                        end
                        
                        TaskPlayAnim(playerPed, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
        
                        npcAttached = true
                    elseif npcAttached then
                        -- Detach the vehicle and throw it in the direction the player's camera is facing
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)
                        local camRot = GetGameplayCamRot(2)
                        local forwardVector = RotToDirection(camRot)
        
                        SetEntityNoCollisionEntity(closestPed, playerPed, false)
        
                        -- Detach the vehicle
                        DetachEntity(closestPed, true, true)
                        -- Apply force to the vehicle
                        local forceVector = forwardVector * Config.throwForce
                        ApplyForceToEntity(
                            closestPed,
                            1, -- Force type (1 is high force)
                            forceVector.x,
                            forceVector.y,
                            forceVector.z
                        )
                        npcAttached = false
                        ClearPedTasks(playerPed)
                        Wait(10)
                        SetPedToRagdoll(closestPed, 1000, 1000, 0, true, false, false)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('net.disable.throw', function()
    if activated then
        activated = false
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if closestVehicle then
        DetachEntity(closestVehicle, true, true)
    end
end)

RegisterNetEvent('plantc4', function()
    local ped         = PlayerPedId()
    local coords      = GetEntityCoords(ped)

    local timeToExplode = 10000

    local model       = 'c4_2_sg_pru'

    RequestModel(model)

    local exploded = false

    local now = GetGameTimer()
    while not HasModelLoaded(model) do
        Wait(1)
    end

    local c4 = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, true, true, true)
    local c4coord = GetEntityCoords(c4)

    SetModelAsNoLongerNeeded(model)

    RequestAnimDict('anim@scripted@freemode@ig9_plant_explosive@male@')

    while not HasAnimDictLoaded('anim@scripted@freemode@ig9_plant_explosive@male@') do
        Wait(1)
    end

    local cam = CreateCam('DEFAULT_SPLINE_CAMERA', true)

    local frontCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)

    SetCamCoord(cam, frontCoords.x, frontCoords.y, frontCoords.z + 5.0)

    PointCamAtEntity(cam,ped)

    AddCamSplineNode(cam, frontCoords.x, frontCoords.y, frontCoords.z + 3.0, 0.0, 0.0, 0.0, 2000, 50, 1)
    AddCamSplineNode(cam, coords.x, coords.y - 2.0, coords.z, 0.0, 0.0, 0.0, 2000, 50, 1)
    RenderScriptCams(true, true, 1, false, true)

    TaskPlayAnim(ped, 'anim@scripted@freemode@ig9_plant_explosive@male@', 'action', 8.0, 8.0, -1, 0, 0, false, false, false)

    AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.1, -0.17, -90.0, 0.0, 0.0, true, true, false, false, 5, false)

    Wait(4000)

    DetachEntity(c4, true, true)

    FreezeEntityPosition(c4, true)

    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(cam, false)

    CreateThread(function()
        while not exploded do
            Wait(1000)
            if (not exploded) then
                PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
            end
        end
    end)

    TriggerEvent("Progress","C4",timeToExplode)

    SetTimeout(timeToExplode,function()
        exploded = true
        
        local currentC4Coords = GetEntityCoords(c4)
        
        RequestNamedPtfxAsset("scr_agencyheistb")
        while not HasNamedPtfxAssetLoaded("scr_agencyheistb") do
            Wait(1)
        end
        
        

        AddExplosion(currentC4Coords.x, currentC4Coords.y, currentC4Coords.z, 47, 1.0, true, false, 4.0)  -- BOMB_CLUSTER menor
        
        
        for i = 1, 3 do
            UseParticleFxAssetNextCall("scr_agencyheistb")
            StartParticleFxLoopedAtCoord("scr_agency3b_heli_exp_trail", currentC4Coords.x, currentC4Coords.y, currentC4Coords.z + (i * 3.0), 0.0, 0.0, 0.0, 1.5, false, false, false, false)
            Wait(100)
        end

        DeleteEntity(c4)
    end)

    
end)