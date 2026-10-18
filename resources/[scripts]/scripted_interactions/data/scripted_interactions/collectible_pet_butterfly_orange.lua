DEFINE_SCRIPTED_INTERACTION 'collectible_pet_butterfly_orange' {
    canSwitchState = true,
    displayName = 'collectibles.pets.butterfly_orange.name',

    {
        name = 'right',
        title = 'collectibles.pets.butterfly_orange.right.title',
        description = 'collectibles.pets.butterfly_orange.right.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta3_santagroup',
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
        title = 'collectibles.pets.butterfly_orange.left.title',
        description = 'collectibles.pets.butterfly_orange.left.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta3_santagroup',
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
        title = 'collectibles.pets.butterfly_orange.around.title',
        description = 'collectibles.pets.butterfly_orange.around.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'borboleta3_santagroup',
                animDict = 'clip@borboleta_volta',
                animName = 'borboleta_volta',
                boneId = 24818,
                offsetPosition = vector3( 0.58, 0.00, 0.19 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
