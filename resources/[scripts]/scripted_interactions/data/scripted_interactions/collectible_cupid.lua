DEFINE_SCRIPTED_INTERACTION 'collectible_cupid' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'valentinespoisonstore02',
				boneId         = 24818,

				offsetPosition = vector3(0.38527981761194, 0.034140457547153, 0.2110566224528),
				offsetRotation = vector3(-6.2119621594359, 86.415979972553, -177.15002452832),
			}
		}
	}
}