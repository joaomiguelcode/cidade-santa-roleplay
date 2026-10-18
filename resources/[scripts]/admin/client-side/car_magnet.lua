local active = false
local range = 20.0
local collisionEnabled = true
local running = false

local defaultRange = 20.0
local maxRange = 50.0
local maxVehicles = 6
local holdDistance = 5.0
local minSpeed = 3.0
local maxSpeed = 38.0
local holdSpeed = 2.5
local minBlend = 0.12
local maxBlend = 0.42
local holdBlend = 0.28
local pullTickMs = 16
local idleTickMs = 400
local controlDelayMs = 450
local proximityBuffer = 30.0
local rollStrengthMin = 0.6
local rollStrengthMax = 1.8
local rollJitterMs = 260
local rollSpeedScale = 16.0

local holdOffsets = {
    { 0.0, -4.5, 0.45 },
    { 0.0, -8.5, 0.65 },
    { 0.0, -12.5, 0.85 },
    { -3.0, -4.5, 0.45 },
    { 3.0, -4.5, 0.45 },
    { 0.0, -16.5, 1.05 },
}

local magnetSignals = {}
local simulatedVehicles = {}
local controlLastTick = {}
local collisionTargetsBySource = {}

local function setVehicleGhost(vehicle, enabled)
    if not vehicle or not DoesEntityExist(vehicle) then
        return
    end

    SetNetworkVehicleAsGhost(vehicle, enabled)
end

local function setPairCollision(vehicleA, vehicleB, disableCollision)
    if not vehicleA or not vehicleB or vehicleA == vehicleB then
        return
    end

    if not DoesEntityExist(vehicleA) or not DoesEntityExist(vehicleB) then
        return
    end

    SetEntityNoCollisionEntity(vehicleA, vehicleB, disableCollision)
    SetEntityNoCollisionEntity(vehicleB, vehicleA, disableCollision)
end

local function getVehicleFromNetId(netId)
    if not netId or netId == 0 or not NetworkDoesNetworkIdExist(netId) then
        return nil
    end

    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        return vehicle
    end

    return nil
end

local function isLocalDriver(vehicle)
    local ped = PlayerPedId()

    return IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) == vehicle and GetPedInVehicleSeat(vehicle, -1) == ped
end

local function vehicleHasHumanDriver(vehicle)
    local driverPed = GetPedInVehicleSeat(vehicle, -1)

    return driverPed ~= 0 and DoesEntityExist(driverPed) and IsPedAPlayer(driverPed)
end

local function tryControl(vehicle, netId)
    if NetworkHasControlOfEntity(vehicle) then
        return true
    end

    local now = GetGameTimer()
    local lastTick = controlLastTick[netId] or 0

    if (now - lastTick) < controlDelayMs then
        return false
    end

    controlLastTick[netId] = now
    NetworkRequestControlOfEntity(vehicle)

    return NetworkHasControlOfEntity(vehicle)
end

local function canSimulateVehicle(vehicle, magnetSourceId)
    if not DoesEntityExist(vehicle) then
        return false
    end

    if isLocalDriver(vehicle) then
        return true
    end

    if NetworkHasControlOfEntity(vehicle) then
        return true
    end

    local mySource = GetPlayerServerId(PlayerId())

    if magnetSourceId == mySource and not vehicleHasHumanDriver(vehicle) then
        return tryControl(vehicle, VehToNet(vehicle))
    end

    return false
end

local function setVehicleDamage(vehicle, enabled, sourceId)
    if not vehicle or not DoesEntityExist(vehicle) then
        return
    end

    if canSimulateVehicle(vehicle, sourceId) then
        SetEntityCanBeDamaged(vehicle, enabled)
    end
end

local function restoreCollisionTarget(vehicle, sourceId)
    if not vehicle or not DoesEntityExist(vehicle) then
        return
    end

    setVehicleGhost(vehicle, false)
    setVehicleDamage(vehicle, true, sourceId)
end

local function applyPulledVehicleCollisions(targetVehicles, collisionOn, sourceId)
    for i = 1, #targetVehicles do
        local vehicle = targetVehicles[i]

        setVehicleGhost(vehicle, not collisionOn)
        setVehicleDamage(vehicle, collisionOn, sourceId)
    end

    for i = 1, #targetVehicles do
        for j = i + 1, #targetVehicles do
            setPairCollision(targetVehicles[i], targetVehicles[j], not collisionOn)
        end
    end
end

