DEFINE_SCRIPTED_INTERACTION 'collectible_fichacassino' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		props =
		{
			{
				modelName = 'fichaanim',
				boneId 	  = 24818,

				offsetPosition = vector3(0.45, 0.05, 0.22),
				offsetRotation = vector3(0.0, 85.0, -1.0),

				animDict = 'clip@fichaanim',
				animName = 'fichaanim',
			}
		}
	}
}


local ptfxAsset = 'scr_gr_def'
local ptfxName = 'scr_gr_warp_in'
local ptfxPlacement = { 0.0, 0.0, 0.0, 0.0, 90.0, 0.0 }
local ptfxScale = 0.08
local ptfxInterval = 4000

---@param asset string
local function LoadParticleFxAsset( asset )
	while not HasNamedPtfxAssetLoaded( asset ) do
		RequestNamedPtfxAsset( asset )
		Wait( 10 )
	end

	return true
end

---@type number[]
local gRuningInteractions = {}

---@param entityId number
local function AddMemoryFichaCassinoInteraction( entityId )
	if gRuningInteractions[entityId] then
		return
	end

	gRuningInteractions[entityId] = entityId
end

---@param entityId number
local function RemoveMemoryFichaCassinoInteraction( entityId )
	gRuningInteractions[entityId] = nil
end

---@param entityId number
local function PlayFichaCassinoInteraction( entityId )
	if not (DoesEntityExist(entityId) and DoesEntityExist(gRuningInteractions[entityId])) then
		return RemoveMemoryFichaCassinoInteraction(entityId)
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	if not (prop and LoadParticleFxAsset( ptfxAsset ) and DoesEntityExist(prop)) then
		return RemoveMemoryFichaCassinoInteraction(entityId)
	end

	UseParticleFxAssetNextCall( ptfxAsset )

	local ptfx = StartNetworkedParticleFxLoopedOnEntityBone(
		ptfxName,
		prop, 
		ptfxPlacement[ 1 ], 
		ptfxPlacement[ 2 ], 
		ptfxPlacement[ 3 ], 
		ptfxPlacement[ 4 ], 
		ptfxPlacement[ 5 ], 
		ptfxPlacement[ 6 ], 
		GetEntityBoneIndexByName( prop, 'Bone.008' ), 
		ptfxScale, 
		0, 
		0, 
		0, 
		1065353216, 
		1065353216,
		1065353216, 
		0
	)

	SetParticleFxLoopedColour( ptfx, 1.0, 1.0, 1.0 )
end

local function PlayFichaCassinoInteractionThread()
	local TICK_INTERVAL = ptfxInterval

	CreateThread(function()
		while next(gRuningInteractions) do
			for _, entityId in pairs(gRuningInteractions) do
				PlayFichaCassinoInteraction(entityId)
			end
			Wait(TICK_INTERVAL)
		end
	end)
end

---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId )

	if interactionName ~= 'collectible_fichacassino' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Ficha Cassino :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ('ScriptedInteraction Collectible Ficha Cassino :: failed to load particle fx asset %s!'):format( ptfxAsset ) )
		return
	end

	local isStartThread = not next(gRuningInteractions)

	if isStartThread then
		PlayFichaCassinoInteractionThread()
	end

	AddMemoryFichaCassinoInteraction(entityId)
end)

AddEventHandler('scripted_interactions:onLocalScriptedInteractionStopped', function(interactionName, entityId)
	if interactionName ~= 'collectible_fichacassino' then
		return
	end

	RemoveMemoryFichaCassinoInteraction(entityId)
end)