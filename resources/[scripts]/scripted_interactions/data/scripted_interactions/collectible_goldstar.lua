DEFINE_SCRIPTED_INTERACTION 'collectible_goldstar' {
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
				modelName = 'happynewyear06',
				boneId 	  = 24818,

				offsetPosition = vector3( 0.34943942152165, 0, 0.21721882174923 ),
				offsetRotation = vector3( 4.6786287438281, 0.93526185470972, -14.517433725983 ),
			}
		}
	}
}


