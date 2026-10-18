local zeroGravVehicles = {}
local zeroGravTouchEnabled = false
local lastHitCooldown = {}
local HIT_COOLDOWN_MS = 1200

local function applyZeroGravityToVehicle(veh)
    if not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        return
    end

    SetEntityHasGravity(veh, false)

    if SetVehicleGravityAmount then

        SetVehicleGravityAmount(veh, 0.0)
    end

    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 1 do

        local pedInSeat = GetPedInVehicleSeat(veh, seat)

        if pedInSeat ~= 0 then

            SetEntityHasGravity(pedInSeat, false)
        end
    end
end

local function restoreGravityToVehicle(veh)
    if not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        return
    end

    SetEntityHasGravity(veh, true)

    if SetVehicleGravityAmount then

        SetVehicleGravityAmount(veh, 9.81)
    end

    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) - 1 do

        local pedInSeat = GetPedInVehicleSeat(veh, seat)

        if pedInSeat ~= 0 then

            SetEntityHasGravity(pedInSeat, true)
        end
    end
end

RegisterNetEvent("admin:toggleZeroGravTouch", function(newEnabled)
    if type(newEnabled) == "boolean" then
        zeroGravTouchEnabled = newEnabled
    else
        zeroGravTouchEnabled = not zeroGravTouchEnabled
    end

    if not zeroGravTouchEnabled then

        for veh, _ in pairs(zeroGravVehicles) do

            restoreGravityToVehicle(veh)
        end

        zeroGravVehicles = {}
    end
end)

RegisterNetEvent("admin:zeroGravAddVehicle", function(vehNet)
    local veh = NetToVeh(vehNet)
    if veh == 0 or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then
        return
    end

    if not zeroGravVehicles[veh] then

        zeroGravVehicles[veh] = true
    end

    applyZeroGravityToVehicle(veh)
end)

RegisterNetEvent("admin:zeroGravResetVehicles", function()

    for veh, _ in pairs(zeroGravVehicles) do
        
        restoreGravityToVehicle(veh)
    end

    zeroGravVehicles = {}
end)

CreateThread(function()
    while true do
        if zeroGravTouchEnabled then
            local ped = PlayerPedId()

            if IsPedInAnyVehicle(ped, false) then

                local myVeh = GetVehiclePedIsIn(ped, false)

                if myVeh ~= 0 and GetPedInVehicleSeat(myVeh, -1) == ped then

                    local myCoords = GetEntityCoords(myVeh)
                    local toCoords = GetOffsetFromEntityInWorldCoords(myVeh, 0.0, 2.5, 0.0)

                    local ray = StartShapeTestCapsule(
                        myCoords.x, myCoords.y, myCoords.z + 0.5,
                        toCoords.x, toCoords.y, toCoords.z + 0.5,
                        1.8,
                        10,
                        myVeh,
                        7
                    )

                    local _, hit, _, _, entityHit = GetShapeTestResult(ray)

                    if hit == 1 and entityHit ~= 0 and entityHit ~= myVeh and IsEntityAVehicle(entityHit) then

                        local dist = #(myCoords - GetEntityCoords(entityHit))

                        if dist < 3.0 then

                            local netId = VehToNet(entityHit)

                            if netId and netId ~= 0 then

                                local now = GetGameTimer()

                                if not lastHitCooldown[netId] or (now - lastHitCooldown[netId]) >= HIT_COOLDOWN_MS then

                                    lastHitCooldown[netId] = now
                                    TriggerServerEvent("admin:zeroGravHitVehicle", netId)
                                end
                            end
                        end
                    end
                end
            end
        end

        -- for veh, _ in pairs(zeroGravVehicles) do

        --     if not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then

        --         zeroGravVehicles[veh] = nil
        --     else

        --         applyZeroGravityToVehicle(veh)
        --     end
        -- end

        Wait(50)
    end
end)
