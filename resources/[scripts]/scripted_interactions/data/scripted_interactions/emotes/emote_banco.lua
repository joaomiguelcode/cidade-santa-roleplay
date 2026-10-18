DEFINE_SCRIPTED_INTERACTION 'emote_banco' {
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
                modelName = 'prop_car_seat',
                boneId = 28422,
                offsetPosition = vector3(0.0, -0.2, -0.14),
            }
        }
    }
}
