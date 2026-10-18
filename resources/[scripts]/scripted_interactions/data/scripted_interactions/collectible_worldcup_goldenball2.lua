DEFINE_SCRIPTED_INTERACTION 'collectible_worldcup_goldenball2' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        animation =
        {
            dict = 'clip@embaixadinha',
            name = 'embaixadinhaclip',
            flags = eAnimationFlags.AF_LOOPING,
        },

        props =
        {
            {
                modelName = 'boladouradaanim',

                offsetPosition = vector3( 0.0, 0.0, -0.90 ),
                offsetRotation = vector3( 0.0, 0.0, 180.0 ),

                animDict = 'clip@boladouradaanim',
                animName = 'boladouradaanim',
            }
        }
    }
}
