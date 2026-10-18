DEFINE_SCRIPTED_INTERACTION 'collectible_gift25' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.SKIP_ALL_CHECKS | eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'xmasgiftanimation@animation',
			name  = 'xmasgiftanimation_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'xmasproppoisonstore06',
				boneId 	  = 57005,

				offsetPosition = vector3(0.19990160837881, 0.12087439370077, -0.14903595930927 ),
				offsetRotation = vector3(102.22984321656, -12.811319593844, -143.96523308682 ),
			}
		}
	}
}

