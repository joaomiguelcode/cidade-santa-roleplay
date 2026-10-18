DEFINE_SCRIPTED_INTERACTION 'collectible_foice' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'foiceanimation@joao',
			name  = 'foice_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'foice_by_joao',
				boneId 	  = 18905,

				offsetPosition = vector3( 0.13, 0.12, 0.0 ),
				offsetRotation = vector3( -100.0, 0.0, 0.0 ),
			}
		}
	}
}
