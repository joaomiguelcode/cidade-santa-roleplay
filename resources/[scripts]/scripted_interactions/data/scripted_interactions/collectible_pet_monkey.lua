DEFINE_SCRIPTED_INTERACTION 'collectible_pet_monkey' {
    canSwitchState = true,
    displayName = 'collectibles.pets.monkey.name',

    {
        name = 'shoulder',
        title = 'collectibles.pets.monkey.shoulder.title',
        description = 'collectibles.pets.monkey.shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'monkey_santagroup',
                animDict = 'clip@monkey_ombro',
                animName = 'monkey_ombro',
                boneId = 24818,
                offsetPosition = vector3( 0.41, -0.01, 0.17 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'leg',
        title = 'collectibles.pets.monkey.leg.title',
        description = 'collectibles.pets.monkey.leg.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'monkey_santagroup',
                animDict = 'clip@monkey_perna',
                animName = 'monkey_perna',
                boneId = 36864,
                offsetPosition = vector3( 0.21, 0.01, 0.07 ),
                offsetRotation = vector3( -180.00, 90.00, -90.00 ),
            },
        },
    },
    {
        name = 'lap',
        title = 'collectibles.pets.monkey.lap.title',
        description = 'collectibles.pets.monkey.lap.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = {
            dict = 'clip@player_monkey',
            name = 'playmonkey_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'monkey_santagroup',
                animDict = 'clip@monkey_colo',
                animName = 'monkey_colo',
                boneId = 24818,
                offsetPosition = vector3( 0.08, 0.29, 0.00 ),
                offsetRotation = vector3( -180.00, -90.00, 5.00 ),
            },
        },
    },
}
