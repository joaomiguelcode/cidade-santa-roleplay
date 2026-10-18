DEFINE_SCRIPTED_INTERACTION 'collectible_freezemask' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'mascara_2',
				boneId 	  = 31086,

				offsetPosition = vector3(0.01, 0.056, 0.0),
				offsetRotation = vector3(-90.0, -90.0, 0.0),
			}
		}
	}
}
