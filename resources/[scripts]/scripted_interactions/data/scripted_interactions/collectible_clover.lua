DEFINE_SCRIPTED_INTERACTION 'collectible_clover' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		props =
		{
			{
				modelName = 'tiaratrevo',
				boneId 	  = 31086,

				offsetPosition = vector3( 0.16, 0.02, 0.00 ),
				offsetRotation = vector3( 90.0, 90.0, 180.0 ),
			}
		}
	}
}
