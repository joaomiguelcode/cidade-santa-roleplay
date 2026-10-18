-- Remaining Misc Prop Emotes
-- Auto-generated from RP.PropEmotes
-- Base emotes: 156

-- Firefighter Unmask (Default)
DEFINE_SCRIPTED_INTERACTION "emote_maskup" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@mp_helmets@on_foot',
            name = 'visor_up',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {

        }
    }
}

-- Firefighter Mask (Default)
DEFINE_SCRIPTED_INTERACTION "emote_maskdown" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@mp_helmets@on_foot',
            name = 'visor_down',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {

        }
    }
}

-- Take Off Mask (Default)
DEFINE_SCRIPTED_INTERACTION "emote_masktakeoff" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@scripted@bty5@ig1_intimidate_actor@female_heeled@',
            name = 'mask_action_b',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {

        }
    }
}

-- Firefighter Adjust Tank / Bag (Default)
DEFINE_SCRIPTED_INTERACTION "emote_adjustbag" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_hiker_standing@male@idle_a',
            name = 'idle_b',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {

        }
    }
}

-- Firefighter Pump PSI (Default)
DEFINE_SCRIPTED_INTERACTION "emote_adjustpanel" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@scripted@heist@ig9_control_tower@male@',
            name = 'loop',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {

        }
    }
}

-- Summon (Default)
DEFINE_SCRIPTED_INTERACTION "emote_summon" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@scripted@surv@ig3_plague_summon@male@',
            name = 'summon_a',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'm24_1_prop_m41_zombiestaff_01a',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

-- Summon2 (Default)
DEFINE_SCRIPTED_INTERACTION "emote_summon2" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@scripted@surv@ig3_plague_summon@male@',
            name = 'summon_b',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'm24_1_prop_m41_zombiestaff_01a',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

-- Candle (Default)
DEFINE_SCRIPTED_INTERACTION "emote_candle" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'special_ped@griff@base',
            name = 'base',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'v_res_fa_candle04',
                boneId = 28422,
                offsetPosition = vector3(0.02, 0.01, 0.01),
                offsetRotation = vector3(0.0, 10.0, 0.0),
            }
        }
    }
}

