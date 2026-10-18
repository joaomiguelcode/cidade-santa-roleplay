DEFINE_SCRIPTED_INTERACTION 'collectible_girls_doglaco' {
    {
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = { dict = 'clip@playerbolca', name = 'playerbolcaclip', flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY },
        props = { { modelName = 'dog2barbie', animDict = 'clip@dog2barbie', animName = 'dog2barbie', boneId = 61163, offsetPosition = vector3( 0.16, -0.145, 0.065 ), offsetRotation = vector3( -75.0, 90.0, -26.0 ) } },
    },
}
