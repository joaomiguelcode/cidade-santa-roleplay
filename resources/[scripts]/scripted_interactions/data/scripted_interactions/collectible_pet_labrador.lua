DEFINE_SCRIPTED_INTERACTION 'collectible_pet_labrador' {
    canSwitchState = false,
    displayName = 'collectibles.pets.labrador.name',

    {
        title = 'collectibles.pets.labrador.lap.title',
        description = 'collectibles.pets.labrador.lap.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = {
            dict = 'clip@player_labrador',
            name = 'playlabradora_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'labrador_santagroup',
                animDict = 'clip@labrador_colo',
                animName = 'labrador_colo',
                boneId = 24818,
                offsetPosition = vector3( 0.00, 0.24, -0.08 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
