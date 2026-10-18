local MRIConfig = SandyHospitalMriConfig
if not MRIConfig or not lib then
    return
end

local hasOxTarget = GetResourceState("ox_target") == "started"
local bedModel = joaat(MRIConfig.bedModel)
local mapBedEntity = nil
local localBedEntity = nil
local isPatient = false
local patientBedEntity = nil
local activePatientServerId = nil
local scanLightActive = false
local bedMovementId = 0
local observerPoint = nil

local function findBedNear(coords)
    local nearest = nil
    local nearestDistance = nil

    for _, obj in pairs(lib.getNearbyObjects(coords, 5.0)) do
        local entity = obj.object
        if entity ~= localBedEntity and GetEntityModel(entity) == bedModel then
            local distance = #(GetEntityCoords(entity) - coords)
            if not nearestDistance or distance < nearestDistance then
                nearest = entity
                nearestDistance = distance
            end
        end
    end

    return nearest
end

local function getMapBedEntity()
    if mapBedEntity and mapBedEntity ~= localBedEntity and DoesEntityExist(mapBedEntity) then
        return mapBedEntity
    end

    mapBedEntity = findBedNear(MRIConfig.bedOutsideCoords) or findBedNear(MRIConfig.bedInsideCoords)
    return mapBedEntity
end

local function setMapBedVisible(visible)
    local entity = getMapBedEntity()
    if not entity then
        return
    end

    SetEntityVisible(entity, visible, 0)
    SetEntityCollision(entity, visible, visible)
    SetEntityAlpha(entity, visible and 255 or 0, false)
end

local function loadBedModel()
    if HasModelLoaded(bedModel) then
        return true
    end

    RequestModel(bedModel)

    local timeoutAt = GetGameTimer() + 5000
    while not HasModelLoaded(bedModel) and GetGameTimer() < timeoutAt do
        Wait(50)
    end

    if HasModelLoaded(bedModel) then
        return true
    end

    print("[player:sandyHospitalMri] Failed to load MRI bed model")
    return false
end

local function prepareLocalBed(entity)
    SetEntityAsMissionEntity(entity, true, true)
    SetEntityDynamic(entity, true)
    ActivatePhysics(entity)
    SetEntityVisible(entity, true, 0)
    SetEntityCollision(entity, true, true)
    SetEntityAlpha(entity, 255, false)
    SetEntityLoadCollisionFlag(entity, true)
end

local function deleteLocalBed()
    if localBedEntity and DoesEntityExist(localBedEntity) then
        SetEntityAsMissionEntity(localBedEntity, true, true)
        DeleteEntity(localBedEntity)
    end

    localBedEntity = nil
    patientBedEntity = nil
end

local function placeLocalBed(coords)
    local entity = localBedEntity

    if not entity or not DoesEntityExist(entity) then
        if not loadBedModel() then
            return nil
        end

        entity = CreateObjectNoOffset(bedModel, coords.x, coords.y, coords.z, false, false, false)
        if not entity or entity == 0 then
            print("[player:sandyHospitalMri] Failed to create local MRI bed")
            SetModelAsNoLongerNeeded(bedModel)
            return nil
        end

        localBedEntity = entity
        SetModelAsNoLongerNeeded(bedModel)
    end

    setMapBedVisible(false)
    prepareLocalBed(entity)

    if not DoesEntityExist(entity) then
        return nil
    end

    FreezeEntityPosition(entity, false)
    SetEntityCoordsNoOffset(entity, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(entity, MRIConfig.bedHeading)
    FreezeEntityPosition(entity, true)

    return entity
end

local function getPatientPose(bedEntity)
    local off = MRIConfig.patientOffset
    local coords = GetOffsetFromEntityInWorldCoords(bedEntity, off.x, off.y, off.z)
    local heading = (GetEntityHeading(bedEntity) + MRIConfig.patientRotation.z) % 360.0

    return coords, heading
end

local function getRemotePatientPed()
    if not activePatientServerId or activePatientServerId == GetPlayerServerId(PlayerId()) then
        return nil
    end

    local player = GetPlayerFromServerId(activePatientServerId)
    if player == -1 then
        return nil
    end

    local ped = GetPlayerPed(player)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return nil
    end

    return ped
end

local function positionPatientOnBed(bedEntity)
    if not isPatient or not bedEntity or not DoesEntityExist(bedEntity) then
        return
    end

    local ped = cache.ped or PlayerPedId()
    local coords, heading = getPatientPose(bedEntity)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading)
    SetEntityVelocity(ped, 0.0, 0.0, 0.0)
