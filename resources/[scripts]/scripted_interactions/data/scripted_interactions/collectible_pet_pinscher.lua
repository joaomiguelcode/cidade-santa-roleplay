DEFINE_SCRIPTED_INTERACTION 'collectible_pet_pinscher' {
    canSwitchState = false,
    displayName = 'collectibles.pets.pinscher.name',

    {
        title = 'collectibles.pets.pinscher.lap.title',
        description = 'collectibles.pets.pinscher.lap.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = {
            dict = 'clip@player_pincher',
            name = 'playpincher_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pincher_santagroup',
                animDict = 'clip@pincher_colo',
                animName = 'pincher_colo',
                boneId = 24818,
                offsetPosition = vector3( 0.03, 0.19, 0.15 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
