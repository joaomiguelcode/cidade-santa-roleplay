
vSERVER = Tunnel.getInterface("admin")

local vehicleControlActive = false
local controlledVehicle = nil
local targetPlayerId = nil
local tempControlData = nil
local driverControlBlocked = false
local driverCam = nil
local driverCamThread = nil
local controlledVehicleEntity = nil
local originalAdminModel = nil
local originalAdminAppearance = {}

local controlInputs = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    handbrake = false
}
local controlThreadActive = false
local lastActionSent = nil
local lastSendTime = 0


local function sendControlUpdate()
end

local function resetControlInputs()
    controlInputs.forward = false
    controlInputs.backward = false
    controlInputs.left = false
    controlInputs.right = false
    controlInputs.handbrake = false
    lastActionSent = nil
    lastSendTime = 0
end

local function forceDriverTakeover()
    if not tempControlData then return end

    local ped = PlayerPedId()
    local vehicle = tempControlData.vehicle
    local targetPed = tempControlData.targetPed

    TriggerServerEvent("net.admin.toggleDriverControl", tempControlData.targetSource, false)

    if targetPed and DoesEntityExist(targetPed) then
        SetBlockingOfNonTemporaryEvents(targetPed, false)
        SetPedCanBeDraggedOut(targetPed, true)
        if tempControlData.seatShuffleFlag ~= nil then
            SetPedConfigFlag(targetPed, 184, tempControlData.seatShuffleFlag)
        end
    end

    vehicleControlActive = false
    controlThreadActive = false
    resetControlInputs()
    driverControlBlocked = false
    targetPlayerId = nil

    SetEntityInvincible(ped, false)
    SetPedCanRagdoll(ped, true)
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true, false)
    SetEntityAlpha(ped, 255, false)

    if vehicle and DoesEntityExist(vehicle) then
        if IsPedInVehicle(ped, vehicle, false) then
            TaskLeaveVehicle(ped, vehicle, 0)
            Wait(500)
        end
        TriggerEvent("Notify2", "#vehicleControlStopped")
    else
        TriggerEvent("Notify2", "#vehicleControlFailed")
    end

    if tempControlData.originalCoords then
        SetEntityCoordsNoOffset(ped, tempControlData.originalCoords.x, tempControlData.originalCoords.y, tempControlData.originalCoords.z, false, false, false)
        if tempControlData.originalHeading then
            SetEntityHeading(ped, tempControlData.originalHeading)
        end
    end

    tempControlData = nil
end

local function ensureControlThread()
end


