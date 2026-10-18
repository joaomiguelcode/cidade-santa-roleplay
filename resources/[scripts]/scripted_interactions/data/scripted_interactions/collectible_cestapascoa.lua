DEFINE_SCRIPTED_INTERACTION 'collectible_cestapascoa' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@cesta',
			name  = 'cesta_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'cesta',
				boneId 	  = 57005,

				offsetPosition = vector3(-0.01, -0.23, -0.05),
				offsetRotation = vector3(5.45, 13.09, 8.73),
			}
		}
	}
}


local ptfxAsset = 'scr_gr_def'
local ptfxName = 'scr_gr_warp_in'
local ptfxPlacement = { 0.0, 0.15, 0.0, 0.0, -90.0, 0.0 }
local ptfxScale = 0.10
local ptfxInterval = 3000

---@param asset string
local function LoadParticleFxAsset( asset )
	while not HasNamedPtfxAssetLoaded( asset ) do
		RequestNamedPtfxAsset( asset )
		Wait( 10 )
	end

	return true
end

---@type number[]
local gRunningCestaPascoaInteractions = {}

---@param entityId number
local function AddMemoryCestaPascoaInteraction( entityId )
	if gRunningCestaPascoaInteractions[ entityId ] then
		return
	end

	gRunningCestaPascoaInteractions[ entityId ] = entityId
end

---@param entityId number
local function RemoveMemoryCestaPascoaInteraction( entityId )
	gRunningCestaPascoaInteractions[ entityId ] = nil
end

---@param entityId number
local function PlayCestaPascoaParticle( entityId )
	if not ( DoesEntityExist( entityId ) and DoesEntityExist( gRunningCestaPascoaInteractions[ entityId ] ) ) then
		return RemoveMemoryCestaPascoaInteraction( entityId )
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	if not ( prop and LoadParticleFxAsset( ptfxAsset ) and DoesEntityExist( prop ) ) then
		return RemoveMemoryCestaPascoaInteraction( entityId )
	end

	local boneIdx = GetEntityBoneIndexByName( prop, 'ROOT' )
	if boneIdx == -1 then
		boneIdx = 0
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
		boneIdx,
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

local function PlayCestaPascoaParticleThread()
	local TICK_INTERVAL = ptfxInterval

	CreateThread( function()
		while next( gRunningCestaPascoaInteractions ) do
			for _, entityId in pairs( gRunningCestaPascoaInteractions ) do
				PlayCestaPascoaParticle( entityId )
			end
			Wait( TICK_INTERVAL )
		end
	end )
end

---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId )

	if interactionName ~= 'collectible_cestapascoa' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Cesta Pascoa :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ( 'ScriptedInteraction Collectible Cesta Pascoa :: failed to load particle fx asset %s!' ):format( ptfxAsset ) )
		return
	end

	local isStartThread = not next( gRunningCestaPascoaInteractions )
	
	AddMemoryCestaPascoaInteraction( entityId )
	if isStartThread then
		PlayCestaPascoaParticleThread()
	end
end )

AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStopped', function( interactionName, entityId )
	if interactionName ~= 'collectible_cestapascoa' then
		return
	end

	RemoveMemoryCestaPascoaInteraction( entityId )
end )


-- simplesmente a animação não carregava por nenhum motivo pelo menos na branch que eu estava criando isso kkkk
CreateThread(function()

	if IsDuplicityVersion() then
		return
	end

	RequestAnimDict('clip@cesta')
	while not HasAnimDictLoaded('clip@cesta') do
		Wait(100)
	end
end)