DEFINE_SCRIPTED_INTERACTION 'emote_comer6' {
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
                modelName = 'prop_taco_01',
                boneId = 18905,
                offsetPosition = vector3(0.16, 0.06, 0.02),
                offsetRotation = vector3(-50.0, 220.0, 60.0),
            }
        }
    }
}
