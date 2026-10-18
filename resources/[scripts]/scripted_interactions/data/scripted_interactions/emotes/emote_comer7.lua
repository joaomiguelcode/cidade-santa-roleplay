DEFINE_SCRIPTED_INTERACTION 'emote_comer7' {
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
                modelName = 'prop_food_bs_chips',
                boneId = 18905,
                offsetPosition = vector3(0.1, 0.0, 0.08),
                offsetRotation = vector3(150.0, 320.0, 160.0),
            }
        }
    }
}
