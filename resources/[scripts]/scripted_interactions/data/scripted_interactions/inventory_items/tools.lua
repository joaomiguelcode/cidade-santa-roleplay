-- Tools - Inventory Items
-- Auto-generated from inventory/config.lua
-- Total: 1 interactions

DEFINE_SCRIPTED_INTERACTION "inventory_scanner" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'mini@golfai',
            name = 'wood_idle_a',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY, --[[ 49 ]]
        },
        props = {
            {
                modelName = 'w_am_digiscanner',
                boneId = 18905,
                offsetPosition = vector3(0.15, 0.1, 0.0),
                offsetRotation = vector3(-270.0, -180.0, -170.0),
            }
        }
    }
}

