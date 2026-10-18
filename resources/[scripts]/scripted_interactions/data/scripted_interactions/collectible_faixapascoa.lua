DEFINE_SCRIPTED_INTERACTION 'collectible_faixapascoa' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'faixa_ovos',
				boneId 	  = 24818,

				offsetPosition = vector3(0.65, 0.00, 0.0),
				offsetRotation = vector3(-180.0, -90.0, 0.0),
			}
		}
	}
}
