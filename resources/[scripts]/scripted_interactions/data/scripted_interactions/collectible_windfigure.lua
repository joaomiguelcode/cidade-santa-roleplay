DEFINE_SCRIPTED_INTERACTION 'collectible_windfigure' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'ninjaf',
				boneId 	  = 64729,

				offsetPosition = vector3(0.12, 0.00, -0.17),
				offsetRotation = vector3(-180.0, 0.0, 30.0),
			}
		}
	}
}
