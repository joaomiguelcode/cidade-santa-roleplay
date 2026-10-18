CameraConfig = {
    ['DEFAULT'] = {
        USE_GHOSTED_PEDS = false,
        START_POS     = vector4(2443.5544433594, 3779.8005371094, 41.061305999756, 255.27941894531),
        PED_POSITIONS = {
            {
                coord = vec4(2446.8537597656, 3780.0979003906, 41.06, 219.9997253418),
                anim = {
                    dict = 'timetable@ron@ig_3_couch',
                    anim = 'base'
                }
            },
            {
                coord = vec4(2449.0297851562, 3778.8103808594, 41.240409851074, 109.9998550415),
                anim = {
                    dict = 'switch@franklin@stripclub2',
                    anim = 'ig_16_base'
                },
                prop = {
                    model = 'prop_anim_cash_pile_01',
                    bone = 57005, -- right hand
                    pos = { x = 0.13, y = 0.01, z = -0.03 },
                    rot = { x = 10.0, y = 10.0, z = 0.0 }
                }
            },
            {
                coord = vec4(2449.2329101562, 3777.1164550781, 41.385364532471, 34.999984741211),
                anim = {
                    dict = 'switch@michael@parkbench_smoke_ranger',
                    anim = 'parkbench_smoke_ranger_loop'
                }
            },
            {
                coord = vec4(2448.2421875, 3776.4326171875, 41.33, 39.999294281006),
                anim = {
                    dict = 'switch@michael@ronex_ig_5_p2',
                    anim = 'base_michael'
                }
            },
            {
                coord = vec4(2446.484375, 3777.931640625, 41.280731201172, 299.9997253418),
                anim = {
                    dict = 'amb@world_human_picnic@female@base',
                    anim = 'base'
                }
            },
        },
        CAMERAS       = {
            {
                fov = 55.0,
                speed = 30000,
                pointAt = vec4(2448.5, 3778.8, 41.2, 132.7),
                nodes = {
                    vec4(2444.59375, 3780.1105957031, 41.0, 247.95907592773),
                    vec4(2446.5, 3775.6, 40.8, 327.9)
                }
            }
        },

        MODELS        = {
            ['locked']   = { 'mp_f_freemode_01', 'mp_f_freemode_01' },
            ['unlocked'] = 'mp_f_freemode_01',
        }
    },
    ['Fronteira'] = {
        USE_GHOSTED_PEDS = false,
        START_POS     = vector4(2443.5544433594, 3779.8005371094, 41.061305999756, 255.27941894531),
        PED_POSITIONS = {
            {
                coord = vec4(2449.9297851562, 3779.0103808594, 40.660009851074, 101.9998550415),
                anim = {
                    dict = 'timetable@michael@on_clubchairidle_b',
                    anim = 'on_clubchair_d'
                },
                prop = {
                    model = 'prop_anim_cash_pile_01',
                    bone = 57005, -- right hand
                    pos = { x = 0.13, y = 0.01, z = -0.03 },
                    rot = { x = 10.0, y = 10.0, z = 0.0 }
                }
            },
            {
                coord = vec4(2446.8537597656, 3780.0979003906, 41.06, 219.9997253418),
                anim = {
                    dict = 'timetable@ron@ig_3_couch',
                    anim = 'base'
                }
            },
            {
                coord = vec4(2449.2329101562, 3777.1164550781, 41.385364532471, 34.999984741211),
                anim = {
                    dict = 'switch@michael@parkbench_smoke_ranger',
                    anim = 'parkbench_smoke_ranger_loop'
                }
            },
            {
                coord = vec4(2448.2421875, 3776.4326171875, 41.33, 39.999294281006),
                anim = {
                    dict = 'switch@michael@ronex_ig_5_p2',
                    anim = 'base_michael'
                }
            },
            {
                coord = vec4(2446.484375, 3777.931640625, 41.280731201172, 299.9997253418),
                anim = {
                    dict = 'amb@world_human_picnic@female@base',
                    anim = 'base'
                }
            },
        },
        CAMERAS       = {
            {
                fov = 55.0,
                speed = 30000,
                pointAt = vec4(2448.5, 3778.8, 41.2, 132.7),
                nodes = {
                    vec4(2444.59375, 3780.1105957031, 41.0, 247.95907592773),
                    vec4(2446.5, 3775.6, 40.8, 327.9)
                }
            }
        },

        MODELS        = {
            ['locked']   = { 'mp_m_character_select', 'mp_f_character_select' },
            ['unlocked'] = 'mp_f_freemode_01',
        }
    }
}

-- Krown reusa a mesma cena/câmera da Fronteira (peds, spline cam e modelos idênticos).
CameraConfig['Krown'] = CameraConfig['Fronteira']
