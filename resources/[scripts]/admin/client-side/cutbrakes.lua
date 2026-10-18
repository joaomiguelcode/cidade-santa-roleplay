local function GetClosestVehicle(coords, maxDistance)
    local closestVehicle = nil
    local closestDistance = maxDistance or 5.0
    
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(coords - vehicleCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestVehicle = vehicle
            end
        end
    end
    
    return closestVehicle, closestDistance
end

CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        -- Do not cache a vehicle handle from a state-bag callback: the entity can be unresolved when it fires.
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed and Entity(vehicle).state.brakesCut == true then
            SetVehicleHandbrake(vehicle, false)
            DisableControlAction(0, 72, true)
            DisableControlAction(0, 76, true)
        end
    end
end)

RegisterNetEvent("net.admin.cutbrakes", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent("Notify2", "#cutbrakesInVehicle")
        return
    end
    
    local closestVehicle, distance = GetClosestVehicle(playerCoords, 5.0)
    
    if not closestVehicle or not DoesEntityExist(closestVehicle) then
        TriggerEvent("Notify2", "#cutbrakesNoVehicle")
        return
    end
    
    local vehicleStateBag = Entity(closestVehicle).state
    if vehicleStateBag.brakesCut == true then
        TriggerEvent("Notify2", "#cutbrakesAlreadyCut")
        return
    end
    
    local vehicleCoords = GetEntityCoords(closestVehicle)
    local vehicleHeading = GetEntityHeading(closestVehicle)
    
    local minDimension, maxDimension = GetModelDimensions(GetEntityModel(closestVehicle))
    local forwardVector = GetEntityForwardVector(closestVehicle)
    
    local frontOffset = maxDimension.y * 1.1
    local liePosition = vehicleCoords + (forwardVector * frontOffset)
    
    local foundGround, groundZ = GetGroundZFor_3dCoord(liePosition.x, liePosition.y, liePosition.z, false)
    
    if foundGround then
        liePosition = vector3(liePosition.x, liePosition.y, groundZ - 0.2)
    else
        liePosition = vector3(liePosition.x, liePosition.y, vehicleCoords.z - 0.4)
    end
    
    SetEntityCoords(playerPed, liePosition.x, liePosition.y, liePosition.z, false, false, false, true)
    
    SetEntityHeading(playerPed, vehicleHeading)
    SetEntityRotation(playerPed, 0.0, 0.0, vehicleHeading, 2, true)
    
    exports.scripted_interactions:startScriptedInteraction('cut_brakes')
    

    Wait(7000)
    
    local vehicleNetId = NetworkGetNetworkIdFromEntity(closestVehicle)
    TriggerServerEvent("net.admin.setBrakesCut", vehicleNetId)
    
    exports.scripted_interactions:stopScriptedInteraction({ interactionName = 'cut_brakes' })
    
end, false)

RegisterNetEvent("net.admin.cutbrakesResult", function(result)
    if result == "success" then
        TriggerEvent("Notify2", "#cutbrakesSuccess")
        return
    end

    if result == "alreadyCut" then
        TriggerEvent("Notify2", "#cutbrakesAlreadyCut")
        return
    end

    TriggerEvent("Notify2", "#cutbrakesNoVehicle")
end)

