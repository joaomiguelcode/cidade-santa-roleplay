DEFINE_SCRIPTED_INTERACTION 'collectible_romanticrose' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'valentinespoisonstore03',
				boneId         = 31086,

				offsetPosition = vector3(-0.044334582473653, 0.025735215326251, 0.035009308665707),
				offsetRotation = vector3(158.68369579651, -88.475740025681, 2.1458603072084),
			}
		}
	}
}
