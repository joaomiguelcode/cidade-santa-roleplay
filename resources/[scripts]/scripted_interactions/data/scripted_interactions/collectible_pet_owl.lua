DEFINE_SCRIPTED_INTERACTION 'collectible_pet_owl' {
    canSwitchState = true,
    displayName = 'collectibles.pets.owl.name',

    {
        name = 'right',
        title = 'collectibles.pets.owl.right.title',
        description = 'collectibles.pets.owl.right.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'coruja_santagroup',
                animDict = 'clip@coruja_voando',
                animName = 'coruja_voando',
                boneId = 24818,
                offsetPosition = vector3( 0.46, -0.20, -0.18 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'left',
        title = 'collectibles.pets.owl.left.title',
        description = 'collectibles.pets.owl.left.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'coruja_santagroup',
                animDict = 'clip@coruja_voando',
                animName = 'coruja_voando',
                boneId = 24818,
                offsetPosition = vector3( 0.46, -0.20, 0.18 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'around',
        title = 'collectibles.pets.owl.around.title',
        description = 'collectibles.pets.owl.around.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'coruja_santagroup',
                animDict = 'clip@coruja_volta',
                animName = 'coruja_volta',
                boneId = 24818,
                offsetPosition = vector3( 0.56, 0.01, 0.38 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
