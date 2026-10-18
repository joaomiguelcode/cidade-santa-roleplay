DEFINE_SCRIPTED_INTERACTION 'collectible_crown' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		props =
		{
			{
				modelName = 'coroa_by_joao',
				boneId 	  = 31086,

				offsetPosition = vector3( 0.179, 0, 0 ),
				offsetRotation = vector3( 17.015, 88.293, 11.732 ),
			}
		}
	}
}
