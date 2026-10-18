DEFINE_SCRIPTED_INTERACTION 'collectible_dados' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@dado',
			name  = 'dado_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'dadoanim',
				boneId 	  = 24818,

				offsetPosition = vector3(-0.21, 0.35, -0.32),
				offsetRotation = vector3(0.00, 87.27, 180.00),

				animDict = 'clip@dadoanim',
				animName = 'dadoanim',
			}
		}
	}
}