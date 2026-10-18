-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Markers = {}
local Players = {}
local Pause = false
local Active = false
LocalPlayer["state"]["Player"] = GetPlayerServerId(PlayerId())
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLORS
-----------------------------------------------------------------------------------------------------------------------------------------
local Colors = {
	["Policia"] = 63,
    ["Tatica"] = 63,
    ["Militar"] = 63,
	["PoliciaPrisional"] = 63,
    ["Federal"] = 63,
	["Prf"] = 63,
    ["Civil"] = 63,
    ["Exercito"] = 63,
	["Paramedic"] = 6,
	["Corredor"] = 32,
    ["BANDIDO PROCURADO"] = 1,
    ["Grupo"] = 0,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORSTART
-----------------------------------------------------------------------------------------------------------------------------------------
for Index,_ in pairs(Colors) do
	AddStateBagChangeHandler(Index,("player:%s"):format(LocalPlayer["state"]["Player"]),function(Name,Key,Value)
		Active = Key

		Citizen.Trace( ('$\nLocalPlayer "%s" state changed! value=%s^\n'):format(
			Key,
			Value
		))

		if not Value then
			Active = false
			CleanMarkers()
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
--[=[
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] and Colors[Active] then

			local Users = vSERVER.UsersMarkers() or {}
			for Index,v in pairs(Users) do
				if Markers[Index] then
					async(function()
						MoveBlipSmooth(Markers[Index],v["Coords"])
					end)
				else
					Markers[Index] = AddBlipForCoord(v["Coords"])
					SetBlipSprite(Markers[Index],1)
					SetBlipDisplay(Markers[Index],2)
					SetBlipAsShortRange(Markers[Index],true)
					SetBlipColour(Markers[Index],Colors[v["Service"]])
					SetBlipScale(Markers[Index],0.7)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("! "..v["Service"])
					EndTextCommandSetBlipName(Markers[Index])
				end
			end
		end

		Wait(5000)
	end
end)
--]=]
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayersMarkers()
	local Selected = {}
	local GamePool = GetGamePool("CPed")

	for _,_player in ipairs(GetActivePlayers()) do
		Selected[GetPlayerServerId(_player)] = true
	end
	--[[ for _,Entity in pairs(GamePool) do
		local Index = NetworkGetPlayerIndexFromPed(Entity)

		if Index and IsPedAPlayer(Entity) and NetworkIsPlayerConnected(Index) then
			Selected[GetPlayerServerId(Index)] = true
		end
	end ]]

	return Selected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANMARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanMarkers()
	for Index,v in pairs(Markers) do
		if DoesBlipExist(v) then
			RemoveBlip(v)
		end
	end

	Citizen.Trace( ('$\nCleaned blips!\n^\n') )

	Markers = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVEBLIPSMOOTH
-----------------------------------------------------------------------------------------------------------------------------------------
function MoveBlipSmooth(Blip,Coords)
	local Timer = 0.0
	local Delay = GetGameTimer()
	local Start = GetBlipCoords(Blip)

	while Timer < 1.0 do
		if GetTimeDifference(GetGameTimer(),Delay) > 10 then
			Delay = GetGameTimer()
			Timer = Timer + 0.01

			if DoesBlipExist(Blip) then
				SetBlipCoords(Blip,Start - (Timer * (Start - Coords)))
			else
				Timer = 1.0
			end
		end

		Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("markers:Add")
AddEventHandler("markers:Add",function(Source,Permission,Type)
	Players[Source] = Permission
    if Type then
        Active = Type
    end

	Citizen.Trace( ('$\nMarker added!\n\tsource=%s\n\tpermission=%s\n^\n'):format(
		Index,
		Permission
	))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("markers:Remove")
AddEventHandler("markers:Remove",function(Source)
	if Players[Source] then
		if Markers[Source] then
			if DoesBlipExist(Markers[Source]) then
				RemoveBlip(Markers[Source])
			end

			Markers[Source] = nil
		end

		Players[Source] = nil

		Citizen.Trace( ('$\nMarker removed!\nsource=%s\npermission=%s\n^\n'):format(
			Index,
			Permission
		))
	end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)