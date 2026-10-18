DEFINE_SCRIPTED_INTERACTION 'collectible_pirulitopascoa' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@pirulito',
			name  = 'pirulito_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'pirulito',
				boneId 	  = 57005,

				offsetPosition = vector3(0.21, 0.08, 0.00),
				offsetRotation = vector3(53.45, 90.55, 24.0),
			}
		}
	}
}
