DEFINE_SCRIPTED_INTERACTION 'emote_pneu3' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'anim@heists@box_carry@',
            name  = 'idle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'imp_prop_impexp_tyre_01a',
                boneId = 28422,
                offsetPosition = vector3(-0.02, -0.1, 0.2),
                offsetRotation = vector3(10.0, 0.0, 0.0),
            }
        }
    }
}
