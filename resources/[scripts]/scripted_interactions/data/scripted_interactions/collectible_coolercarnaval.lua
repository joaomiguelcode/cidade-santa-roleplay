DEFINE_SCRIPTED_INTERACTION 'collectible_coolercarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval03',
				boneId 	  = 24818,

				offsetPosition = vector3(-0.035450825833436, 0.2519401703972, -0.015879286530089),
				offsetRotation = vector3(6.5941733106014, 87.882699042014, 176.154580466),
			}
		}
	}
}
