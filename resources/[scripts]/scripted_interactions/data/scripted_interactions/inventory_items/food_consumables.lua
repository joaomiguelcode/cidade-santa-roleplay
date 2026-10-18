-- Food Consumables - Inventory Items
-- Generated from ItemProps table with animations and offsets from emotes_hd
-- Total: 90 interactions (49 original + 41 new from emote mappings)

--[[ Fast Food - Burgers ]]

DEFINE_SCRIPTED_INTERACTION "inventory_hamburger" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'hamburger2_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_hamburger2" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'hamburger2_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_fries" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'batata_frita_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_onionrings" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'onionrings',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_hotdog" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_hotdog_02',
                boneId = 60309,
                offsetPosition = vector3(-0.03, 0.01, -0.01),
                offsetRotation = vector3(95.1071, 94.7001, -66.9179),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_sandwich" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_sandwich_01',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.05, 0.02),
                offsetRotation = vector3(-50.0, 16.0, 60.0),
            }
        }
    }
}

--[[ Pizza Items ]]

DEFINE_SCRIPTED_INTERACTION "inventory_pizzamozzarella" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_pizza_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_pizzamushroom" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_pizza_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_pizzabanana" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_pizza_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_pizzachocolate" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_pizza_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_calzone" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_pizza_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

--[[ Sweets and Desserts ]]

DEFINE_SCRIPTED_INTERACTION "inventory_donut" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'donuts_sg',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.05, 0.02),
                offsetRotation = vector3(-50.0, 16.0, 60.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_cupcake" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@pnq',
            name = 'loop',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_candy_pqs',
                boneId = 60309,
                offsetPosition = vector3(-0.03, 0.018, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_chocolate" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'doce_chocolate2_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_cookies" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'comida_cookie_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_applelove" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'macadoamor_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

--[[ Drinks - Milkshake and Soda ]]

DEFINE_SCRIPTED_INTERACTION "inventory_milkshake" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@code_human_wander_drinking@female@base',
            name = 'static',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'brum_cherryshake_cherry',
                boneId = 28422,
                offsetPosition = vector3(0.003, 0.028, 0.08),
                offsetRotation = vector3(-180.0, -180.0, 30.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_soda" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'ng_proc_sodacan_01b',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 130.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_energetico" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_p_sf_grass_gls_s_01a',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, -0.14),
                offsetRotation = vector3(0.0, 0.0, 9.0),
            }
        }
    }
}

--[[ Drinks - Water and Coffee ]]

DEFINE_SCRIPTED_INTERACTION "inventory_water" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'vw_prop_casino_water_bottle_01a',
                boneId = 60309,
                offsetPosition = vector3(0.008, 0.0, -0.05),
                offsetRotation = vector3(0.0, 0.0, -40.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_coffee" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'cafezinho',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_coffeemilk" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'cappuccino_sg',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_cappuccino" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bebida_frapuccino_sg',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

--[[ Alcohol - Beer, Whiskey, Vodka, Champagne, Cognac ]]

DEFINE_SCRIPTED_INTERACTION "inventory_dewars" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'h4_prop_battle_whiskey_bottle_2_s',
                boneId = 60309,
                offsetPosition = vector3(0.008, 0.001, 0.016),
                offsetRotation = vector3(3.569, 4.6611, -49.9065),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_absolut" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_vodka_bottle',
                boneId = 60309,
                offsetPosition = vector3(0.008, 0.001, 0.016),
                offsetRotation = vector3(3.569, 4.6611, -49.9065),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_chandon" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_champ_01a',
                boneId = 60309,
                offsetPosition = vector3(0.008, 0.001, 0.016),
                offsetRotation = vector3(3.569, 4.6611, -49.9065),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_hennessy" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_rum_bottle',
                boneId = 60309,
                offsetPosition = vector3(0.008, 0.001, 0.016),
                offsetRotation = vector3(3.569, 4.6611, -49.9065),
            }
        }
    }
}

--[[ Fruits ]]

DEFINE_SCRIPTED_INTERACTION "inventory_apple" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_banana" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'fruta_banana_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_orange" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'fruta_laranja_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_tange" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_grape" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_grapes_01',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_strawberry" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_tomato" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_acerola" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_guarana" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_passion" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'sf_prop_sf_apple_01b',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

