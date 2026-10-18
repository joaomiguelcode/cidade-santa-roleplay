DEFINE_SCRIPTED_INTERACTION 'collectible_nitro' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'colecionaveiscorrida@joao',
			name  = 'nitro_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},


		props =
		{
			{
				modelName = 'nitro_by_joao',
				boneId 	  = 24818,
				
				offsetPosition = vector3( -0.1144, 0.224, 0.013 ),
				offsetRotation = vector3( 1.652, 51.772, -174.0745 ),
			}
		}
	}
}