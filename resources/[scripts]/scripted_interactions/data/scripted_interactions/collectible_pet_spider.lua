DEFINE_SCRIPTED_INTERACTION 'collectible_pet_spider' {
    canSwitchState = false,
    displayName = 'collectibles.pets.spider.name',

    {
        title = 'collectibles.pets.spider.shoulder.title',
        description = 'collectibles.pets.spider.shoulder.description',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'halloweenaranha',
                animDict = 'clip@halloweenaranha',
                animName = 'halloweenaranha',
                boneId = 24818,
                offsetPosition = vector3( 0.27, -0.08, 0.18 ),
                offsetRotation = vector3( -180.00, -90.00, 0.00 ),
            },
        },
    },
}
