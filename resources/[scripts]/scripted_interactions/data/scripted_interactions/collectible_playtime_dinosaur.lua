DEFINE_SCRIPTED_INTERACTION 'collectible_playtime_dinosaur' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'dinoanim',
                boneId = 64729,

                offsetPosition = vector3( 0.16, 0.0, -0.12 ),
                offsetRotation = vector3( -180.0, 0.0, 13.0 ),

                animDict = 'clip@dinoanim',
                animName = 'dinoanim',
            }
        }
    }
}
