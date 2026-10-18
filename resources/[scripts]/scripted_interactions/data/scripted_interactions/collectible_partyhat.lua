DEFINE_SCRIPTED_INTERACTION 'collectible_partyhat' {
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
				modelName = 'happynewyear05',
				boneId 	  = 12844,

				offsetPosition = vector3( 0.182, 0, 0 ),
				offsetRotation = vector3( 2.2355381939747, 87.992105113854, -169.24775732306 ),
			}
		}
	}
}


