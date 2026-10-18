DEFINE_SCRIPTED_INTERACTION 'collectible_loveletter' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'valentinespoisonstore06',
				boneId         = 31086,

				offsetPosition = vector3(-0.091680613880385, 0.023331005576722, 0.032678208526756),
				offsetRotation = vector3(162.2669802494, -70.980493970234, -20.920810311621),
			}
		}
	}
}