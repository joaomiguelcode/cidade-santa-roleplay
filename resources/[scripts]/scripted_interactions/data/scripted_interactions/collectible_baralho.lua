DEFINE_SCRIPTED_INTERACTION 'collectible_baralho' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@cartas',
			name  = 'cartas_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'cartas',
				boneId 	  = 28422,

				offsetPosition = vector3(0.11, 0.04, -0.04),
				offsetRotation = vector3(16.36, 75.27, -9.82),
			}
		}
	}
}
