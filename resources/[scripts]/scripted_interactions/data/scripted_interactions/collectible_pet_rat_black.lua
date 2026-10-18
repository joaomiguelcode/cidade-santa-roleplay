DEFINE_SCRIPTED_INTERACTION 'collectible_pet_rat_black' {
    canSwitchState = true,
    displayName = 'collectibles.pets.rat_black.name',

    {
        name = 'right_shoulder',
        title = 'collectibles.pets.rat_black.right_shoulder.title',
        description = 'collectibles.pets.rat_black.right_shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'rato3_santagroup',
                animDict = 'clip@rato_parado',
                animName = 'rato_parado',
                boneId = 10706,
                offsetPosition = vector3( 0.11, -0.02, 0.13 ),
                offsetRotation = vector3( -180.00, -180.00, -20.00 ),
            },
        },
    },
    {
        name = 'left_shoulder',
        title = 'collectibles.pets.rat_black.left_shoulder.title',
        description = 'collectibles.pets.rat_black.left_shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'rato3_santagroup',
                animDict = 'clip@rato_parado',
                animName = 'rato_parado',
                boneId = 64729,
                offsetPosition = vector3( 0.11, -0.02, -0.13 ),
                offsetRotation = vector3( -180.00, 0.00, 20.00 ),
            },
        },
    },
    {
        name = 'head',
        title = 'collectibles.pets.rat_black.head.title',
        description = 'collectibles.pets.rat_black.head.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'rato3_santagroup',
                animDict = 'clip@rato_parado',
                animName = 'rato_parado',
                boneId = 31086,
                offsetPosition = vector3( 0.24, -0.02, 0.00 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
