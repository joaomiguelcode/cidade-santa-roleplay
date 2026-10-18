DEFINE_SCRIPTED_INTERACTION 'collectible_tiaracarnaval2' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval15',
				boneId 	  = 12844,

				offsetPosition = vector3(0.15772393912195, 0.0, 0.0032943857201735),
				offsetRotation = vector3(7.7469661141228, 87.612375278965, 173.02506002891),
			}
		}
	}
}
