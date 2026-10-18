DEFINE_SCRIPTED_INTERACTION 'emote_kinderovo' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'amb@code_human_wander_eating_donut@male@idle_a',
            name  = 'idle_a',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'doce_kinder_ovo',
                boneId = 28422,
            }
        }
    }
}
