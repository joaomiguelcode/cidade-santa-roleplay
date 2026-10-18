DEFINE_SCRIPTED_INTERACTION 'collectible_calangocarnaval' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval05',
				boneId 	  = 24818,

				offsetPosition = vector3(0.26122644788018, 0.0, 0.050639701738846),
				offsetRotation = vector3(-176.35468347611, -87.69504768078, -3.1382391059145),
			}
		}
	}
}
