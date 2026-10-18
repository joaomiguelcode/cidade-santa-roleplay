DEFINE_SCRIPTED_INTERACTION 'collectible_mochilacoelhom' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'ursinho_m',
				boneId 	  = 24818,

				offsetPosition = vector3(0.14, -0.17, 0.0),
				offsetRotation = vector3(90.0, 90.0, 180.0),
			}
		}
	}
}
