DEFINE_SCRIPTED_INTERACTION 'collectible_icedout_grillsred' {
    canSwitchState = false,
    exclusiveGroup = 'icedout_grills',
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        props = {
            {
                modelName = 'dentecvermelhosantagroup',
                attachAsPed = true,
                boneId = 31086,
                offsetPosition = vector3(-0.014, 0.10, 0.0),
                offsetRotation = vector3(-180.0, -90.0, 0.0),
            },
            {
                modelName = 'dentebvermelhosantagroup',
                attachAsPed = true,
                boneId = 46240,
                offsetPosition = vector3(0.068, 0.0, 0.036),
                offsetRotation = vector3(0.0, -35.0, 90.0),
            },
        },
    },
}