end

local function positionRemotePatientOnBed(bedEntity)
    if not bedEntity or not DoesEntityExist(bedEntity) then
        return
    end

    local ped = getRemotePatientPed()
    if not ped then
        return
    end

    local coords, heading = getPatientPose(bedEntity)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading)
end

local function movePatientWithBed(bedEntity)
    if not isPatient or not bedEntity or not DoesEntityExist(bedEntity) then
        return
    end

    local ped = cache.ped or PlayerPedId()
    local coords, heading = getPatientPose(bedEntity)
    local pedCoords = GetEntityCoords(ped)
    local frameTime = math.max(GetFrameTime(), 0.016)
    local velocity = vector3(
        (coords.x - pedCoords.x) / frameTime,
        (coords.y - pedCoords.y) / frameTime,
        (coords.z - pedCoords.z) / frameTime
    )
    local speed = #velocity
    local maxSpeed = 2.0

    if speed > maxSpeed then
        velocity = velocity * (maxSpeed / speed)
    end

    SetEntityHeading(ped, heading)
    SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
end

local function playPatientAnimation()
    local ped = cache.ped or PlayerPedId()
    local anim = MRIConfig.patientAnim

    if IsEntityPlayingAnim(ped, anim.dict, anim.name, 3) then
        return
    end

    TaskPlayAnim(ped, anim.dict, anim.name, 8.0, -8.0, -1, 1, 0, false, false, false)
end

local function restoreMapBed()
    bedMovementId = bedMovementId + 1
    deleteLocalBed()
    setMapBedVisible(true)
    patientBedEntity = nil
    activePatientServerId = nil
end

RegisterNetEvent("player:sandyHospitalMri:createBed", function(coords, patientServerId)
    activePatientServerId = patientServerId

    local entity = placeLocalBed(coords or MRIConfig.bedOutsideCoords)
    if not isPatient then
        positionRemotePatientOnBed(entity)
    end
end)

local function moveLocalBed(fromCoords, toCoords, duration, movementId)
    CreateThread(function()
        local entity = placeLocalBed(fromCoords)
        if not entity then
            return
        end

        if isPatient then
            patientBedEntity = entity
            positionPatientOnBed(entity)
        end

        FreezeEntityPosition(entity, false)

        local startMs = GetGameTimer()
        while bedMovementId == movementId and DoesEntityExist(entity) do
            local elapsed = GetGameTimer() - startMs
            local progress = math.min(elapsed / duration, 1.0)
            local eased = progress * progress * (3.0 - 2.0 * progress)

            local x = fromCoords.x + (toCoords.x - fromCoords.x) * eased
            local y = fromCoords.y + (toCoords.y - fromCoords.y) * eased
            local z = fromCoords.z + (toCoords.z - fromCoords.z) * eased

            SetEntityCoordsNoOffset(entity, x, y, z, false, false, false)
            SetEntityHeading(entity, MRIConfig.bedHeading)

            if isPatient then
                movePatientWithBed(entity)
                playPatientAnimation()
            else
                positionRemotePatientOnBed(entity)
            end

            if progress >= 1.0 then
                break
            end

            Wait(0)
        end

        if bedMovementId == movementId and DoesEntityExist(entity) then
            SetEntityCoordsNoOffset(entity, toCoords.x, toCoords.y, toCoords.z, false, false, false)
            SetEntityHeading(entity, MRIConfig.bedHeading)
            FreezeEntityPosition(entity, true)

            if isPatient then
                positionPatientOnBed(entity)
                playPatientAnimation()
            else
                positionRemotePatientOnBed(entity)
            end
        end
    end)
