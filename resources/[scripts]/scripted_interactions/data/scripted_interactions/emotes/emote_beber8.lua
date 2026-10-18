DEFINE_SCRIPTED_INTERACTION 'emote_beber8' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'amb@world_human_drinking@coffee@male@idle_a',
            name  = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_plastic_cup_02',
                boneId = 28422,
            }
        }
    }
}
