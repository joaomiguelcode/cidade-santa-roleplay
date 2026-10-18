DEFINE_SCRIPTED_INTERACTION 'collectible_balloon' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		-- animation =
		-- {
		-- 	dict  = 'impexp_int-0',
		-- name  = 'mp_m_waremech_01_dual-0',
		-- 	flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		-- },

		props =
		{
			{
				modelName = 'happynewyear01',
				boneId 	  = 24818,

				offsetPosition = vector3( 0.68651032870343, 0, 0 ),
				offsetRotation = vector3( -3.6839458355719, 87.552449214956, -172.8424454269 ),
			}
		}
	}
}


