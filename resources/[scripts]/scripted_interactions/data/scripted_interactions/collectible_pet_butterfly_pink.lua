DEFINE_SCRIPTED_INTERACTION 'collectible_pet_butterfly_pink' {
    canSwitchState = true,
    displayName = 'collectibles.pets.butterfly_pink.name',

    {
        name = 'right',
        title = 'collectibles.pets.butterfly_pink.right.title',
        description = 'collectibles.pets.butterfly_pink.right.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta_santagroup',
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
        title = 'collectibles.pets.butterfly_pink.left.title',
        description = 'collectibles.pets.butterfly_pink.left.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta_santagroup',
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
        title = 'collectibles.pets.butterfly_pink.around.title',
        description = 'collectibles.pets.butterfly_pink.around.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta_santagroup',
                animDict = 'clip@borboleta_volta',
                animName = 'borboleta_volta',
                boneId = 24818,
                offsetPosition = vector3( 0.58, 0.00, 0.19 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
