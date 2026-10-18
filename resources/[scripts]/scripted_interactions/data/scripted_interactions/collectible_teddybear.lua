DEFINE_SCRIPTED_INTERACTION 'collectible_teddybear' {
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
				modelName = 'happynewyear04',
				boneId 	  = 5232,

				offsetPosition = vector3( 0.19427864419845, 0, -0.099754832088904 ),
				offsetRotation = vector3( 179.28181192632, 56.619872399566, 37.433663382475 ),
			}
		}
	}
}


