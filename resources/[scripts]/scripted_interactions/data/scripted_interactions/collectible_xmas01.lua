DEFINE_SCRIPTED_INTERACTION 'collectible_santa25' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'xmasproppoisonstore01',
				boneId         = 24818,

				offsetPosition = vector3(0.37019324392304, 0.060145667768271, 0.16759700981164),
				offsetRotation = vector3(-3.7054002449364, 81.546601024079, 178.19269598978),
			}
		}
	}
}