end

RegisterNetEvent("player:sandyHospitalMri:moveBedLocal", function(fromCoords, toCoords, duration, movementId, patientServerId)
    activePatientServerId = patientServerId or activePatientServerId
    bedMovementId = movementId
    moveLocalBed(fromCoords, toCoords, duration, movementId)
end)

RegisterNetEvent("player:sandyHospitalMri:cleanupBed", function()
    restoreMapBed()
end)

local function startScanLight(duration)
    if scanLightActive then
        return
    end

    scanLightActive = true

    CreateThread(function()
        local scanLight = MRIConfig.scanLight
        local coords = scanLight.coords
        local color = scanLight.color
        local startMs = GetGameTimer()

        while scanLightActive and (GetGameTimer() - startMs) < duration do
            local elapsed = (GetGameTimer() - startMs) / 1000.0
            local pulse = (math.sin(elapsed * scanLight.flashHz * 2.0 * math.pi) + 1.0) / 2.0
            local flicker = 1.0

            if math.random() < 0.15 then
                flicker = 0.3 + math.random() * 0.4
            end

            local intensity = scanLight.intensity * pulse * flicker
            if intensity > 0.05 then
                DrawLightWithRange(coords.x, coords.y, coords.z, color.r, color.g, color.b, scanLight.range, intensity)
            end

            Wait(0)
        end

        scanLightActive = false
    end)
end

RegisterNetEvent("player:sandyHospitalMri:scanLightStart", function(duration)
    startScanLight(duration)
end)

RegisterNetEvent("player:sandyHospitalMri:scanLightStop", function()
    scanLightActive = false
end)

RegisterNetEvent("player:sandyHospitalMri:scanProgress", function(duration)
    if not lib.progressCircle then
        return
    end

    lib.progressCircle({
        duration = duration,
        label = MRIConfig.messages.scanInProgress,
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
    })
end)

RegisterNetEvent("player:sandyHospitalMri:scanDone", function()
    lib.notify({
        title = MRIConfig.messages.menuTitle,
        description = MRIConfig.messages.scanComplete,
        type = "success",
    })
end)

local function detachPatient()
    if not isPatient then
        return
    end

    isPatient = false

    local ped = cache.ped or PlayerPedId()
    ClearPedTasks(ped)
    SetPedCanRagdoll(ped, true)
    patientBedEntity = nil
end

local function patientGetUp()
    if not isPatient then
        return
    end

    detachPatient()
    lib.callback.await("player:sandyHospitalMri:getUp", false)
end

local function abortLieDown()
    lib.callback.await("player:sandyHospitalMri:abortLieDown", false)
    lib.notify({
        title = MRIConfig.messages.menuTitle,
        description = "MRI bed not found - please try again.",
        type = "error",
    })
end

local function doLieDown()
    if isPatient then
        return false
    end

    local ok = lib.callback.await("player:sandyHospitalMri:lieDown", false)
    if not ok then
        return false
    end

    local bedEntity = placeLocalBed(MRIConfig.bedOutsideCoords)
    if not bedEntity then
        abortLieDown()
        return false
    end

    isPatient = true
    activePatientServerId = GetPlayerServerId(PlayerId())
    patientBedEntity = bedEntity

    local ped = cache.ped or PlayerPedId()
    lib.requestAnimDict(MRIConfig.patientAnim.dict)

    SetPedCanRagdoll(ped, false)
    positionPatientOnBed(bedEntity)
    Wait(100)
    playPatientAnimation()

    return true
end

