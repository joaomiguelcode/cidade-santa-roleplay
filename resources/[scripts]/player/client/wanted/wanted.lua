local IS_PLAYER_WANTED = false
local timeBlips = {}
local showBlips = {}
RegisterNetEvent('SetWanted')
AddEventHandler('SetWanted', function(Boolean)
    IS_PLAYER_WANTED = Boolean
end)

function IsPlayerWanted()
    return IS_PLAYER_WANTED
end
exports('IsPlayerWanted', IsPlayerWanted)


RegisterNetEvent("PushWantedBlip")
AddEventHandler("PushWantedBlip",function(id,Coords)
    if DoesBlipExist(showBlips[id]) then
        RemoveBlip(showBlips[id])
        showBlips[id] = nil
        timeBlips[id] = nil
    end
    local data = {}
    data["title"] = "! Ultima Localizacao"
    data["blipColor"] = 1
	timeBlips[id] = 10
	showBlips[id] = AddBlipForCoord(Coords["x"],Coords["y"],Coords["z"])
	SetBlipSprite(showBlips[id],1)
	SetBlipDisplay(showBlips[id],4)
    SetBlipColour(showBlips[id],1)
    SetBlipScale(showBlips[id],0.7)
    SetBlipAsShortRange(showBlips[id],true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(data["title"])
	EndTextCommandSetBlipName(showBlips[id])
end)

CreateThread(function()
	while true do
		for k,v in pairs(timeBlips) do
			if timeBlips[k] > 0 then
				timeBlips[k] = timeBlips[k] - 1
				if timeBlips[k] <= 0 then
					RemoveBlip(showBlips[k])
					showBlips[k] = nil
					timeBlips[k] = nil
				end
			end
		end
		Wait(1000)
	end
end)