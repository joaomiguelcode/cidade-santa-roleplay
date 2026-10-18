-- Props - Inventory Items
-- Auto-generated from inventory/config.lua
-- Total: 1 interactions

DEFINE_SCRIPTED_INTERACTION "inventory_rose" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'anim@heists@humane_labs@finale@keycards',
            name = 'ped_a_enter_loop',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]] --[[ 49 ]]
        },
        props = {
            {
                modelName = 'prop_single_rose',
                boneId = 60309,
                offsetPosition = vector3(0.030300377868343, -0.089448889096099, 0.057604746626449),
                offsetRotation = vector3(61.220232495974, 16.591771864914, 40.802979865805),
            }
        }
    }
}

