DEFINE_SCRIPTED_INTERACTION 'collectible_roleta' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@roleta',
			name  = 'roleta_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'roletaanim',
				boneId 	  = 28422,

				offsetPosition = vector3(0.05, 0.02, -0.18),
				offsetRotation = vector3(9.82, 13.09, -90.55),

				animDict = 'clip@roletaanim',
				animName = 'roletaanim',
			}
		}
	}
}