--[[ Fruit Juices ]]

DEFINE_SCRIPTED_INTERACTION "inventory_tangejuice" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'suco_cenoura_sg',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, -0.14),
                offsetRotation = vector3(0.0, 0.0, 9.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_grapejuice" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'suco_uva_sg',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, -0.14),
                offsetRotation = vector3(0.0, 0.0, 9.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_strawberryjuice" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'suco_morango_sg',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, -0.14),
                offsetRotation = vector3(0.0, 0.0, 9.0),
            }
        }
    }
}

--[[ Medical Items ]]

DEFINE_SCRIPTED_INTERACTION "inventory_bandage" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_clipboard@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_ld_health_pack',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_analgesic" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_clipboard@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_pills',
                boneId = 60309,
                offsetPosition = vector3(-0.03, 0.018, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

--[[ Tools and Misc ]]

DEFINE_SCRIPTED_INTERACTION "inventory_binoculars" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_binoculars@male@idle_b',
            name = 'idle_f',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_binoc_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_canofbeans" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1',
            name = 'base_idle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'h4_prop_h4_caviar_tin_01a',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.03, 0.01),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_toolbox1" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'move_weapon@jerrycan@generic',
            name = 'idle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_tool_box_04',
                boneId = 57005,
                offsetPosition = vector3(0.33, 0.0, -0.03),
                offsetRotation = vector3(0.0017365, -79.9999997, 110.0651988),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_toolbox2" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'move_weapon@jerrycan@generic',
            name = 'idle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_tool_box_04',
                boneId = 57005,
                offsetPosition = vector3(0.33, 0.0, -0.03),
                offsetRotation = vector3(0.0017365, -79.9999997, 110.0651988),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_teddy" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'impexp_int-0',
            name = 'mp_m_waremech_01_dual-0',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'v_ilev_mr_rasberryclean',
                boneId = 24817,
                offsetPosition = vector3(-0.2, 0.46, -0.016),
                offsetRotation = vector3(-180.0, -90.0, 0.0),
            }
        }
    }
}

--[[ Cigarettes ]]

DEFINE_SCRIPTED_INTERACTION "inventory_cigarette" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_aa_smoke@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_ciggy_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

--[[ Drugs ]]

DEFINE_SCRIPTED_INTERACTION "inventory_cocaine" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_smoking@male@male_a@enter',
            name = 'enter',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'h4_prop_h4_coke_spatula_01',
                boneId = 47419,
                offsetPosition = vector3(0.01, 0.0, 0.0),
                offsetRotation = vector3(50.0, 0.0, -80.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_joint" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_aa_smoke@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'p_amb_joint_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

DEFINE_SCRIPTED_INTERACTION "inventory_meth" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_smoking@male@male_a@enter',
            name = 'enter',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_meth_pipe',
                boneId = 47419,
                offsetPosition = vector3(0.01, 0.0, 0.0),
                offsetRotation = vector3(50.0, 0.0, -80.0),
            }
        }
    }
}

--[[ New Food and Drink Items - Generated from emote mappings ]]

-- Xmas Snowflake Cookie (food_cookie)
DEFINE_SCRIPTED_INTERACTION "inventory_food_cookie" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pata_christmasfood2',
                boneId = 60309,
                offsetPosition = vector3(0.02, -0.05, 0.02),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

-- Xmas Cupcake Brownie (food_brownie)
DEFINE_SCRIPTED_INTERACTION "inventory_food_brownie" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pata_christmasfood6',
                boneId = 60309,
                offsetPosition = vector3(0.01, 0.02, -0.01),
                offsetRotation = vector3(-170.1788, 87.6716, 30.054),
            }
        }
    }
}

-- Croissant (food_croissant)
DEFINE_SCRIPTED_INTERACTION "inventory_food_croissant" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_foodpack_croissant001',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.01),
                offsetRotation = vector3(0.0, 0.0, 90.0),
            }
        }
    }
}

-- Burger (food_burger)
DEFINE_SCRIPTED_INTERACTION "inventory_food_burger" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

-- Double Burger (food_double_burger)
DEFINE_SCRIPTED_INTERACTION "inventory_food_double_burger" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