RegisterNetEvent("net.admin.startVehicleControl", function(targetSource)
    CreateThread(function()

        Wait(250)

        local adminPed = PlayerPedId()
        local targetPlayer = GetPlayerFromServerId(targetSource)

        if targetPlayer == -1 then
            TriggerEvent("Notify2", "#playerOffline")
            return
        end

        local targetPed = GetPlayerPed(targetPlayer)

        if not DoesEntityExist(targetPed) then
            TriggerEvent("Notify2", "#playerOffline")
            return
        end

        if not IsPedInAnyVehicle(targetPed, false) then
            TriggerEvent("Notify2", "#playerNotInVehicle")
            return
        end

        local vehicle = GetVehiclePedIsIn(targetPed, false)

        if not DoesEntityExist(vehicle) then
            TriggerEvent("Notify2", "#vehicleControlFailed")
            return
        end

        vehicleControlActive = true
        controlledVehicle = vehicle
        targetPlayerId = targetSource
        resetControlInputs()

        tempControlData = {
            adminPed = adminPed,
            targetPed = targetPed,
            targetSource = targetSource,
            vehicle = vehicle,
            originalCoords = GetEntityCoords(adminPed),
            originalHeading = GetEntityHeading(adminPed),
            vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle),
            seatShuffleFlag = GetPedConfigFlag(targetPed, 184, true)
        }

        SetEntityInvincible(adminPed, true)
        SetPedCanRagdoll(adminPed, false)
        ClearPedTasksImmediately(adminPed)

        local timer = GetGameTimer() + 2000
        while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() <= timer do
            NetworkRequestControlOfEntity(vehicle)
            Wait(0)
        end

        timer = GetGameTimer() + 2000
        while not NetworkHasControlOfEntity(targetPed) and GetGameTimer() <= timer do
            NetworkRequestControlOfEntity(targetPed)
            Wait(0)
        end

        SetVehicleEngineOn(vehicle, true, true, false)
        
        originalAdminModel = GetEntityModel(adminPed)
        for i = 0, 20 do
            originalAdminAppearance[i] = {
                GetPedDrawableVariation(adminPed, i),
                GetPedTextureVariation(adminPed, i),
                GetPedPaletteVariation(adminPed, i)
            }
        end
        for i = 0, 10 do
            originalAdminAppearance["p"..i] = {
                GetPedPropIndex(adminPed, i),
                GetPedPropTextureIndex(adminPed, i)
            }
        end
        
        CreateThread(function()
            Wait(1200)
            local targetModel = GetEntityModel(targetPed)
            if targetModel ~= originalAdminModel then
                RequestModel(targetModel)
                while not HasModelLoaded(targetModel) do
                    Wait(10)
                end
                SetPlayerModel(PlayerId(), targetModel)
                adminPed = PlayerPedId()
                Wait(100)
            end
            
            for i = 0, 20 do
                local drawable = GetPedDrawableVariation(targetPed, i)
                local texture = GetPedTextureVariation(targetPed, i)
                local palette = GetPedPaletteVariation(targetPed, i)
                SetPedComponentVariation(adminPed, i, drawable, texture, palette)
            end
            
            for i = 0, 10 do
                local propIndex = GetPedPropIndex(targetPed, i)
                if propIndex ~= -1 then
                    local propTexture = GetPedPropTextureIndex(targetPed, i)
                    SetPedPropIndex(adminPed, i, propIndex, propTexture, true)
                else
                    ClearPedProp(adminPed, i)
                end
            end

            SetPedEyeColor(adminPed, GetPedEyeColor(targetPed))
            SetPedComponentVariation(adminPed, 2, GetPedDrawableVariation(targetPed, 2), GetPedTextureVariation(targetPed, 2), GetPedPaletteVariation(targetPed, 2))
            SetPedHairColor(adminPed, GetPedHairColor(targetPed), GetPedHairHighlightColor(targetPed))
        end)

        exports.scripted_interactions:startScriptedInteraction('joystick_control', { state = 'idle' })
        TriggerServerEvent("net.admin.toggleDriverControl", targetSource, true)
        Wait(800)

        if GetPedInVehicleSeat(vehicle, -1) == targetPed then
            SetPedCoordsKeepVehicle(targetPed, GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -1.5, 0.0))
            ClearPedTasksImmediately(targetPed)
            Wait(100)
            if IsPedInVehicle(targetPed, vehicle, false) then
                SetPedIntoVehicle(targetPed, vehicle, 0)
                Wait(50)
                SetPedCoordsKeepVehicle(targetPed, GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -1.5, 0.0))
                Wait(100)
            end
        end

        exports.scripted_interactions:stopScriptedInteraction({ interactionName = 'joystick_control' })
        Wait(300)

        local targetModel = GetEntityModel(targetPed)
        if targetModel ~= originalAdminModel then
            RequestModel(targetModel)
            while not HasModelLoaded(targetModel) do
                Wait(10)
            end
            SetPlayerModel(PlayerId(), targetModel)
            adminPed = PlayerPedId()
            Wait(100)
        end

        local attempts = 0
        while not IsPedInVehicle(adminPed, vehicle, false) and attempts < 15 do
            if GetPedInVehicleSeat(vehicle, -1) == 0 or GetPedInVehicleSeat(vehicle, -1) ~= targetPed then
                SetPedIntoVehicle(adminPed, vehicle, -1)
                Wait(200)
                if not IsPedInVehicle(adminPed, vehicle, false) then
                    TaskWarpPedIntoVehicle(adminPed, vehicle, -1)
                    Wait(200)
                end
            else
                Wait(200)
            end
            attempts = attempts + 1
        end

        if not IsPedInVehicle(adminPed, vehicle, false) then
            TriggerEvent("Notify2", "#vehicleControlFailed")
            TriggerServerEvent("net.admin.toggleDriverControl", targetSource, false)
            vehicleControlActive = false
            tempControlData = nil
            return
        end

        ClonePedToTarget(targetPed, adminPed)
        Wait(100)

        TriggerEvent("Notify2", "#vehicleControlActive")

        CreateThread(function()
            while vehicleControlActive and tempControlData do
                local driverPlayer = GetPlayerFromServerId(tempControlData.targetSource)
                if driverPlayer == -1 or not DoesEntityExist(tempControlData.vehicle) or (tempControlData.targetPed and not DoesEntityExist(tempControlData.targetPed)) then
                    forceDriverTakeover()
                    break
                end
                Wait(250)
            end
        end)

    end)
end)


