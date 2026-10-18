-- Generated Emotes - dances
-- Auto-generated from emotes_with_props.json
-- Total new emotes: 31

-- ~r~WC ~b~ Dance F72 [White8vo] (Generated)
DEFINE_SCRIPTED_INTERACTION "emote_wc_f3_072" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'wc_f3_072@animations',
            name = 'pazeee@fournite@rage@clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
        {
            modelName = 'v_ilev_fos_mic',
            boneId = 28422,
            offsetPosition = vector3(0.13, -0.14, -0.24),
            offsetRotation = vector3(-70.0, 15.0, 0.0),
        }
        }
    }
}

