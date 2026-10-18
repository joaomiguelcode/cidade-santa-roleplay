DEFINE_SCRIPTED_INTERACTION 'collectible_playtime_astronaut' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'buzzanim',
                boneId = 24818,

                offsetPosition = vector3( 0.31, 0.0, 0.18 ),
                offsetRotation = vector3( -180.0, -99.0, 0.0 ),

                animDict = 'clip@buzzanim',
                animName = 'buzzanim',
            }
        }
    }
}
