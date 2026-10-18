DEFINE_SCRIPTED_INTERACTION 'collectible_surfboard' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'santaanim@joao',
			name  = 'beachanim_surf_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'pranchasurf_by_joao',
				boneId 	  = 28252,

				offsetPosition = vector3( 0.11,0.0,-0.1 ),
				offsetRotation = vector3( -93.0, -200.0,-2.1500 ),
			}
		}
	}
}