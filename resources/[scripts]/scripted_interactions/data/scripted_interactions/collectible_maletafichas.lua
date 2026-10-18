DEFINE_SCRIPTED_INTERACTION 'collectible_maletafichas' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@maletafichas',
			name  = 'maletafichas_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'maletafichas',
				boneId 	  = 28422,

				offsetPosition = vector3(0.05, 0.03, -0.13),
				offsetRotation = vector3(89.45, -2.18, 73.09),
			}
		}
	}
}
