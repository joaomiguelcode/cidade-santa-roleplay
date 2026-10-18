DEFINE_SCRIPTED_INTERACTION 'collectible_nobrakes_glassesgt' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'oculosnobrakes',
                boneId = 31086,

                offsetPosition = vector3( 0.06, 0.07, 0.0 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),

                animDict = 'clip@oculosnobrakes',
                animName = 'oculosnobrakes',
            }
        }
    }
}
