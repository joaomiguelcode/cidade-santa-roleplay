DEFINE_SCRIPTED_INTERACTION 'collectible_girls_dogoculos' {
    {
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,
        animation = { dict = 'clip@playerbolca', name = 'playerbolcaclip', flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY },
        props = { { modelName = 'dogbarbie', animDict = 'clip@dogbarbie', animName = 'dogbarbie', boneId = 61163, offsetPosition = vector3( 0.16, -0.16, 0.07 ), offsetRotation = vector3( -75.0, 90.0, -26.0 ) } },
    },
}
