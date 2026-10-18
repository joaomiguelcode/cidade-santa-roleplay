DEFINE_SCRIPTED_INTERACTION 'collectible_nobrakes_shoesgt' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'crocsnobrakesr',
                boneId = 52301,

                offsetPosition = vector3( 0.13, -0.01, -0.01 ),
                offsetRotation = vector3( -109.0, 95.0, -5.0 ),

                animDict = 'clip@crocsnobrakesr',
                animName = 'crocsnobrakesr',
            },
            {
                modelName = 'crocsnobrakesl',
                boneId = 14201,

                offsetPosition = vector3( 0.11, -0.02, 0.01 ),
                offsetRotation = vector3( -109.0, 85.0, 5.0 ),

                animDict = 'clip@crocsnobrakesl',
                animName = 'crocsnobrakesl',
            }
        }
    }
}
