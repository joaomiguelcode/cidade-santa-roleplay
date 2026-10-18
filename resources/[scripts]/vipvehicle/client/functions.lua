---@param vehicle number
function SetVehicleTuning(vehicle)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false)
	SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false)
	SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false)
	SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false)
	ToggleVehicleMod(vehicle, 18, true)
end

---@param model string
---@return table
function RunVipVehicleTestDrive(model)
	local ped = PlayerPedId()
	local hash = GetHashKey(model)

	SetNuiFocus(false, false)
	SendNUIMessage({ action = "close" })
	DoScreenFadeOut(500)
	TriggerEvent("hud:Active", false)

	while not IsScreenFadedOut() do
		Wait(0)
	end

	local destination = vector4(-967.14, -3356.71, 13.93, 59.53)

	SetEntityCoords(ped, destination.x, destination.y, destination.z)
	SetEntityHeading(ped, destination.w)
	RequestModel(hash)

	local loadDeadline = GetGameTimer() + 10000

	while not HasModelLoaded(hash) and GetGameTimer() < loadDeadline do
		Wait(0)
	end

	if not HasModelLoaded(hash) then
		vServer.EndTestDrive()
		DoScreenFadeIn(500)
		TriggerEvent("hud:Active", true)
		sx.logger:error(("[vipvehicle] Timeout ao carregar modelo. model=%s"):format(model))
		return { success = false, message = "O veículo não pôde ser carregado." }
	end

	local vehicle = CreateVehicle(hash, destination.x, destination.y, destination.z, destination.w, false, false)

	if not DoesEntityExist(vehicle) then
		SetModelAsNoLongerNeeded(hash)
		vServer.EndTestDrive()
		DoScreenFadeIn(500)
		TriggerEvent("hud:Active", true)
		sx.logger:error(("[vipvehicle] Falha ao criar veículo. model=%s"):format(model))
		return { success = false, message = "O veículo não pôde ser criado." }
	end

	SetVehicleEngineOn(vehicle, true, true, true)
	SetPedIntoVehicle(ped, vehicle, -1)
	SetVehicleTuning(vehicle)
	SetVehicleDirtLevel(vehicle, 0)
	DoScreenFadeIn(750)

	while not IsScreenFadedIn() do
		Wait(0)
	end

	TriggerEvent("hud:Active", true)
	TriggerEvent("Notify:Text", "Saia do carro para finalizar o test-drive! [F]")

	while DoesEntityExist(vehicle) and IsPedInVehicle(ped, vehicle, false) do
		Wait(0)
	end

	DoScreenFadeOut(500)

	while not IsScreenFadedOut() do
		Wait(0)
	end

	TriggerEvent("Notify:Text", "")
	TriggerEvent("hud:Active", false)

	if DoesEntityExist(vehicle) then
		DeleteVehicle(vehicle)
		DeleteEntity(vehicle)
	end

	SetModelAsNoLongerNeeded(hash)
	local response = vServer.EndTestDrive()
	DoScreenFadeIn(500)

	while not IsScreenFadedIn() do
		Wait(0)
	end

	TriggerEvent("hud:Active", true)

	return response
end
