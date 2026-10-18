DEFINE_SCRIPTED_INTERACTION 'collectible_ovodouradopascoa' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@ovo',
			name  = 'ovo_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'ovo',
				boneId 	  = 24818,

				offsetPosition = vector3(0.0, 0.33, 0.00),
				offsetRotation = vector3(0.0, 0.0, -90.0),
			}
		}
	}
}
