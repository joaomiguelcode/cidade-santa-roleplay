DEFINE_SCRIPTED_INTERACTION 'collectible_sparkle' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'amb@code_human_wander_drinking@beer@male@base',
			name  = 'static',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'happynewyear03',
				boneId 	  = 28422,

				offsetPosition = vector3( 0.0,0.0,0.1 ),
				offsetRotation = vector3( 0.0,0.0,0.0  ),
			}
		}
	}
}

local ptfxAsset = 'des_train_crash'
local ptfxName = 'ent_ray_train_sparks_trails'
local ptfxPlacement = { 0.0, 0.0, 0.0, 0.0, 290.0, 0.0 }

---@param asset string
local function LoadParticleFxAsset( asset )
	while not HasNamedPtfxAssetLoaded( asset ) do
		RequestNamedPtfxAsset( asset )
		Wait( 10 )
	end

	return true
end

---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId )

	if interactionName ~= 'collectible_sparkle' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Sparkle :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ('ScriptedInteraction Collectible Sparkle :: failed to load particle fx asset %s!'):format( ptfxAsset ) )
		return
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
		GetEntityBoneIndexByName( prop, 'VFX' ),
		0.3,
		0,
		0,
		0
	)

	SetParticleFxLoopedColour( ptfx, 1.0, 1.0, 1.0 )
end)