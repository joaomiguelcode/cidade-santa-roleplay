DEFINE_SCRIPTED_INTERACTION 'collectible_flag' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'amb@world_human_car_park_attendant@male@base',
			name  = 'base',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},


		props =
		{
			{
				modelName = 'flag_corrida_by_joao',
				boneId 	  = 57005,
				
				offsetPosition = vector3( 0.0961, 0, -0.0586 ),
				offsetRotation = vector3( -59.948, 0, 0 ),
			}
		}
	}
}
