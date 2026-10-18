local lastCameraUpdate = 0
local CAMERA_TIMEOUT = 2000
local ANGLE_THRESHOLD = 3.0
local CUMULATIVE_THRESHOLD = 15.0
local CUMULATIVE_WINDOW = 500

--- @param status boolean
function SetCameraStatus(status)
    cameraStatus = status
    if status then
        -- Reset the timer when camera is activated
        lastCameraUpdate = GetGameTimer()
    end
end

--- @param a number
--- @param b number
--- @return number
local function GetAngleDifference(a, b)
    local diff = math.abs(a - b)
    return diff > 180 and (360 - diff) or diff
end

--- @param oldRot vector3
--- @param newRot vector3
--- @return boolean
local function HasSignificantRotation(oldRot, newRot)
    local xDiff = GetAngleDifference(oldRot.x, newRot.x)
    local yDiff = GetAngleDifference(oldRot.y, newRot.y)
    local zDiff = GetAngleDifference(oldRot.z, newRot.z)
    local maxDiff = math.max(xDiff, yDiff, zDiff)
    
    return xDiff > ANGLE_THRESHOLD or yDiff > ANGLE_THRESHOLD or zDiff > ANGLE_THRESHOLD
end


function UpdateCameraActivity()
    if cameraStatus then
        lastCameraUpdate = GetGameTimer()
    end
end

CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        
        if cameraStatus then
            local currentTime = GetGameTimer()
            local timeSinceLastUpdate = currentTime - lastCameraUpdate
            -- If no camera movement for 20 seconds
            if timeSinceLastUpdate > CAMERA_TIMEOUT then
                SetCameraStatus(false)
                TriggerEvent("keyText:remove")
            end
        end
    end
end)

CreateThread(function()
    local lastCamRot = vector3(0, 0, 0)
    local cumulativeX, cumulativeY, cumulativeZ = 0, 0, 0
    local lastCumulativeReset = GetGameTimer()
    
    while true do
        Wait(500)
        local camRot = GetGameplayCamRot(2)
        local currentRot = vector3(camRot.x, camRot.y, camRot.z)
        
        -- Calculate frame-by-frame differences
        local xDiff = GetAngleDifference(lastCamRot.x, currentRot.x)
        local yDiff = GetAngleDifference(lastCamRot.y, currentRot.y)
        local zDiff = GetAngleDifference(lastCamRot.z, currentRot.z)
        
        -- Add to cumulative differences
        cumulativeX = cumulativeX + xDiff
        cumulativeY = cumulativeY + yDiff
        cumulativeZ = cumulativeZ + zDiff
        
        -- Check for immediate significant rotation
        if HasSignificantRotation(lastCamRot, currentRot) then
            SetCameraStatus(true)
            UpdateCameraActivity()
        end
        
        -- Check cumulative movement within time window
        local currentTime = GetGameTimer()
        if currentTime - lastCumulativeReset > CUMULATIVE_WINDOW then
            -- Check if cumulative movement exceeds threshold
            if cumulativeX > CUMULATIVE_THRESHOLD or 
               cumulativeY > CUMULATIVE_THRESHOLD or 
               cumulativeZ > CUMULATIVE_THRESHOLD then
                SetCameraStatus(true)
                UpdateCameraActivity()
            end
            
            -- Reset cumulative values
            cumulativeX, cumulativeY, cumulativeZ = 0, 0, 0
            lastCumulativeReset = currentTime
        end
        
        lastCamRot = currentRot
    end
end)

-- Export the function so other resources can use it
exports('SetCameraStatus', SetCameraStatus)
exports('GetCameraStatus', function() return cameraStatus end)
