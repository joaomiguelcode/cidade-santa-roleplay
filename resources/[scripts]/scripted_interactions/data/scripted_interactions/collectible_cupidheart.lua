local MIN_TIME_CHECK_ANIMATION = 2000               -- tempo para não ficar verificando em poucos frames toda hora
local MIN_DISTANCE_TO_PLAY_PARTICLE_ANIMATION = 3.0 -- distância para jogar o efeito de partículas

local ANIMATION_NAME_PARTICLE = 'batendo_clip'
local ANIMATION_NAME_NONE = 'parado_clip'
local DICT_ANIMATION = 'clip@valentinesdaypoisonstore01'

DEFINE_SCRIPTED_INTERACTION 'collectible_cupidheart' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'valentinesdaypoisonstore01',
				boneId         = 24818,

				offsetPosition = vector3(0.423, 0.0, 0.241),
				offsetRotation = vector3(10.708, 87.954, 175.72),
			}
		}
	}
}

---@alias ScriptedInteraction.MemoryCollectibleCupidHeartKeyId number

---@class ScriptedInteraction.MemoryCollectibleCupidHeartData
---@field entityId ScriptedInteraction.MemoryCollectibleCupidHeartKeyId
---@field propEntityId number
---@field lastCheckAt number

---@alias ScriptedInteraction.PlayingInteractionCollectibleCupidHeart table<ScriptedInteraction.MemoryCollectibleCupidHeartKeyId, ScriptedInteraction.MemoryCollectibleCupidHeartData>

---@type ScriptedInteraction.PlayingInteractionCollectibleCupidHeart
local gPlayingInteractionCollectibleCupidHeart = {}

---@param entityId ScriptedInteraction.MemoryCollectibleCupidHeartKeyId
local function AddMemoryCollectibleCupidHeart(entityId, propEntityId)
	gPlayingInteractionCollectibleCupidHeart[entityId] = {
		entityId = entityId,
		propEntityId = propEntityId,
		lastCheckAt = GetGameTimer() - MIN_TIME_CHECK_ANIMATION -- forçando a animação inicial
	}
end

---@param entityId ScriptedInteraction.MemoryCollectibleCupidHeartKeyId
local function RemoveMemoryCollectibleCupidHeart(entityId)
	gPlayingInteractionCollectibleCupidHeart[entityId] = nil
end

---@param data ScriptedInteraction.MemoryCollectibleCupidHeartData
local function PlayCollectibleCupidHeart(data)
	if not (DoesEntityExist(data.propEntityId) and DoesEntityExist(data.entityId)) then
		return RemoveMemoryCollectibleCupidHeart(data.entityId)
	end

	if (GetGameTimer() - data.lastCheckAt) < MIN_TIME_CHECK_ANIMATION then
		return
	end

	data.lastCheckAt = GetGameTimer()

	local entityCoords = GetEntityCoords(data.entityId)
	local animationName = ANIMATION_NAME_NONE

	for playerId in pairs(gPlayingInteractionCollectibleCupidHeart) do
		if playerId ~= data.entityId and #(entityCoords - GetEntityCoords(playerId)) <= MIN_DISTANCE_TO_PLAY_PARTICLE_ANIMATION then
			animationName = ANIMATION_NAME_PARTICLE
			break
		end
	end

	if IsEntityPlayingAnim(data.propEntityId, DICT_ANIMATION, animationName, 3) then
		return
	end

	PlayEntityAnim(data.propEntityId, animationName, DICT_ANIMATION, 8.0, true, true, false, 0, 0)
end

local function PlayCollectibleCupidHeartThread()
	local TICK_INTERVAL = 1000

	CreateThread(function()
		while next(gPlayingInteractionCollectibleCupidHeart) do
			for _, data in pairs(gPlayingInteractionCollectibleCupidHeart) do
				PlayCollectibleCupidHeart(data)
			end
			Wait(TICK_INTERVAL)
		end

	end)
end

---@param interactionName string
---@param entityId number
AddEventHandler('scripted_interactions:onLocalScriptedInteractionStarted', function(interactionName, entityId)
	if interactionName ~= 'collectible_cupidheart' then
		return
	end

	local propEntityId = exports.scripted_interactions:getLocalScriptedInteractionPropId(entityId)

	assert(propEntityId ~= nil, 'ScriptedInteraction Collectible Cupid Heart :: prop not found!')

	RequestAnimDict(DICT_ANIMATION)
	while not HasAnimDictLoaded(DICT_ANIMATION) do
		Wait(0)
	end
	
	local isStartThread = not next(gPlayingInteractionCollectibleCupidHeart)

	AddMemoryCollectibleCupidHeart(entityId, propEntityId)

	if isStartThread then
		PlayCollectibleCupidHeartThread()
	end
end)

AddEventHandler('scripted_interactions:onLocalScriptedInteractionStopped', function(interactionName, entityId)
	if interactionName ~= 'collectible_cupidheart' then
		return
	end

	RemoveMemoryCollectibleCupidHeart(entityId)

	if not next(gPlayingInteractionCollectibleCupidHeart) then
		RemoveAnimDict(DICT_ANIMATION)
	end
end)
