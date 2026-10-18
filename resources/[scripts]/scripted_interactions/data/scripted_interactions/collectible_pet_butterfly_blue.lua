DEFINE_SCRIPTED_INTERACTION 'collectible_pet_butterfly_blue' {
    canSwitchState = true,
    displayName = 'collectibles.pets.butterfly_blue.name',

    {
        name = 'right',
        title = 'collectibles.pets.butterfly_blue.right.title',
        description = 'collectibles.pets.butterfly_blue.right.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta2_santagroup',
                animDict = 'clip@borboleta_parada',
                animName = 'borboleta_parada',
                boneId = 24818,
                offsetPosition = vector3( 0.41, 0.00, 0.22 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'left',
        title = 'collectibles.pets.butterfly_blue.left.title',
        description = 'collectibles.pets.butterfly_blue.left.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta2_santagroup',
                animDict = 'clip@borboleta_parada',
                animName = 'borboleta_parada',
                boneId = 24818,
                offsetPosition = vector3( 0.41, 0.00, -0.22 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'around',
        title = 'collectibles.pets.butterfly_blue.around.title',
        description = 'collectibles.pets.butterfly_blue.around.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta2_santagroup',
                animDict = 'clip@borboleta_volta',
                animName = 'borboleta_volta',
                boneId = 24818,
                offsetPosition = vector3( 0.58, 0.00, 0.19 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