-- Batata Frita (food_batata_frita) - uses burger anim with batata_frita_sg prop
DEFINE_SCRIPTED_INTERACTION "inventory_food_batata_frita" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'batata_frita_sg',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

-- Cat Cookie (food_cat_cookie)
DEFINE_SCRIPTED_INTERACTION "inventory_food_cat_cookie" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pata_christmasfood2',
                boneId = 60309,
                offsetPosition = vector3(0.02, -0.05, 0.02),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

-- Cat Cake (food_cat_cake)
DEFINE_SCRIPTED_INTERACTION "inventory_food_cat_cake" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pata_christmasfood8',
                boneId = 60309,
                offsetPosition = vector3(0.02, 0.0, -0.01),
                offsetRotation = vector3(9.3608, -90.1809, 66.3689),
            }
        }
    }
}

-- Pizza Slice (food_pizza_slice)
DEFINE_SCRIPTED_INTERACTION "inventory_food_pizza_slice" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'knjgh_pizzaslice2',
                boneId = 60309,
                offsetPosition = vector3(0.05, -0.02, -0.02),
                offsetRotation = vector3(73.6928, -66.7427, 68.3677),
            }
        }
    }
}

-- Pizza Pepperoni (food_pizza_pepperoni)
DEFINE_SCRIPTED_INTERACTION "inventory_food_pizza_pepperoni" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'knjgh_pizzaslice5',
                boneId = 60309,
                offsetPosition = vector3(0.05, -0.02, -0.02),
                offsetRotation = vector3(73.6928, -66.7427, 68.3677),
            }
        }
    }
}

-- Pizza Mussarela (food_pizza_mussarela)
DEFINE_SCRIPTED_INTERACTION "inventory_food_pizza_mussarela" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'knjgh_pizzaslice4',
                boneId = 60309,
                offsetPosition = vector3(0.05, -0.02, -0.02),
                offsetRotation = vector3(73.6928, -66.7427, 68.3677),
            }
        }
    }
}

-- Taco (food_taco)
DEFINE_SCRIPTED_INTERACTION "inventory_food_taco" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_taco_01',
                boneId = 60309,
                offsetPosition = vector3(-0.017, 0.007, -0.021),
                offsetRotation = vector3(107.9846, -105.0251, 55.7779),
            }
        }
    }
}

-- Burrito (food_burrito)
DEFINE_SCRIPTED_INTERACTION "inventory_food_burrito" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_taco_01',
                boneId = 60309,
                offsetPosition = vector3(-0.017, 0.007, -0.021),
                offsetRotation = vector3(107.9846, -105.0251, 55.7779),
            }
        }
    }
}

-- Nachos (food_nachos)
DEFINE_SCRIPTED_INTERACTION "inventory_food_nachos" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_taco_01',
                boneId = 60309,
                offsetPosition = vector3(-0.017, 0.007, -0.021),
                offsetRotation = vector3(107.9846, -105.0251, 55.7779),
            }
        }
    }
}

-- Petisco (food_petisco) - uses burger anim with onionrings prop
DEFINE_SCRIPTED_INTERACTION "inventory_food_petisco" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'onionrings',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

-- Amendoim (food_amendoim) - uses burger anim with onionrings prop
DEFINE_SCRIPTED_INTERACTION "inventory_food_amendoim" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'onionrings',
                boneId = 60309,
                offsetPosition = vector3(0.0, 0.0, -0.02),
                offsetRotation = vector3(30.0, 0.0, 0.0),
            }
        }
    }
}

-- Horchata (drink_horchata)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_horchata" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mulled_wine_a',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.03, 0.05),
                offsetRotation = vector3(-110.0, -47.0, 7.0),
            }
        }
    }
}

-- Caipirinha (drink_caipirinha)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_caipirinha" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mulled_wine_a',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.03, 0.05),
                offsetRotation = vector3(-110.0, -47.0, 7.0),
            }
        }
    }
}

-- Mojito (drink_mojito)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_mojito" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mulled_wine_a',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.03, 0.05),
                offsetRotation = vector3(-110.0, -47.0, 7.0),
            }
        }
    }
}

