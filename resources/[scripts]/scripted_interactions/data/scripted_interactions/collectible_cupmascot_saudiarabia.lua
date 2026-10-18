DEFINE_SCRIPTED_INTERACTION 'collectible_cupmascot_saudiarabia' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'mascotearabiaanim',
                boneId = 24818,

                offsetPosition = vector3( 0.32, -0.02, 0.17 ),
                offsetRotation = vector3( 0.0, 75.0, -180.0 ),

                animDict = 'clip@mascotearabiaanim',
                animName = 'mascotearabiaanim',
            }
        }
    }
}
