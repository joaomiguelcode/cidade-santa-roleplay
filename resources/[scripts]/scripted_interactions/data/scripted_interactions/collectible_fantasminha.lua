DEFINE_SCRIPTED_INTERACTION 'collectible_fantasminha' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		props =
		{
			{
				modelName = 'fantasminha_by_joao',
				boneId 	  = 10706,

				offsetPosition = vector3( 0.09, -0.0, 0.18 ),
				offsetRotation = vector3( 0.0, 0.0, 195.0 ),
			}
		}
	}
}
