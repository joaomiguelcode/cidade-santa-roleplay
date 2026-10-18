DEFINE_SCRIPTED_INTERACTION 'potions' {
    {
        name = 'idle',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@drunk@',
            name  = 'drink',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pocao_amarela_pru',
                boneId = 57005,
                offsetPosition = vector3(0.08, 0.02, -0.02),
                offsetRotation = vector3(60.0, 0.0, 180.0),
            }
        }
    },
    {
        name = 'yellow',
        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@drunk@',
            name  = 'drink',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pocao_amarela_pru',
                boneId = 57005,
                offsetPosition = vector3(0.08, 0.02, -0.02),
                offsetRotation = vector3(60.0, 0.0, 180.0),
            }
        }
    },
    {
        name = 'blue',
		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation =
        {
            dict  = 'anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@drunk@',
            name  = 'drink',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props =
        {
            {
                modelName = 'pocao_azul_pru',
                boneId = 57005,
                offsetPosition = vector3(0.08, 0.02, -0.02),
                offsetRotation = vector3(60.0, 0.0, 180.0),
            }
        }
    },
    {
        name = 'green',
		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
        animation = {
            dict  = 'anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@drunk@',
            name  = 'drink',
            flags = eAnimationFlags.AF_LOOPING | eAnimationFlags.AF_UPPERBODY | eAnimationFlags.AF_SECONDARY,
        },
        props = {
            {
                modelName = 'pocao_verde_pru',
                boneId = 57005,
                offsetPosition = vector3(0.08, 0.02, -0.02),
                offsetRotation = vector3(60.0, 0.0, 180.0),
            }
        }
    }
}