-- Shot (drink_shot)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_shot" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mulled_wine_a',
                boneId = 18905,
                offsetPosition = vector3(0.13, 0.03, 0.05),
                offsetRotation = vector3(-110.0, -47.0, 7.0),
            }
        }
    }
}

-- Suco Limao (drink_suco_limao)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_suco_limao" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_orang_can_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 130.0),
            }
        }
    }
}

-- Cat Latte (drink_cat_latte)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_cat_latte" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mug_a',
                boneId = 18905,
                offsetPosition = vector3(0.09, -0.01, 0.08),
                offsetRotation = vector3(-44.0, 137.0, 9.0),
            }
        }
    }
}

-- Cat Choco (drink_cat_choco)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_cat_choco" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_aa_coffee@base',
            name = 'base',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pata_christmasfood1',
                boneId = 28422,
                offsetPosition = vector3(0.01, -0.11, -0.13),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

-- Cafe (drink_cafe)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_cafe" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'p_amb_coffeecup_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 0.0),
            }
        }
    }
}

-- Cappuccino (drink_cappuccino)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_cappuccino" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mug_a',
                boneId = 18905,
                offsetPosition = vector3(0.09, -0.01, 0.08),
                offsetRotation = vector3(-44.0, 137.0, 9.0),
            }
        }
    }
}

-- Mocha (drink_mocha)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_mocha" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mp_player_intdrink',
            name = 'loop_bottle',
            flags = eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'bzzz_food_xmas_mug_b',
                boneId = 18905,
                offsetPosition = vector3(0.09, -0.01, 0.08),
                offsetRotation = vector3(-44.0, 137.0, 9.0),
            }
        }
    }
}

-- Refrigerante (drink_refrigerante)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_refrigerante" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'smo@milkshake_idle',
            name = 'milkshake_idle_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'rpemotesreborn_soda01',
                boneId = 28422,
                offsetPosition = vector3(0.047, 0.004, -0.06),
                offsetRotation = vector3(-88.0263, -25.0367, -27.3898),
            }
        }
    }
}

-- Milkshake (drink_milkshake)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_milkshake" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'smo@milkshake_idle',
            name = 'milkshake_idle_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'brum_cherryshake_chocolate',
                boneId = 28422,
                offsetPosition = vector3(0.085, 0.067, -0.035),
                offsetRotation = vector3(-115.0862, -165.7841, 24.1318),
            }
        }
    }
}

-- Suco (drink_suco)
DEFINE_SCRIPTED_INTERACTION "inventory_drink_suco" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_orang_can_01',
                boneId = 28422,
                offsetPosition = vector3(0.0, 0.0, 0.0),
                offsetRotation = vector3(0.0, 0.0, 130.0),
            }
        }
    }
}

--[[ Combo Items - All use cofpose emote ]]

-- Combo Mojito Night (combo_mojito_night)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_mojito_night" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Mojito Party (combo_mojito_party)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_mojito_party" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Mex Fiesta (combo_mex_fiesta)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_mex_fiesta" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Mex Basic (combo_mex_basic)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_mex_basic" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Pizza Classic (combo_pizza_classic)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_pizza_classic" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Pizza Full (combo_pizza_full)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_pizza_full" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo BS Simples (combo_bs_simples)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_bs_simples" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo BS Duplo (combo_bs_duplo)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_bs_duplo" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Cat Basic (combo_cat_basic)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_cat_basic" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Bean Classic (combo_bean_classic)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_bean_classic" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Bean Premium (combo_bean_premium)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_bean_premium" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}

-- Combo Cat Sweet (combo_cat_sweet)
DEFINE_SCRIPTED_INTERACTION "inventory_combo_cat_sweet" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'chocoholic@single23',
            name = 'single23_clip',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'prop_fib_coffee',
                boneId = 28422,
                offsetPosition = vector3(0.072, 0.039, -0.023),
                offsetRotation = vector3(-125.8797, -168.4347, 17.4518),
            },
            {
                modelName = 'prop_cs_burger_01',
                boneId = 60309,
                offsetPosition = vector3(0.086, 0.003, 0.057),
                offsetRotation = vector3(106.1459, 8.0371, 17.0945),
            }
        }
    }
}
