DEFINE_SCRIPTED_INTERACTION 'emote_prebeber' {
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
                modelName = 'p_amb_coffeecup_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, -0.05),
            }
        }
    }
}
