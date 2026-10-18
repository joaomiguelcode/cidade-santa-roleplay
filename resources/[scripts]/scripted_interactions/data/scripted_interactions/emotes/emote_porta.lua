DEFINE_SCRIPTED_INTERACTION 'emote_porta' {
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
                modelName = 'imp_prop_impexp_car_door_04a',
                boneId = 28422,
                offsetPosition = vector3(-0.5, -0.15, -0.1),
                offsetRotation = vector3(0.0, 0.0, 90.0),
            }
        }
    }
}
