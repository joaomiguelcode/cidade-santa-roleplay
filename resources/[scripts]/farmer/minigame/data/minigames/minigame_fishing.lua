local function MINIGAME_FISHING_VOLUMES()

    return table_join(
        ---@type fsMinigameVolumesDef
        {
            { 'polygon', -- Pescaria - pier
                {
                    vector2(1378.98,6715.73),
                    vector2(1378.26,6688.41),
                    vector2(1459.28,6688.42),
                    vector2(1459.3,6715.1),
                    vector2(1411.94,6715.84),
                    vector2(1411.47,6712.73),
                    vector2(1404.3,6712.7),
                    vector2(1404.43,6715.73)
                }
            },
            { 'polygon', -- PescariaPerico
                {
                    vector2(5109.82, -5112.69),
                    vector2(5109.61, -5207.14),
                    vector2(5088.84, -5207.01),
                    vector2(5088.65, -5113.09)
                }
            }
        },
        SWITCH( cityName, {
            { 'CidadeNobre',
                ---@type fsMinigameVolumesDef
                {
                
                }
            },
            { 'Grande',
                ---@type fsMinigameVolumesDef
                {
                

                }
            },
            { 'Malta',
                ---@type fsMinigameVolumesDef
                {
                    { 'polygon', 
                        {
                            vector2(1210.35, 4089.63),
                            vector2(1352.73, 4159.29),
                            vector2(1513.30, 4063.89),
                            vector2(1433.01, 3923.57),
                            vector2(1319.41, 3799.40),
                            vector2(1051.30, 3864.51),
                            vector2(964.96, 4084.08)
                        }
                    }

                }
            },
            { 'Santa',
                ---@type fsMinigameVolumesDef
                {
                }
            },
            { 'Alexandria',
                ---@type fsMinigameVolumesDef
                {
                    { 'polygon', -- Mansao56
                        {
                            vector2(-1962.64,-244.70),
                            vector2(-1956.06,-249.17),
                            vector2(-1963.51,-259.62),
                            vector2(-1969.72,-255.41)
                        }
                    },

                    -- { 'polygon', -- PescaLuxor
                    --     {
                    --         vector2(-312.12, 144.70),
                    --         vector2(-284.09, 145.45),
                    --         vector2(-285.98, 168.94),
                    --         vector2(-313.64, 169.32)
                    --     }
                    -- }
                }
            },
            { 'Boomerang',
                ---@type fsMinigameVolumesDef
                {
                    -- { 'polygon', -- Pesca_Pier
                    --     {
                    --         vector2(1378.25,6688.43),
                    --         vector2(1459.29,6688.43),
                    --         vector2(1459.29,6715.09),
                    --         vector2(1378.32,6715.84)
                    --     }
                    -- },

                    -- { 'polygon', -- PescaLuxor
                    --     {
                    --         vector2(-312.12, 144.70),
                    --         vector2(-284.09, 145.45),
                    --         vector2(-285.98, 168.94),
                    --         vector2(-313.64, 169.32)
                    --     }
                    -- }
                }
            },
            { 'Universo',
                ---@type fsMinigameVolumesDef
                {
                    { 'polygon', -- QG_13 
                        {
                            vector2(119.64,-402.61),
                            vector2(116.51,-410.5),
                            vector2(91.84,-401.74),
                            vector2(95.27,-393.03)
                        }
                    },
                    { 'polygon', -- QG_62
                        {
                            vector2(1540.63, 1434.09),
                            vector2(1537.09, 1433.19),
                            vector2(1535.49, 1438.83),
                            vector2(1539.05, 1439.96)
                        }
                    },
                    { 'polygon', -- QG_09
                        {
                            vector2(696.56,-790.47),
                            vector2(696.49,-799.8),
                            vector2(682.73,-791.12),
                            vector2(683.15,-799.39)
                        }
                    },
                    { 'polygon', -- QG_171
                        {
                            vector2(1099.47,3759.53),
                            vector2(1101.21,3775.15),
                            vector2(1068.62,3777.38),
                            vector2(1068.02,3761.86),
                            vector2(1072.12,3761.62),
                            vector2(1072.91,3772.71),
                            vector2(1096.29,3771.1),
                            vector2(1095.64,3759.87)
                        }
                    },
                    { 'polygon', -- mansao01
                        {
                            vector2(-3254.65,804.03),
                            vector2(-3248.38,807.99),
                            vector2(-3229.84,779.39),
                            vector2(-3238.58,778.37)
                        }
                    },
                    { 'polygon', -- QG_85 
                        {
                            vector2(-951.63,-1491.16),
                            vector2(-945.48,-1489.36),
                            vector2(-942.96,-1496.69),
                            vector2(-948.37,-1499.19)
                        }
                    },
                    { 'polygon', -- QG_84
                        {
                            vector2 (-2644.83,1693.29),
                            vector2 (-2643.09,1693.90),
                            vector2 (-2640.63,1695.14),
                            vector2 (-2641.51,1696.93),
                            vector2 (-2643.74,1696.08),
                            vector2 (-2645.76,1695.21)
                        }
                    },
                    { 'polygon', -- Mansao97 
                        {
                            vector2(2252.59,4867.9),
                            vector2(2245.26,4874.75),
                            vector2(2226.97,4853.74),
                            vector2(2233.94,4847.21)
                        }
                    }
                }
            },
            { 'Kingdom', 
                {

                    { 'polygon', -- MANSAO94
                        {
                            vector2(-430.99,4401.39),
                            vector2(-431.44,4393.39),
                            vector2(-426.59,4392.8),
                            vector2(-426.52,4401.12)
                        }
                    },
                    { 'polygon', -- QG_54
                        {
                            vector2(52.29,938.73),
                            vector2(86.71,933.64),
                            vector2(83.74,912.74),
                            vector2(48.9,917.94)
                        }
                    },
                    { 'polygon', -- id 187
                        {
                            vector2(-1584.96,2.1),
                            vector2(-1582.29,1.51),
                            vector2(-1583.38,-0.5),
                            vector2(-1585.58,0.39)
                        }
                    },
                    { 'polygon', -- QG_127
                        {
                            vector2(2009.29,4271.31),
                            vector2(2018.67,4273.19),
                            vector2(2022.98,4248.37),
                            vector2(2013.31,4246.41)
                        }
                    },
                    { 'polygon', -- QG_59
                        {
                            vector2(-3037.97,38.09),
                            vector2(-3037.04,40.32),
                            vector2(-3038.58,42.2),
                            vector2(-3041.65,40.07),
                            vector2(-3040.25,37.75)
                        }
                    },
                    { 'polygon', -- QG_50
                        {
                            vector2(1042.84,-2534.04),
                            vector2(1044.42,-2534.51),
                            vector2(1043.58,-2540.12),
                            vector2(1042.07,-2539.97)
                        }
                    },
                    { 'polygon', -- QG_250
                        {
                            vector2(-3502.22,4581.36),
                            vector2(-3501.04,4579.79),
                            vector2(-3499.43,4579.92),
                            vector2(-3500.10,4582.05)
                        }
                    },
                    { 'polygon', -- mansao15
                        {
                            vector2(177.41,1725.21),
                            vector2(177.34,1726.96),
                            vector2(182.99,1726.96),
                            vector2(182.97,1724.56)
                        }
                    },
                    { 'polygon', -- QG_202
                        {
                            vector2(-739.34,662.46),
                            vector2(-728.12,665.44),
                            vector2(-723.96,653.75),
                            vector2(-736.6,646.48),
                            vector2(-737.82,653.57)
                        }
                    },
                    { 'polygon', -- QG_51
                        {
                            vector2(643.53,-2721.63),
                            vector2(637.06,-2725.41),
                            vector2(642.11,-2732.63),
                            vector2(646.98,-2730.68)
                        }
                    },
                    { 'polygon', -- mansao75
                        {
                            vector2(-2050.27,-666.72),
                            vector2(-2046.89,-670.47),
                            vector2(-2050.93,-674.03),
                            vector2(-2054.79,-671.41)
                        }
                    },
                    { 'polygon', -- mansao17
                        {
                            vector2(-5858.68,1177.6),
                            vector2(-5852.21,1177.96),
                            vector2(-5850.96,1170.89),
                            vector2(-5859.12,1169.02)
                        }
                    }
                } 
            },
            { 'District99', 
                {
                    { 'polygon', -- QG_19
                        {
                            vector2(-1037.45, 296.08),
                            vector2(-1034.54, 286.03),
                            vector2(-1025.64, 285.83),
                            vector2(-1029.01, 299.44)
                        }
                    },
                    { 'polygon', -- QG_210
                        {
                            vector2(2685.25, 1767.68),
                            vector2(2689.46, 1767.46),
                            vector2(2689.27, 1761.17),
                            vector2(2685.72, 1761.37)
                        }
                    },
                    { 'polygon', -- mansao26
                        {
                            vector2(257.06, 767.78),
                            vector2(256.38, 761.61),
                            vector2(261.83, 760.3),
                            vector2(262.74, 764.83)
                        }
                    },
                    { 'polygon', -- QG_228
                        {
                            vector2(-3497.38,1293.22),
                            vector2(-3494.01,1300.84),
                            vector2(-3500.39,1304.3),
                            vector2(-3503.45,1298.09)
                        }
                    },
                    { 'polygon', -- QG_293
                        {
                            vector2(202.34, 1724.01),
                            vector2(202.24, 1727.23),
                            vector2(207.33, 1727.2),
                            vector2(207.22, 1724.06)
                        }
                    },
                    { 'polygon', -- QG_147
                        {
                            vector2(-1178.66, -1748.16),
                            vector2(-1173.17, -1745.31),
                            vector2(-1177.16, -1739.11),
                            vector2(-1182.83, -1741.95)
                        }
                    },
                    { 'polygon', -- mansao08
                        {
                            vector2(-2790.77, 1453.07),
                            vector2(-2798.34, 1458.44),
                            vector2(-2802.97, 1452.49),
                            vector2(-2794.93, 1446.77)
                        }
                    },
                    { 'polygon', -- Mansao66
                        {
                            vector2(-2813.64,3017.02),
                            vector2(-2809.24,3014.54),
                            vector2(-2811.50,3010.83),
                            vector2(-2816.15,3012.58)
                        }
                    },
                    { 'polygon', -- QG_212
                        {
                            vector2(-1277.16, 751.23),
                            vector2(-1285.23, 770.46),
                            vector2(-1295.85, 762.97),
                            vector2(-1299.33, 747.45),
                            vector2(-1289.36, 746.8)
                        }
                    },
                    { 'polygon', -- QG_46
                        {
                            vector2(-179.4, -1259.18),
                            vector2(-179.35, -1266.19),
                            vector2(-183.58, -1266.25),
                            vector2(-183.91, -1258.68)
                        }
                    },
                    { 'polygon', -- QG_331
                        {
                            vector2(-1462.99, -64.03),
                            vector2(-1468.65, -68.91),
                            vector2(-1471.35, -65.44),
                            vector2(-1465.85, -60.73)
                        }
                    },
                    { 'polygon', -- QG_183
                        {
                            vector2(-3292.8, 743.75),
                            vector2(-3293.97, 736.67),
                            vector2(-3287.32, 734.8),
                            vector2(-3285.6, 742.87) 
                        }
                    },
                    { 'polygon', -- QG_20
                        {
                            vector2(-1460.98, 222.49),
                            vector2(-1453.03, 221.74),
                            vector2(-1451.52, 216.43),
                            vector2(-1457.20, 214.16),
                            vector2(-1463.26, 210.75),
                            vector2(-1468.56, 212.27),
                            vector2(-1467.42, 217.57),
                            vector2(-1465.53, 222.87)
                        }
                    },
                    { 'polygon', -- QG_117
                        {
                            vector2(1354.42,-749.12),
                            vector2(1357.76,-752.91),
                            vector2(1355.17,-759.59),
                            vector2(1351.64,-758.62)
                        }
                    },
                    { 'polygon', -- QG_59
                        {
                            vector2(-3048.75,71.32),
                            vector2(-3053.68,63.31),
                            vector2(-3060.88,69.37),
                            vector2(-3054.25,77.31)
                        }
                    }
                } 
            },
            { 'Krown', 
                {
                    { 'polygon', -- Coringadas / mansao161
                        {
                            vector2(-3520.89, 2820.0),
                            vector2(-3516.59, 2819.75),
                            vector2(-3515.73, 2801.62),
                            vector2(-3520.94, 2800.38)
                        }
                    },
                } 
            },
            { 'Orizon', 
                {
                    -- { 'polygon', -- pier
                    --     {
                    --         vector2(1364.02, 6632.95),
                    --         vector2(1364.02, 6687.88),
                    --         vector2(1466.29, 6687.88),
                    --         vector2(1466.29, 6632.95)
                    --     }
                    -- }
                }
            },
            { 'Liberty99', 
                {
                    { 'polygon', -- QG_59
                        {
                            vector2(-2916.02, 16.48),
                            vector2(-2914.2, 22.15),
                            vector2(-2921.6, 24.61),
                            vector2(-2923.43, 18.97)
                        }
                    },
                    { 'polygon', -- qg_295
                        {
                            vector2(1423.07, 4712.05),
                            vector2(1423.53, 4707.47),
                            vector2(1420.09, 4707.3),
                            vector2(1419.24, 4712.09)
                        }
                    },
                    { 'polygon', -- QG_87
                        {
                            vector2(732.82, 3427.82),
                            vector2(728.3, 3427.6),
                            vector2(728.19, 3420.76),
                            vector2(732.78, 3420.82)
                        }
                    },
                    { 'polygon', -- QG_182
                        {
                            vector2(-3124.33, 1478.01),
                            vector2(-3119.48, 1478.8),
                            vector2(-3120.44, 1485.88),
                            vector2(-3125.53, 1485.22)
                        }
                    },
                    { 'polygon', -- QG_212
                        {
                            vector2(-1209.07, 832.21),
                            vector2(-1211.01, 827.94),
                            vector2(-1205.8, 825.29),
                            vector2(-1203.83, 829.96)
                        }
                    },
                    { 'polygon', -- QG_19
                        {
                            vector2(-990.81, 337.89),
                            vector2(-988.79, 334.42),
                            vector2(-983.34, 337.07),
                            vector2(-985.31, 340.54)
                        }
                    },
                    -- { 'polygon', -- QG_59
                    --     {
                    --         vector2(-3048.75,71.32),
                    --         vector2(-3053.68,63.31),
                    --         vector2(-3060.88,69.37),
                    --         vector2(-3054.25,77.31)
                    --     }
                    -- }
                } 
            },
            { 'Royal', { 
                

                }
            },
            { 'Real', 
                {
                    { 'polygon', -- QG_237 / Mansao32
                        {
                            vector2(-707.90,614.12),
                            vector2(-709.29,618.99),
                            vector2(-703.77,620.90),
                            vector2(-702.42,616.62)
                        }
                    },
                    { 'polygon', -- QG_58
                        {
                            vector2(-2225.50,245.11),
                            vector2(-2232.67,261.49),
                            vector2(-2249.18,255.57),
                            vector2(-2249.29,236.25)
                        }
                    }
                } 
            },
            { 'Prime', 
                {
                    -- { 'polygon', -- pier
                    --     {
                    --         vector2(1364.02, 6632.95),
                    --         vector2(1364.02, 6687.88),
                    --         vector2(1466.29, 6687.88),
                    --         vector2(1466.29, 6632.95)
                    --     }
                    -- }
                } 
            },
            { 'GoatRP', 
                {
                    -- { 'polygon', -- pier
                    --     {
                    --         vector2(1364.02, 6632.95),
                    --         vector2(1364.02, 6687.88),
                    --         vector2(1466.29, 6687.88),
                    --         vector2(1466.29, 6632.95)
                    --     }
                    -- }
                } 
            },
            { 'Maresia', 
                ---@type fsMinigameVolumesDef
                {

                } 
            }
        })
    )
