DEFINE_SCRIPTED_INTERACTION 'collectible_girls_pinkcat' {
    {
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = {
            dict = 'clip@playerbolca',
            name = 'playerbolcaclip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY
        },
        props = {
            { modelName = 'gatobarbie', animDict = 'clip@gatobarbie', animName = 'gatobarbie', boneId = 61163, offsetPosition = vector3(0.16, -0.15, 0.065), offsetRotation = vector3(-75.0, 90.0, -26.0) }
        },
    },
}