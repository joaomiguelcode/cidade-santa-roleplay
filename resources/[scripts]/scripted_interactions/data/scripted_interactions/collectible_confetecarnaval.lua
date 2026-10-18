local animDict = 'poisonstoreconfettianim@animation'
local animName = 'poisonstoreconfettianim_clip'

local ptfxAsset = 'proj_xmas_firework'
local ptfxName = 'scr_firework_xmas_spiral_burst_rgw'

local HEIGHT_OFFSET_EFFECT = 1.1
local SCALE_EFFECT = 0.11
local TIME_TO_PLAY_ANIM_MS = 170

local MAX_DISTANCE_TO_SEE_EFFECT = 40.0

---@type number[]
local gPlayingInteractions = {}

DEFINE_SCRIPTED_INTERACTION 'collectible_confetecarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation = {
			dict  = animDict,
			name  = animName,
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName      = 'poisonstorecarnaval12',
				boneId         = 18905,

				offsetPosition = vector3(0.10137551098762, -0.01518442232142, 0.046003547659753),
				offsetRotation = vector3(0, 0, 34.177113068995),
			}
		}
	}
}

---@param asset string
local function LoadParticleFxAsset(asset)
	while not HasNamedPtfxAssetLoaded(asset) do
		RequestNamedPtfxAsset(asset)
		Wait(10)
	end
	return true
end

---@param entityOwnerId number
local function AddMemoryInteraction(entityOwnerId)
	gPlayingInteractions[entityOwnerId] = GetGameTimer()
end

---@param entityId number
function RemoveMemoryInteraction(entityId)
	gPlayingInteractions[entityId] = nil
end

---@param entityOwnerId number
---@param startTimeMs number
local function PlayInteraction(entityOwnerId, startTimeMs)
	if not DoesEntityExist(entityOwnerId) then
		return RemoveMemoryInteraction(entityOwnerId)
	end

	if not IsEntityPlayingAnim(entityOwnerId, animDict, animName, 3) then
		return
	end

	local duration = GetEntityAnimCurrentTime(entityOwnerId, animDict, animName)

	if not (duration > 0.7 and duration < 0.8) then --- marca o meio da animação como pointeiro
		return
	end

	local diffTimeMs = GetGameTimer() - startTimeMs
	
	if diffTimeMs < TIME_TO_PLAY_ANIM_MS then
		return
	end

	local boneId = GetPedBoneIndex(entityOwnerId, 57005)

	if not boneId then
		return
	end

	local position = GetWorldPositionOfEntityBone(entityOwnerId, boneId)
	local localPosition = GetEntityCoords(PlayerPedId())

	local distance = #(position - localPosition)

	if distance > MAX_DISTANCE_TO_SEE_EFFECT then
		return
	end

	LoadParticleFxAsset(ptfxAsset)
	UseParticleFxAssetNextCall(ptfxAsset)

	local ptfxHandle = StartParticleFxNonLoopedAtCoord(
		ptfxName,
		position.x,
		position.y,
		position.z + HEIGHT_OFFSET_EFFECT,
		0.0,
		0.0,
		0.0,
		SCALE_EFFECT,
		false,
		false,
		false
	)

	SetParticleFxLoopedColour(ptfxHandle, 1.0, 1.0, 1.0, true)
	gPlayingInteractions[entityOwnerId] = GetGameTimer()

	print('play once ptfx', ptfxHandle, startTimeMs)
end

local function PlayCollectibleInteractionThread()
	local TICK_LOOP_TIME = 100

	CreateThread(function()
		while next(gPlayingInteractions) do
			for entityOwnerId, propEntityId in pairs(gPlayingInteractions) do
				PlayInteraction(entityOwnerId, propEntityId)
			end

			Wait(TICK_LOOP_TIME)
		end
	end)
end

---@param interactionName string
---@param entityId number
AddEventHandler('scripted_interactions:onLocalScriptedInteractionStarted', function(interactionName, entityId)
	if interactionName ~= 'collectible_confetecarnaval' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId(entityId)

	assert(prop ~= nil, 'ScriptedInteraction Collectible Confete Carnaval :: prop not found!')

	if not LoadParticleFxAsset(ptfxAsset) then
		sx.logger:error(('ScriptedInteraction Collectible Confete Carnaval :: failed to load particle fx asset %s!')
			:format(ptfxAsset))
		return
	end

	local isStartThread = not next(gPlayingInteractions)

	AddMemoryInteraction(entityId)

	if isStartThread then
		PlayCollectibleInteractionThread()
	end
end)

AddEventHandler('scripted_interactions:onLocalScriptedInteractionStopped', function(interactionName, entityId)
	if interactionName ~= 'collectible_confetecarnaval' then
		return
	end
	
	if gPlayingInteractions[entityId] then
		return
	end

	RemoveMemoryInteraction(entityId)
end)