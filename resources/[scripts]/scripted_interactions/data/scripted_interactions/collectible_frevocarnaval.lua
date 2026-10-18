DEFINE_SCRIPTED_INTERACTION 'collectible_frevocarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval02',
				boneId 	  = 12844,

				offsetPosition = vector3(0.19184874755263, 0.03050839960704, -0.010906388646399),
				offsetRotation = vector3(33.370711702517, 67.089349138629, 86.785549007202),
			}
		}
	}
}
