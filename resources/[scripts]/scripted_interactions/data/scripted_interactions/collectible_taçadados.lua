DEFINE_SCRIPTED_INTERACTION 'collectible_taçadados' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@taca',
			name  = 'taca_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'taca',
				boneId 	  = 28422,

				offsetPosition = vector3(0.06, 0.07, 0.00),
				offsetRotation = vector3(20.073, 60.0, 14.18),
			}
		}
	}
}
