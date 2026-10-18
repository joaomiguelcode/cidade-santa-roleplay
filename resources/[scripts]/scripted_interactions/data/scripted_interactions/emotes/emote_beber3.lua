DEFINE_SCRIPTED_INTERACTION 'emote_beber3' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'amb@world_human_drinking@beer@male@idle_a',
            name  = 'idle_a',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_amb_beer_bottle',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.05),
            }
        }
    }
}