local function patientLieDown()
    if not doLieDown() then
        lib.notify({
            title = MRIConfig.messages.menuTitle,
            description = MRIConfig.messages.alreadyInUse,
            type = "error",
        })
        return
    end

    lib.showTextUI(MRIConfig.messages.getUpHint)

    while isPatient do
        playPatientAnimation()

        DisableControlAction(0, 32, true)
        DisableControlAction(0, 33, true)
        DisableControlAction(0, 34, true)
        DisableControlAction(0, 35, true)
        DisableControlAction(0, 22, true)
        DisableControlAction(0, 36, true)

        if IsControlJustPressed(0, 194) or IsControlJustPressed(0, 177) then
            patientGetUp()
            break
        end

        Wait(0)
    end

    lib.hideTextUI()
    RemoveAnimDict(MRIConfig.patientAnim.dict)
end

RegisterNetEvent("player:sandyHospitalMri:forceGetUp", function()
    if not isPatient then
        return
    end

    if lib.cancelProgress then
        lib.cancelProgress()
    end

    detachPatient()
end)

RegisterNetEvent("player:sandyHospitalMri:runTest", function()
    CreateThread(function()
        lib.notify({ title = "MRI Test", description = "Starting automated MRI test...", type = "info" })

        if not doLieDown() then
            lib.notify({ title = "MRI Test", description = "Failed to lie down.", type = "error" })
            return
        end

        Wait(1500)

        lib.notify({ title = "MRI Test", description = "Moving bed inside...", type = "info" })
        if not lib.callback.await("player:sandyHospitalMri:moveBed", false, "inside") then
            lib.notify({ title = "MRI Test", description = "Failed to move bed inside.", type = "error" })
            patientGetUp()
            return
        end

        Wait(MRIConfig.slideDuration + 1000)

        lib.notify({ title = "MRI Test", description = "Starting scan...", type = "info" })
        if not lib.callback.await("player:sandyHospitalMri:startScan", false) then
            lib.notify({ title = "MRI Test", description = "Failed to start scan.", type = "error" })
            patientGetUp()
            return
        end

        Wait(MRIConfig.scanDuration + 1500)

        lib.notify({ title = "MRI Test", description = "Moving bed outside...", type = "info" })
        lib.callback.await("player:sandyHospitalMri:moveBed", false, "outside")
        Wait(MRIConfig.slideDuration + 1000)

        lib.notify({ title = "MRI Test", description = "Test complete.", type = "success" })
        patientGetUp()
        RemoveAnimDict(MRIConfig.patientAnim.dict)
    end)
end)

local function openOperatorMenu()
    local state = lib.callback.await("player:sandyHospitalMri:getState", false)
    if not state then
        lib.notify({
            title = MRIConfig.messages.menuTitle,
            description = MRIConfig.messages.accessDenied,
            type = "error",
        })
        return
    end

    local options = {}

    if state.hasPatient and state.bedPosition == "outside" and not state.scanning then
        options[#options + 1] = {
            title = MRIConfig.messages.moveInside,
            icon = "arrow-right",
            onSelect = function()
                local ok = lib.callback.await("player:sandyHospitalMri:moveBed", false, "inside")
                if not ok then
                    lib.notify({ title = MRIConfig.messages.menuTitle, description = MRIConfig.messages.bedMoving, type = "error" })
                end
            end,
        }
    end

    if state.hasPatient and state.bedPosition == "inside" and not state.scanning then
        options[#options + 1] = {
            title = MRIConfig.messages.startScan,
            icon = "brain",
            onSelect = function()
                local ok = lib.callback.await("player:sandyHospitalMri:startScan", false)
                if not ok then
                    lib.notify({ title = MRIConfig.messages.menuTitle, description = MRIConfig.messages.scanInProgress, type = "error" })
                end
            end,
        }
        options[#options + 1] = {
            title = MRIConfig.messages.moveOutside,
            icon = "arrow-left",
            onSelect = function()
                local ok = lib.callback.await("player:sandyHospitalMri:moveBed", false, "outside")
                if not ok then
                    lib.notify({ title = MRIConfig.messages.menuTitle, description = MRIConfig.messages.bedMoving, type = "error" })
                end
            end,
        }
    end

    if state.hasPatient then
        options[#options + 1] = {
            title = MRIConfig.messages.releasePatient,
            icon = "person-walking-arrow-right",
            onSelect = function()
                lib.callback.await("player:sandyHospitalMri:releasePatient", false)
            end,
        }
    end

    if #options == 0 then
        local title = MRIConfig.messages.noPatient
        if state.scanning then
            title = MRIConfig.messages.scanInProgress
        elseif state.bedPosition == "moving" then
            title = MRIConfig.messages.bedMoving
        end

        options[#options + 1] = {
            title = title,
            icon = "circle-info",
            disabled = true,
        }
    end

    lib.registerContext({
        id = "sandy_hospital_mri_operator_menu",
        title = MRIConfig.messages.menuTitle,
        options = options,
    })
    lib.showContext("sandy_hospital_mri_operator_menu")
