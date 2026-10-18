-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local NoClip = false
local noClipLoopRunning = false
local gNoClipAttachedObjectVisibility = {}
local NOCLIP_ATTACHED_OBJECT_REFRESH_MS = 500
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.ReturnNoClip()
	return NoClip
end

local NOCLIP_STATEBAG_KEY = "psnc"
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHED OBJECT VISIBILITY
-----------------------------------------------------------------------------------------------------------------------------------------
local function SetAttachedObjectsVisible( ped, visible )

	for _, object in ipairs(GetGamePool("CObject")) do
		if DoesEntityExist(object) and GetEntityAttachedTo(object) == ped then
			if visible then
				if gNoClipAttachedObjectVisibility[object] then
					SetEntityVisible(object,true,false)
				end

				gNoClipAttachedObjectVisibility[object] = nil
			else
				if gNoClipAttachedObjectVisibility[object] == nil then
					gNoClipAttachedObjectVisibility[object] = IsEntityVisible(object)
				end

				SetEntityVisible(object,false,false)
			end
		end
	end

	if visible then
		for object, wasVisible in pairs(gNoClipAttachedObjectVisibility) do
			if DoesEntityExist(object) and wasVisible then
				SetEntityVisible(object,true,false)
			end

			gNoClipAttachedObjectVisibility[object] = nil
		end
	end
end

local function DisableNoClipCombat()

	DisablePlayerFiring(PlayerId(), true)
	DisableControlAction(0, 24, true) -- INPUT_ATTACK
	DisableControlAction(0, 25, true) -- INPUT_AIM
end

local function applyNoClipEntityState()
	local Ped = PlayerPedId()

	LocalPlayer["state"]:set(NOCLIP_STATEBAG_KEY, true, true)
	LocalPlayer["state"]["Invincible"] = true
	LocalPlayer["state"]["Invisible"] = true

	SetEntityInvincible(Ped, true)
	SetEntityVisible(Ped, false, false)
	SetAttachedObjectsVisible(Ped, false)
	SetEntityCollision(Ped, false, false)
	SetLocalPlayerAsGhost(true)
	SetGhostedEntityAlpha(254)
	DisableNoClipCombat()
end

local function onNoClipDisabled()
	local Ped = PlayerPedId()

	SetEntityInvincible(Ped, false)
	SetEntityVisible(Ped, true, false)
	SetAttachedObjectsVisible(Ped, true)
	SetLocalPlayerAsGhost(false)

	LocalPlayer["state"]["Invisible"] = false
	LocalPlayer["state"]["Invincible"] = false

	-- ENG-504: reabilitar colisão enquanto o Child ainda está attached corrompe a física.
	-- Aplicar apenas para quem está sendo carregado (Child); quem carrega (Parent)
	-- precisa da colisão normal para conseguir andar.
	local localServerId = GetPlayerServerId(PlayerId())
	local localAttachment = sx.player.attachment.getAttachment(localServerId)

	if localAttachment?.relationKind == ePlayerAttachmentRelationKind.Child then
		SetEntityCollision(Ped, false, false)
		LocalPlayer.state:set('attachment-collision-suppressed', true, false)

		local coords = GetEntityCoords(Ped)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		SetEntityCoords(Ped, coords.x, coords.y, coords.z, false, false, false, false)
	else
		SetEntityCollision(Ped, true, true)
	end
end

local function startNoClipMovementLoop()
	if noClipLoopRunning then
		return
	end

	noClipLoopRunning = true

	CreateThread(function()
		DisplayRadar(true)
		Wait(10)
		SetBigmapActive(true, false)

		local nextAttachedObjectRefresh = 0

		while NoClip do
			local Ped = PlayerPedId()
			local Speed = 1.0
			local timer = GetGameTimer()
			local cX, cY, cZ = GetCamDirections()
			local Coords = GetEntityCoords(Ped)
			local X, Y, Z = table.unpack(Coords)

			DisableNoClipCombat()

			if timer >= nextAttachedObjectRefresh then
				SetAttachedObjectsVisible(Ped, false)
				nextAttachedObjectRefresh = timer + NOCLIP_ATTACHED_OBJECT_REFRESH_MS
			end

			if IsControlPressed(1, 21) then
				Speed = 5.0
			end

			if IsControlPressed(1, 32) then
				X = X + Speed * cX
				Y = Y + Speed * cY
				Z = Z + Speed * cZ
			end

			if IsControlPressed(1, 34) then
				X = X - Speed * cY
				Y = Y + Speed * cX
			end

			if IsControlPressed(1, 35) then
				X = X + Speed * cY
				Y = Y - Speed * cX
			end

			if IsControlPressed(1, 269) then
				X = X - Speed * cX
				Y = Y - Speed * cY
				Z = Z - Speed * cZ
			end

			if IsControlPressed(1, 10) then
				Z = Z + 0.25
			end

			if IsControlPressed(1, 11) then
				Z = Z - 0.25
			end

			SetEntityCoordsNoOffset(Ped, X, Y, Z, true, false, false)
			Wait(0)
		end

		SetBigmapActive(false, false)

		local hudConfig = exports["hud"]:GetHudConfig()
		if hudConfig.minimapStyle ~= 1 then
			DisplayRadar(false)
		end

		noClipLoopRunning = false
	end)
end

function tvRP.ReapplyNoClip()
	if not NoClip then
		return false
	end

	applyNoClipEntityState()
	startNoClipMovementLoop()

	return true
end

function tvRP.EnsureNoClipEnabled()
	if not NoClip then
		NoClip = true
		LocalPlayer["state"]:set(NOCLIP_STATEBAG_KEY, true, true)
	end

	applyNoClipEntityState()
	startNoClipMovementLoop()

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.noClip()
	NoClip = not NoClip

	LocalPlayer["state"]:set(NOCLIP_STATEBAG_KEY, NoClip, true)

	if NoClip then
		applyNoClipEntityState()
		startNoClipMovementLoop()
	else
		onNoClipDisabled()
	end
end

RegisterNetEvent("net.noclip.disable", function()
	if NoClip then
		tvRP.noClip()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCAMDIRECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCamDirections()
	local Ped = PlayerPedId()
	local Pitch = GetGameplayCamRelativePitch()
	local Heading = GetGameplayCamRelativeHeading() + GetEntityHeading(Ped)
	local x = -math.sin(Heading * math.pi / 180.0)
	local y = math.cos(Heading * math.pi / 180.0)
	local z = math.sin(Pitch * math.pi / 180.0)
	local Len = math.sqrt(x * x + y * y + z * z)
	if Len ~= 0 then
		x = x / Len
		y = y / Len
		z = z / Len
	end

	return x, y, z
end
