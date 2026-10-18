local MISSION_ID = "role_pela_cidade"
local TARGET_METERS = 300.0

---@param missions table|nil
---@return boolean
local function RoleMissionInProgress(missions)
    local row = missions and missions[MISSION_ID]

    return row ~= nil and row.completed_at == nil
end

---@param vehicle number
---@return boolean
local function HasPlayerInVehicle(vehicle)
    local seatCount = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))

    for seat = -1, seatCount - 2 do
        local ped = GetPedInVehicleSeat(vehicle, seat)

        if ped ~= 0 and ped ~= cache.ped and IsPedAPlayer(ped) then
            return true
        end
    end

    return false
end

---@param vehicle number
local function StartThreads(vehicle)
    if not vehicle then return end
    
    CreateThread(function()
        local accumulated = 0.0
        local lastPos = nil
        
        while cache.vehicle == vehicle do
            if not HasPlayerInVehicle(vehicle) then
                accumulated = 0.0
                lastPos = nil
            else
                local pos = GetEntityCoords(cache.ped)

                if lastPos then
                    accumulated = accumulated + #(pos - lastPos)
                end

                lastPos = pos

                if accumulated >= TARGET_METERS then
                    TriggerServerEvent("missions:server:cityJoyride")
                    break
                end
            end

            Wait(200)
        end
    end)
end

lib.onCache("vehicle", function(vehicle)
    if not vehicle then return end
    
    if not RoleMissionInProgress(gPlayerData.missions) then return end

    StartThreads(vehicle)
end)
