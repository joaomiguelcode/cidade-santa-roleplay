config.interiors = {
    [1] = {
        duration = 30, -- 30 dias
        renewItem = 'pent01', -- item que faz a renovação da penthouse
        id = 1,
        building = 1,
        level = 1,
        title = (translations[language]['level']):format(1),
        address = 'Penthouse Essencial',
        weight = 10000,
        rooms = 3,
        furnished = translations[language]['unfurnished'],
        people = 3,
        visitorOptions = {
            { value = 3, label = ('3 %s'):format(translations[language]['visitors']) }
        },
        price = 99,
        images = {
            showcase = {
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel1.png',
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel1_2.png'
            },
            main = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel1.png'
        },
        big = true,
        entrance = vec4(-588.16, 67.26, 132.66, 138.58),
        settingsLocation = vec4(-590.66, 65.67, 132.66, 104.37),
        chests = {
            {
                coords = vec4(-572.87, 50.97, 132.66, 6.10),
                weight = 10000
            }
        },
        cloakrooms = {
            vec4(-577.72, 61.93, 132.66, 271.45)
        },
        barber = {
            vec4(-572.49, 55.62, 132.66, 2.58)
        },
        tattoo = {
            vec4(-571.30, 61.94, 132.66, 111.61),
        },
        drinks = {
            vec4(-575.54, 49.73, 129.27, 211.01)
        },
        tour = {
            spawn = vec4(-588.07, 67.64, 132.66, 90.71),
            splines = {
                {
                    from     = vec4(-599.50, 6.90, 133.19, 295.34),
                    to       = vec4(-642.24, 60.74, 135.07, 295.34),
                    center   = vec4(-596.48, 53.54, 130.78, 50.81),
                    interval = 5000
                },
                {
                    from = vec4(-629.55, 71.19, 134.5, 295.34),
                    to = vec4(-604.91, 57.29, 134.66, 42.32),
                    center = vec4(-612.16, 63.89, 132.66, 11.86),
                    interval = 5000
                },
                {
                    from = vec4(-607.71, 64.56, 133.20, 295.34),
                    to = vec4(-585.31, 51.68, 133.93, 295.34),
                    center = vec4(-594.31, 59.65, 132.66, 51.72),
                    interval = 5000,
                },
                {
                    from = vec4(-578.63, 86.94, 134.64, 295.34),
                    to = vec4(-563.22, 68.08, 133.40, 247.51),
                    center = vec4(-578.51, 68.97, 132.66, 267.26),
                    interval = 5000
                },
                {
                    from = vec4(-576.99, 32.20, 130.44, 295.34),
                    to = vec4(-592.53, 46.92, 129.32, 265.78),
                    center = vec4(-577.08, 46.72, 129.27, 177.82),
                    interval = 5000
                },
                {
                    from = vec4(-589.95, 46.0, 133.21, 295.34),
                    to = vec4(-577.14, 36.02, 132.65, 295.34),
                    center = vec4(-577.51, 47.29, 132.66, 87.29),
                    interval = 5000
                },
                {
                    from = vec4(-626.24, 75.10, 141.25, 295.34),
                    to = vec4(-567.96, 60.54, 139.35, 295.34),
                    center = vec4(-578.22, 43.41, 136.74, 351.25),
                    interval = 5000
                }
            }
        },
        dry_volumes = {
            {
                min = vector3(-640.37, 19.29, 37.37),
                max = vector3(-568.07, 70.18, 116.67)
            }
        },
        tiers = {
            [1] = {
                ymaps = {
                    ['vertexgroup_cb_water_bloc']   = true,  -- piscina / true: bloqueado, false: desbloqueado
                    ['vertexgroup_cb_deco_01']      = false, -- lounge exterior
                    ['vertexgroup_cb_deco_02']      = false, -- lounge terraço
                    ['vertexgroup_cb_deco_03']      = false, -- moveis da entrada
                    ['vertexgroup_cb_deco_piscina'] = false, -- moveis piscina
                    ['vertexgroup_cb_amb_grass']    = false, -- plantas área externa
                    ['vertexgroup_cb_heli']         = false  -- helipointo
                },
                mlo_entities = {
                    ["vertexgroup_cb_cozinha_mlo"] = {
                        coords = vector3(-577.86400000, 46.44700000, 129.74600000),
                        sets = {
                            ["cozinha_wall"] = true,
                            ["cozinha_deco"] = false, -- decoração da cozinha
                            ["cozinha_box"]  = true   -- caixas de construção na cozinha
                        }
                    },
                    ["vertexgroup_cb_elevador_mlo"] = {
                        coords = vector3(-594.834, 66.648, 133.352),
                        sets = {
                            ["elev_wall"] = true,
                            ["elev_bloc"] = true, -- acesso ao terraço
                            ["elev_box"]  = true, -- caixas de construção na entrada
                            ["elev_deco"] = false -- decoração da entrada
                        }
                    },
                    ["vertexgroup_cb_quartos_mlo"] = {
                        coords = vector3(-577.94600000, 57.19800000, 133.47600000),
                        sets = {
                            ["suite_wall"]   = true,
                            ["suite01"]      = false, -- decoração da suite 01
                            ["suite02"]      = false, -- decoração da suite 02
                            ["suite_01_sun"] = false, -- venezianas da suite 01
                            ["suite_02_sun"] = false, -- venezianas da suite 02
                            ["suite_box"]    = true   -- caixas de construção nas suites
                        }
                    },
                    ["vertexgroup_cb_sala_mlo"] = {
                        coords = vector3(-612.304, 64.454, 133.352),
                        sets = {
                            ["sala_wall"] = true,
                            ["sala_deco"] = false, -- decoração da sala
                            ["sala_box"]  = true   -- caixas de construção na sala
                        }
                    }
                },
            }
        }
    },
    [2] = {
        duration = 30, -- 30 dias
        renewItem = 'pent02', -- item que faz a renovação da penthouse
        id = 2,
        building = 1,
        level = 2,
        title = (translations[language]['level']):format(2),
        address = 'Penthouse Gourmet',
        weight = 20000,
        rooms = 6,
        furnished = translations[language]['basic_furniture'],
        people = 6,
        price = 199,
        visitorOptions = {
            { value = 3, label = ('3 %s'):format(translations[language]['visitors']) },
            { value = 6, label = ('6 %s'):format(translations[language]['visitors']) }
        },
        images = {
            showcase = {
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel2.png',
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel2_2.png'
            },
            main = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel2.png'
        },
        big = true,
        entrance = vec4(-588.16, 67.26, 132.66, 138.58),
        settingsLocation = vec4(-590.66, 65.67, 132.66, 104.37),
        chests = {
            {
                coords = vec4(-572.87, 50.97, 132.66, 6.10),
                weight = 20000
            }
        },
        cloakrooms = {
            vec4(-577.72, 61.93, 132.66, 271.45)
        },
        barber = {
            vec4(-572.49, 55.62, 132.66, 2.58)
        },
        tattoo = {
            vec4(-571.30, 61.94, 132.66, 111.61),
        },
        drinks = {
            vec4(-575.54, 49.73, 129.27, 211.01)
        },
        tour = {
            spawn = vec4(-588.07, 67.64, 132.66, 90.71),
            splines = {
                {
                    from     = vec4(-599.50, 6.90, 133.19, 295.34),
                    to       = vec4(-642.24, 60.74, 135.07, 295.34),
                    center   = vec4(-596.48, 53.54, 130.78, 50.81),
                    interval = 5000
                },
                {
                    from = vec4(-629.55, 71.19, 134.5, 295.34),
                    to = vec4(-604.91, 57.29, 134.66, 42.32),
                    center = vec4(-612.16, 63.89, 132.66, 11.86),
                    interval = 5000
                },
                {
                    from = vec4(-607.71, 64.56, 133.20, 295.34),
                    to = vec4(-585.31, 51.68, 133.93, 295.34),
                    center = vec4(-594.31, 59.65, 132.66, 51.72),
                    interval = 5000,
                },
                {
                    from = vec4(-578.63, 86.94, 134.64, 295.34),
                    to = vec4(-563.22, 68.08, 133.40, 247.51),
                    center = vec4(-578.51, 68.97, 132.66, 267.26),
                    interval = 5000
                },
                {
                    from = vec4(-576.99, 32.20, 130.44, 295.34),
                    to = vec4(-592.53, 46.92, 129.32, 265.78),
                    center = vec4(-577.08, 46.72, 129.27, 177.82),
                    interval = 5000
                },
                {
                    from = vec4(-589.95, 46.0, 133.21, 295.34),
                    to = vec4(-577.14, 36.02, 132.65, 295.34),
                    center = vec4(-577.51, 47.29, 132.66, 87.29),
                    interval = 5000
                },
                {
                    from = vec4(-626.24, 75.10, 141.25, 295.34),
                    to = vec4(-567.96, 60.54, 139.35, 295.34),
                    center = vec4(-578.22, 43.41, 136.74, 351.25),
                    interval = 5000
                }
            }
        },
        dry_volumes = {
            {
                min = vector3(-640.37, 19.29, 37.37),
                max = vector3(-568.07, 70.18, 116.67)
            }
        },
        tiers = {
            [1] = {
                ymaps = {
                    ['vertexgroup_cb_water_bloc']   = true,  -- piscina / true: bloqueado, false: desbloqueado
                    ['vertexgroup_cb_deco_01']      = false, -- lounge exterior
                    ['vertexgroup_cb_deco_02']      = false, -- lounge terraço
                    ['vertexgroup_cb_deco_03']      = true,  -- moveis da entrada
                    ['vertexgroup_cb_deco_piscina'] = false, -- moveis piscina
                    ['vertexgroup_cb_amb_grass']    = false, -- plantas área externa
                    ['vertexgroup_cb_heli']         = false  -- helipointo
                },
                mlo_entities = {
                    ["vertexgroup_cb_cozinha_mlo"] = {
                        coords = vector3(-577.86400000, 46.44700000, 129.74600000),
                        sets = {
                            ["cozinha_wall"] = true,
                            ["cozinha_deco"] = true, -- decoração da cozinha
                            ["cozinha_box"]  = false -- caixas de construção na cozinha
                        }
                    },
                    ["vertexgroup_cb_elevador_mlo"] = {
                        coords = vector3(-594.834, 66.648, 133.352),
                        sets = {
                            ["elev_wall"] = true,
                            ["elev_bloc"] = true,  -- acesso ao terraço
                            ["elev_box"]  = false, -- caixas de construção na entrada
                            ["elev_deco"] = true   -- decoração da entrada
                        }
                    },
                    ["vertexgroup_cb_quartos_mlo"] = {
                        coords = vector3(-577.94600000, 57.19800000, 133.47600000),
                        sets = {
                            ["suite_wall"]   = true,
                            ["suite01"]      = true,  -- decoração da suite 01
                            ["suite02"]      = false, -- decoração da suite 02 (bloqueada)
                            ["suite_01_sun"] = true,  -- venezianas da suite 01
                            ["suite_02_sun"] = false, -- venezianas da suite 02 (bloqueada)
                            ["suite_box"]    = false  -- caixas de construção nas suites
                        }
                    },
                    ["vertexgroup_cb_sala_mlo"] = {
                        coords = vector3(-612.304, 64.454, 133.352),
                        sets = {
                            ["sala_wall"] = true,
                            ["sala_deco"] = true, -- decoração da sala
                            ["sala_box"]  = false -- caixas de construção na sala
                        }
                    }
                },
            }
        }
    },
    [3] = {
        duration = 30, -- 30 dias
        renewItem = 'pent03', -- item que faz a renovação da penthouse
        id = 3,
        building = 1,
        level = 3,
        title = (translations[language]['level']):format(3),
        address = 'Penthouse Premium',
        weight = 30000,
        rooms = 10,
        furnished = translations[language]['external_details'],
        people = 10,
        price = 299,
        visitorOptions = {
            { value = 3,  label = ('3 %s'):format(translations[language]['visitors']) },
            { value = 6,  label = ('6 %s'):format(translations[language]['visitors']) },
            { value = 10, label = ('10 %s'):format(translations[language]['visitors']) }
        },
        images = {
            showcase = {
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel3.png',
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel3_2.png'
            },
            main = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel3.png'
        },
        big = true,
        entrance = vec4(-588.16, 67.26, 132.66, 138.58),
        settingsLocation = vec4(-590.66, 65.67, 132.66, 104.37),
        chests = {
            {
                coords = vec4(-572.87, 50.97, 132.66, 6.10),
                weight = 30000
            }
        },
        cloakrooms = {
            vec4(-577.72, 61.93, 132.66, 271.45)
        },
        barber = {
            vec4(-572.49, 55.62, 132.66, 2.58)
        },
        tattoo = {
            vec4(-571.30, 61.94, 132.66, 111.61),
        },
        drinks = {
            vec4(-575.54, 49.73, 129.27, 211.01)
        },
        tour = {
            spawn = vec4(-588.07, 67.64, 132.66, 90.71),
            splines = {
                {
                    from     = vec4(-599.50, 6.90, 133.19, 295.34),
                    to       = vec4(-642.24, 60.74, 135.07, 295.34),
                    center   = vec4(-596.48, 53.54, 130.78, 50.81),
                    interval = 5000
                },
                {
                    from = vec4(-629.55, 71.19, 134.5, 295.34),
                    to = vec4(-604.91, 57.29, 134.66, 42.32),
                    center = vec4(-612.16, 63.89, 132.66, 11.86),
                    interval = 5000
                },
                {
                    from = vec4(-607.71, 64.56, 133.20, 295.34),
                    to = vec4(-585.31, 51.68, 133.93, 295.34),
                    center = vec4(-594.31, 59.65, 132.66, 51.72),
                    interval = 5000,
                },
                {
                    from = vec4(-578.63, 86.94, 134.64, 295.34),
                    to = vec4(-563.22, 68.08, 133.40, 247.51),
                    center = vec4(-578.51, 68.97, 132.66, 267.26),
                    interval = 5000
                },
                {
                    from = vec4(-576.99, 32.20, 130.44, 295.34),
                    to = vec4(-592.53, 46.92, 129.32, 265.78),
                    center = vec4(-577.08, 46.72, 129.27, 177.82),
                    interval = 5000
                },
                {
                    from = vec4(-589.95, 46.0, 133.21, 295.34),
                    to = vec4(-577.14, 36.02, 132.65, 295.34),
                    center = vec4(-577.51, 47.29, 132.66, 87.29),
                    interval = 5000
                },
                {
                    from = vec4(-626.24, 75.10, 141.25, 295.34),
                    to = vec4(-567.96, 60.54, 139.35, 295.34),
                    center = vec4(-578.22, 43.41, 136.74, 351.25),
                    interval = 5000
                }
            }
        },
        dry_volumes = {
            {
                min = vector3(-640.37, 19.29, 37.37),
                max = vector3(-568.07, 70.18, 116.67)
            }
        },
        tiers = {
            [1] = {
                ymaps = {
                    ['vertexgroup_cb_water_bloc']   = true,  -- piscina / true: bloqueado, false: desbloqueado
                    ['vertexgroup_cb_deco_01']      = true,  -- lounge exterior
                    ['vertexgroup_cb_deco_02']      = true,  -- lounge terraço
                    ['vertexgroup_cb_deco_03']      = true,  -- moveis da entrada
                    ['vertexgroup_cb_deco_piscina'] = false, -- moveis piscina
                    ['vertexgroup_cb_amb_grass']    = true,  -- plantas área externa
                    ['vertexgroup_cb_heli']         = false  -- helipointo
                },
                mlo_entities = {
                    ["vertexgroup_cb_cozinha_mlo"] = {
                        coords = vector3(-577.86400000, 46.44700000, 129.74600000),
                        sets = {
                            ["cozinha_wall"] = true,
                            ["cozinha_deco"] = true, -- decoração da cozinha
                            ["cozinha_box"]  = false -- caixas de construção na cozinha
                        }
                    },
                    ["vertexgroup_cb_elevador_mlo"] = {
                        coords = vector3(-594.834, 66.648, 133.352),
                        sets = {
                            ["elev_wall"] = true,
                            ["elev_bloc"] = true,  -- acesso ao terraço
                            ["elev_box"]  = false, -- caixas de construção na entrada
                            ["elev_deco"] = true   -- decoração da entrada
                        }
                    },
                    ["vertexgroup_cb_quartos_mlo"] = {
                        coords = vector3(-577.94600000, 57.19800000, 133.47600000),
                        sets = {
                            ["suite_wall"]   = true,
                            ["suite01"]      = true, -- decoração da suite 01
                            ["suite02"]      = true, -- decoração da suite 02
                            ["suite_01_sun"] = true, -- venezianas da suite 01
                            ["suite_02_sun"] = true, -- venezianas da suite 02
                            ["suite_box"]    = false -- caixas de construção nas suites
                        }
                    },
                    ["vertexgroup_cb_sala_mlo"] = {
                        coords = vector3(-612.304, 64.454, 133.352),
                        sets = {
                            ["sala_wall"] = true,
                            ["sala_deco"] = true, -- decoração da sala
                            ["sala_box"]  = false -- caixas de construção na sala
                        }
                    }
                },
            }
        }
    },
    [4] = {
        duration = 30, -- 30 dias
        renewItem = 'pent04', -- item que faz a renovação da penthouse
        id = 4,
        building = 1,
        level = 4,
        title = (translations[language]['level']):format(4),
        address = 'Penthouse Resort',
        weight = 40000,
        rooms = 3,
        furnished = translations[language]['jaccuzi_and_pool'],
        people = 20,
        visitorOptions = {
            { value = 3,  label = ('3 %s'):format(translations[language]['visitors']) },
            { value = 6,  label = ('6 %s'):format(translations[language]['visitors']) },
            { value = 10, label = ('10 %s'):format(translations[language]['visitors']) },
            { value = 20, label = ('20 %s'):format(translations[language]['visitors']) },
        },
        price = 399,

        images = {
            showcase = {
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel4.png',
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel4_2.png'
            },
            main = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel4.png'
        },
        big = true,
        entrance = vec4(-588.16, 67.26, 132.66, 138.58),
        settingsLocation = vec4(-590.66, 65.67, 132.66, 104.37),
        chests = {
            {
                coords = vec4(-572.87, 50.97, 132.66, 6.10),
                weight = 40000
            }
        },
        cloakrooms = {
            vec4(-577.72, 61.93, 132.66, 271.45)
        },
        barber = {
            vec4(-572.49, 55.62, 132.66, 2.58)
        },
        tattoo = {
            vec4(-571.30, 61.94, 132.66, 111.61),
        },
        drinks = {
            vec4(-575.54, 49.73, 129.27, 211.01)
        },
        tour = {
            spawn = vec4(-588.07, 67.64, 132.66, 90.71),
            splines = {
                {
                    from     = vec4(-599.50, 6.90, 133.19, 295.34),
                    to       = vec4(-642.24, 60.74, 135.07, 295.34),
                    center   = vec4(-596.48, 53.54, 130.78, 50.81),
                    interval = 5000
                },
                {
                    from = vec4(-629.55, 71.19, 134.5, 295.34),
                    to = vec4(-604.91, 57.29, 134.66, 42.32),
                    center = vec4(-612.16, 63.89, 132.66, 11.86),
                    interval = 5000
                },
                {
                    from = vec4(-607.71, 64.56, 133.20, 295.34),
                    to = vec4(-585.31, 51.68, 133.93, 295.34),
                    center = vec4(-594.31, 59.65, 132.66, 51.72),
                    interval = 5000,
                },
                {
                    from = vec4(-578.63, 86.94, 134.64, 295.34),
                    to = vec4(-563.22, 68.08, 133.40, 247.51),
                    center = vec4(-578.51, 68.97, 132.66, 267.26),
                    interval = 5000
                },
                {
                    from = vec4(-576.99, 32.20, 130.44, 295.34),
                    to = vec4(-592.53, 46.92, 129.32, 265.78),
                    center = vec4(-577.08, 46.72, 129.27, 177.82),
                    interval = 5000
                },
                {
                    from = vec4(-589.95, 46.0, 133.21, 295.34),
                    to = vec4(-577.14, 36.02, 132.65, 295.34),
                    center = vec4(-577.51, 47.29, 132.66, 87.29),
                    interval = 5000
                },
                {
                    from = vec4(-626.24, 75.10, 141.25, 295.34),
                    to = vec4(-567.96, 60.54, 139.35, 295.34),
                    center = vec4(-578.22, 43.41, 136.74, 351.25),
                    interval = 5000
                }
            }
        },
        dry_volumes = {
            {
                min = vector3(-640.37, 19.29, 37.37),
                max = vector3(-568.07, 70.18, 116.67)
            }
        },
        tiers = {
            [1] = {
                ymaps = {
                    ['vertexgroup_cb_water_bloc']   = false, -- piscina / true: bloqueado, false: desbloqueado
                    ['vertexgroup_cb_deco_01']      = true,  -- lounge exterior
                    ['vertexgroup_cb_deco_02']      = true,  -- lounge terraço
                    ['vertexgroup_cb_deco_03']      = true,  -- moveis da entrada
                    ['vertexgroup_cb_deco_piscina'] = true,  -- moveis piscina
                    ['vertexgroup_cb_amb_grass']    = true,  -- plantas área externa
                    ['vertexgroup_cb_heli']         = false  -- helipointo
                },
                mlo_entities = {
                    ["vertexgroup_cb_cozinha_mlo"] = {
                        coords = vector3(-577.86400000, 46.44700000, 129.74600000),
                        sets = {
                            ["cozinha_wall"] = true,
                            ["cozinha_deco"] = true, -- decoração da cozinha
                            ["cozinha_box"]  = false -- caixas de construção na cozinha
                        }
                    },
                    ["vertexgroup_cb_elevador_mlo"] = {
                        coords = vector3(-594.834, 66.648, 133.352),
                        sets = {
                            ["elev_wall"] = true,
                            ["elev_bloc"] = true,  -- acesso ao terraço
                            ["elev_box"]  = false, -- caixas de construção na entrada
                            ["elev_deco"] = true   -- decoração da entrada
                        }
                    },
                    ["vertexgroup_cb_quartos_mlo"] = {
                        coords = vector3(-577.94600000, 57.19800000, 133.47600000),
                        sets = {
                            ["suite_wall"]   = true,
                            ["suite01"]      = true, -- decoração da suite 01
                            ["suite02"]      = true, -- decoração da suite 02
                            ["suite_01_sun"] = true, -- venezianas da suite 01
                            ["suite_02_sun"] = true, -- venezianas da suite 02
                            ["suite_box"]    = false -- caixas de construção nas suites
                        }
                    },
                    ["vertexgroup_cb_sala_mlo"] = {
                        coords = vector3(-612.304, 64.454, 133.352),
                        sets = {
                            ["sala_wall"] = true,
                            ["sala_deco"] = true, -- decoração da sala
                            ["sala_box"]  = false -- caixas de construção na sala
                        }
                    }
                },
            }
        }
    },
    [5] = {
        duration = 30, -- 30 dias
        renewItem = 'pent05', -- item que faz a renovação da penthouse
        id = 5,
        building = 1,
        level = 5,
        title = (translations[language]['level']):format(5),
        address = 'Penthouse Suprema',
        weight = 50000,
        rooms = 3,
        furnished = translations[language]['partyarea_and_helipad'],
        people = 'ilimitado',
        price = 499,
        visitorOptions = {
            { value = 3,  label = ('3 %s'):format(translations[language]['visitors']) },
            { value = 6,  label = ('6 %s'):format(translations[language]['visitors']) },
            { value = 10, label = ('10 %s'):format(translations[language]['visitors']) },
            { value = 20, label = ('20 %s'):format(translations[language]['visitors']) },
            { value = -1, label = ('%s'):format(translations[language]['unlimited']) }
        },
        images = {
            showcase = {
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel5.png',
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel5_2.png',
                'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel5_3.png',
            },
            main = 'https://santaimagens.roleplayrp.com/img/imagens_variadas/penthouse/nivel5.png'
        },
        big = true,
        entrance = vec4(-588.16, 67.26, 132.66, 138.58),
        settingsLocation = vec4(-590.66, 65.67, 132.66, 104.37),
        chests = {
            {
                coords = vec4(-572.87, 50.97, 132.66, 6.10),
                weight = 50000
            }
        },
        cloakrooms = {
            vec4(-577.72, 61.93, 132.66, 271.45)
        },
        barber = {
            vec4(-572.49, 55.62, 132.66, 2.58)
        },
        tattoo = {
            vec4(-571.30, 61.94, 132.66, 111.61),
        },
        drinks = {
            vec4(-575.54, 49.73, 129.27, 211.01)
        },
        tour = {
            spawn = vec4(-588.07, 67.64, 132.66, 90.71),
            splines = {
                {
                    from     = vec4(-599.50, 6.90, 133.19, 295.34),
                    to       = vec4(-642.24, 60.74, 135.07, 295.34),
                    center   = vec4(-596.48, 53.54, 130.78, 50.81),
                    interval = 5000
                },
                {
                    from = vec4(-629.55, 71.19, 134.5, 295.34),
                    to = vec4(-604.91, 57.29, 134.66, 42.32),
                    center = vec4(-612.16, 63.89, 132.66, 11.86),
                    interval = 5000
                },
                {
                    from = vec4(-607.71, 64.56, 133.20, 295.34),
                    to = vec4(-585.31, 51.68, 133.93, 295.34),
                    center = vec4(-594.31, 59.65, 132.66, 51.72),
                    interval = 5000,
                },
                {
                    from = vec4(-578.63, 86.94, 134.64, 295.34),
                    to = vec4(-563.22, 68.08, 133.40, 247.51),
                    center = vec4(-578.51, 68.97, 132.66, 267.26),
                    interval = 5000
                },
                {
                    from = vec4(-576.99, 32.20, 130.44, 295.34),
                    to = vec4(-592.53, 46.92, 129.32, 265.78),
                    center = vec4(-577.08, 46.72, 129.27, 177.82),
                    interval = 5000
                },
                {
                    from = vec4(-589.95, 46.0, 133.21, 295.34),
                    to = vec4(-577.14, 36.02, 132.65, 295.34),
                    center = vec4(-577.51, 47.29, 132.66, 87.29),
                    interval = 5000
                },
                {
                    from = vec4(-626.24, 75.10, 141.25, 295.34),
                    to = vec4(-567.96, 60.54, 139.35, 295.34),
                    center = vec4(-578.22, 43.41, 136.74, 351.25),
                    interval = 5000
                }
            }
        },
        dry_volumes = {
            {
                min = vector3(-640.37, 19.29, 37.37),
                max = vector3(-568.07, 70.18, 116.67)
            }
        },
        tiers = {
            [1] = {
                ymaps = {
                    ['vertexgroup_cb_water_bloc']   = false, -- piscina / true: bloqueado, false: desbloqueado
                    ['vertexgroup_cb_deco_01']      = true,  -- lounge exterior
                    ['vertexgroup_cb_deco_02']      = true,  -- lounge terraço
                    ['vertexgroup_cb_deco_03']      = true,  -- moveis da entrada
                    ['vertexgroup_cb_deco_piscina'] = true,  -- moveis piscina
                    ['vertexgroup_cb_amb_grass']    = true,  -- plantas área externa
                    ['vertexgroup_cb_heli']         = true   -- helipointo
                },
                mlo_entities = {
                    ["vertexgroup_cb_cozinha_mlo"] = {
                        coords = vector3(-577.86400000, 46.44700000, 129.74600000),
                        sets = {
                            ["cozinha_wall"] = true,
                            ["cozinha_deco"] = true, -- decoração da cozinha
                            ["cozinha_box"]  = false -- caixas de construção na cozinha
                        }
                    },
                    ["vertexgroup_cb_elevador_mlo"] = {
                        coords = vector3(-594.834, 66.648, 133.352),
                        sets = {
                            ["elev_wall"] = true,
                            ["elev_bloc"] = false, -- acesso ao terraço
                            ["elev_box"]  = false, -- caixas de construção na entrada
                            ["elev_deco"] = true   -- decoração da entrada
                        }
                    },
                    ["vertexgroup_cb_quartos_mlo"] = {
                        coords = vector3(-577.94600000, 57.19800000, 133.47600000),
                        sets = {
                            ["suite_wall"]   = true,
                            ["suite01"]      = true, -- decoração da suite 01
                            ["suite02"]      = true, -- decoração da suite 02
                            ["suite_01_sun"] = true, -- venezianas da suite 01
                            ["suite_02_sun"] = true, -- venezianas da suite 02
                            ["suite_box"]    = false -- caixas de construção nas suites
                        }
                    },
                    ["vertexgroup_cb_sala_mlo"] = {
                        coords = vector3(-612.304, 64.454, 133.352),
                        sets = {
                            ["sala_wall"] = true,
                            ["sala_deco"] = true, -- decoração da sala
                            ["sala_box"]  = false -- caixas de construção na sala
                        }
                    }
                },
            }
        }
    }
}
