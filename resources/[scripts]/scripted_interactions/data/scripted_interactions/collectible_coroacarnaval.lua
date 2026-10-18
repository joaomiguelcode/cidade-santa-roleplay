DEFINE_SCRIPTED_INTERACTION 'collectible_coroacarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'poisonstorecarnaval14',
				boneId         = 12844,

				offsetPosition = vector3(0.22, -0.039197330445553, 0.0),
				offsetRotation = vector3(158.38868824579, -88.549651936737, -0.17073955143969),
			}
		}
	},
	{
		name = 'combine_coroa_with_plumas',
		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
		props =
		{
			{
				modelName      = 'poisonstorecarnaval14',
				boneId         = 12844,

				offsetPosition = vector3(0.22, -0.039197330445553, 0.0),
				offsetRotation = vector3(158.38868824579, -88.549651936737, -0.17073955143969),
			},
			{
				modelName      = 'poisonstorecarnaval01',
				boneId         = 24818,

				offsetPosition = vector3(0.0, -0.012, 0.0),
				offsetRotation = vector3(-5.8736428215288, 88.851302042281, 177.8720333957),
			}
		}
	}
}

