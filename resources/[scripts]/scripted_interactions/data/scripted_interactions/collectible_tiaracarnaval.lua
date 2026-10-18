DEFINE_SCRIPTED_INTERACTION 'collectible_tiaracarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval04',
				boneId 	  = 12844,

				offsetPosition = vector3(0.16872393912195, 0.029591145290851, 0.0034943857201735),
				offsetRotation = vector3(7.7469661141228, 87.612375278965, 173.02506002891),
			}
		}
	}
}
