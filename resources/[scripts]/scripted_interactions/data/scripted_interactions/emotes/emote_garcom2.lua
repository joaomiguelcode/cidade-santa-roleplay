DEFINE_SCRIPTED_INTERACTION 'emote_garcom2' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'anim@move_f@waitress',
            name  = 'idle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_food_tray_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.01),
            }
        }
    }
}
