
---@type DoorId | nil
local gInteractingDoorId = nil

local gNetworkTimeLastRequestedDoorsState = nil

--[[
---@param index number
---@return Door
local function GetDoorByIndex(index)
	local door = gDoors[index]

	assert(door, ('Door not found with index=%s'):format(index) )

	return door
end
--]]

---@param position vector3
local function GetDoorsNearPosition(position)
	local cellX, cellY = GetWorldGridCellXYFromPosition(position)

	local worldGridCell = GetWorldGridCell(cellX, cellY)

	assert( worldGridCell )

	return worldGridCell.doors or { }
end

local function UpdateInteractingDoorUiAction()
    if gInteractingDoorId then
        local door = GetDoorById(gInteractingDoorId)

        TriggerEvent("hoverfy:toggle", true, { title = door.lockState and _t("locked") or _t("unLocked"), key = "E", legend = door.lockState and _t("toLock") or  _t("toUnlock") })
    else
        TriggerEvent("hoverfy:toggle", false)
    end
end

local function TickDoorSystem()
	local playerPedId = PlayerPedId()
	local playerPos = GetEntityCoords(playerPedId)

	--- A porta que estamos interagindo atualmente
	---@type Door | nil
	local interactingDoorThisFrame = gInteractingDoorId and GetDoorById(gInteractingDoorId) or nil

	---@param door Door
	---@return boolean
	local function Scoped__CanInteractWithDoor(door)
		local distance = #(door.position - playerPos)

		return distance < door.interactionDist
	end

	---@param door Door | nil
	local function Scoped__SetInteractingDoor(door)

if DOORSYSTEM_DEBUG then
		print(
			door
				and ('Started interacting with door with doorId=%s'):format( door.id )
				or 	('Stopped interacting with door with doorId=%s'):format( gInteractingDoorId or '?' )
			)
end

		gInteractingDoorId = door and door.id or nil

		interactingDoorThisFrame = door

		UpdateInteractingDoorUiAction()
	end

	-- Não estamos interagindo com nenhuma porta, vamos procurar uma!
	if not interactingDoorThisFrame then

		local cell = GetWorldGridCellFromPosition( playerPos )

		assert( cell )

		--[[ Só vamos verificar as portas que estão na mesma grid que o jogador ]]
		local doors = cell.doors

		for _, door in ipairs( doors ) do
			if Scoped__CanInteractWithDoor(door) then

				Scoped__SetInteractingDoor(door)

				--[[ Só queremos uma porta por vez? ]]
				break
			end
		end
	end

	if interactingDoorThisFrame then

        local door = interactingDoorThisFrame

		if not Scoped__CanInteractWithDoor(door) then
			Scoped__SetInteractingDoor(nil)

			--[[ A porta parou de ser interagivel, vamos pular esse tick! ]]
			return
		end

		if IsControlJustPressed(1, 38) and not vRP.ReturnNoClip() then
            if GetResourceState("sleepless_interact") == "started" then
                if not exports["sleepless_interact"].getDuiStatus() then
                    TriggerServerEvent('toggleDoorLockState', door.id)
                end
            else
                TriggerServerEvent('toggleDoorLockState', door.id)
            end
            --[[
                Isso daqui não é real, a gente só tá "prevendo" que o servidor vai aceitar esse update,
                então a gente muda antes do servidor mudar para a gente,
                mas se o servidor recusar, o estado vai ser alterado para o anterior!
            --]]
            -- SetDoorLockState(door, not door.lockState)
		end
	end
end

---@param door Door
---@param lockState DoorLockState
function OnSetDoorLockState(door, lockState)

if DOORSYSTEM_DEBUG then
    -- print( ('OnSetDoorLockState door=%d lockState=%s'):format(door.id, lockState) )
end

    local state =
        lockState == true
        and
            1 --[[ DOORSTATE_LOCKED   ]]
        or
            0 --[[ DOORSTATE_UNLOCKED ]]

if DOORSYSTEM_DEBUG then
    print( ('OnSetDoorLockState door=%d lockState=%s state=%d'):format(door.id, lockState, state) )
end

	local doorHash = door.hash

    DoorSystemSetOpenRatio(doorHash, 0.0, false --[[ network ]], false --[[ flushState ]])
	DoorSystemSetAutomaticRate(doorHash, 2.0, false --[[ network ]], false --[[ flushState ]])
	DoorSystemSetDoorState(doorHash, state, false --[[ network ]], true --[[ flushState ]])

if DOORSYSTEM_DEBUG then
	print( ('OnSetDoorLockState door=%d newState=%d'):format(door.id, DoorSystemGetDoorState(doorHash) ) )
end

	UpdateInteractingDoorUiAction()
end

CreateThread(function()

	-- TickWorldGrid depende do sx
	while not sx do
		Wait( 0 )
	end

	while true do

		local fc = GetFrameCount()

		TickWorldGrid(fc)

		TickDoorSystem()

		--[[ Wait(0) quando interagindo (precisa de IsControlJustPressed), senão 250ms basta pra scan de proximidade ]]
		Wait(gInteractingDoorId and 0 or 250)
	end
end)

---@param doorId DoorId
---@param state DoorState
local function OnNetworkDoorState(doorId, state)
if DOORSYSTEM_DEBUG then
    print( ('OnNetworkDoorState doorId=%d state=%s'):format(doorId, state) )
end

    local door = GetDoorById(doorId)

    SetDoorLockState(door, state)
end

---@param data table<DoorId, DoorState>
local function OnNetworkDoorsState(data)
if DOORSYSTEM_DEBUG then
    print( ('OnNetworkDoorsState data=%s'):format( json.encode(data) ) )
end

    for doorId, state in pairs(data) do

        local lockState = state

        xpcall(
            function()
                local door = GetDoorById(doorId)

                SetDoorLockState(door, lockState)
            end,
            function(err)
                print( ('An error occurred while trying to set a door\'s lock state! doorId=%d lockState=%s. %s'):format(doorId, lockState, err) )
            end
        )
    end
end

RegisterNetEvent('doorState', OnNetworkDoorState)
RegisterNetEvent('doorsState', OnNetworkDoorsState)


local ANIMATION_DICT = "veh@mower@base"
local ANIMATION_NAME = "start_engine"
local ANIMATION_DURATION_MS = 2000

-- Tocar animação de destrancar porta
RegisterNetEvent('door:playUnlockAnimation', function()
	LocalPlayer["state"]["Buttons"] = true
    LocalPlayer["state"]["Cancel"] = true

    local playerPed = PlayerPedId()
    
    -- Carregar a animação
    RequestAnimDict(ANIMATION_DICT)
    while not HasAnimDictLoaded(ANIMATION_DICT) do
        Wait(10)
    end
    
    SetPedConfigFlag( PlayerPedId(), 104, false ) 
    TaskPlayAnim(playerPed, ANIMATION_DICT, ANIMATION_NAME, 8.0, 8.0, -1, 48, 0, false, false, false)

	Wait(ANIMATION_DURATION_MS)

	LocalPlayer["state"]["Buttons"] = false
    LocalPlayer["state"]["Cancel"] = false

	ClearPedTasks(playerPed)
	SetPedConfigFlag( PlayerPedId(), 104, true ) 
end)