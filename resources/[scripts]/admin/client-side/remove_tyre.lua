local tyreInHand = nil
local isRemovingTyre = false

local config = {
    tyreProp = 'prop_wheel_tyre',
    animDict = 'amb@world_human_vehicle_mechanic@male@base',
    animName = 'base',
    maxDistance = 3.0,
    wheelBones = {
        [0] = 'wheel_lf',
        [1] = 'wheel_rf',
        [2] = 'wheel_lm',
        [3] = 'wheel_rm',
        [4] = 'wheel_lr',
        [5] = 'wheel_rr',
    }
}

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function GetHeadingFromCoords2D(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local heading = math.atan2(dy, dx) * 180.0 / math.pi
    return heading
end

local function GetWheelPosition(vehicle, wheelIndex)
    local boneName = config.wheelBones[wheelIndex]
    if not boneName then
        return nil
    end
    
    local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
    if boneIndex == -1 then
        return nil
    end
    
    return GetWorldPositionOfEntityBone(vehicle, boneIndex)
end

local function GetClosestWheel(vehicle)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestWheelIndex = nil
    local closestDistance = config.maxDistance
    
    for wheelIndex = 0, 5 do
        local wheelPos = GetWheelPosition(vehicle, wheelIndex)
        if wheelPos then
            local distance = #(playerCoords - wheelPos)
            if distance < closestDistance then
                if not IsVehicleTyreBurst(vehicle, wheelIndex, false) then
                    closestDistance = distance
                    closestWheelIndex = wheelIndex
                end
            end
        end
    end
    
    return closestWheelIndex, closestDistance
end

local function CreateTyreInHand()
    if tyreInHand and DoesEntityExist(tyreInHand) then
        DeleteEntity(tyreInHand)
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    local tyreModel = GetHashKey(config.tyreProp)
    RequestModel(tyreModel)
    while not HasModelLoaded(tyreModel) do
        Wait(10)
    end
    
    tyreInHand = CreateObject(tyreModel, coords.x, coords.y, coords.z, true, false, false)
    SetEntityAsMissionEntity(tyreInHand, true, true)
    
    AttachEntityToEntity(
        tyreInHand, 
        ped, 
        GetPedBoneIndex(ped, 60309), 
        0.2,
        0.08,
        0.2,
        -45.0,
        290.0,
        0.0,
        true, true, false, true, 1, true
    )
    
    SetModelAsNoLongerNeeded(tyreModel)
end

local function RemoveTyre(vehicle, wheelIndex)
    if isRemovingTyre then
        return
    end
    
    isRemovingTyre = true
    
    local ped = PlayerPedId()
    
    LoadAnimDict(config.animDict)
    
    local wheelPos = GetWheelPosition(vehicle, wheelIndex)
    if wheelPos then
        local pedCoords = GetEntityCoords(ped)
        
        local directionToWheel = vector3(
            wheelPos.x - pedCoords.x,
            wheelPos.y - pedCoords.y,
            0.0
        )
        local distanceToWheel = #directionToWheel
        
        if distanceToWheel > 0 then
            directionToWheel = directionToWheel / distanceToWheel
            
            local targetPos = vector3(
                wheelPos.x - directionToWheel.x * 0.5,
                wheelPos.y - directionToWheel.y * 0.2,
                wheelPos.z
            )
            
            local foundGround, groundZ = GetGroundZFor_3dCoord(targetPos.x, targetPos.y, targetPos.z, false)
            if foundGround then
                targetPos = vector3(targetPos.x, targetPos.y, groundZ + 0.5)
            else
                targetPos = vector3(targetPos.x, targetPos.y, wheelPos.z - 0.2)
            end
            
            SetEntityCoordsNoOffset(ped, targetPos.x, targetPos.y, targetPos.z, false, false, true)
            
            local dx = wheelPos.x - targetPos.x
            local dy = wheelPos.y - targetPos.y
            local headingToWheel = (math.atan2(dx, dy) * 180.0 / math.pi) + 180.0
            SetEntityHeading(ped, headingToWheel)
            
            Wait(500)
        end
    end
    
    RequestAnimSet("move_ped_crouched")
    while not HasAnimSetLoaded("move_ped_crouched") do
        Wait(10)
    end
    SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
    
    LoadAnimDict('amb@medic@standing@kneel@base')
    
    TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, 8.0, 3000, 1, 0, 0, 0, 0)
    
    Wait(3000)
    
    ResetPedMovementClipset(ped, 0.25)
    
    SetVehicleTyreBurst(vehicle, wheelIndex, true, 1000.0)
    
    CreateTyreInHand()
    
    ClearPedTasks(ped)
    Wait(200)
    
    LoadAnimDict('anim@heists@box_carry@')
    TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 49, 0, 0, 0, 0)
    
    TriggerServerEvent('net.admin.setTyreRemoved', NetworkGetNetworkIdFromEntity(vehicle), wheelIndex)
    
    isRemovingTyre = false
