DEFINE_SCRIPTED_INTERACTION 'collectible_halloween26_ghostboo' {
    canSwitchState = false,
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'halloweenfantasma',
                boneId = 24818,
                offsetPosition = vector3( 0.42, 0.10, -0.34 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),
                animDict = 'clip@halloweenfantasmaosso',
                animName = 'halloweenfantasma',
                animDict2 = 'clip@halloweenfantasmatextura',
                animName2 = 'halloweenfantasma',
            },
        },
    },
}
