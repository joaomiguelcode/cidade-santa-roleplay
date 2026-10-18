-- Misc - Inventory Items
-- Auto-generated from inventory/config.lua
-- Total: 9 interactions

DEFINE_SCRIPTED_INTERACTION "inventory_lanca" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@incar@male@smoking@enter',
            name = 'enter',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'mah_lanca',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_milho" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@code_human_wander_eating_donut@male@idle_a',
            name = 'idle_a',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'pru_milho',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_tyres" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@heists@box_carry@',
            name = 'idle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'imp_prop_impexp_tyre_01a',
                boneId = 28422,
                offsetPosition = vector3(-0.02, -0.1, 0.2),
                offsetRotation = vector3(10.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_guarananatural" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'prop_food_bs_juice02',
                boneId = 28422,
                offsetPosition = vector3(0.0, -0.01, -0.15),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_gamebooster" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'sg_boostgamer_prop_02',
                boneId = 28422,
                offsetPosition = vector3(0.0, -0.01, -0.06),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_gamebooster1" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'sg_boostgamer_prop_02',
                boneId = 28422,
                offsetPosition = vector3(0.0, -0.01, -0.06),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_sinkalmy" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'vw_prop_casino_water_bottle_01a',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.06),
                offsetRotation = vector3(0.0, 0.0, 130.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_ritmoneury" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'vw_prop_casino_water_bottle_01a',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.06),
                offsetRotation = vector3(0.0, 0.0, 130.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_cola" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'prop_ecola_can',
                boneId = 60309,
                offsetPosition = vector3(0.01, 0.01, 0.05),
                offsetRotation = vector3(0.0, 0.0, 90.0),
            }
        }
    }
}

