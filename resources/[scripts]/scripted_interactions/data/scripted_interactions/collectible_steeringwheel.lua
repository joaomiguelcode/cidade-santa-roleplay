DEFINE_SCRIPTED_INTERACTION 'collectible_steeringwheel' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'colecionaveiscorrida@joao',
			name  = 'volante_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},


		props =
		{
			{
				modelName = 'volante_by_joao',
				boneId 	  = 10706,
				
				offsetPosition = vector3( -0.063, 0.326, -0.286 ),
				offsetRotation = vector3( -27.437, -19.779, 22.55 ),
			}
		}
	}
}
