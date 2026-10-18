DEFINE_SCRIPTED_INTERACTION 'collectible_pet_cat_white' {
    canSwitchState = true,
    displayName = 'collectibles.pets.cat_white.name',

    {
        name = 'neck',
        title = 'collectibles.pets.cat_white.neck.title',
        description = 'collectibles.pets.cat_white.neck.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'gato2_santagroup',
                animDict = 'clip@gato_deitado',
                animName = 'gato_deitado',
                boneId = 24818,
                offsetPosition = vector3( 0.33, -0.14, -0.06 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
    {
        name = 'shoulder_sleeping',
        title = 'collectibles.pets.cat_white.shoulder_sleeping.title',
        description = 'collectibles.pets.cat_white.shoulder_sleeping.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'gato2_santagroup',
                animDict = 'clip@gato_dormindo',
                animName = 'gato_dormindo',
                boneId = 24818,
                offsetPosition = vector3( 0.30, -0.04, 0.10 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
