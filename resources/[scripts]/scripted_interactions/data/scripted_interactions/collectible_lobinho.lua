DEFINE_SCRIPTED_INTERACTION 'collectible_lobinho' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		-- animation =
		-- {
		-- 	dict  = 'lobinho@joao',
		-- 	name  = '',
		-- 	flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		-- },

		props =
		{
			{
				modelName = 'lobinho_by_joao',
				boneId 	  = 64729,

				offsetPosition = vector3(0.094, 0.1, -0.24 ),
				offsetRotation = vector3(177.17, -4.96, 12.55),
			}
		}
	}
}