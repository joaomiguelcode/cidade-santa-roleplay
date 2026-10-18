DEFINE_SCRIPTED_INTERACTION 'collectible_midnightcarblack' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'carropretoanim',
                boneId = 24818,

                offsetPosition = vector3( 0.30, 0.0, 0.15 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),

                animDict = 'clip@carropretoanim',
                animName = 'carropretoanim',
            }
        }
    }
}
