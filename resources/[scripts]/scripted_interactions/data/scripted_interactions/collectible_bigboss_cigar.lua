DEFINE_SCRIPTED_INTERACTION 'collectible_bigboss_cigar' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props = {
            {
                modelName = 'charutobigboss',
                boneId = 31086,

                offsetPosition = vector3( -0.01, 0.13, 0.02 ),
                offsetRotation = vector3( 172.0, -90.0, -28.0 ),
            },
        },

        ptfx = {
            asset = 'cut_arena',
            name = 'cs_arena_car_exhaust',
            offsetPosition = vector3( 0.0, -0.03, 0.0 ),
            offsetRotation = vector3( 0.0, 0.0, 0.0 ),
            scale = 0.3,
            onProp = true,
            boneName = 'Bone.008',
        },
    },
}
