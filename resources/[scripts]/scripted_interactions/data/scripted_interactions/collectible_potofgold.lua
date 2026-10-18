DEFINE_SCRIPTED_INTERACTION 'collectible_potofgold' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		animation =
		{
			dict  = 'clip@baumoeda',
			name  = 'baumoeda_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName = 'baumoeda',
				boneId 	  = 18905,

				offsetPosition = vector3( 0.12, 0.02, 0.16 ),
				offsetRotation = vector3( -26.18, 116.73, 9.82 ),
			}
		}
	}
}
