DEFINE_SCRIPTED_INTERACTION 'collectible_verify' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		props =
		{
			{
				modelName      = 'verify',
				boneId         = 24818,

				offsetPosition = vector3(0.39, 0.00, 0.27),
				offsetRotation = vector3(0.00, 79.64, 0.00),
			}
		}
	}
}
