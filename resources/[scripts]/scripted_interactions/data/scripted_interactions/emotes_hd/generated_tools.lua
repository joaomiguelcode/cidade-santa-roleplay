-- ~r~WC ~o~ Tikitoki 149 B [White8vo] (Generated)
DEFINE_SCRIPTED_INTERACTION "emote_wc_tkt149b" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'wc_tikitoki149@animations',
            name = 'dj_menina_do_job_jj_kane_2_walk',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
        {
            modelName = 'prop_boombox_01',
            boneId = 28422,
            offsetPosition = vector3(0.02, 0.02, -0.2),
            offsetRotation = vector3(-10.0, 0.0, -100.0),
        }
        }
    }
}

-- 🤼 ~r~WC ~b~ Castigate Pull With Shovel Right 1 [Shared] (Generated)
DEFINE_SCRIPTED_INTERACTION "emote_wc_c_shared_029" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'wc_c_shared_029@animations',
            name = 'pazeee@punish@zzp@clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
        {
            modelName = 'prop_tool_shovel4',
            boneId = 24817,
            offsetPosition = vector3(-1.4, -0.61, -0.81),
            offsetRotation = vector3(-25.69, 84.302, 25.43),
        }
        }
    }
}

-- 🤼 ~r~WC ~b~ Castigate Pull With Shovel Left 1 [Shared] (Generated)
DEFINE_SCRIPTED_INTERACTION "emote_wc_c_shared_031" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'wc_c_shared_031@animations',
            name = 'pazeee@punish@zzr@clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
        {
            modelName = 'prop_tool_shovel4',
            boneId = 24818,
            offsetPosition = vector3(-1.65, -0.47, 0.5),
            offsetRotation = vector3(-10.0, 90.0, 0.0),
        }
        }
    }
}

