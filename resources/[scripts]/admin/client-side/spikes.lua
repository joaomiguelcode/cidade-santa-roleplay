local spikeObjects = {}
local spikeCheckThread = nil

local function CreateSpikesBehindVehicle()
    local ped = PlayerPedId()
    
    if not IsPedInAnyVehicle(ped, false) then
        TriggerEvent("Notify2", "#notInVehicle")
        return
    end
    
    local vehicle = GetVehiclePedIsUsing(ped)
    if not DoesEntityExist(vehicle) then
        return
    end

    local vehicleCoords = GetEntityCoords(vehicle)
    local vehicleHeading = GetEntityHeading(vehicle)
    
    local forwardVector = GetEntityForwardVector(vehicle)
    local rearVector = vector3(-forwardVector.x, -forwardVector.y, forwardVector.z)
    local minDimension, maxDimension = GetModelDimensions(GetEntityModel(vehicle))
    local vehicleLength = maxDimension.y - minDimension.y
    local distanceBehind = (vehicleLength / 2) + 0.3
    local centerCoords = vector3(
        vehicleCoords.x + (rearVector.x * distanceBehind),
        vehicleCoords.y + (rearVector.y * distanceBehind),
        vehicleCoords.z
    )
    
    local foundGround, groundZ = GetGroundZFor_3dCoord(centerCoords.x, centerCoords.y, centerCoords.z, false)
    if foundGround then
        centerCoords = vector3(centerCoords.x, centerCoords.y, groundZ + 0.05)
    else
        centerCoords = vector3(centerCoords.x, centerCoords.y, centerCoords.z - 0.45)
    end
    
    TriggerServerEvent("admin:createSpikes", centerCoords, vehicleHeading, 4.0)
end

local function RemoveSpikeObjects(spikeId)
    if spikeObjects[spikeId] then
        spikeObjects[spikeId] = nil
    end
end

local function StartSpikeCheckThread()
    if spikeCheckThread then
        return
    end
    
    spikeCheckThread = CreateThread(function()
        while true do
            local waitTime = 100
            
            if next(spikeObjects) == nil then
                waitTime = 1000
            else
                local allVehicles = GetGamePool('CVehicle')
                local ped = PlayerPedId()
                local playerVehicle = GetVehiclePedIsIn(ped, false)
                
                for spikeId, spikeData in pairs(spikeObjects) do
                    if spikeData.centerCoords then
                        for _, vehicle in pairs(allVehicles) do
                            if DoesEntityExist(vehicle) then
                                local vehicleCoords = GetEntityCoords(vehicle)
                                local distance = #(vehicleCoords - spikeData.centerCoords)
                                
                                local dx = vehicleCoords.x - spikeData.centerCoords.x
                                local dy = vehicleCoords.y - spikeData.centerCoords.y
                                local horizontalDistance = math.sqrt(dx * dx + dy * dy)
                                
                                if horizontalDistance < 1.5 then
                                    local vehicleStateBag = Entity(vehicle).state
                                    if vehicleStateBag then
                                        local lastHitKey = "lastSpikeHit_" .. spikeId
                                        local lastHit = vehicleStateBag[lastHitKey] or 0
                                        
                                        if GetGameTimer() - lastHit > 500 then
                                            vehicleStateBag[lastHitKey] = GetGameTimer()
                                            
                                            local tyresCanBurst = GetVehicleTyresCanBurst(vehicle)
                                            
                                            if not tyresCanBurst then
                                                SetVehicleTyresCanBurst(vehicle, true)
                                            end
                                            
                                            for wheelIndex = 0, 5 do
                                                if not IsVehicleTyreBurst(vehicle, wheelIndex, false) then
                                                    SetVehicleTyreBurst(vehicle, wheelIndex, true, 1000.0)
                                                end
                                            end
                                            
                                            if not tyresCanBurst then
                                                SetVehicleTyresCanBurst(vehicle, false)
                                            end
                                            
                                            vehicleStateBag.spikesHit = (vehicleStateBag.spikesHit or 0) + 1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            Wait(waitTime)
        end
    end)
end

AddStateBagChangeHandler("spikeActive", nil, function(bagName, key, value, reserved, replicated)
    if not value then
        local success, spikeObject = pcall(GetEntityFromStateBagName, bagName)
        if success and spikeObject and spikeObject ~= 0 then
            local spikeStateBag = Entity(spikeObject).state
            if spikeStateBag then
                local spikeId = spikeStateBag.spikeId
                if spikeId and spikeObjects[spikeId] then
                    RemoveSpikeObjects(spikeId)
                end
            end
        end
        return
    end
    
    if value ~= true then
        return
    end
    
    Wait(100)
    
    local success, spikeObject = pcall(GetEntityFromStateBagName, bagName)
    if not success or not spikeObject or spikeObject == 0 or not DoesEntityExist(spikeObject) then
        return
    end
    
    local spikeStateBag = Entity(spikeObject).state
    if not spikeStateBag then
        return
    end
    
    local spikeId = spikeStateBag.spikeId
    local spikeCoords = spikeStateBag.spikeCoords
    local spikeCenterCoords = spikeStateBag.spikeCenterCoords
    local spikeOwner = spikeStateBag.spikeOwner
    
    if not spikeId or not spikeCoords then
        Wait(200)
        spikeId = spikeStateBag.spikeId
        spikeCoords = spikeStateBag.spikeCoords
        spikeCenterCoords = spikeStateBag.spikeCenterCoords
        spikeOwner = spikeStateBag.spikeOwner
    end
    
    if not spikeId or not spikeCoords then
        return
    end
    
    if not spikeCenterCoords then
        spikeCenterCoords = spikeCoords
    end
    
    if not spikeObjects[spikeId] then
        spikeObjects[spikeId] = {
            centerCoords = spikeCenterCoords,
            width = 3.0,
            owner = spikeOwner
        }
        
        CreateThread(function()
            Wait(60000)
            if spikeObjects[spikeId] then
                RemoveSpikeObjects(spikeId)
            end
        end)
        
        StartSpikeCheckThread()
    end
end)

