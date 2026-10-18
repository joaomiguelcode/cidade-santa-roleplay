DEFINE_SCRIPTED_INTERACTION 'collectible_pet_eagle' {
    canSwitchState = true,
    displayName = 'collectibles.pets.eagle.name',

    {
        name = 'shoulder',
        title = 'collectibles.pets.eagle.shoulder.title',
        description = 'collectibles.pets.eagle.shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'aguia_santagroup',
                animDict = 'clip@aguia_ombro',
                animName = 'aguia_ombro',
                boneId = 24818,
                offsetPosition = vector3( 0.39, -0.10, 0.16 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'right',
        title = 'collectibles.pets.eagle.right.title',
        description = 'collectibles.pets.eagle.right.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'aguia_santagroup',
                animDict = 'clip@aguia_voando',
                animName = 'aguia_voando',
                boneId = 24818,
                offsetPosition = vector3( 0.45, -0.39, 0.45 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'left',
        title = 'collectibles.pets.eagle.left.title',
        description = 'collectibles.pets.eagle.left.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'aguia_santagroup',
                animDict = 'clip@aguia_voando',
                animName = 'aguia_voando',
                boneId = 24818,
                offsetPosition = vector3( 0.45, -0.39, -0.45 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
