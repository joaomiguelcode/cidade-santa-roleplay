DEFINE_SCRIPTED_INTERACTION 'collectible_pet_seal' {
    canSwitchState = true,
    displayName = 'collectibles.pets.seal.name',

    {
        name = 'right_shoulder',
        title = 'collectibles.pets.seal.right_shoulder.title',
        description = 'collectibles.pets.seal.right_shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'foca_santagroup',
                animDict = 'clip@foca_direita',
                animName = 'foca_direita',
                boneId = 24818,
                offsetPosition = vector3( 0.27, -0.12, 0.14 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'left_shoulder',
        title = 'collectibles.pets.seal.left_shoulder.title',
        description = 'collectibles.pets.seal.left_shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'foca_santagroup',
                animDict = 'clip@foca_esquerda',
                animName = 'foca_esquerda',
                boneId = 24818,
                offsetPosition = vector3( 0.26, -0.13, -0.14 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
