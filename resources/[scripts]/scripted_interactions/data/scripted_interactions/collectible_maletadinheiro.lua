DEFINE_SCRIPTED_INTERACTION 'collectible_maletadinheiro' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@maletadinheiro',
			name  = 'maletadinheiro_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'maletadinheiro',
				boneId 	  = 28422,

				offsetPosition = vector3(0.05, 0.05, -0.17),
				offsetRotation = vector3(104.73, -21.82, 46.91),
			}
		}
	}
}

local ptfxAsset = 'scr_xs_celebration'
local ptfxName = 'scr_xs_money_rain_celeb'
local ptfxPlacement = { 0.0, 0.0, 0.0, 90.0, 0.0, 0.0 }
local ptfxScale = 0.67

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
	if interactionName ~= 'collectible_maletadinheiro' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Maleta Fichas :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ('ScriptedInteraction Collectible Maleta Fichas :: failed to load particle fx asset %s!'):format( ptfxAsset ) )
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
end)