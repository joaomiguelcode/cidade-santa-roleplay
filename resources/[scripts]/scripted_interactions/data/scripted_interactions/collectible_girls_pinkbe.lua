DEFINE_SCRIPTED_INTERACTION 'collectible_girls_pinkbe' {
    canSwitchState = true,
    displayName = 'collectibles.girls.pinkbe.name',

    {
        name = 'back',
        title = 'collectibles.girls.pinkbe.back.title',
        description = 'collectibles.girls.pinkbe.back.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props = {
            {
                modelName = 'ursinhobarbie',
                animDict = 'clip@ursinhobarbie1',
                animName = 'ursinhobarbie1',
                boneId = 24818,
                offsetPosition = vector3( 0.21, -0.16, 0.13 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),
            },
        },
    },
    {
        name = 'leg',
        title = 'collectibles.girls.pinkbe.leg.title',
        description = 'collectibles.girls.pinkbe.leg.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props = {
            {
                modelName = 'ursinhobarbie',
                animDict = 'clip@ursinhobarbie2',
                animName = 'ursinhobarbie2',
                boneId = 36864,
                offsetPosition = vector3( 0.18, 0.03, 0.18 ),
                offsetRotation = vector3( -180.0, 90.0, 0.0 ),
            },
        },
    },
}
