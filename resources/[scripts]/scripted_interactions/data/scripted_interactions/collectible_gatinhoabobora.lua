DEFINE_SCRIPTED_INTERACTION 'collectible_gatinhoabobora' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'abracando@joao',
			name  = 'esquerda_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'gatinhoabobora_by_joao',
				boneId 	  = 28422,

				offsetPosition = vector3( 0.0, 0.10071332641611, -0.10936116884556 ),
				offsetRotation = vector3( -85.061389438678, 0, 0 ),
			}
		}
	}
}
