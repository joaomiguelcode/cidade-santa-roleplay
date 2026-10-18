DEFINE_SCRIPTED_INTERACTION 'collectible_bouquet' {
	{
		name = 'idle',

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

		animation =
		{
			dict  = 'buqueflowerspoisonstore01@animation',
			name  = 'buqueflowerspoisonstore01_clip',
			flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
		},

		props =
		{
			{
				modelName      = 'fallingpetalspoison01',
				boneId         = 57005,

				offsetPosition = vector3(0.089183418815423, 0.1358855287346, 0.016632971782931),
				offsetRotation = vector3(-82.41083482504, 41.448604524929, 17.853776731517),
			}
		}
	}
}
