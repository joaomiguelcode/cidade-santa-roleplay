DEFINE_SCRIPTED_INTERACTION 'collectible_macacocarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval06',
				boneId 	  = 24818,

				offsetPosition = vector3(0.32586997937176, 0.014567065041966, 0.16800546122078),
				offsetRotation = vector3(4.2652743850801, 87.446295092129, -177.11588584217),
			}
		}
	}
}
