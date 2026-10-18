DEFINE_SCRIPTED_INTERACTION 'collectible_pintinhopascoa' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'pintinho',
				boneId 	  = 24818,

				offsetPosition = vector3(0.03, 0.27, 0.00),
				offsetRotation = vector3(-90.00, -90.0, 0.0),
			}
		}
	}
}
