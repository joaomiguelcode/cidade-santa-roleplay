DEFINE_SCRIPTED_INTERACTION 'emote_comer4' {
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
                modelName = 'prop_choc_ego',
                boneId = 60309,
            }
        }
    }
}
