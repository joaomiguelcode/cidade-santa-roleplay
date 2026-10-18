-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local vSERVER = Tunnel.getInterface("race/checkpoints")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Race = 1
local Saved = 0
local Blips = {}
local Points = 0
local Objects = {}
local Progress = 0
local Checkpoint = 1
local Actived = false
local Ranking = false
local TyreExplodes = 0
local gRaceStartBlocked = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Race"] = false

RegisterNUICallback("getMax", function(_, cb)
  cb(#RacesCheckpoints[Race]["Coords"])
end)

RegisterNUICallback("getRanking", function(_, cb)
    cb(vSERVER.Ranking(Race))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------

function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(_t("start_race_prompt"))
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end

RegisterCommand("remRank",function()
    Wait(100)
    if Actived then
        SendNUIMessage({ action = "ToggleRanking", data = false })
    end
end)

RegisterKeyMapping("remRank","remRank","keyboard","h")

local CachedBlips = {}

function DeleteBlipsRace()
    for k,v in pairs(CachedBlips) do
        RemoveBlip(v)
        CachedBlips[k] = nil
    end
    CachedBlips = {}
end

function CreateBlipsRace()
	for k,Info in pairs(RacesCheckpoints) do
		local Inits = AddBlipForCoord(Info["Init"]["x"],Info["Init"]["y"],Info["Init"]["z"])
        CachedBlips[k] = Inits
		SetBlipSprite(Inits,315)
		SetBlipDisplay(Inits,4)
		SetBlipAsShortRange(Inits,true)
		SetBlipColour(Inits,62)
		SetBlipScale(Inits,0.5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_t("illegal_race"))
		EndTextCommandSetBlipName(Inits)
	end
end

AddEventHandler("misc:CreateBlips",function(resource)
    CreateBlipsRace()
end)

AddEventHandler("misc:DeleteBlips",function(resource)
    DeleteBlipsRace()
end)

CreateThread(function()
    CreateBlipsRace()
	while true do
		local TimeDistance = 999
		if not LocalPlayer["state"]["Race"] then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			if Actived then
				TimeDistance = 100
				Points = GetGameTimer() - Saved
				SendNUIMessage({
                    action = "UpdateProgress",
                    data = {
                        Points = Points,
                        Timer = Progress - GetGameTimer()
                    }
                })

				if GetGameTimer() >= Progress or not IsPedInAnyVehicle(Ped) then
					Leave()
				end

				local Distance = #(Coords - vec3(RacesCheckpoints[Race]["Coords"][Checkpoint][1][1],RacesCheckpoints[Race]["Coords"][Checkpoint][1][2],RacesCheckpoints[Race]["Coords"][Checkpoint][1][3]))
				if Distance <= 5 then
					if Checkpoint >= #RacesCheckpoints[Race]["Coords"] then
						SendNUIMessage({ action = "setVisible", data = false })
						vSERVER.Finish(Race,Points)
						CleanObjects()
						CleanBlips()

						Race = 1
						Saved = 0
						Points = 0
						Checkpoint = 1
						Actived = false
					else
						if DoesBlipExist(Blips[Checkpoint]) then
							RemoveBlip(Blips[Checkpoint])
							Blips[Checkpoint] = nil
						end

						SendNUIMessage({ action = "UpdateCheckpoint", data = Checkpoint })
						SetBlipRoute(Blips[Checkpoint + 1],true)
						Checkpoint = Checkpoint + 1
						MakeObjects()
					end
				end
			elseif LocalPlayer.state['minigame:active'] then
				if not gRaceStartBlocked then
					SendNUIMessage({ action = "setVisible", data = false })
					Ranking = false
					gRaceStartBlocked = true
				end
			else
				gRaceStartBlocked = false
				for Number,v in pairs(RacesCheckpoints) do
					local Distance = #(Coords - v["Init"])
					if Distance <= 25 then
						local Vehicle = GetVehiclePedIsUsing(Ped)
						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
                            DrawText3D(v["Init"]["x"],v["Init"]["y"],v["Init"]["z"] + 0.5,"[~g~E~w~] Iniciar Corrida")
							DrawMarker(5,v["Init"]["x"],v["Init"]["y"],v["Init"]["z"] - 0.4,0.0,0.0,5.0,0.0,0.0,0.0,10.0,10.0,10.0,162,124,219,100,0,0,0,0)
							TimeDistance = 1

							if Distance <= 5 then
								SendNUIMessage({ action = "setVisible", data = "races" })
								if IsControlJustPressed(1,74) then
									Ranking = not Ranking
									SendNUIMessage({ action = "ToggleRanking", data = false })
								end

								if IsControlJustPressed(1,38) then
									if vSERVER.Start(Number) then
										SendNUIMessage({ action = "ToggleCheckpoint", data = true })
										Progress = GetGameTimer() + (v["Timer"] * 1000)
										Saved = GetGameTimer()
										Checkpoint = 1
										Race = Number
										Points = 0

										MakeBlips()
										MakeObjects()

										Actived = true
									end
								end
							elseif (Distance > 5) and (not Actived) then
								SendNUIMessage({ action = "setVisible", data = false })
								Ranking = false
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeBlips()
	for Number = 1,#RacesCheckpoints[Race]["Coords"] do
		Blips[Number] = AddBlipForCoord(RacesCheckpoints[Race]["Coords"][Number][1][1],RacesCheckpoints[Race]["Coords"][Number][1][2],RacesCheckpoints[Race]["Coords"][Number][1][3])
		SetBlipSprite(Blips[Number],1)
		SetBlipColour(Blips[Number],60)
		SetBlipScale(Blips[Number],0.85)
		SetBlipRoute(Blips[Checkpoint],true)
		ShowNumberOnBlip(Blips[Number],Number)
		SetBlipAsShortRange(Blips[Number],true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function MakeObjects()
	for Number,Object in pairs(Objects) do
		if DoesEntityExist(Object) then
			DeleteEntity(Object)
			Objects[Number] = nil
		end
	end

	if LoadModel("prop_offroad_tyres02") then
		Objects[1] = CreateObjectNoOffset("prop_offroad_tyres02",RacesCheckpoints[Race]["Coords"][Checkpoint][2][1],RacesCheckpoints[Race]["Coords"][Checkpoint][2][2],RacesCheckpoints[Race]["Coords"][Checkpoint][2][3],false,false,false)
		Objects[2] = CreateObjectNoOffset("prop_offroad_tyres02",RacesCheckpoints[Race]["Coords"][Checkpoint][3][1],RacesCheckpoints[Race]["Coords"][Checkpoint][3][2],RacesCheckpoints[Race]["Coords"][Checkpoint][3][3],false,false,false)

		PlaceObjectOnGroundProperly(Objects[1])
		PlaceObjectOnGroundProperly(Objects[2])

		SetEntityCollision(Objects[1],false,false)
		SetEntityCollision(Objects[2],false,false)

		SetEntityLodDist(Objects[1],0xFFFF)
		SetEntityLodDist(Objects[2],0xFFFF)

		SetModelAsNoLongerNeeded("prop_offroad_tyres02")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanBlips()
	for Number,Bliped in pairs(Blips) do
		if DoesBlipExist(Bliped) then
			RemoveBlip(Bliped)
			Blips[Number] = nil
		end
	end

	Blips = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanObjects()
	for Number,Object in pairs(Objects) do
		if DoesEntityExist(Object) then
			DeleteEntity(Object)
			Objects[Number] = nil
		end
	end

	Objects = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Leave()
    SetNuiFocus(false,false)
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
	vSERVER.Cancel()
	Actived = false

	CleanObjects()
	CleanBlips()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTYREEXPLODES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if not Actived then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				TimeDistance = 1

				--DisableControlAction(0,345,true)

				local Vehicle = GetVehiclePedIsUsing(Ped)
				if GetPedInVehicleSeat(Vehicle,-1) == Ped then
					local Speed = GetEntitySpeed(Vehicle) * 3.6
					if Speed ~= TyreExplodes then
						if (TyreExplodes - Speed) >= 125 then
							local Tyre = math.random(4)
							if Tyre == 1 then
								if GetTyreHealth(Vehicle,0) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,0,true,1000.0)
								end
							elseif Tyre == 2 then
								if GetTyreHealth(Vehicle,1) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,1,true,1000.0)
								end
							elseif Tyre == 3 then
								if GetTyreHealth(Vehicle,4) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,4,true,1000.0)
								end
							elseif Tyre == 4 then
								if GetTyreHealth(Vehicle,5) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,5,true,1000.0)
								end
							end
						end

						TyreExplodes = Speed
					end
				end
			else
				if TyreExplodes ~= 0 then
					TyreExplodes = 0
				end
			end
		end

		Wait(TimeDistance)
	end
end)
