DEFINE_SCRIPTED_INTERACTION 'collectible_playtime_cowboy' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'woodyanim',
                boneId = 64729,

                offsetPosition = vector3( 0.12, 0.0, -0.10 ),
                offsetRotation = vector3( -180.0, 7.0, 19.0 ),

                animDict = 'clip@woodyanim',
                animName = 'woodyanim',
            }
        }
    }
}
