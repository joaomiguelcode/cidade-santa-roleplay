DEFINE_SCRIPTED_INTERACTION 'collectible_pet_crow' {
    canSwitchState = true,
    displayName = 'collectibles.pets.crow.name',

    {
        name = 'shoulder',
        title = 'collectibles.pets.crow.shoulder.title',
        description = 'collectibles.pets.crow.shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'corvo_santagroup',
                animDict = 'clip@corvo_ombro',
                animName = 'corvo_ombro',
                boneId = 24818,
                offsetPosition = vector3( 0.35, -0.04, -0.14 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'right',
        title = 'collectibles.pets.crow.right.title',
        description = 'collectibles.pets.crow.right.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'corvo_santagroup',
                animDict = 'clip@corvo_voando',
                animName = 'corvo_voando',
                boneId = 24818,
                offsetPosition = vector3( 0.44, -0.18, 0.28 ),
                offsetRotation = vector3( -160.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'left',
        title = 'collectibles.pets.crow.left.title',
        description = 'collectibles.pets.crow.left.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'corvo_santagroup',
                animDict = 'clip@corvo_voando',
                animName = 'corvo_voando',
                boneId = 24818,
                offsetPosition = vector3( 0.44, -0.18, -0.28 ),
                offsetRotation = vector3( -160.00, -90.00, 0.00 ),
            },
        },
    },
}
