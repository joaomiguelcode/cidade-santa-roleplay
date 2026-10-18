-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("party")

local function IsAffiliateWorldClientActive()
	return GetResourceState("new_hub") == "started" and exports.new_hub:IsAffiliateWorldClientActive()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Party99",function(source,Message)
	if IsAffiliateWorldClientActive() then
		return
	end

	SendNUIMessage({ action = "open", data = vSERVER.List() })

	if vSERVER.ShouldShowTutorial() then
		SendNUIMessage({
			action = "tutorialParty:start",
			data = {
				steps = {
					{
						target = '[data-tutorial-target="create-room"]',
						placement = "left",
						title = _t("PartyTutorialCreateRoomTitle"),
						content = _t("PartyTutorialCreateRoomContent"),
						advanceOnEvent = "party:room-created"
					},
					{
						target = '[data-tutorial-target="room-card-first"]',
						placement = "right",
						title = _t("PartyTutorialEnterRoomTitle"),
						content = _t("PartyTutorialEnterRoomContent"),
						advanceOnClick = true,
						closeOnEscape = true
					}
				}
			}
		})
	end

	SetNuiFocus(true,true)
end)

RegisterNUICallback("tutorialParty:finished",function(Data,Callback)
	vSERVER.MarkTutorialSeen()
	Callback("Ok")
end)

RegisterNUICallback("tutorialParty:skipped",function(Data,Callback)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEROOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("createRoom",function(Data,Callback)
	Callback(vSERVER.Create(Data["name"],Data["password"],Data["type"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXITROOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("exitRoom",function(Data,Callback)
	Callback(vSERVER.Exit())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERROOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("enterRoom",function(Data,Callback)
	Callback(vSERVER.Enter(Data["name"],Data["password"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Party99", _t("Party"), "keyboard", "J")

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)