local function clearCollisionGroup(sourceId)
    local previous = collisionTargetsBySource[sourceId]

    if not previous then
        return
    end

    for netId, vehicle in pairs(previous) do
        for otherNetId, otherVehicle in pairs(previous) do
            if netId ~= otherNetId then
                setPairCollision(vehicle, otherVehicle, false)
            end
        end

        restoreCollisionTarget(vehicle, sourceId)
    end

    collisionTargetsBySource[sourceId] = nil
end

local function syncMagnetCollisionGroup(sourceId, targets, collisionOn)
    local previous = collisionTargetsBySource[sourceId] or {}
    local current = {}

    for i = 1, #targets do
        local vehicle = targets[i]
        local netId = VehToNet(vehicle)

        if netId ~= 0 then
            current[netId] = vehicle
        end
    end

    for netId, vehicle in pairs(previous) do
        if not current[netId] then
            for otherNetId, otherVehicle in pairs(previous) do
                if netId ~= otherNetId then
                    setPairCollision(vehicle, otherVehicle, false)
                end
            end

            restoreCollisionTarget(vehicle, sourceId)
        end
    end

    local targetList = {}

    for _, vehicle in pairs(current) do
        targetList[#targetList + 1] = vehicle
    end

    applyPulledVehicleCollisions(targetList, collisionOn, sourceId)
    collisionTargetsBySource[sourceId] = current
end

local function applyZeroGrav(vehicle)
    SetEntityHasGravity(vehicle, false)

    if SetVehicleGravityAmount then
        SetVehicleGravityAmount(vehicle, 0.0)
    end
end

local function restoreVehiclePhysics(vehicle, sourceId)
    if not vehicle or not DoesEntityExist(vehicle) then
        return
    end

    if SetEntityAngularVelocity then
        SetEntityAngularVelocity(vehicle, 0.0, 0.0, 0.0)
    end

    setVehicleGhost(vehicle, false)

    if sourceId then
        setVehicleDamage(vehicle, true, sourceId)
    end

    SetEntityHasGravity(vehicle, true)

    if SetVehicleGravityAmount then
        SetVehicleGravityAmount(vehicle, 9.81)
    end
end

local function randomSigned(maxAbs)
    return (math.random() * 2.0 - 1.0) * maxAbs
end

local function clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value))
end

local function createRollProfile()
    return {
        pitch = randomSigned(1.0),
        roll = randomSigned(1.0),
        yaw = randomSigned(0.25),
        strength = rollStrengthMin + math.random() * (rollStrengthMax - rollStrengthMin),
        nextJitterAt = 0,
    }
end

local function refreshRollProfile(profile)
    local now = GetGameTimer()

    if now < profile.nextJitterAt then
        return
    end

    profile.nextJitterAt = now + rollJitterMs
    profile.pitch = clamp(profile.pitch + randomSigned(0.45), -1.0, 1.0)
    profile.roll = clamp(profile.roll + randomSigned(0.45), -1.0, 1.0)
    profile.yaw = clamp(profile.yaw + randomSigned(0.2), -0.5, 0.5)
end

local function applyAirRoll(vehicle, rollProfile, speed)
    if not rollProfile or not SetEntityAngularVelocity then
        return
    end

    refreshRollProfile(rollProfile)

    local speedFactor = math.min(1.0, speed / rollSpeedScale)
    local strength = rollProfile.strength * (0.35 + speedFactor * 0.65)

    SetEntityAngularVelocity(
        vehicle,
        rollProfile.pitch * strength,
        rollProfile.roll * strength,
        rollProfile.yaw * strength * 0.4
    )
end

local function stopSimulation(netId)
    netId = tonumber(netId)

    if not netId then
        return
    end

    local data = simulatedVehicles[netId]

    if not data then
        return
    end

    if data.vehicle and DoesEntityExist(data.vehicle) then
        restoreVehiclePhysics(data.vehicle, data.sourceId)
    end

    simulatedVehicles[netId] = nil
    controlLastTick[netId] = nil
end

local function stopSimulationsForSource(sourceId)
    for netId, data in pairs(simulatedVehicles) do
        if data.sourceId == sourceId then
            stopSimulation(netId)
        end
    end

    clearCollisionGroup(sourceId)
end

