DEFINE_SCRIPTED_INTERACTION 'collectible_irishflag' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@bandeira',
			name  = 'bandeira_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'bandeiraanim',
				boneId 	  = 18905,

				offsetPosition = vector3( 0.13, 0.33, -0.29 ),
				offsetRotation = vector3( -88.36, 86.18, -18.55 ),
			}
		}
	}
}


---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId )

	if interactionName ~= 'collectible_irishflag' then
		return
	end

	local prop = exports.scripted_interactions:getLocalScriptedInteractionPropId( entityId )

	assert( prop ~= nil, 'ScriptedInteraction Collectible Irish Flag :: prop not found!' )

	local animDict = 'clip@bandeiraanim'
	local animName = 'bandeiraanim'

	RequestAnimDict( animDict )
	while not HasAnimDictLoaded( animDict ) do
		Wait( 10 )
	end

	PlayEntityAnim( prop, animName, animDict, 1000.0, true, false, true, 0, 0.0 )
end)
