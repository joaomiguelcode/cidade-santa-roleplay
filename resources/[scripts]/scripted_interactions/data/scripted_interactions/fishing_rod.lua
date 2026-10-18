DEFINE_SCRIPTED_INTERACTION 'fishing_rod' {
	{
		animation =
		{
			dict  = 'amb@world_human_stand_fishing@idle_a',
			name  = 'idle_c',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
		},
		prop =
		{
			modelName = 'prop_fishing_rod_01',
			boneId 	  = 60309,
		}
	}
}