DEFINE_SCRIPTED_INTERACTION 'collectible_balaopascoam' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'clip@balao',
			name  = 'balao_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'balao_m',
				boneId 	  = 57005,

				offsetPosition = vector3(0.23, 0.45, 0.11),
				offsetRotation = vector3(15.27, 84.0, 17.45),
			}
		}
	}
}