end

local function GetClosestVehicleToPlayer(maxDistance)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDistance = maxDistance
    
    for _, vehicle in pairs(vehicles) do
        if DoesEntityExist(vehicle) and not IsPedInVehicle(ped, vehicle, false) then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(pedCoords - vehicleCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestVehicle = vehicle
            end
        end
    end
    
    return closestVehicle
end

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoord()
    local distance = #(camCoords - vec3(x, y, z))
    
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
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

local removeTyreActive = false

CreateThread(function()
    while true do
        local idle = 1000
        
        if removeTyreActive and not isRemovingTyre then
            local ped = PlayerPedId()
            
            local vehicle = GetClosestVehicleToPlayer(config.maxDistance)
            
            if vehicle and DoesEntityExist(vehicle) then
                local wheelIndex, distance = GetClosestWheel(vehicle)
                
                if wheelIndex ~= nil then
                    idle = 0
                    
                    local wheelPos = GetWheelPosition(vehicle, wheelIndex)
                    if wheelPos then
                        DrawText3D(wheelPos.x, wheelPos.y, wheelPos.z, "[E] Remover Pneu")
                    end
                    
                    if IsControlJustPressed(0, 38) then
                        RemoveTyre(vehicle, wheelIndex)
                        TriggerEvent("Notify2", "#removeTyreSuccess")
                    end
                end
            end
        end
        
        Wait(idle)
    end
end)

RegisterCommand('droptyre', function()
    if tyreInHand and DoesEntityExist(tyreInHand) then
        local ped = PlayerPedId()
        ClearPedTasks(ped)
        DetachEntity(tyreInHand)
        
        local tyreCoords = GetEntityCoords(tyreInHand)
        
        local foundGround, groundZ = GetGroundZFor_3dCoord(tyreCoords.x, tyreCoords.y, tyreCoords.z, false)
        
        if foundGround then
            SetEntityCoords(tyreInHand, tyreCoords.x, tyreCoords.y, groundZ + 0.3, false, false, true)
        else
            SetEntityCoords(tyreInHand, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.5, 0.0))
        end
        
        PlaceObjectOnGroundProperly(tyreInHand)
        
        Wait(100)
        
        local finalCoords = GetEntityCoords(tyreInHand)
        local finalGround, finalGroundZ = GetGroundZFor_3dCoord(finalCoords.x, finalCoords.y, finalCoords.z, false)
        if finalGround then
            SetEntityCoords(tyreInHand, finalCoords.x, finalCoords.y, finalGroundZ + 0.3, false, false, true)
        end
        
        FreezeEntityPosition(tyreInHand, true)
        tyreInHand = nil
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            if tyreInHand and DoesEntityExist(tyreInHand) then
                DeleteEntity(tyreInHand)
                tyreInHand = nil
                ClearPedTasks(ped)
            end
        end
    end
end)

AddStateBagChangeHandler("tyreRemoved", nil, function(bagName, key, value, reserved, replicated)
    if replicated or not bagName or bagName == "" then
        return
    end
    
    local success, vehicle = pcall(GetEntityFromStateBagName, bagName)
    if not success or not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return
    end
    
    if value and type(value) == "number" then
        SetVehicleTyreBurst(vehicle, value, true, 1000.0)
    end
end)

RegisterNetEvent("net.admin.removeTyre", function()
    local playerPed = PlayerPedId()
    local playerGroups = vRP.GetPlayerGroups()
    local isAdmin = playerGroups["Admin"] == 1 or playerGroups["gestaoinfluencer"] == 1 or playerGroups["Developers"] == 1
    
    if not isAdmin then
        return
    end
    
    if IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent("Notify2", "#removeTyreInVehicle")
        return
    end
    
    removeTyreActive = true
    
    CreateThread(function()
        Wait(30000)
        removeTyreActive = false
    end)
end)

