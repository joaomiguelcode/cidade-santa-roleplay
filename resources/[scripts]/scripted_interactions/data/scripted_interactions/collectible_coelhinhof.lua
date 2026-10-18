DEFINE_SCRIPTED_INTERACTION 'collectible_coelhinhof' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'coelhoanimf',
				boneId 	  = 64729,

				offsetPosition = vector3(0.12, -0.02, -0.17),
				offsetRotation = vector3(-180.0, 8.73, 19.64),

				animDict = 'clip@coelhoanimf',
				animName = 'coelhoanimf',
			}
		}
	}
}