RegisterNetEvent("net.admin.stopVehicleControl", function()
    local ped = PlayerPedId()
    

    if tempControlData then
        TriggerServerEvent("net.admin.toggleDriverControl", tempControlData.targetSource, false)
    end

    if vehicleControlActive and tempControlData then
        local vehicle = tempControlData.vehicle
        
        if vehicle and DoesEntityExist(vehicle) and IsPedInVehicle(ped, vehicle, false) then
            if tempControlData.originalCoords then
                SetEntityCoordsNoOffset(ped, tempControlData.originalCoords.x, tempControlData.originalCoords.y, tempControlData.originalCoords.z, false, false, false)
                if tempControlData.originalHeading then
                    SetEntityHeading(ped, tempControlData.originalHeading)
                end
            else
                SetPedCoordsKeepVehicle(ped, GetEntityCoords(vehicle))
                TaskLeaveVehicle(ped, vehicle, 0)
                Wait(300)
                if IsPedInVehicle(ped, vehicle, false) then
                    ClearPedTasksImmediately(ped)
                    SetPedCoordsKeepVehicle(ped, GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.0, 0.0))
                    Wait(200)
                end
            end
        end
        
        if originalAdminModel then
            local currentModel = GetEntityModel(ped)
            if currentModel ~= originalAdminModel then
                RequestModel(originalAdminModel)
                while not HasModelLoaded(originalAdminModel) do
                    Wait(10)
                end
                SetPlayerModel(PlayerId(), originalAdminModel)
                ped = PlayerPedId()
                Wait(100)
            end
            
            if originalAdminAppearance then
                for i = 0, 20 do
                    if originalAdminAppearance[i] then
                        SetPedComponentVariation(ped, i, originalAdminAppearance[i][1], originalAdminAppearance[i][2], originalAdminAppearance[i][3])
                    end
                end
                for i = 0, 10 do
                    if originalAdminAppearance["p"..i] then
                        if originalAdminAppearance["p"..i][1] ~= -1 then
                            SetPedPropIndex(ped, i, originalAdminAppearance["p"..i][1], originalAdminAppearance["p"..i][2], true)
                        else
                            ClearPedProp(ped, i)
                        end
                    end
                end
            end
        end
        
        SetEntityInvincible(ped, false)
        SetPedCanRagdoll(ped, true)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, false)
        SetEntityAlpha(ped, 255, false)

        TriggerEvent("Notify2", "#vehicleControlStopped")
        
        originalAdminModel = nil
        originalAdminAppearance = {}
    end

    if tempControlData and DoesEntityExist(tempControlData.targetPed) then
        SetBlockingOfNonTemporaryEvents(tempControlData.targetPed, false)
        SetPedCanBeDraggedOut(tempControlData.targetPed, true)
        if tempControlData.seatShuffleFlag ~= nil then
            SetPedConfigFlag(tempControlData.targetPed, 184, tempControlData.seatShuffleFlag)
        end
    end

    vehicleControlActive = false
    controlledVehicle = nil
    targetPlayerId = nil
    tempControlData = nil
    controlThreadActive = false
    resetControlInputs()
end)


