DEFINE_SCRIPTED_INTERACTION 'emote_comer5' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'mp_player_inteat@burger',
            name  = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_sandwich_01',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.05, 0.02),
                offsetRotation = vector3(-50.0, 16.0, 60.0),
            }
        }
    }
}