end

local function shouldUseOxTarget()
    if MRIConfig.interaction == "ox_target" then
        return true
    end
    if MRIConfig.interaction == "textui" then
        return false
    end
    return hasOxTarget
end

local function setupMRIInteractions()
    if shouldUseOxTarget() then
        exports.ox_target:addBoxZone({
            coords = MRIConfig.patientInteractCoords,
            size = MRIConfig.patientInteractSize,
            rotation = MRIConfig.bedHeading,
            debug = false,
            options = {
                {
                    name = "sandy_hospital_mri_patient_liedown",
                    icon = "fas fa-bed",
                    label = MRIConfig.messages.patientPrompt,
                    onSelect = patientLieDown,
                },
            },
        })

        exports.ox_target:addBoxZone({
            coords = MRIConfig.operatorInteractCoords,
            size = MRIConfig.operatorInteractSize,
            rotation = MRIConfig.operatorInteractHeading or MRIConfig.bedHeading,
            debug = false,
            options = {
                {
                    name = "sandy_hospital_mri_operator_controls",
                    icon = "fas fa-desktop",
                    label = MRIConfig.messages.operatorPrompt,
                    onSelect = openOperatorMenu,
                },
            },
        })
        return
    end

    local patientUIShown = false
    local operatorUIShown = false

    lib.zones.box({
        coords = MRIConfig.patientInteractCoords,
        size = MRIConfig.patientInteractSize,
        rotation = MRIConfig.bedHeading,

        onEnter = function()
            if not isPatient then
                lib.showTextUI("[E] " .. MRIConfig.messages.patientPrompt)
                patientUIShown = true
            end
        end,
        onExit = function()
            if patientUIShown then
                lib.hideTextUI()
                patientUIShown = false
            end
        end,
        inside = function()
            if not isPatient and IsControlJustPressed(0, 38) then
                if patientUIShown then
                    lib.hideTextUI()
                    patientUIShown = false
                end
                patientLieDown()
            end
        end,
    })

    lib.zones.box({
        coords = MRIConfig.operatorInteractCoords,
        size = MRIConfig.operatorInteractSize,
        rotation = MRIConfig.operatorInteractHeading or MRIConfig.bedHeading,

        onEnter = function()
            lib.showTextUI("[E] " .. MRIConfig.messages.operatorPrompt)
            operatorUIShown = true
        end,
        onExit = function()
            if operatorUIShown then
                lib.hideTextUI()
                operatorUIShown = false
            end
        end,
        inside = function()
            if IsControlJustPressed(0, 38) then
                openOperatorMenu()
            end
        end,
    })
end

local function setupObserverSync()
    observerPoint = lib.points.new({
        coords = MRIConfig.observerCoords or MRIConfig.patientInteractCoords,
        distance = MRIConfig.observerRadius or 60.0,

        onEnter = function()
            lib.callback.await("player:sandyHospitalMri:sync", false)
        end,
    })
end

setupMRIInteractions()
setupObserverSync()

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    scanLightActive = false
    detachPatient()
    restoreMapBed()

    if observerPoint then
        observerPoint:remove()
        observerPoint = nil
    end
end)
