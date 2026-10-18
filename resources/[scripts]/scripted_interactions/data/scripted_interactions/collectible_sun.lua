DEFINE_SCRIPTED_INTERACTION 'collectible_sun' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		props =
		{
			{
				modelName = 'solzinho_by_joao',
				boneId 	  = 64729,

				offsetPosition = vector3( 0.10, 0.0, -0.18 ),
				offsetRotation = vector3( -180.0, 0.0, 20.0 ),
			}
		}
	}
}
