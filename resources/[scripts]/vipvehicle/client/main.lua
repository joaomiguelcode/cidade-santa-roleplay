Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vServer = Tunnel.getInterface("vipvehicle")

local gVipVehicleNotificationGeneration = 0
local gVipVehicleNotificationActive = false

---@return boolean
local function IsVipVehicleUiBlocked()
	-- dminigames seta false (não nil) ao sair/reiniciar
	return LocalPlayer.state["minigame:active"] and true or false
end

---@param response table?
local function OpenRedeemFrame(response)
	if IsVipVehicleUiBlocked() then
		return
	end

	local payload = type(response) == "table" and response.data or nil

	if type(response) ~= "table" or response.success ~= true or type(payload) ~= "table" or type(payload.slots) ~= "table" then
		SetNuiFocus(false, false)
		SendNUIMessage({ action = "close" })
		TriggerEvent("Notify", "vermelho", (type(response) == "table" and response.message) or _t("server.error.load_failed"), 5000)
		return
	end

	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "openRedeem",
		data = { kind = "vehicle", slots = type(payload.slots) == "table" and payload.slots or {} },
	})
end

local function CloseRedeemFrame()
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "close" })
end

local function StartVipVehicleNotification()
	if gVipVehicleNotificationActive then
		return
	end

	gVipVehicleNotificationActive = true
	gVipVehicleNotificationGeneration = gVipVehicleNotificationGeneration + 1
	local generation = gVipVehicleNotificationGeneration

	local function Notify()
		if not gVipVehicleNotificationActive or generation ~= gVipVehicleNotificationGeneration then
			return
		end

		if not LocalPlayer.state["minigame:active"] then
			TriggerEvent("Notify2", "#rescueVeicVip")
		end

		SetTimeout(30000, Notify)
	end

	Notify()
end

local function StopVipVehicleNotification()
	if not gVipVehicleNotificationActive then
		return
	end

	gVipVehicleNotificationActive = false
	gVipVehicleNotificationGeneration = gVipVehicleNotificationGeneration + 1
end

RegisterNUICallback("getCityName", function(_, callback)
	callback(GetConvar("cityName", ""))
end)

RegisterNUICallback("testDrive", function(data, callback)
	local model = type(data) == "table" and data.id or nil

	if type(model) ~= "string" or model == "" then
		return callback({ success = false, message = "Veículo inválido para test-drive." })
	end
	
	if not IsModelValid(GetHashKey(model)) then
		return callback({ success = false, message = "Veículo inválido para test-drive." })
	end

	local response = vServer.BeginTestDrive(model)

	callback(response or { success = false, message = "O servidor não respondeu." })

	if response and response.success then
		CreateThread(function()
			RunVipVehicleTestDrive(model)
		end)
	end
end)

RegisterNUICallback("redeemVehicles", function(data, callback)
	if
		type(data) ~= "table"
		or (type(data.selections) ~= "table" and type(data.ids) ~= "table")
	then
		callback({ success = false, message = _t("server.error.invalid_selection") })
		return
	end

	local response = vServer.RedeemVehicles({
		selections = data.selections,
		ids = data.ids,
	})

	if type(response) ~= "table" or type(response.success) ~= "boolean" then
		response = { success = false, message = _t("client.error.unconfirmed_redemption") }
	end

	callback(response)

	if not response.success then
		TriggerEvent(
			"Notify",
			"vermelho",
			response.message or _t("client.error.unconfirmed_redemption"),
			5000
		)
	end
end)

RegisterNUICallback("hideFrame", function(_, callback)
	CloseRedeemFrame()
	callback({ success = true })
end)

RegisterNetEvent("vipvehicle:Open", function()
	OpenRedeemFrame(vServer.GetRedeemSession())
end)

RegisterNetEvent("vipvehicle:Close", function()
	CloseRedeemFrame()
end)

RegisterNetEvent("vipvehicle:PendingUpdated", function()
	StartVipVehicleNotification()
end)

local playerServerId = GetPlayerServerId(PlayerId())

AddStateBagChangeHandler("VehicleVip", ("player:%s"):format(playerServerId), function(_, _, value)
	if value then
		StartVipVehicleNotification()
	else
		StopVipVehicleNotification()
	end
end)

local gVipVehicleWasInMinigame = false

AddStateBagChangeHandler("minigame:active", ("player:%s"):format(playerServerId), function(_, _, value)
	if value then
		gVipVehicleWasInMinigame = true
		CloseRedeemFrame()
		return
	end

	if not gVipVehicleWasInMinigame then
		return
	end

	gVipVehicleWasInMinigame = false

	if gVipVehicleNotificationActive then
		TriggerEvent("Notify2", "#rescueVeicVip")
	end
end)
