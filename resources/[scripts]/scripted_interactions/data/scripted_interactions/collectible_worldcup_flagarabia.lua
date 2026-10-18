DEFINE_SCRIPTED_INTERACTION 'collectible_worldcup_flagarabia' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        animation =
        {
            dict = 'clip@bandeira',
            name = 'bandeiraclip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },

        props =
        {
            {
                modelName = 'arabiaanim',
                boneId = 18905,

                offsetPosition = vector3( 0.30, 0.30, -0.04 ),
                offsetRotation = vector3( -124.0, -77.0, 4.0 ),

                animDict = 'clip@arabiaanim',
                animName = 'arabiaanim',
            }
        }
    }
}
