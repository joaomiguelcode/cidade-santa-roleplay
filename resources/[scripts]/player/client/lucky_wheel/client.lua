local _wheel = nil
local _lambo = nil
local _isShowCar = false
local _wheelPos = vector3(165.02,-975.86,29.74)
local _baseWheelPos = vector3(165.02,-975.86,29.74)
local _movePos = vector3(165.02,-975.86,29.74)

local casinoprops = {}

local Keys = {
    ["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

local _isRolling = false

RegisterNetEvent("luckywheel:doRoll")
AddEventHandler("luckywheel:doRoll", function(_priceIndex)
    _isRolling = true
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    local _wheel = GetClosestObjectOfType(Coords["x"],Coords["y"],Coords["z"], 10.0, -945995088, false, false, false)
    local Heading = GetEntityHeading(_wheel)
    local Heading = -15.0
    --SetEntityRotation(_wheel, 0.0, 0, Heading, 1, true)
    SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
    local _priceIndex = math.random(1,20)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _priceIndex = math.random(1, 20)
        local _priceIndex = 1

        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0
                    
                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            -- if _rollAngle < 5.0 then
            --     if _y > _winAngle then
            --         _y = _winAngle
            --     end
            -- end
            --SetEntityRotation(_wheel, 0.0, _y, Heading, 1, true)
            SetEntityRotation(_wheel, 0.0, _y, -18.9754, 2, true)
            Citizen.Wait(0)
        end
    end)
end)

--[[ RegisterCommand("setwheel",function(source,args)
    if args[1] then
    SetEntityHeading(_wheel, 328.34)
    local rotation = (tonumber(args[1]) * 10) / 10
        SetEntityRotation(_wheel, 0.0, rotation, 328.34, 2, true)
    end
end) ]]

RegisterNetEvent("luckywheel:rollFinished")
AddEventHandler("luckywheel:rollFinished", function()
    _isRolling = false
end)

function doRoll()
    if not _isRolling then
        if not vSERVER.GetStatusLucky() then
            return
        end
        _isRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        RequestAnimDict(lib)
        TaskGoStraightToCoord(playerPed, _movePos.x, _movePos.y, _movePos.z, 1.0, -1, 337.33, 0.0)
        Wait(100)
        SetEntityHeading(playerPed, 337.33)
        local _isMoved = false
        while not _isMoved do
            local coords = GetEntityCoords(PlayerPedId())
            if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                _isMoved = true
            end
            Citizen.Wait(0)
        end
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
        TriggerServerEvent("luckywheel:getLucky")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
-- Menu Controls
local normalText = "~g~E~w~ PARA RODAR A ROLETA"
local disableText = "~r~SISTEMA DESATIVADO TEMPORARIAMENTE~w~"
local wheelDisable = true
-- Citizen.CreateThread(function()
--     while true do
--         local castle = 500
--         local coords = GetEntityCoords(PlayerPedId())
--         if (GetDistanceBetweenCoords(coords, _wheelPos.x, _wheelPos.y, _wheelPos.z, true) < 1.5) and not _isRolling then
--             castle = 4
--             local Text = normalText
--             if wheelDisable then
--                 Text = disableText
--             end
--             DrawText(_wheelPos[1], _wheelPos[2], _wheelPos[3],Text)
--             if IsControlJustReleased(0, Keys['E']) then
--                 doRoll()
--                 --print("Not implemented yet")
--             end
--         end
--         Citizen.Wait(castle)
--     end
-- end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _,wheel in pairs(casinoprops) do
            DeleteEntity(_wheel)
            DeleteEntity(_basewheel)
            DeleteEntity(_lambo)
        end
	end
end)