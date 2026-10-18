---@class VehicleRewindFrame
---@field timestamp number
---@field x number
---@field y number
---@field z number
---@field qx number
---@field qy number
---@field qz number
---@field qw number

---@class VehicleRewindHistory
---@field vehicle number
---@field netId number
---@field firstIndex number
---@field frameCount number
---@field frames VehicleRewindFrame[]
---@field lastFrameAt number
---@field lastResetReason string
---@field lastResetAt number

---@class ActiveVehicleRewind
---@field vehicle number
---@field frames VehicleRewindFrame[]
---@field targetTimestamp number
---@field latestTimestamp number
---@field upperFrameIndex number
---@field controlDeadlineAt number
---@field startedAt number | nil
---@field wasFrozen boolean
---@field collisionDisabled boolean
---@field phase "waitingControl" | "rewinding"

---@class PendingVehicleRewindConfirmation
---@field vehicle number
---@field rewindSeconds number
---@field expiresAt number

local gVehicleRewindMaxFrames = math.ceil((gVehicleRewindConfig.maxSeconds * 1000) / gVehicleRewindConfig.sampleIntervalMs) + 2

---@type VehicleRewindHistory
local gVehicleRewindHistory = {
    vehicle = 0,
    netId = 0,
    firstIndex = 1,
    frameCount = 0,
    frames = {},
    lastFrameAt = 0,
    lastResetReason = "resource_started",
    lastResetAt = 0,
}

---@type ActiveVehicleRewind | nil
local gActiveVehicleRewind = nil
local gVehicleRewindLastSampleAt = 0
local gVehicleRewindVehicleMissingAt = nil
local gVehicleRewindHistoryTickAbort = nil
local gVehicleRewindTickAbort = nil

---@type PendingVehicleRewindConfirmation | nil
local gPendingVehicleRewindConfirmation = nil
local gVehicleRewindConfirmationTickAbort = nil

---@param key string
local function NotifyVehicleRewind(key)

    TriggerEvent("Notify2", key)
end

---@return number | nil vehicle
local function GetLocalOccupiedVehicle()

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or not DoesEntityExist(vehicle) then
        return nil
    end

    return vehicle
end

---@param vehicle number
---@return boolean isDriver
local function IsLocalVehicleDriver(vehicle)

    return GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()
end

---@return number | nil vehicle
local function GetLocalDrivenVehicle()

    local vehicle = GetLocalOccupiedVehicle()

    if not vehicle or not IsLocalVehicleDriver(vehicle) then
        return nil
    end

    return vehicle
end

---@param vehicle number
---@return number | nil vehicleNetId
local function GetVehicleNetworkId(vehicle)

    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)

    if vehicleNetId == 0 then
        return nil
    end

    return vehicleNetId
end

---@param vehicle number
---@param vehicleNetId number
---@param resetReason string
local function ResetVehicleRewindHistory(vehicle, vehicleNetId, resetReason)

    gVehicleRewindHistory.vehicle = vehicle
    gVehicleRewindHistory.netId = vehicleNetId
    gVehicleRewindHistory.firstIndex = 1
    gVehicleRewindHistory.frameCount = 0
    gVehicleRewindHistory.frames = {}
    gVehicleRewindHistory.lastFrameAt = 0
    gVehicleRewindHistory.lastResetReason = resetReason
    gVehicleRewindHistory.lastResetAt = GetGameTimer()
end

