DEFINE_SCRIPTED_INTERACTION 'collectible_plumascarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval01',
				boneId 	  = 24818,

				offsetPosition = vector3(0.0, -0.012, 0.0),
				offsetRotation = vector3(-5.8736428215288, 88.851302042281, 177.8720333957),
			}
		}
	}
}
