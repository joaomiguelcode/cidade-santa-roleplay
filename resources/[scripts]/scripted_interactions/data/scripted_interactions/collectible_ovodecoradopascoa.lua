DEFINE_SCRIPTED_INTERACTION 'collectible_ovodecoradopascoa' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@ovobr',
			name  = 'ovobr_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'ovo_br',
				boneId 	  = 24818,

				offsetPosition = vector3(0.04, 0.37, 0.00),
				offsetRotation = vector3(90.0, 90.0, 180.0),
			}
		}
	}
}