RegisterNetEvent("net.admin.driverControl", function(state)
    driverControlBlocked = state or false
    local ped = PlayerPedId()

    if driverControlBlocked then
        SetPedCanRagdoll(ped, false)
        
        local vehicle = nil
        if IsPedInAnyVehicle(ped, false) then
            vehicle = GetVehiclePedIsIn(ped, false)
        end
        
        if vehicle and DoesEntityExist(vehicle) then
            controlledVehicleEntity = vehicle
            
            SetEntityAlpha(ped, 0, false)
            SetEntityVisible(ped, false, false)
            SetEntityCollision(ped, false, false)
            Wait(100)
            
            if IsPedInVehicle(ped, vehicle, false) then
                SetPedCoordsKeepVehicle(ped, GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -1.5, 0.0))
                ClearPedTasksImmediately(ped)
                Wait(100)
                if IsPedInVehicle(ped, vehicle, false) then
                    SetPedIntoVehicle(ped, vehicle, 0)
                    Wait(50)
                    SetPedCoordsKeepVehicle(ped, GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -1.5, 0.0))
                    Wait(100)
                end
            end
            
            AttachEntityToEntity(ped, vehicle, -1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            
            if driverCam then
                RenderScriptCams(false, true, 500, true, true)
                DestroyCam(driverCam, false)
                driverCam = nil
            end
            
            driverCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamFov(driverCam, 70.0)
            RenderScriptCams(true, true, 500, true, true)
            
            driverCamThread = CreateThread(function()
                local lastCamPos = nil
                local lastCamRot = nil
                
                while driverControlBlocked and DoesEntityExist(vehicle) and driverCam do
                    if DoesEntityExist(vehicle) then
                        local vehicleSpeed = GetEntitySpeed(vehicle)
                        local speedFactor = math.min(vehicleSpeed * 0.1, 0.8)
                        
                        local distance = 5.0 + speedFactor
                        local height = 1.5 + (speedFactor * 0.5)
                        
                        local targetCamPos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -distance, height)
                        
                        local vehicleCoords = GetEntityCoords(vehicle)
                        local vehicleRot = GetEntityRotation(vehicle, 2)
                        
                        local camRotX = vehicleRot.x
                        local camRotY = vehicleRot.y
                        local camRotZ = vehicleRot.z
                        
                        local lerpSpeed = 0.12
                        local rotLerpSpeed = 0.18
                        
                        if lastCamPos then
                            local lerpedX = lastCamPos.x + (targetCamPos.x - lastCamPos.x) * lerpSpeed
                            local lerpedY = lastCamPos.y + (targetCamPos.y - lastCamPos.y) * lerpSpeed
                            local lerpedZ = lastCamPos.z + (targetCamPos.z - lastCamPos.z) * lerpSpeed
                            
                            SetCamCoord(driverCam, lerpedX, lerpedY, lerpedZ)
                            lastCamPos = vector3(lerpedX, lerpedY, lerpedZ)
                        else
                            SetCamCoord(driverCam, targetCamPos.x, targetCamPos.y, targetCamPos.z)
                            lastCamPos = targetCamPos
                        end
                        
                        if lastCamRot then
                            local function normalizeAngle(angle)
                                while angle > 180.0 do angle = angle - 360.0 end
                                while angle < -180.0 do angle = angle + 360.0 end
                                return angle
                            end
                            
                            local diffX = normalizeAngle(camRotX - lastCamRot.x)
                            local diffY = normalizeAngle(camRotY - lastCamRot.y)
                            local diffZ = normalizeAngle(camRotZ - lastCamRot.z)
                            
                            local lerpedRotX = lastCamRot.x + diffX * rotLerpSpeed
                            local lerpedRotY = lastCamRot.y + diffY * rotLerpSpeed
                            local lerpedRotZ = lastCamRot.z + diffZ * rotLerpSpeed
                            
                            SetCamRot(driverCam, lerpedRotX, lerpedRotY, lerpedRotZ, 2)
                            lastCamRot = vector3(lerpedRotX, lerpedRotY, lerpedRotZ)
                        else
                            SetCamRot(driverCam, camRotX, camRotY, camRotZ, 2)
                            lastCamRot = vector3(camRotX, camRotY, camRotZ)
                        end
                    end
                    Wait(0)
                end
                
                if driverCam then
                    RenderScriptCams(false, true, 500, true, true)
                    DestroyCam(driverCam, false)
                    driverCam = nil
                end
                driverCamThread = nil
            end)
        end
    else
        SetPedCanRagdoll(ped, true)
        
        if driverCam then
            RenderScriptCams(false, true, 500, true, true)
            DestroyCam(driverCam, false)
            driverCam = nil
        end
        driverCamThread = nil
        
        SetEntityVisible(ped, true, false)
        SetEntityAlpha(ped, 255, false)
        SetEntityCollision(ped, true, true)
        
        DetachEntity(ped, true, true)
        
        local vehicle = controlledVehicleEntity
        if not vehicle or not DoesEntityExist(vehicle) then
            vehicle = GetEntityAttachedTo(ped)
            if not vehicle or not DoesEntityExist(vehicle) or not IsEntityAVehicle(vehicle) then
                vehicle = nil
            end
        end
        
        if vehicle and DoesEntityExist(vehicle) then
            SetPedIntoVehicle(ped, vehicle, -1)
            Wait(200)
            if not IsPedInVehicle(ped, vehicle, false) then
                TaskWarpPedIntoVehicle(ped, vehicle, -1)
                Wait(200)
                if not IsPedInVehicle(ped, vehicle, false) then
                    SetPedIntoVehicle(ped, vehicle, -1)
                end
            end
        end
        
        controlledVehicleEntity = nil
    end
end)

CreateThread(function()
    while true do
        if driverControlBlocked then
            DisableControlAction(0, 71, true)
            DisableControlAction(0, 72, true)
            DisableControlAction(0, 63, true)
            DisableControlAction(0, 64, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 76, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 59, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)


RegisterCommand("pararcontrole", function()
    if vehicleControlActive or tempControlData then
        local targetSource = targetPlayerId
        if not targetSource and tempControlData then
            targetSource = tempControlData.targetSource
        end

        TriggerServerEvent("net.admin.stopVehicleControl", targetSource)

    else
        TriggerEvent("Notify2", "#noVehicleControl")
    end
end)