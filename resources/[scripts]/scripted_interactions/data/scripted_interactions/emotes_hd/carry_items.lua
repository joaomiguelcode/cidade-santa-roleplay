-- Weights 5 - Female Pose (Default)
DEFINE_SCRIPTED_INTERACTION "emote_weights5" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'frabi@femalepose@solo@firstsport',
            name = 'fem_pose_sport_001',
            flags = eAnimationFlags.AF_LOOPING,
        },
        props = {
            {
                modelName = 'v_res_tre_weight',
                boneId = 28422,
                offsetPosition = vector3(0.058, -0.006, 0.03),
                offsetRotation = vector3(-11.8498, 170.2644, 7.8352),
            },
            {
                modelName = 'v_res_tre_weight',
                boneId = 60309,
                offsetPosition = vector3(0.088, 0.0, 0.059),
                offsetRotation = vector3(-29.1132, -128.5627, 13.7517),
            }
        }
    }
}

-- Weights 6 - Female Pose 2 (Default)
DEFINE_SCRIPTED_INTERACTION "emote_weights6" {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        canPlayerControl = true,
        animation = {
            dict = 'frabi@femalepose@solo@firstsport',
            name = 'fem_pose_sport_002',
            flags = eAnimationFlags.AF_LOOPING,
        },
        props = {
            {
                modelName = 'v_res_tre_weight',
                boneId = 28422,
                offsetPosition = vector3(0.07, 0.04, -0.06),
                offsetRotation = vector3(24.5966, 6.4814, -13.9845),
            },
            {
                modelName = 'v_res_tre_weight',
                boneId = 60309,
                offsetPosition = vector3(0.055, -0.007, -0.0309),
                offsetRotation = vector3(-20.5854, -15.0123, 0.571),
            }
        }
    }
}

