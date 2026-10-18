DEFINE_SCRIPTED_INTERACTION 'collectible_trophygold' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'colecionaveiscorrida@joao',
			name  = 'champion_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},


		props =
		{
			{
				modelName = 'trophy_ouro_santa_by_joao',
				boneId 	  = 10706,
				
				offsetPosition = vector3( -0.032, 0.294, 0.335 ),
				offsetRotation = vector3( -1.816, 10.011, -166.603 ),
			}
		}
	}
}
