DEFINE_SCRIPTED_INTERACTION 'collectible_mochilacenoura' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'cenoura',
				boneId 	  = 24818,

				offsetPosition = vector3(0.15, -0.17, 0.0),
				offsetRotation = vector3(97.09, 90.0, 180.0),
			}
		}
	}
}