---@param vehicle number
---@param timestamp number
local function AppendVehicleRewindFrame(vehicle, timestamp)

    local coords = GetEntityCoords(vehicle)
    local qx, qy, qz, qw = GetEntityQuaternion(vehicle)
    local frameIndex = ((gVehicleRewindHistory.firstIndex + gVehicleRewindHistory.frameCount - 1) % gVehicleRewindMaxFrames) + 1

    gVehicleRewindHistory.frames[frameIndex] = {
        timestamp = timestamp,
        x = coords.x,
        y = coords.y,
        z = coords.z,
        qx = qx,
        qy = qy,
        qz = qz,
        qw = qw,
    }

    if gVehicleRewindHistory.frameCount < gVehicleRewindMaxFrames then
        gVehicleRewindHistory.frameCount = gVehicleRewindHistory.frameCount + 1
        gVehicleRewindHistory.lastFrameAt = timestamp
        return
    end

    gVehicleRewindHistory.firstIndex = (gVehicleRewindHistory.firstIndex % gVehicleRewindMaxFrames) + 1
    gVehicleRewindHistory.lastFrameAt = timestamp
end

---@param historyIndex number
---@return VehicleRewindFrame | nil frame
local function GetVehicleRewindHistoryFrame(historyIndex)

    if historyIndex < 1 or historyIndex > gVehicleRewindHistory.frameCount then
        return nil
    end

    local frameIndex = ((gVehicleRewindHistory.firstIndex + historyIndex - 2) % gVehicleRewindMaxFrames) + 1

    return gVehicleRewindHistory.frames[frameIndex]
end

