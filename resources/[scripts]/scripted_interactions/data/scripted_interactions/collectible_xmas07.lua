DEFINE_SCRIPTED_INTERACTION 'collectible_tree25' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'impexp_int-0',
		name  = 'mp_m_waremech_01_dual-0',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},

		props =
		{
			{
				modelName = 'xmasproppoisonstore07',
				boneId 	  = 24817,

				offsetPosition = vector3( 0.046401423428165, 0.36998693654503, 0 ),
				offsetRotation = vector3( -3.3479422357029, 88.256360431137, -2.0419830468754 ),
			}
		}
	}
}

