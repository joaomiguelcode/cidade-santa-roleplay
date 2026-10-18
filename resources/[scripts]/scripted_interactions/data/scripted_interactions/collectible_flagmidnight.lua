DEFINE_SCRIPTED_INTERACTION 'collectible_flagmidnight' {
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
                modelName = 'bandeiracarro',
                boneId = 18905,

                offsetPosition = vector3( 0.28, 0.26, 0.0 ),
                offsetRotation = vector3( -126.0, -86.0, 3.3 ),

                animDict = 'clip@bandeiracarro',
                animName = 'bandeiracarro',
            }
        }
    }
}
