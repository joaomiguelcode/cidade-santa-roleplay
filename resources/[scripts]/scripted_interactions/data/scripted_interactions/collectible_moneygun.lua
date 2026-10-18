DEFINE_SCRIPTED_INTERACTION 'collectible_moneygun' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'arma',
				boneId 	  = 57005,

				offsetPosition = vector3(0.19, 0.07, 0.0),
				offsetRotation = vector3(12.0, -1.09, -12.0),
			}
		}
	}
}


local ptfxAsset = 'scr_xs_celebration'
local ptfxName = 'scr_xs_money_rain_celeb'
local ptfxPlacement = { 0.09, 0.0, -0.02, 0.0, 90.0, 0.0 }
local ptfxScale = 0.8

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

	if interactionName ~= 'collectible_moneygun' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Money Gun :: prop not found!' )

	if not LoadParticleFxAsset( ptfxAsset ) then
		sx.logger:error( ('ScriptedInteraction Collectible Money Gun :: failed to load particle fx asset %s!'):format( ptfxAsset ) )
		return
	end

	UseParticleFxAssetNextCall( ptfxAsset )

	for i = 1, 2 do
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
end)