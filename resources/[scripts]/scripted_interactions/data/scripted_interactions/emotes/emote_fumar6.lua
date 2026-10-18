DEFINE_SCRIPTED_INTERACTION 'emote_fumar6' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'amb@world_human_aa_smoke@male@idle_a',
            name  = 'idle_b',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_ciggy_01',
                boneId = 28422,
            }
        }
    }
}
