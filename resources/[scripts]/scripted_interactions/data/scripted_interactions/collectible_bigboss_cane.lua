DEFINE_SCRIPTED_INTERACTION 'collectible_bigboss_cane' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        animation = {
            dict = 'clip@bengala',
            name = 'bengalaclip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },

        props = {
            {
                modelName = 'bengalabigboss',
                boneId = 57005,

                offsetPosition = vector3( 0.16, -0.15, -0.39 ),
                offsetRotation = vector3( 44.0, -49.0, 123.0 ),
            },
        },
    },
}
