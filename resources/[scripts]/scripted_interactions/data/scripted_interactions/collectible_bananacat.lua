DEFINE_SCRIPTED_INTERACTION 'collectible_bananacat' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'banana_cat_sg_exclusivo',
				boneId 	  = 24818,

				offsetPosition = vector3(0.27, 0.0, 0.16),
				offsetRotation = vector3(-3.70, 81.54, 178.192),
			}
		}
	}
}

