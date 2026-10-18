DEFINE_SCRIPTED_INTERACTION 'collectible_greenbeer' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@bebida',
			name  = 'bebida_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'bebida',
				boneId 	  = 18905,

				offsetPosition = vector3( 0.19, 0.00, 0.06 ),
				offsetRotation = vector3( 0.0, 160.0, 0.0 ),
			}
		}
	}
}


local ptfxAsset = 'core'
local ptfxName = 'ent_amb_tnl_bubbles_sml'
local ptfxPlacement = { 0.0, 0.13, 0.0, 0.0, 0.0, 90.0 }

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
	if interactionName ~= 'collectible_greenbeer' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Green Beer :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ('ScriptedInteraction Collectible Green Beer :: failed to load particle fx asset %s!'):format( ptfxAsset ) )
		return
	end

	UseParticleFxAssetNextCall( ptfxAsset )
	SetParticleFxNonLoopedEmitterScale( 0.2, 0.2, 0.2 )

	local ptfx = StartNetworkedParticleFxLoopedOnEntityBone( -- todo: resolver
		ptfxName,
		prop, 
		ptfxPlacement[ 1 ], 
		ptfxPlacement[ 2 ], 
		ptfxPlacement[ 3 ], 
		ptfxPlacement[ 4 ], 
		ptfxPlacement[ 5 ], 
		ptfxPlacement[ 6 ], 
		GetEntityBoneIndexByName( prop, 'VFX' ), 
		0.4, 
		0, 
		0, 
		0, 
		1065353216, 
		1065353216,
		1065353216, 
		0
	)

	SetParticleFxLoopedColour( ptfx, 0.255, 0.255, 0.255 )

	SetWind(0)
	SetWindDirection(0.0)
	SetWindSpeed(0.0)

end)