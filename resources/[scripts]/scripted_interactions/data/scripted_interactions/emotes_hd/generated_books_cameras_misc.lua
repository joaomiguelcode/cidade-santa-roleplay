-- Generated Emotes - books_cameras_misc
-- Auto-generated from emotes_with_props.json
-- Total emotes: 2

-- ~r~WC ~o~ Tikitoki 66 A [White8vo] (Generated)
DEFINE_SCRIPTED_INTERACTION "emote_wc_tkt66a" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'wc_tikitoki66@animations',
            name = 'bugatti-trend-fast',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
        {
            modelName = 'prop_cs_sol_glasses',
            boneId = 12844,
            offsetPosition = vector3(0.0, 0.0, 0.0),
            offsetRotation = vector3(0.0, 0.0, 0.0),
        }
        }
    }
}
-- ~r~WC ~o~ Tikitoki 66 B [White8vo] (Generated)
DEFINE_SCRIPTED_INTERACTION "emote_wc_tkt66b" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'wc_tikitoki66@animations',
            name = 'bugatti-trend-slow',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
        {
            modelName = 'prop_cs_sol_glasses',
            boneId = 12844,
            offsetPosition = vector3(0.0, 0.0, 0.0),
            offsetRotation = vector3(0.0, 0.0, 0.0),
        }
        }
    }
}
