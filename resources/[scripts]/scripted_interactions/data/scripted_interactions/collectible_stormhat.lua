DEFINE_SCRIPTED_INTERACTION 'collectible_stormhat' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'chapeumortal',
				boneId 	  = 31086,

				offsetPosition = vector3(0.12, 0.0, 0.0),
				offsetRotation = vector3(1.09, 90.0, 0.0),
			}
		}
	}
}
