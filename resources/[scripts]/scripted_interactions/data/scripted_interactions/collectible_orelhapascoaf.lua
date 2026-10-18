DEFINE_SCRIPTED_INTERACTION 'collectible_orelhapascoaf' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'orelha_f',
				boneId 	  = 31086,

				offsetPosition = vector3(0.22, 0.00, 0.0),
				offsetRotation = vector3(-90.0, -90.0, 0.0),
			}
		}
	}
}