---@param rewindSeconds number
---@return VehicleRewindFrame[] | nil frames
---@return number | nil targetTimestamp
local function BuildVehicleRewindFrames(rewindSeconds)

    if gVehicleRewindHistory.frameCount < 2 then
        return nil, nil
    end

    local oldestFrame = GetVehicleRewindHistoryFrame(1)
    local latestFrame = GetVehicleRewindHistoryFrame(gVehicleRewindHistory.frameCount)

    if not oldestFrame or not latestFrame then
        sx.logger:warn("[vehicleRewind] historico incompleto ao montar os frames")
        return nil, nil
    end

    local targetTimestamp = latestFrame.timestamp - (rewindSeconds * 1000)

    if oldestFrame.timestamp > targetTimestamp then
        return nil, nil
    end

    local frames = {}

    for historyIndex = 1, gVehicleRewindHistory.frameCount do
        local frame = GetVehicleRewindHistoryFrame(historyIndex)

        if frame and frame.timestamp >= targetTimestamp then
            frames[#frames + 1] = frame
        end
    end

    if #frames < 2 then
        return nil, nil
    end

    return frames, targetTimestamp
end

---@return number historyDurationMs
local function GetVehicleRewindHistoryDurationMs()

    if gVehicleRewindHistory.frameCount < 2 then
        return 0
    end

    local oldestFrame = GetVehicleRewindHistoryFrame(1)
    local latestFrame = GetVehicleRewindHistoryFrame(gVehicleRewindHistory.frameCount)

    if not oldestFrame or not latestFrame then
        return 0
    end

    return latestFrame.timestamp - oldestFrame.timestamp
end

---@param reason string
---@param vehicle number | nil
---@param vehicleNetId number | nil
---@param rewindSeconds number
local function LogVehicleRewindHistoryUnavailable(reason, vehicle, vehicleNetId, rewindSeconds)

    local lastFrameAgeMs = gVehicleRewindHistory.lastFrameAt > 0 and GetGameTimer() - gVehicleRewindHistory.lastFrameAt or nil
    local lastResetAgeMs = gVehicleRewindHistory.lastResetAt > 0 and GetGameTimer() - gVehicleRewindHistory.lastResetAt or nil

    sx.logger:warn(("[vehicleRewind] history unavailable reason=%s vehicle=%s vehicleNetId=%s historyVehicle=%s historyNetId=%s frames=%s durationMs=%s lastFrameAgeMs=%s lastResetReason=%s lastResetAgeMs=%s seconds=%.2f"):format(
        reason,
        tostring(vehicle),
        tostring(vehicleNetId),
        tostring(gVehicleRewindHistory.vehicle),
        tostring(gVehicleRewindHistory.netId),
        gVehicleRewindHistory.frameCount,
        GetVehicleRewindHistoryDurationMs(),
        tostring(lastFrameAgeMs),
        gVehicleRewindHistory.lastResetReason,
        tostring(lastResetAgeMs),
        rewindSeconds
    ))
end

---@param ax number
---@param ay number
---@param az number
---@param aw number
---@param bx number
---@param by number
---@param bz number
---@param bw number
---@param fraction number
---@return number x
---@return number y
---@return number z
---@return number w
local function NlerpQuaternion(ax, ay, az, aw, bx, by, bz, bw, fraction)

    if (ax * bx + ay * by + az * bz + aw * bw) < 0 then
        bx, by, bz, bw = -bx, -by, -bz, -bw
    end

    local x = ax + (bx - ax) * fraction
    local y = ay + (by - ay) * fraction
    local z = az + (bz - az) * fraction
    local w = aw + (bw - aw) * fraction
    local length = math.sqrt(x * x + y * y + z * z + w * w)

    if length == 0 then
        return ax, ay, az, aw
    end

    return x / length, y / length, z / length, w / length
end

---@param vehicle number
---@param frame VehicleRewindFrame
local function ApplyVehicleRewindFrame(vehicle, frame)

    SetEntityCoordsNoOffset(vehicle, frame.x, frame.y, frame.z, true, true, true)
    SetEntityQuaternion(vehicle, frame.qx, frame.qy, frame.qz, frame.qw)
end

---@param vehicle number
---@param context ActiveVehicleRewind
---@param playbackTimestamp number
local function ApplyVehicleRewindAtTimestamp(vehicle, context, playbackTimestamp)

    while context.upperFrameIndex > 1 and context.frames[context.upperFrameIndex - 1].timestamp >= playbackTimestamp do
        context.upperFrameIndex = context.upperFrameIndex - 1
    end

    local upperFrame = context.frames[context.upperFrameIndex]

    if context.upperFrameIndex == 1 then
        ApplyVehicleRewindFrame(vehicle, upperFrame)
        return
    end

    local lowerFrame = context.frames[context.upperFrameIndex - 1]
    local frameSpan = upperFrame.timestamp - lowerFrame.timestamp
    local fraction = frameSpan > 0 and ((playbackTimestamp - lowerFrame.timestamp) / frameSpan) or 0
    local x = lowerFrame.x + (upperFrame.x - lowerFrame.x) * fraction
    local y = lowerFrame.y + (upperFrame.y - lowerFrame.y) * fraction
    local z = lowerFrame.z + (upperFrame.z - lowerFrame.z) * fraction
    local qx, qy, qz, qw = NlerpQuaternion(
        lowerFrame.qx,
        lowerFrame.qy,
        lowerFrame.qz,
        lowerFrame.qw,
        upperFrame.qx,
        upperFrame.qy,
        upperFrame.qz,
        upperFrame.qw,
        fraction
    )

    SetEntityCoordsNoOffset(vehicle, x, y, z, true, true, true)
    SetEntityQuaternion(vehicle, qx, qy, qz, qw)
end

local function DisableVehicleRewindControls()

    DisableControlAction(0, 59, true)
    DisableControlAction(0, 60, true)
    DisableControlAction(0, 63, true)
    DisableControlAction(0, 64, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 76, true)
end

---@param notificationKey string | nil
local function FinishVehicleRewind(notificationKey)

    local context = gActiveVehicleRewind

    if not context then
        return
    end

    if context.startedAt and DoesEntityExist(context.vehicle) then
        if context.collisionDisabled then
            SetEntityCollision(context.vehicle, true, true)
        end

        FreezeEntityPosition(context.vehicle, context.wasFrozen)
        SetEntityVelocity(context.vehicle, 0.0, 0.0, 0.0)
    end

    gActiveVehicleRewind = nil

    if gVehicleRewindTickAbort then
        gVehicleRewindTickAbort()
        gVehicleRewindTickAbort = nil
    end

    if notificationKey then
        NotifyVehicleRewind(notificationKey)
    end
end

---@param context ActiveVehicleRewind
---@return boolean started
local function TryBeginVehicleRewind(context)

    if not DoesEntityExist(context.vehicle) then
        sx.logger:warn("[vehicleRewind] veiculo deixou de existir antes do inicio")
        return false
    end

    context.wasFrozen = IsEntityPositionFrozen(context.vehicle)
    context.collisionDisabled = true
    context.startedAt = GetGameTimer()
    context.phase = "rewinding"

    SetEntityCollision(context.vehicle, false, false)
    FreezeEntityPosition(context.vehicle, true)
    SetEntityVelocity(context.vehicle, 0.0, 0.0, 0.0)

    return true
end

local function UpdateVehicleRewind()

    local context = gActiveVehicleRewind

    if not context then
        return
    end

    local vehicle = GetLocalDrivenVehicle()
    local vehicleNetId = vehicle and GetVehicleNetworkId(vehicle) or nil

    if not vehicle or vehicle ~= context.vehicle or gVehicleRewindHistory.vehicle ~= vehicle then
        FinishVehicleRewind("#vehicleRewindInterrupted")
        return
    end

    if context.phase == "waitingControl" then
        if NetworkHasControlOfEntity(vehicle) then
            if not TryBeginVehicleRewind(context) then
                FinishVehicleRewind("#vehicleRewindInterrupted")
            end

            return
        end

        if GetGameTimer() >= context.controlDeadlineAt then
            sx.logger:warn(("[vehicleRewind] sem controle de rede vehicleNetId=%s"):format(vehicleNetId))
            FinishVehicleRewind("#vehicleRewindNoControl")
            return
        end

        NetworkRequestControlOfEntity(vehicle)
        return
    end

    if not NetworkHasControlOfEntity(vehicle) then
        sx.logger:warn(("[vehicleRewind] controle de rede perdido vehicleNetId=%s"):format(vehicleNetId))
        FinishVehicleRewind("#vehicleRewindInterrupted")
        return
    end

    DisableVehicleRewindControls()

    local elapsed = (GetGameTimer() - context.startedAt) * gVehicleRewindConfig.speedMultiplier
    local playbackTimestamp = context.latestTimestamp - elapsed

    if playbackTimestamp <= context.targetTimestamp then
        ApplyVehicleRewindFrame(vehicle, context.frames[1])
        FinishVehicleRewind("#vehicleRewindComplete")
        return
    end

    ApplyVehicleRewindAtTimestamp(vehicle, context, playbackTimestamp)
end

local function EnsureVehicleRewindTick()

    if gVehicleRewindTickAbort then
        return
    end

    gVehicleRewindTickAbort = sx.script.setTick(UpdateVehicleRewind)
end

local function FinishVehicleRewindConfirmation()

    gPendingVehicleRewindConfirmation = nil

    if gVehicleRewindConfirmationTickAbort then
        gVehicleRewindConfirmationTickAbort()
        gVehicleRewindConfirmationTickAbort = nil
    end
end

local function UpdateVehicleRewindConfirmation()

    local pendingConfirmation = gPendingVehicleRewindConfirmation

    if not pendingConfirmation then
        return
    end

    local vehicle = GetLocalDrivenVehicle()

    if not vehicle or vehicle ~= pendingConfirmation.vehicle then
        FinishVehicleRewindConfirmation()
        NotifyVehicleRewind("#vehicleRewindNotDriver")
        return
    end

    if gVehicleRewindHistory.vehicle ~= vehicle then
        LogVehicleRewindHistoryUnavailable("vehicle_changed_before_confirmation", vehicle, GetVehicleNetworkId(vehicle), pendingConfirmation.rewindSeconds)
        FinishVehicleRewindConfirmation()
        NotifyVehicleRewind("#vehicleRewindNoHistory")
        return
    end

    local vehicleNetId = GetVehicleNetworkId(vehicle)

    if vehicleNetId then
        local rewindSeconds = pendingConfirmation.rewindSeconds

        FinishVehicleRewindConfirmation()
        TriggerServerEvent("net.admin.confirmVehicleRewind", vehicleNetId, rewindSeconds)
        return
    end

    if GetGameTimer() < pendingConfirmation.expiresAt then
        return
    end

    sx.logger:warn(("[vehicleRewind] network id unavailable before confirmation vehicle=%s historyVehicle=%s frames=%s"):format(
        vehicle,
        gVehicleRewindHistory.vehicle,
        gVehicleRewindHistory.frameCount
    ))
    FinishVehicleRewindConfirmation()
    NotifyVehicleRewind("#vehicleRewindNetworkUnavailable")
end

local function EnsureVehicleRewindConfirmationTick()

    if gVehicleRewindConfirmationTickAbort then
        return
    end

    gVehicleRewindConfirmationTickAbort = sx.script.setTick(UpdateVehicleRewindConfirmation)
end

local function RecordVehicleRewindHistory()

    if gActiveVehicleRewind then
        return
    end

    local now = GetGameTimer()

    if now - gVehicleRewindLastSampleAt < gVehicleRewindConfig.sampleIntervalMs then
        return
    end

    gVehicleRewindLastSampleAt = now

    local vehicle = GetLocalOccupiedVehicle()

    if not vehicle then
        if gVehicleRewindHistory.vehicle == 0 then
            gVehicleRewindVehicleMissingAt = nil
            return
        end

        if not gVehicleRewindVehicleMissingAt then
            gVehicleRewindVehicleMissingAt = now
            return
        end

        if now - gVehicleRewindVehicleMissingAt >= gVehicleRewindConfig.vehicleLeaveResetDelayMs then
            ResetVehicleRewindHistory(0, 0, "local_vehicle_missing")
            gVehicleRewindVehicleMissingAt = nil
        end

        return
    end

    gVehicleRewindVehicleMissingAt = nil

    if gVehicleRewindHistory.vehicle == 0 then
        if not IsLocalVehicleDriver(vehicle) then
            return
        end

        ResetVehicleRewindHistory(vehicle, GetVehicleNetworkId(vehicle) or 0, "driver_started_tracking")
    elseif gVehicleRewindHistory.vehicle ~= vehicle then
        if IsLocalVehicleDriver(vehicle) then
            ResetVehicleRewindHistory(vehicle, GetVehicleNetworkId(vehicle) or 0, "driver_changed_vehicle")
        else
            ResetVehicleRewindHistory(0, 0, "local_vehicle_changed")
            return
        end
    elseif gVehicleRewindHistory.lastFrameAt > 0 and now - gVehicleRewindHistory.lastFrameAt >= gVehicleRewindConfig.historySampleGapResetDelayMs then
        ResetVehicleRewindHistory(vehicle, GetVehicleNetworkId(vehicle) or 0, "history_sample_gap")
    else
        local vehicleNetId = GetVehicleNetworkId(vehicle)

        if vehicleNetId then
            gVehicleRewindHistory.netId = vehicleNetId
        end
    end

    AppendVehicleRewindFrame(vehicle, now)
end

local function EnsureVehicleRewindHistoryTick()

    if gVehicleRewindHistoryTickAbort then
        return
    end

    gVehicleRewindHistoryTickAbort = sx.script.setTick(RecordVehicleRewindHistory)
end

local function StartVehicleRewindHistoryWhenSxIsReady()

    CreateThread(function()

        while type(sx) ~= "table" or type(sx.script) ~= "table" or type(sx.script.setTick) ~= "function" do
            Wait(0)
        end

        EnsureVehicleRewindHistoryTick()
    end)
end

RegisterNetEvent("net.admin.vehicleRewind", function(vehicleNetId, rewindSeconds)

    if gActiveVehicleRewind then
        NotifyVehicleRewind("#vehicleRewindInProgress")
        return
    end

    rewindSeconds = tonumber(rewindSeconds)

    if not rewindSeconds then
        NotifyVehicleRewind("#vehicleRewindInvalidSeconds")
        return
    end

    rewindSeconds = math.max(gVehicleRewindConfig.minSeconds, math.min(rewindSeconds, gVehicleRewindConfig.maxSeconds))

    local vehicle = GetLocalDrivenVehicle()
    local localVehicleNetId = vehicle and GetVehicleNetworkId(vehicle) or nil

    if not vehicle then
        sx.logger:warn(("[vehicleRewind] motorista mudou antes do inicio localVehicleNetId=%s authorizedVehicleNetId=%s"):format(tostring(localVehicleNetId), tostring(vehicleNetId)))
        NotifyVehicleRewind("#vehicleRewindNotDriver")
        return
    end

    if not localVehicleNetId or localVehicleNetId ~= vehicleNetId then
        sx.logger:warn(("[vehicleRewind] network id changed before start localVehicleNetId=%s authorizedVehicleNetId=%s"):format(tostring(localVehicleNetId), tostring(vehicleNetId)))
        NotifyVehicleRewind("#vehicleRewindNetworkUnavailable")
        return
    end

    if gVehicleRewindHistory.vehicle ~= vehicle then
        LogVehicleRewindHistoryUnavailable("vehicle_changed_before_start", vehicle, localVehicleNetId, rewindSeconds)
        NotifyVehicleRewind("#vehicleRewindNoHistory")
        return
    end

    AppendVehicleRewindFrame(vehicle, GetGameTimer())

    local frames, targetTimestamp = BuildVehicleRewindFrames(rewindSeconds)

    if not frames or not targetTimestamp then
        LogVehicleRewindHistoryUnavailable("insufficient_frames", vehicle, localVehicleNetId, rewindSeconds)
        NotifyVehicleRewind("#vehicleRewindNoHistory")
        return
    end

    gActiveVehicleRewind = {
        vehicle = vehicle,
        frames = frames,
        targetTimestamp = targetTimestamp,
        latestTimestamp = frames[#frames].timestamp,
        upperFrameIndex = #frames,
        controlDeadlineAt = GetGameTimer() + gVehicleRewindConfig.controlTimeoutMs,
        startedAt = nil,
        wasFrozen = false,
        collisionDisabled = false,
        phase = "waitingControl",
    }

    EnsureVehicleRewindTick()
end)

RegisterNetEvent("net.admin.requestVehicleRewind", function(rewindSeconds)

    local vehicle = GetLocalDrivenVehicle()

    if not vehicle then
        sx.logger:debug("[vehicleRewind] solicitacao recebida sem motorista local")
        NotifyVehicleRewind("#vehicleRewindNotDriver")
        return
    end

    if gVehicleRewindHistory.vehicle ~= vehicle then
        LogVehicleRewindHistoryUnavailable("vehicle_changed_before_request", vehicle, GetVehicleNetworkId(vehicle), rewindSeconds)
        NotifyVehicleRewind("#vehicleRewindNoHistory")
        return
    end

    gPendingVehicleRewindConfirmation = {
        vehicle = vehicle,
        rewindSeconds = rewindSeconds,
        expiresAt = GetGameTimer() + gVehicleRewindConfig.networkIdRetryTimeoutMs,
    }

    EnsureVehicleRewindConfirmationTick()
end)

AddEventHandler("onResourceStop", function(resourceName)

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    FinishVehicleRewind(nil)
    FinishVehicleRewindConfirmation()

    if gVehicleRewindHistoryTickAbort then
        gVehicleRewindHistoryTickAbort()
        gVehicleRewindHistoryTickAbort = nil
    end
end)

StartVehicleRewindHistoryWhenSxIsReady()
