DEFINE_SCRIPTED_INTERACTION 'collectible_leprechaun' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		
		props =
		{
			{
				modelName = 'gnomo',
				boneId 	  = 64729,

				offsetPosition = vector3( 0.12, 0.03, -0.10 ),
				offsetRotation = vector3( 180.0, 6.55, 27.27 ),
			}
		}
	}
}