end

DEFINE_MINIGAME 'fishing' {

    -- Nome que será exibido para o jogador
    -- ( o sistema de exibir texto não gosta de acentos )
    displayName = _t("fishing"),

    -- Animação que será executada
    scriptedInteractionName = 'fishing_rod',

    duration = 60,

    -- # Recompensas
    rewards =
    {
        {
            item =
            {
                -- Todos os items tem as mesmas chances!
                { id = 'octopus'    , amount = 1, chanceWeight = 1.0 },
                { id = 'shrimp'     , amount = 1, chanceWeight = 1.0 },
                { id = 'carp'       , amount = 1, chanceWeight = 1.0 },
                { id = 'horsefish'  , amount = 1, chanceWeight = 1.0 },
                { id = 'tilapia'    , amount = 1, chanceWeight = 1.0 },
                { id = 'codfish'    , amount = 1, chanceWeight = 1.0 },
                { id = 'catfish'    , amount = 1, chanceWeight = 1.0 },
            },
        },
        {
            item =
            {
                -- Todos os items tem as mesmas chances!
                { id = 'octopus'    , amount = 1, chanceWeight = 1.0 },
                { id = 'shrimp'     , amount = 1, chanceWeight = 1.0 },
                { id = 'carp'       , amount = 1, chanceWeight = 1.0 },
                { id = 'horsefish'  , amount = 1, chanceWeight = 1.0 },
                { id = 'tilapia'    , amount = 1, chanceWeight = 1.0 },
                { id = 'codfish'    , amount = 1, chanceWeight = 1.0 },
                { id = 'catfish'    , amount = 1, chanceWeight = 1.0 },
                { id = 'goldenfish' , amount = 1, chanceWeight = 1.0 },
                { id = 'pirarucu'   , amount = 1, chanceWeight = 1.0 },
                { id = 'pacu'       , amount = 1, chanceWeight = 1.0 },
                { id = 'tambaqui'   , amount = 1, chanceWeight = 1.0 },
            },

            when = function ( ctx )

                -- Quando houver 4 ou mais membros na party
                -- esse loottable vai ser usada

                if ctx.hostPartyNumMembers < 4 then

                    return false
                end

                return true
            end
        }
    },

    -- Mover todos os participants do minigame para um bucket privado
    flags = eMinigameDefFlags.MDF__ON_CREATE__SWITCH_TO_PRIVATE_ROUTING_BUCKET | eMinigameDefFlags.MDF_FLAG_PLAYER_INVINCIBLE,

    volumes = MINIGAME_FISHING_VOLUMES()
}