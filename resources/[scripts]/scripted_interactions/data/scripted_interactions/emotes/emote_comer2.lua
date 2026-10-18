DEFINE_SCRIPTED_INTERACTION 'emote_comer2' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'amb@code_human_wander_eating_donut@male@idle_a',
            name  = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_hotdog_01',
                boneId = 28422,
            }
        }
    }
}
