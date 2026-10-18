DEFINE_SCRIPTED_INTERACTION 'collectible_morceguinho' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		props =
		{
			{
				modelName = 'morceguinho_by_joao',
				boneId 	  = 64729,

				offsetPosition = vector3( 0.18, 0.0, -0.12 ),
				offsetRotation = vector3( -180.0, 15.0, 20.0 ),
			}
		}
	}
}
