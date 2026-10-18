DEFINE_SCRIPTED_INTERACTION 'collectible_cuptrophy_brasil' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        animation =
        {
            dict = 'clip@trofeucopa',
            name = 'trofeucopaclip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },

        props =
        {
            {
                modelName = 'trofeubrasilanim',
                boneId = 24818,

                offsetPosition = vector3( 0.13, 0.17, 0.19 ),
                offsetRotation = vector3( 150.0, -107.0, -8.0 ),

                animDict = 'clip@trofeubrasilanim',
                animName = 'trofeubrasilanim',
            }
        }
    }
}
