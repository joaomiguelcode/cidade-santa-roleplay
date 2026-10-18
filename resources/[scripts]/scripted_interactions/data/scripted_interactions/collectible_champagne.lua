DEFINE_SCRIPTED_INTERACTION 'collectible_champagne' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'anim@mp_player_intupperspray_champagne',
			name  = 'idle_a',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'ba_prop_battle_champ_open',
				boneId 	  = 28422,

				offsetPosition = vector3( 0.0, 0.0, 0.0 ),
				offsetRotation = vector3( 0.0, 0.0, 0.0 ),
			}
		}
	}
}


local ptfxAsset = 'scr_ba_club'
local ptfxName = 'scr_ba_club_champagne_spray'
local ptfxPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }

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

	if interactionName ~= 'collectible_champagne' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Champagne :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ('ScriptedInteraction Collectible Champagne :: failed to load particle fx asset %s!'):format( ptfxAsset ) )
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
		1065353216, 
		0, 
		0, 
		0, 
		1065353216, 
		1065353216,
		1065353216, 
		0
	)

	SetParticleFxLoopedColour( ptfx, 1.0, 1.0, 1.0 )
end)