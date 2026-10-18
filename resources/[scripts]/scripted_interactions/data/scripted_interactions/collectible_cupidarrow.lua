DEFINE_SCRIPTED_INTERACTION 'collectible_cupidarrow' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName      = 'valentinespoisonstore04',
				boneId         = 31086,

				offsetPosition = vector3(0.1154584378088, -0.0022061470327335, 0.019897328637901),
				offsetRotation = vector3(166.15139579298, 63.123058179772, -176.15745268288),
			}
		}
	}
}
