DEFINE_SCRIPTED_INTERACTION 'collectible_faquinha' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		-- animation =
		-- {
		-- 	dict  = 'faquinhaincotrolavel@joao',
		-- 	name  = '',
		-- 	flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		-- },

		props =
		{
			{
				modelName = 'faquinhaincotrolavel_by_joao',
				boneId 	  = 64729,

				offsetPosition = vector3( 0.08, 0.0, -0.13 ),
				offsetRotation = vector3( -180.0, 15.0, 20.0 ),
			}
		}
	}
}