DEFINE_SCRIPTED_INTERACTION 'collectible_placagolpe' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'poisonstorecarnaval09',
				boneId 	  = 24818,

				offsetPosition = vector3(0.026799208158423, 0.031950970362071, -0.007041936385943),
				offsetRotation = vector3(-2.9241385113508, 86.518640438338, -175.36483473349),
			}
		}
	}
}
