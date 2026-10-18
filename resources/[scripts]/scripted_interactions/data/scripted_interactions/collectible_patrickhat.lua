DEFINE_SCRIPTED_INTERACTION 'collectible_patrickhat' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		props =
		{
			{
				modelName = 'chapeu',
				boneId 	  = 31086,

				offsetPosition = vector3( 0.25, 0.02, 0.00 ),
				offsetRotation = vector3( 90.0, 90.0, 180.0 ),
			}
		}
	}
}
