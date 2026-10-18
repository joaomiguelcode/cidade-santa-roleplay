DEFINE_SCRIPTED_INTERACTION 'collectible_bruxinha' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'santaanim@joao',
			name  = 'joaosegurando_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'bruxinha_by_joao',
				boneId 	  = 18905,

				offsetPosition = vector3( 0.07, 0.08, 0.08 ),
				offsetRotation = vector3( 100.0, -20.0, 200.0 ),
			}
		}
	}
}
