DEFINE_SCRIPTED_INTERACTION 'collectible_halloween26_batcrown' {
    canSwitchState = false,
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'halloweenmorcego',
                boneId = 31086,
                offsetPosition = vector3( 0.19, 0.0, 0.0 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),
                animDict = 'clip@halloweenmorcego',
                animName = 'halloweenmorcego',
            },
        },
    },
}
