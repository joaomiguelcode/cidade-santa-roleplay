DEFINE_SCRIPTED_INTERACTION 'emote_beber10' {
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
                modelName = 'ng_proc_sodacan_01b',
                boneId = 28422,
                offsetPosition = vector3(0.0, -0.01, -0.08),
            }
        }
    }
}
