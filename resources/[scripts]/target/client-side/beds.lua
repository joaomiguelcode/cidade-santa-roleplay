-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
local Treatment = false
local TreatmentTimer = 0
local CHECKIN_MODE_REVIVE = "revive"
local CHECKIN_MODE_TREATMENT = "treatment"

local function IsLocalPlayerDead(ped)
	return exports["survival"]:IsLocalPlayerDead() or GetEntityHealth(ped) <= 100
end

local function StopTreatment()
	if Treatment then
		LocalPlayer["state"]["Cancel"] = false
		LocalPlayer["state"]["Commands"] = false
		Treatment = false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Beds = {
	
	{ ["Coords"] = vec3(1124.39,-1553.7,34.9), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(1124.35,-1553.76,34.9), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(1127.27,-1553.81,34.9), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(1126.42,-1562.18,34.9), ["Heading"] = 181.42 },
	{ ["Coords"] = vec3(1123.75,-1562.13,34.9), ["Heading"] = 181.42 },
	{ ["Coords"] = vec3(1121.07,-1562.19,34.9), ["Heading"] = 181.42 },
	{ ["Coords"] = vec3(1118.67,-1562.17,34.9), ["Heading"] = 181.42 },
	{ ["Coords"] = vec3(1126.88,-1547.37,34.9), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1116.3,-1562.33,34.9), ["Heading"] = 172.92 },
	{ ["Coords"] = vec3(1126.9,-1544.04,34.9), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1126.91,-1547.32,34.9), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1126.89,-1541.1,34.9), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1126.85,-1544.14,34.9), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1126.86,-1538.34,34.9), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1126.82,-1541.16,34.9), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1113.39,-1530.2,34.76), ["Heading"] = 56.7 },
	{ ["Coords"] = vec3(1098.63,-1523.67,34.76), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(1098.49,-1520.37,34.76), ["Heading"] = 181.42 },
	{ ["Coords"] = vec3(1148.88,-1562.79,35.3), ["Heading"] = 2.84 },
	{ ["Coords"] = vec3(1133.1,-1579.83,35.31), ["Heading"] = 2.84 },
	{ ["Coords"] = vec3(1126.59,-1580.58,35.31), ["Heading"] = 274.97 },
	{ ["Coords"] = vec3(1126.91,-1541.15,34.9), ["Heading"] = 96.38 },
	{ ["Coords"] = vec3(1126.66,-1584.37,35.31), ["Heading"] = 269.3 },
	{ ["Coords"] = vec3(1126.99,-1538.33,34.9), ["Heading"] = 90.71 },
	{ ["Coords"] = vec3(1126.68,-1588.21,35.31), ["Heading"] = 260.79},
	{ ["Coords"] = vec3(1126.66,-1592.04,35.31), ["Heading"] = 260.79 },
	{ ["Coords"] = vec3(1098.44,-1520.31,34.76), ["Heading"] = 170.08 },
	{ ["Coords"] = vec3(1098.61,-1523.65,34.76), ["Heading"] = 8.51 },
	{ ["Coords"] = vec3(1113.39,-1530.29,34.76), ["Heading"] = 53.86 },
	{ ["Coords"] = vec3(1148.9,-1565.84,35.3), ["Heading"] = 189.93 },
	
	-- Nobre
	{ ["Coords"] = vec3(-245.57,6316.26,32.35), ["Heading"] = 311.82 },
    { ["Coords"] = vec3(-247.18,6318.1,32.35), ["Heading"] = 317.49 },
    { ["Coords"] = vec3(-251.07,6321.48,32.35), ["Heading"] = 314.65 },
    { ["Coords"] = vec3(-252.17,6322.89,32.35), ["Heading"] = 325.99 },
    { ["Coords"] = vec3(-257.46,6317.41,32.35), ["Heading"] = 138.9 },
    { ["Coords"] = vec3(-256.16,6315.87,32.35), ["Heading"] = 133.23 },
    { ["Coords"] = vec3(-254.51,6314.23,32.35), ["Heading"] = 130.4 },
    { ["Coords"] = vec3(-252.82,6312.38,32.35), ["Heading"] = 133.23 },
    { ["Coords"] = vec3(-251.1,6310.94,32.35), ["Heading"] = 133.23 },
    { ["Coords"] = vec3(-250.59,6310.42,32.35), ["Heading"] = 133.23 },
    { ["Coords"] = vec3(-252.21,6311.8,32.35), ["Heading"] = 130.4 },
    { ["Coords"] = vec3(-253.82,6313.83,32.35), ["Heading"] = 130.4 },
    { ["Coords"] = vec3(-255.66,6315.41,32.35), ["Heading"] = 136.07 },
    { ["Coords"] = vec3(-257.21,6317.28,32.35), ["Heading"] = 133.23 },

	-- Grande
	{ ["Coords"] = vec3(-345.01,-611.43,38.18), ["Heading"] = 300.48 },
	{ ["Coords"] = vec3(-348.07,-603.82,38.18), ["Heading"] = 209.77 },
	{ ["Coords"] = vec3(-345.01,-611.38,38.18), ["Heading"] = 303.31 },
	{ ["Coords"] = vec3(-341.18,-612.98,38.18), ["Heading"] = 28.35 },
	{ ["Coords"] = vec3(-298.77,-588.42,38.18), ["Heading"] = 34.02 },
	{ ["Coords"] = vec3(-298.73,-588.43,38.18), ["Heading"] = 31.19 },
	{ ["Coords"] = vec3(-292.25,-577.41,38.18), ["Heading"] = 119.06 },
	{ ["Coords"] = vec3(-309.16,-568.87,38.18), ["Heading"] = 212.6 }
	
	
	-- -- Hospital Saint
    -- { ["Coords"] = vec3(1124.74,-1554.48,34.96), ["Heading"] = 0.0 },
    -- { ["Coords"] = vec3(1121.26,-1554.65,34.96), ["Heading"] = 0.0 },
    -- { ["Coords"] = vec3(1117.69,-1554.75,34.96), ["Heading"] = 0.0 },
    -- { ["Coords"] = vec3(1117.84,-1563.13,34.96), ["Heading"] = 170.08 },
    -- { ["Coords"] = vec3(1121.4,-1563.03,34.96), ["Heading"] = 187.09 },
	-- { ["Coords"] = vec3(1124.82,-1563.06,34.96), ["Heading"] = 187.09 },



	-- -- Medical Center Norte
	-- { ["Coords"] = vec3(-252.15,6323.11,32.35), ["Heading"] = 133.23 },
	-- { ["Coords"] = vec3(-250.5,6321.87,32.35), ["Heading"] = 133.23 },
	-- { ["Coords"] = vec3(-246.98,6317.95,32.33), ["Heading"] = 133.23 },
	-- { ["Coords"] = vec3(-245.27,6316.22,32.35), ["Heading"] = 133.23 },
	-- { ["Coords"] = vec3(-251.03,6310.51,32.35), ["Heading"] = 317.49 },
	-- { ["Coords"] = vec3(-252.63,6312.12,32.35), ["Heading"] = 317.49 },
	-- { ["Coords"] = vec3(-254.39,6313.88,32.35), ["Heading"] = 317.49 },
	-- { ["Coords"] = vec3(-256.1,6315.58,32.35), ["Heading"] = 317.49 },
	-- { ["Coords"] = vec3(-258.03,6317.12,32.35), ["Heading"] = 317.49 },
	-- -- Boolingbroke
	-- { ["Coords"] = vec3(1761.87,2591.56,45.66), ["Heading"] = 272.13 },
	-- { ["Coords"] = vec3(1761.87,2594.64,45.66), ["Heading"] = 272.13 },
	-- { ["Coords"] = vec3(1761.87,2597.73,45.66), ["Heading"] = 272.13 },
	-- { ["Coords"] = vec3(1771.98,2597.95,45.66), ["Heading"] = 87.88 },
	-- { ["Coords"] = vec3(1771.98,2594.88,45.66), ["Heading"] = 87.88 },
	-- { ["Coords"] = vec3(1771.98,2591.79,45.66), ["Heading"] = 87.88 },	
	-- -- Clandestine
	-- { ["Coords"] = vec3(-471.87,6287.56,13.63), ["Heading"] = 53.86 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Beds) do
		AddBoxZone("Beds:"..Number,v["Coords"],1.0,1.0,{
			name = "Beds:"..Number,
			heading = v["Heading"],
			minZ = v["Coords"]["z"] - 0.01,
			maxZ = v["Coords"]["z"] + 0.55
		},{
			shop = Number,
			Distance = 1.75,
			options = {
				{
					event = "target:PutBed",
					label = _t("lay_down"),
					tunnel = "client"
				},{
					event = "target:Treatment",
					label = _t("treatment"),
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PUTBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:PutBed")
AddEventHandler("target:PutBed",function(Number)
	if not Previous then
		local Ped = PlayerPedId()
		Previous = GetEntityCoords(Ped)
		SetEntityCoords(Ped,Beds[Number]["Coords"]["x"],Beds[Number]["Coords"]["y"],Beds[Number]["Coords"]["z"],false,false,false,false)
		vRP.playAnim(false,{"amb@world_human_sunbathe@female@back@idle_a","idle_a"},true)
		SetEntityHeading(Ped,Beds[Number]["Heading"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:UpBed")
AddEventHandler("target:UpBed",function()
	if Previous then
		local Ped = PlayerPedId()
		SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"],false,false,false,false)
		Previous = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Treatment")
AddEventHandler("target:Treatment",function(Number)
	if not Previous then
		local checkInMode = vSERVER.CheckIn()

		if checkInMode then
			local ped = PlayerPedId()

			if checkInMode == CHECKIN_MODE_TREATMENT and IsLocalPlayerDead(ped) then
				return
			end

			Previous = GetEntityCoords(ped)
			TriggerEvent("inventory:preventWeapon",true)
			LocalPlayer["state"]["Commands"] = true
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("paramedic:Reset")

			if checkInMode == CHECKIN_MODE_REVIVE and IsLocalPlayerDead(ped) then
				exports["survival"]:Revive(101)
			end

			Treatment = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:StartTreatment")
AddEventHandler("target:StartTreatment",function()
	if not Treatment then
		local ped = PlayerPedId()

		if IsLocalPlayerDead(ped) then
			return
		end

		LocalPlayer["state"]["Commands"] = true
		LocalPlayer["state"]["Cancel"] = true
		Treatment = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
exports("StopTreatment",StopTreatment)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBEDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if Previous and not IsEntityPlayingAnim(Ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
			SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
			Previous = nil
		end

		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment then
			if GetGameTimer() >= TreatmentTimer then
				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)
				TreatmentTimer = GetGameTimer() + 1000

				if IsLocalPlayerDead(ped) then
					StopTreatment()
				elseif health < 400 then
					SetEntityHealth(ped,health + 4)
				else
					StopTreatment()
					--TriggerEvent("Notify","amarelo","Tratamento concluido.",5000)
					TriggerEvent("Notify2","#completedTreatment")
				end
			end
		end

		Wait(1000)
	end
end)
