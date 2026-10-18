DEFINE_SCRIPTED_INTERACTION 'collectible_bigboss_kitflapper' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        animation = {
            dict = 'clip@cigarrete',
            name = 'cigarreteclip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },

        props = {
            {
                modelName = 'cigarretebigboss',
                boneId = 57005,

                offsetPosition = vector3( 0.17, 0.01, 0.02 ),
                offsetRotation = vector3( 180.0, 108.0, 107.0 ),
            },
            {
                modelName = 'flapperbigboss',
                boneId = 31086,

                offsetPosition = vector3( 0.11, 0.04, 0.0 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),
            },
        },

        ptfx = {
            asset = 'cut_arena',
            name = 'cs_arena_car_exhaust',
            offsetPosition = vector3( 0.0, -0.05, 0.0 ),
            offsetRotation = vector3( 0.0, 0.0, 0.0 ),
            scale = 0.3,
            onProp = true,
            boneName = 'Bone.008',
        },
    },
}