local function stopAllSimulations()
    local sourceIds = {}

    for sourceId in pairs(collisionTargetsBySource) do
        sourceIds[#sourceIds + 1] = sourceId
    end

    for i = 1, #sourceIds do
        clearCollisionGroup(sourceIds[i])
    end

    for netId in pairs(simulatedVehicles) do
        stopSimulation(netId)
    end

    simulatedVehicles = {}
    controlLastTick = {}
    collisionTargetsBySource = {}
end

local function getPullBlend(distance, pullRange)
    if distance <= holdDistance then
        return holdBlend
    end

    local span = math.max(pullRange - holdDistance, 1.0)
    local factor = math.max(0.0, math.min(1.0, (distance - holdDistance) / span))

    return minBlend + (maxBlend - minBlend) * (1.0 - factor)
end

local function getTargetSpeed(distance, pullRange)
    if distance <= holdDistance then
        return holdSpeed
    end

    local span = math.max(pullRange - holdDistance, 1.0)
    local factor = math.max(0.0, math.min(1.0, (distance - holdDistance) / span)) ^ 0.65

    return minSpeed + (maxSpeed - minSpeed) * factor
end

local function getHoldTargetCoords(sourceVehicle, slotIndex)
    local offset = holdOffsets[slotIndex] or holdOffsets[#holdOffsets]

    return GetOffsetFromEntityInWorldCoords(sourceVehicle, offset[1], offset[2], offset[3])
end

local function computePullVelocity(sourceVehicle, vehicle, slotIndex, pullRange)
    local vehicleCoords = GetEntityCoords(vehicle)
    local holdCoords = getHoldTargetCoords(sourceVehicle, slotIndex)
    local diff = holdCoords - vehicleCoords
    local distance = #diff
    local sourceVelocity = GetEntityVelocity(sourceVehicle)
    local velocity = GetEntityVelocity(vehicle)
    local sourceCoords = GetEntityCoords(sourceVehicle)
    local lift = math.max(0.0, (sourceCoords.z - vehicleCoords.z) * 0.35 + 0.25)

    if distance < 0.05 then
        return sourceVelocity.x, sourceVelocity.y, sourceVelocity.z
    end

    local direction = diff / distance
    local speed = getTargetSpeed(distance, pullRange)
    local blend = getPullBlend(distance, pullRange)
    local followBlend = distance <= holdDistance and 0.55 or 0.0
    local wantX = direction.x * speed + sourceVelocity.x * followBlend
    local wantY = direction.y * speed + sourceVelocity.y * followBlend
    local wantZ = direction.z * speed * 0.45 + lift + sourceVelocity.z * followBlend

    return velocity.x + (wantX - velocity.x) * blend,
        velocity.y + (wantY - velocity.y) * blend,
        velocity.z + (wantZ - velocity.z) * blend
end

local function getVehiclesInRange(coords, radius, excludeVehicle)
    local found = {}
    local vehicles = GetGamePool("CVehicle")
    local limitRadius = radius + 0.0001

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if vehicle ~= excludeVehicle and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            local distance = #(coords - GetEntityCoords(vehicle))

            if distance <= limitRadius then
                found[#found + 1] = { vehicle = vehicle, distance = distance }
            end
        end
    end

    table.sort(found, function(a, b)
        return a.distance < b.distance
    end)

    local results = {}
    local limit = math.min(#found, maxVehicles)

    for i = 1, limit do
        results[i] = found[i].vehicle
    end

    return results
end

local function isPlayerNearCoords(coords, reach)
    return #(GetEntityCoords(PlayerPedId()) - coords) <= reach
end

local function bootstrapMagnetSignals()
    for _, player in ipairs(GetActivePlayers()) do
        local sourceId = GetPlayerServerId(player)
        local signal = Player(sourceId).state.carMagnet

        if signal and signal.netId and signal.range then
            magnetSignals[sourceId] = signal
        end
    end

    if next(magnetSignals) then
        ensureSimulationThread()
    end
end

local function simulateMagnetPull(sourceId, signal, sourceVehicle)
    local pullRange = signal.range or defaultRange
    local collisionOn = signal.collision ~= false
    local sourceCoords = GetEntityCoords(sourceVehicle)
    local targets = getVehiclesInRange(sourceCoords, pullRange, sourceVehicle)
    local activeThisTick = {}

    for slotIndex = 1, #targets do
        local vehicle = targets[slotIndex]
        local netId = VehToNet(vehicle)

        if netId ~= 0 and canSimulateVehicle(vehicle, sourceId) then
            activeThisTick[netId] = true

            applyZeroGrav(vehicle)

            local vx, vy, vz = computePullVelocity(sourceVehicle, vehicle, slotIndex, pullRange)
            SetEntityVelocity(vehicle, vx, vy, vz)

            local previous = simulatedVehicles[netId]

            simulatedVehicles[netId] = {
                vehicle = vehicle,
                sourceId = sourceId,
                roll = previous and previous.roll or createRollProfile(),
            }

            applyAirRoll(vehicle, simulatedVehicles[netId].roll, math.sqrt(vx * vx + vy * vy + vz * vz))
        end
    end

    syncMagnetCollisionGroup(sourceId, targets, collisionOn)

    for netId, data in pairs(simulatedVehicles) do
        if data.sourceId == sourceId and not activeThisTick[netId] then
            stopSimulation(netId)
        end
    end
end

local function processMagnetSignals()
    local waitMs = idleTickMs

    for sourceId, signal in pairs(magnetSignals) do
        local sourceVehicle = getVehicleFromNetId(signal.netId)

        if not sourceVehicle then
            stopSimulationsForSource(sourceId)
        else
            local sourceCoords = GetEntityCoords(sourceVehicle)
            local reach = signal.range + proximityBuffer

            if sourceId == GetPlayerServerId(PlayerId()) or isPlayerNearCoords(sourceCoords, reach) then
                waitMs = pullTickMs
                simulateMagnetPull(sourceId, signal, sourceVehicle)
            else
                stopSimulationsForSource(sourceId)
            end
        end
    end

    return waitMs
end

local function ensureSimulationThread()
    if running then
        return
    end

    running = true

    CreateThread(function()
        while next(magnetSignals) do
            local waitMs = processMagnetSignals()
            Wait(waitMs)
        end

        stopAllSimulations()
        running = false
    end)
end

AddStateBagChangeHandler("carMagnet", nil, function(bagName, key, value)
    local sourceId = tonumber(string.match(bagName, "player:(%d+)"))

    if not sourceId then
        return
    end

    if value and value.netId and value.range then
        magnetSignals[sourceId] = value
        ensureSimulationThread()
    else
        stopSimulationsForSource(sourceId)
        magnetSignals[sourceId] = nil
    end
end)

local function publishMagnetSignal(enabled)
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        return false
    end

    local vehicle = GetVehiclePedIsIn(ped, false)

    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        return false
    end

    local netId = VehToNet(vehicle)

    if netId == 0 then
        return false
    end

    TriggerServerEvent("admin:CarMagnetSetSignal", enabled, range, netId, collisionEnabled)

    return true
end

local function getCollisionNotifyArg()
    return collisionEnabled and "#carMagnetCollisionOn" or "#carMagnetCollisionOff"
end

local function notifyCarMagnetIn()
    TriggerEvent("Notify2", "#carMagnetIn", {
        msg = math.floor(range),
        msg2 = getCollisionNotifyArg(),
    })
end

local function notifyCarMagnetUpdated()
    TriggerEvent("Notify2", "#carMagnetUpdated", {
        msg = math.floor(range),
        msg2 = getCollisionNotifyArg(),
    })
end

local function disable()
    if active then
        TriggerEvent("Notify2", "#carMagnetOut")
    end

    active = false
    range = defaultRange
    collisionEnabled = true
    TriggerServerEvent("admin:CarMagnetSetSignal", false)
    stopAllSimulations()

    local mySource = GetPlayerServerId(PlayerId())
    magnetSignals[mySource] = nil
end

local function enable(newRange, newCollision)
    range = newRange or defaultRange
    collisionEnabled = newCollision ~= false
    active = true

    if not publishMagnetSignal(true) then
        active = false
        return false
    end

    notifyCarMagnetIn()
    return true
end

local function startSourceThread()
    CreateThread(function()
        while active do
            if not IsPedInAnyVehicle(PlayerPedId(), false) or GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) ~= PlayerPedId() then
                disable()
                break
            end

            publishMagnetSignal(true)
            Wait(500)
        end
    end)
end

RegisterNetEvent("admin:CarMagnet", function(distance, collision)
    local newCollision = collision ~= false

    if distance and distance > 0 then
        local newRange = math.min(distance, maxRange)

        if active then
            local rangeChanged = range ~= newRange
            local collisionChanged = collisionEnabled ~= newCollision

            range = newRange
            collisionEnabled = newCollision

            if rangeChanged or collisionChanged then
                publishMagnetSignal(true)
                notifyCarMagnetUpdated()
            end

            return
        end

        if enable(newRange, newCollision) then
            startSourceThread()
        end

        return
    end

    if active then
        disable()
        return
    end

    if enable(defaultRange, newCollision) then
        startSourceThread()
    end
end)

RegisterNetEvent("net.disable.carmagnet", disable)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    TriggerServerEvent("admin:CarMagnetSetSignal", false)
    stopAllSimulations()
end)

CreateThread(function()
    Wait(1500)
    bootstrapMagnetSignals()
end)
