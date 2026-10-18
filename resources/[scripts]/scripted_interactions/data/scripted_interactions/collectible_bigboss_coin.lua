DEFINE_SCRIPTED_INTERACTION 'collectible_bigboss_coin' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        animation = {
            dict = 'clip@moeda',
            name = 'moedaclip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },

        props = {
            {
                modelName = 'moedabigboss',
                boneId = 57005,

                offsetPosition = vector3( 0.15, 0.04, -0.01 ),
                offsetRotation = vector3( 0.0, 90.0, 0.0 ),

                animDict = 'clip@moedabigboss',
                animName = 'moedabigboss',
            },
        },
    },
}
