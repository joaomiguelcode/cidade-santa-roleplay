DEFINE_SCRIPTED_INTERACTION 'collectible_pet_sloth' {
    canSwitchState = false,
    displayName = 'collectibles.pets.sloth.name',

    {
        title = 'collectibles.pets.sloth.foot.title',
        description = 'collectibles.pets.sloth.foot.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'preguica_santagroup',
                animDict = 'clip@preguica_perna',
                animName = 'preguica_perna',
                boneId = 36864,
                offsetPosition = vector3( 0.16, -0.08, 0.14 ),
                offsetRotation = vector3( 0.00, -93.00, -160.00 ),
            },
        },
    },
}
