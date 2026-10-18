DEFINE_SCRIPTED_INTERACTION 'emote_pipoca' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'amb@code_human_wander_drinking@beer@male@base',
            name  = 'static',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_pipoca_sg',
                boneId = 28422,
            }
        }
    }
}
