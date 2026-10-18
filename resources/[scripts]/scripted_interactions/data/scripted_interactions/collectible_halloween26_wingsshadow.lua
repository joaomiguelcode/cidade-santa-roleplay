DEFINE_SCRIPTED_INTERACTION 'collectible_halloween26_wingsshadow' {
    canSwitchState = false,
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'halloweenasa',
                boneId = 24818,
                offsetPosition = vector3( 0.18, -0.10, 0.0 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),
                animDict = 'clip@halloweenasa',
                animName = 'halloweenasa',
            },
        },
    },
}
