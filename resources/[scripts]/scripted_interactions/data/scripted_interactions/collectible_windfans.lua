DEFINE_SCRIPTED_INTERACTION 'collectible_windfans' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@leque',
			name  = 'leque_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		}, 

		props =
		{
			{
				modelName = 'leque',
				boneId 	  = 18905,

				offsetPosition = vector3(0.16, 0.01, 0.05),
				offsetRotation = vector3(-124.00, -164.0, -59.0),
			}
		}
	}
}

CreateThread( function()

	if IsDuplicityVersion() then
		return
	end

	RequestAnimDict( 'clip@leque' )
	while not HasAnimDictLoaded( 'clip@leque' ) do
		Wait( 100 )
	end
end )
