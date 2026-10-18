DEFINE_SCRIPTED_INTERACTION 'collectible_pet_chicken' {
    canSwitchState = false,
    displayName = 'collectibles.pets.chicken.name',

    {
        title = 'collectibles.pets.chicken.lap.title',
        description = 'collectibles.pets.chicken.lap.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = {
            dict = 'clip@player_galinha',
            name = 'playgalinha_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'galinha_santagroup',
                animDict = 'clip@galinha_braco',
                animName = 'galinha_braco',
                boneId = 24818,
                offsetPosition = vector3( -0.06, 0.10, 0.21 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