AddStateBagChangeHandler("spikesHit", nil, function(bagName, key, value, reserved, replicated)
    if replicated or not value then
        return
    end
    
    local success, vehicle = pcall(GetEntityFromStateBagName, bagName)
    if not success or not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return
    end
    
    local tyresCanBurst = GetVehicleTyresCanBurst(vehicle)
    
    if not tyresCanBurst then
        SetVehicleTyresCanBurst(vehicle, true)
    end
    
    for wheelIndex = 0, 5 do
        if not IsVehicleTyreBurst(vehicle, wheelIndex, false) then
            SetVehicleTyreBurst(vehicle, wheelIndex, true, 1000.0)
        end
    end
    
    if not tyresCanBurst then
        SetVehicleTyresCanBurst(vehicle, false)
    end
end)

RegisterNetEvent("admin:requestSpikeCoords", function()
    CreateSpikesBehindVehicle()
end)

StartSpikeCheckThread()

AddStateBagChangeHandler("spikeFinalCoords", nil, function(bagName, key, value, reserved, replicated)
    if not value or replicated then
        return
    end
    
    Wait(50)
    
    local success, spikeObject = pcall(GetEntityFromStateBagName, bagName)
    if not success or not spikeObject or spikeObject == 0 or not DoesEntityExist(spikeObject) then
        return
    end
    
    local spikeStateBag = Entity(spikeObject).state
    if not spikeStateBag then
        return
    end
    
    local finalCoords = spikeStateBag.spikeFinalCoords
    local heading = spikeStateBag.spikeHeading
    
    if not finalCoords or not heading then
        Wait(150)
        finalCoords = spikeStateBag.spikeFinalCoords
        heading = spikeStateBag.spikeHeading
    end
    
    if finalCoords and heading then
        SetEntityDynamic(spikeObject, true)
        SetEntityHasGravity(spikeObject, true)
        SetEntityCollision(spikeObject, true, true)
        
        local headingRad = math.rad(heading)
        local vehicleSpeed = 0.0
        
        local randomX = (math.random() - 0.5) * 0.4
        local randomY = (math.random() - 0.5) * 0.4
        local backwardX = -0.25 * math.sin(headingRad)
        local backwardY = -0.25 * math.cos(headingRad)
        
        local rotX = (math.random() - 0.5) * 360.0
        local rotY = (math.random() - 0.5) * 360.0
        local rotZ = (math.random() - 0.5) * 360.0
        
        SetEntityRotation(spikeObject, rotX, rotY, rotZ + heading, 2, true)
        
        SetEntityVelocity(spikeObject, randomX + backwardX, randomY + backwardY, -2.5)
        
        CreateThread(function()
            local hasLanded = false
            local bounceCount = 0
            local maxBounces = 2
            
            while DoesEntityExist(spikeObject) and not hasLanded do
                Wait(50)
                
                local currentCoords = GetEntityCoords(spikeObject)
                local velocity = GetEntityVelocity(spikeObject)
                local foundGround, groundZ = GetGroundZFor_3dCoord(currentCoords.x, currentCoords.y, currentCoords.z, false)
                
                if foundGround and currentCoords.z <= groundZ + 0.15 then
                    if bounceCount < maxBounces and math.abs(velocity.z) > 0.3 then
                        bounceCount = bounceCount + 1
                        local bounceVelocity = vector3(
                            velocity.x * 0.3,
                            velocity.y * 0.3,
                            math.abs(velocity.z) * 0.4
                        )
                        SetEntityVelocity(spikeObject, bounceVelocity.x, bounceVelocity.y, bounceVelocity.z)
                        
                        local newRotX = GetEntityRotation(spikeObject, 2).x + (math.random() - 0.5) * 30.0
                        local newRotY = GetEntityRotation(spikeObject, 2).y + (math.random() - 0.5) * 30.0
                        local newRotZ = GetEntityRotation(spikeObject, 2).z + (math.random() - 0.5) * 30.0
                        SetEntityRotation(spikeObject, newRotX, newRotY, newRotZ, 2, true)
                    else
                        hasLanded = true
                        SetEntityCoords(spikeObject, currentCoords.x, currentCoords.y, groundZ + 0.05, false, false, false, false)
                        -- FreezeEntityPosition(spikeObject, true)
                        
                        local finalRot = GetEntityRotation(spikeObject, 2)
                        SetEntityRotation(spikeObject, finalRot.x, finalRot.y, heading, 2, true)
                    end
                end
            end
        end)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        spikeObjects = {}
    end
end)

