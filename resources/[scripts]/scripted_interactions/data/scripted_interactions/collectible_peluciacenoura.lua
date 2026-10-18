DEFINE_SCRIPTED_INTERACTION 'collectible_peluciacenoura' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@ursoceno',
			name  = 'ursoceno_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'ursoanim',
				boneId 	  = 57005,

				offsetPosition = vector3(0.10, 0.09, -0.20),
				offsetRotation = vector3(-111.27, 53.85, -25.00),

				animDict = 'clip@ursoanim',
				animName = 'ursoanim',
			}
		}
	}
}
