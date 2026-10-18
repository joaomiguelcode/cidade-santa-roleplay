DEFINE_SCRIPTED_INTERACTION 'collectible_playtime_cowgirl' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'jessyanim',
                boneId = 64729,

                offsetPosition = vector3( 0.13, -0.01, -0.12 ),
                offsetRotation = vector3( -180.0, 7.6, 12.0 ),

                animDict = 'clip@jessyanim',
                animName = 'jessyanim',
            }
        }
    }
}
