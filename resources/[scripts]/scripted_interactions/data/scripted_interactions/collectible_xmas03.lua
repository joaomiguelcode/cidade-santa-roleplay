DEFINE_SCRIPTED_INTERACTION 'collectible_ren25' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'barbiesegurandoanim@joao',
			name  = 'barbiesegurandoanim_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'xmasproppoisonstore03',
				boneId 	  = 36029,

				offsetPosition = vector3( 0.02, 0.141, 0.045 ),
				offsetRotation = vector3( 95.86, -23.33, -161.8 ),
			}
		}
	}
}

