DEFINE_SCRIPTED_INTERACTION 'collectible_flamemask' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'mascara_1',
				boneId 	  = 31086,

				offsetPosition = vector3(0.01, 0.01, 0.0),
				offsetRotation = vector3(180.0, -88.0, -1.09),
			}
		}
	}
}
