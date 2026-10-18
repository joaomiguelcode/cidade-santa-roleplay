local ESCAPE_CLONE_ENTITY_TIMEOUT_MS = 5000
local ESCAPE_CLONE_CONTROL_TIMEOUT_MS = 3000
local ESCAPE_CLONE_MIN_CRUISE_SPEED = 200.0

local gPendingEscapeCloneRequestId = nil

---@param vehicle number
---@return table
local function CollectVehicleData(vehicle)

    local modelHash = GetEntityModel(vehicle)
    local modelName = GetEntityArchetypeName(vehicle)
    local data = {
        model = modelName or tostring(modelHash),
        modelHash = modelHash,
        speed = GetEntitySpeed(vehicle),
        colours = { GetVehicleColours(vehicle) },
        extraColours = { GetVehicleExtraColours(vehicle) },
        dashboardColor = GetVehicleDashboardColour(vehicle),
        interiorColor = GetVehicleInteriorColour(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        wheelType = GetVehicleWheelType(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        neons = {},
        mods = {},
        modVariations = {},
        toggles = {},
        extras = {},
        windows = {},
        tyres = {},
    }

    if GetIsVehiclePrimaryColourCustom(vehicle) then
        local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
        data.customPrimaryColour = { r, g, b }
    end

    if GetIsVehicleSecondaryColourCustom(vehicle) then
        local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
        data.customSecondaryColour = { r, g, b }
    end

    for index = 0, 3 do
        data.neons[index] = IsVehicleNeonLightEnabled(vehicle, index)
    end

    local r, g, b = GetVehicleNeonLightsColour(vehicle)
    data.neonColour = { r, g, b }

    if IsToggleModOn(vehicle, 20) then
        local smokeR, smokeG, smokeB = GetVehicleTyreSmokeColor(vehicle)
        data.tyreSmoke = { enabled = true, smokeR, smokeG, smokeB }
    end

    for modType = 0, 49 do
        local modValue = GetVehicleMod(vehicle, modType)

        if modValue ~= -1 then
            data.mods[modType] = modValue
            data.modVariations[modType] = GetVehicleModVariation(vehicle, modType)
        end
    end

    for toggle = 17, 22 do
        data.toggles[toggle] = IsToggleModOn(vehicle, toggle)
    end

    for extraId = 0, 14 do
        if DoesExtraExist(vehicle, extraId) then
            data.extras[extraId] = IsVehicleExtraTurnedOn(vehicle, extraId)
        end
    end

    local livery = GetVehicleLivery(vehicle)
    if livery and livery >= 0 then
        data.livery = livery
    end

    local roofLivery = GetVehicleRoofLivery(vehicle)
    if roofLivery and roofLivery >= 0 then
        data.roofLivery = roofLivery
    end

    for doorIndex = 0, 5 do
        if IsVehicleDoorDamaged(vehicle, doorIndex) then
            data.windows[tostring(doorIndex)] = true
        end
    end

    for tyreIndex = 0, 3 do
        if IsVehicleTyreBurst(vehicle, tyreIndex, false) or IsVehicleTyreBurst(vehicle, tyreIndex, true) then
            data.tyres[tostring(tyreIndex)] = true
        end
    end

    return data
end

---@param netId number
---@param resolve fun(netId: number): number
---@return number | nil
local function AwaitNetworkEntity(netId, resolve)

    local timeoutAt = GetGameTimer() + ESCAPE_CLONE_ENTITY_TIMEOUT_MS
    local entity = resolve(netId)

    while (not entity or entity == 0 or not DoesEntityExist(entity)) and GetGameTimer() < timeoutAt do
        Wait(50)
        entity = resolve(netId)
    end

    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return nil
    end

    return entity
end

---@param entity number
---@return boolean
local function RequestEntityControl(entity)

    local timeoutAt = GetGameTimer() + ESCAPE_CLONE_CONTROL_TIMEOUT_MS

    while DoesEntityExist(entity) and not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeoutAt do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end

    return DoesEntityExist(entity) and NetworkHasControlOfEntity(entity)
end

---@param sourcePed number
---@param targetPed number
---@return boolean
local function CopyPedAppearance(sourcePed, targetPed)

    if not DoesEntityExist(sourcePed) or not DoesEntityExist(targetPed) then
        return false
    end

    ClonePedToTarget(sourcePed, targetPed)
    Wait(100)

    for componentId = 0, 11 do
        SetPedComponentVariation(
            targetPed,
            componentId,
            GetPedDrawableVariation(sourcePed, componentId),
            GetPedTextureVariation(sourcePed, componentId),
            GetPedPaletteVariation(sourcePed, componentId)
        )
    end

    for propId = 0, 10 do
        local propIndex = GetPedPropIndex(sourcePed, propId)

        if propIndex >= 0 then
            SetPedPropIndex(targetPed, propId, propIndex, GetPedPropTextureIndex(sourcePed, propId), true)
        else
            ClearPedProp(targetPed, propId)
        end
    end

    SetPedEyeColor(targetPed, GetPedEyeColor(sourcePed))
    SetPedHairColor(targetPed, GetPedHairColor(sourcePed), GetPedHairHighlightColor(sourcePed))

    return true
end

---@param data table
---@return boolean
local function ConfigureEscapeClone(data)

    if type(data) ~= "table" or type(data.vehicleNet) ~= "number" or type(data.pedNet) ~= "number" then
        return false
    end

    local vehicle = AwaitNetworkEntity(data.vehicleNet, NetToVeh)
    local ped = AwaitNetworkEntity(data.pedNet, NetToPed)
    if not vehicle or not ped then
        return false
    end

    if not RequestEntityControl(vehicle) or not RequestEntityControl(ped) then
        return false
    end

    local sourcePed = PlayerPedId()
    if not DoesEntityExist(sourcePed) or not CopyPedAppearance(sourcePed, ped) then
        return false
    end

    SetEntityAsMissionEntity(vehicle, true, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetPedIntoVehicle(ped, vehicle, -1)
    Wait(0)

    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        Wait(100)
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        return false
    end

    local cruiseSpeed = math.max(tonumber(data.initialSpeed) or 0.0, ESCAPE_CLONE_MIN_CRUISE_SPEED)
    SetPedKeepTask(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanBeDraggedOut(ped, false)
    SetPedCanRagdoll(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 17, false)
    SetPedCombatAttributes(ped, 5, false)
    SetPedSteersAroundPeds(ped, false)
    SetPedSteersAroundVehicles(ped, false)
    SetPedSteersAroundObjects(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedConfigFlag(ped, 281, true)
    SetPedConfigFlag(ped, 2, false)
    SetPedConfigFlag(ped, 122, false)
    TaskVehicleDriveWander(ped, vehicle, cruiseSpeed, 786468)
    SetDriveTaskDrivingStyle(ped, 786468)
    SetDriveTaskCruiseSpeed(ped, cruiseSpeed)
    SetDriveTaskMaxCruiseSpeed(ped, cruiseSpeed)
    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, 1.0)

    return true
end

RegisterNetEvent("net.admin.prepareEscapeClone", function(requestId)

    if gPendingEscapeCloneRequestId then
        TriggerServerEvent("net.admin.cancelEscapeCloneRequest", requestId)
        return
    end

    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) then
        TriggerEvent("Notify2", "#fakeCarNoVehicle")
        TriggerServerEvent("net.admin.cancelEscapeCloneRequest", requestId)
        return
    end

    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    if GetPedInVehicleSeat(playerVehicle, -1) ~= playerPed then
        TriggerEvent("Notify2", "#fakeCarNotDriver")
        TriggerServerEvent("net.admin.cancelEscapeCloneRequest", requestId)
        return
    end

    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerVehicle, 0.0, 20.0, 0.0)
    local foundGround, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z + 1.0, true)
    if foundGround then
        spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ + 0.3)
    end

    gPendingEscapeCloneRequestId = requestId
    TriggerServerEvent("net.admin.createEscapeClone", requestId, {
        spawn = {
            x = spawnCoords.x,
            y = spawnCoords.y,
            z = spawnCoords.z,
            heading = GetEntityHeading(playerVehicle),
        },
        vehicle = CollectVehicleData(playerVehicle),
    })
end)

RegisterNetEvent("net.admin.configureEscapeClone", function(requestId, data)

    if gPendingEscapeCloneRequestId ~= requestId then
        return
    end

    local configured = ConfigureEscapeClone(data)
    gPendingEscapeCloneRequestId = nil

    if configured then
        TriggerServerEvent("net.admin.escapeCloneConfigured", requestId)
        return
    end

    TriggerServerEvent("net.admin.escapeCloneConfigurationFailed", requestId)
end)

RegisterNetEvent("net.admin.escapeCloneFailed", function(requestId)

    if gPendingEscapeCloneRequestId == requestId then
        gPendingEscapeCloneRequestId = nil
    end
end)

AddEventHandler("onResourceStop", function(resourceName)

    if resourceName == GetCurrentResourceName() and gPendingEscapeCloneRequestId then
        TriggerServerEvent("net.admin.cancelEscapeCloneRequest", gPendingEscapeCloneRequestId)
    end
end)
