-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("doors")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Display = {}
local Doors = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	local Unlocked = vSERVER.Unlocked()

-- 	for Number,v in pairs(DoorsConfig) do
-- 		if IsDoorRegisteredWithSystem(Number) then
-- 			RemoveDoorFromSystem(Number)
-- 		end
-- 		AddDoorToSystem(Number,v["Hash"],v["Coords"],false,false,true)

-- 		DoorSystemSetOpenRatio(Number,0.0,false,false)
-- 		DoorSystemSetAutomaticRate(Number,2.0,false,false)

-- 		local Locked = 1

-- 		for _, Id in ipairs(Unlocked) do
-- 			if Id == Number then
-- 				Locked = 0
-- 				break
-- 			end
-- 		end
-- 		Doors[Number] = Locked == 1
-- 		DoorSystemSetDoorState(Number, Locked, true)
-- 	end
-- end)

RegisterNetEvent("Doors", function(Number, Status)
	DoorSystemSetOpenRatio(Number,0.0,false,false)
	DoorSystemSetAutomaticRate(Number,2.0,false,false)
	DoorSystemSetDoorState(Number,Status and 1 or 0,true)

	Doors[Number] = Status

	local Second = DoorsConfig[Number]["Other"]

	if Second ~= nil then
		Doors[Second] = Status
		DoorSystemSetDoorState(Second, Status and 1 or 0, true)
	end

	if Display[Number] then
		TriggerEvent("hoverfy:toggle", true, { title = Status and _t("locked") or _t("unLocked"), key = "E", legend = Status and _t("toLock") or _t("toUnlock") })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while false do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for Number,v in pairs(DoorsConfig) do
				local Distance = #(Coords - v["Coords"])
				if Distance <= v["Distance"] then
					TimeDistance = 1

					if not Display[Number] then
						TriggerEvent("hoverfy:toggle", true, { title = Doors[Number] and _t("locked") or _t("unLocked"), key = "E", legend = Doors[Number] and _t("toLock") or  _t("toUnlock") })
						Display[Number] = true
					end

					if IsControlJustPressed(1,38) then
						if vSERVER.DoorsPermission(Number) then
							vRP.playAnim(true, { "anim@heists@keycard@", "exit" }, false)
							Wait(350)
							vRP.stopAnim()
						end
					end
				else
					if Display[Number] then
						TriggerEvent("hoverfy:toggle", false)
						Display[Number] = nil
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

CreateThread(function()
    -- for i=1,5000 do
    --     DoorSystemSetOpenRatio(i, 0.0, false --[[ network ]], false --[[ flushState ]])
    --     DoorSystemSetAutomaticRate(i, 2.0, false --[[ network ]], false --[[ flushState ]])
    --     DoorSystemSetDoorState(i, true, false --[[ network ]], true --[[ flushState ]])
    -- end
    while true do
        if not LocalPlayer["state"]["WorldPVP"] then
            if LocalPlayer["state"]["Route"] > 1 and not LocalPlayer.state['matchcity:house'] then
                for i=1,5000 do
                    DoorSystemSetOpenRatio(i, 0.0, false --[[ network ]], false --[[ flushState ]])
                    DoorSystemSetAutomaticRate(i, 2.0, false --[[ network ]], false --[[ flushState ]])
                    DoorSystemSetDoorState(i, false, false --[[ network ]], true --[[ flushState ]])
                end
            end
        end
        Wait(500)
    end
end)
