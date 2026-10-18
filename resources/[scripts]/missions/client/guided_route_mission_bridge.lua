local rules = GUIDED_ROUTE_MISSION_RULES

local VEHICLE_ENTER_RULES = {}
local VEHICLE_RULE_MISSION_IDS = {}
local RECONCILE_MISSION_IDS = {}

if type(rules) == 'table' then
    for i = 1, #rules do
        local r = rules[i]
        if r.startOnVehicleEnter == true then
            VEHICLE_ENTER_RULES[#VEHICLE_ENTER_RULES + 1] = r
            local mid = r.startWhenMissionInProgress
            if type(mid) == 'string' and mid ~= '' then
                VEHICLE_RULE_MISSION_IDS[mid] = true
            end
        end
        local midAll = r.startWhenMissionInProgress
        if type(midAll) == 'string' and midAll ~= '' then
            RECONCILE_MISSION_IDS[midAll] = true
        end
    end
end

local function getSyncedMissions()
    local gd = rawget(_G, 'gPlayerData')
    if type(gd) == 'table' and type(gd.missions) == 'table' then
        return gd.missions
    end
    return nil
end

local function isMissionRowInProgress(row)
    if type(row) ~= 'table' then
        return false
    end
    local c = row.completed_at
    return c == nil or c == false
end

local missionRouteInProgress = {}

local function clearMissionRouteProgress(mid)
    missionRouteInProgress[mid] = nil
end

local function shouldTrackMissionIdForRules(mid)
    return type(mid) == 'string' and mid ~= '' and VEHICLE_RULE_MISSION_IDS[mid] == true
end

local function reconcileMissionRouteProgressFromPayload(playerData)
    if type(playerData) ~= 'table' or playerData.enabled == false then
        return
    end
    local missions = playerData.missions
    if type(missions) ~= 'table' then
        return
    end

    for mid in pairs(RECONCILE_MISSION_IDS) do
        if isMissionRowInProgress(missions[mid]) then
            missionRouteInProgress[mid] = true
        else
            clearMissionRouteProgress(mid)
        end
    end
end

local function isMissionConsideredInProgress(missions, mid)
    if isMissionRowInProgress(missions[mid]) then
        return true
    end
    return missionRouteInProgress[mid] == true
end

local function tryStartFromVehicleRules(missions)
    missions = missions or getSyncedMissions() or {}
    if type(missions) ~= 'table' then
        return
    end

    local nRules = #VEHICLE_ENTER_RULES
    if nRules == 0 then
        return
    end

    local playerPed = PlayerPedId()
    if playerPed == 0 then
        return
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        return
    end

    local activePreset = GuidedRouteGetActivePresetId()
    local driverSeatPed = GetPedInVehicleSeat(vehicle, -1)

    for i = 1, nRules do
        local rule = VEHICLE_ENTER_RULES[i]
        local mid = rule.startWhenMissionInProgress
        if type(mid) == 'string' and mid ~= '' and isMissionConsideredInProgress(missions, mid) then
            local driverOk = rule.requireDriverSeat == false or driverSeatPed == playerPed
            local pid = rule.presetId
            if driverOk and type(pid) == 'string' and pid ~= '' and activePreset ~= pid then
                GuidedRouteStart(pid)
                return
            end
        end
    end
end

local function deferTryStart(missionsPayload)
    CreateThread(function()
        Wait(0)
        tryStartFromVehicleRules(missionsPayload)
    end)
end

local function onMissionCompleted(missionId)
    if type(missionId) == 'string' then
        clearMissionRouteProgress(missionId)
    end

    if type(rules) ~= 'table' then
        return
    end

    local activeId = GuidedRouteGetActivePresetId()
    local presetToStart

    for i = 1, #rules do
        local rule = rules[i]
        if activeId and rule.presetId == activeId and rule.stopWhenMissionCompletes == missionId then
            GuidedRouteStop()
            activeId = nil
        end
        if rule.startAfterMissionCompletes == missionId and type(rule.presetId) == 'string' then
            presetToStart = rule.presetId
        end
    end

    if presetToStart and GuidedRouteGetActivePresetId() ~= presetToStart then
        GuidedRouteStart(presetToStart)
    end
end

RegisterNetEvent('missions:client:missionCompleted', function(missionId)
    onMissionCompleted(missionId)
end)

AddEventHandler('gameEventTriggered', function(eventName, args)
    if eventName ~= 'CEventNetworkPlayerEnteredVehicle' then
        return
    end
    if args[1] ~= nil and tonumber(args[1]) ~= PlayerId() then
        return
    end
    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.Active == false then
        return
    end
    deferTryStart()
end)

RegisterNetEvent('missions:client:missionStarted', function(missionId)
    if type(missionId) == 'string' and missionId ~= '' and shouldTrackMissionIdForRules(missionId) then
        missionRouteInProgress[missionId] = true
    end
    deferTryStart()
end)

AddEventHandler('missions:updatePlayerData', function(playerData)
    if not playerData then
        return
    end
    reconcileMissionRouteProgressFromPayload(playerData)
    deferTryStart(playerData.missions)
end)
