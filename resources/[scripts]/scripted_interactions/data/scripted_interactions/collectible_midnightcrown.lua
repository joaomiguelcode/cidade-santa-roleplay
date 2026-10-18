DEFINE_SCRIPTED_INTERACTION 'collectible_midnightcrown' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'coroa',
                boneId = 31086,

                offsetPosition = vector3( 0.16, 0.01, 0.02 ),
                offsetRotation = vector3( -180.0, -108.0, -12.0 ),
            }
        }
    }
}
