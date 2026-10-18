KEY_STATE_CREATOR = 'character-creator-state'

CREATOR_CONFIG = {}

local cities_spawn_positions = {
    ['GoatRP'] = vector4(-808.35,-1171.70,55.13,264.29)
}

CREATOR_CONFIG.SPAWN_POSITION = cities_spawn_positions[CITY_NAME] or vector4(-811.83, 175.17, 76.75, 113.98)
CREATOR_CONFIG.MAX_HEALTH = 400.0

CREATOR_CONFIG.INITIAL_GENDER = GetHashKey('mp_f_freemode_01') -- gênero inicial do personagem (criação de personagem)
CREATOR_CONFIG.ANIMATION_DICT = 'move_f@multiplayer'           -- animação quando abrir o creator
CREATOR_CONFIG.ANIMATION_NAME = 'idle'                         -- nome da animação
CREATOR_CONFIG.TRANSITION_FADE_SCREEN_MS = 500                 -- tempo de transição da tela (500ms)

CREATOR_CONFIG.CAMERA_PARTS = {     
    ['center-screen'] = {
        distance = 1.5,
        heightOffset = 0.4,
        offsetCamera = vector3(0.0, 0.0, 0.0),
        offset = vector3(0.0, 0.0, 0.35)
    },
    ['left-screen'] = {
        bone = 31086,
        distance = 0.35,
        heightOffset = 0.0,
        offsetCamera = vector3(0.02, 0.0, 0.0),
        offset = vector3(-0.12, 0.0, 0.65)
    },
    head            = { bone = 31086, distance = 0.5, heightOffset = 0.0, offset = vector3(0.0, 0.0, 0.65) },
    eyes            = { bone = 25260, distance = 0.29, heightOffset = 0.02, offset = vector3(0.0, 0.0, 0.65) },
    nose            = { bone = 39317, distance = 0.31, heightOffset = 2.6, offset = vector3(0.0, 0.0, 0.65) },
    mouth           = { bone = 47419, distance = 0.31, heightOffset = 0.1, offset = vector3(0.0, 0.0, 0.65) },
    chest           = { bone = 24816, distance = 0.8, heightOffset = 0.0, offset = vector3(0.0, 0.0, 0.65) },
    body            = { bone = 11816, distance = 1.2, heightOffset = 0.2, offset = vector3(0.0, 0.0, 0.25) },
}

CREATOR_CONFIG.CAMERA_CONFIG = { -- configurações basicas da camera (gerais)
    MAIN_POSITION = vector3(0.0, 0.0, 0.0),
    ADJUSTED_POSITION = vector3(0.0, 0.0, 0.7),
    POINT_AT_ENTITY = vector3(0.0, 0.0, 0.68),
    MAX_ZOOM = 2.4,
    MIN_ZOOM = 0.34,
}

---@type table<string, vector3[]> - tabela de posições do spawn inicial da cidade
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS = {
    default = {
        vector3(-1646.41, -1102.18, 13.01)
    }
}

CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Santa'] = { 
    vector3( -1676.54,-1112.54,13.28),
}

CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['CidadeNobre'] = { 
    vector3(-1676.54,-1112.54,13.28), -- Pier
    -- vector3(184.3,-963.66,29.76), -- Praça
    -- vector3(-1106.82,-2039.88,13.29), -- Mec
    -- vector3(1155.68,-1519.67,34.85), -- HP
    -- vector3(-1283.05,299.89,64.96), -- Hotel        
    -- vector3(-1673.84,-223.09,55.15), -- Cemitério
}
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Maresia'] = { 
    vector3(-1675.61,-1110.98,13.29),
}

CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Boomerang'] = { vector3(-1676.54,-1112.54,13.28) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Grande'] = {
    vector3(-1671.78,-1108.65,13.29), -- pier
    -- vector3(545.37,-194.68,54.44), -- mec nova
    -- vector3(-311.76,-609.63,32.76), -- hospital novo 
    -- vector3(165.66,-999.42,30.24), -- praca
}
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Malta'] = { vector3(-1676.54,-1112.54,13.28) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Kingdom'] = {
    vector3(-1676.54,-1112.54,13.28), -- Pier
    -- vector3(184.3,-963.66,29.76), -- Praça
    -- vector3(-1106.82,-2039.88,13.29), -- Mec
    -- vector3(1155.68,-1519.67,34.85), -- HP
}
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['District99'] = { vector3(-1670.46,-1108.27,13.29) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Krown'] = { vector3(-1670.46,-1108.27,13.29) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Orizon'] = { vector3(-1670.46,-1108.27,13.29) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Liberty99'] = { vector3(-1670.46,-1108.27,13.29) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Royal'] = { vector3(-1667.69,-1100.82,13.28) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Real'] = { vector3(-1676.54,-1112.54,13.28) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Universo'] = { vector3(-1675.61, -1110.98, 13.29) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Prime'] = { vector3(-1676.54,-1112.54,13.28) }
CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['Fronteira'] = { vector3(-1676.54,-1112.54,13.28) }

CREATOR_CONFIG.MAIN_DISCOUNT = 30.0

CREATOR_CONFIG.CURRENT_SEASON = {
    ["Santa"] = 6,
    ["CidadeNobre"] = 6,
    ["Boomerang"] = 6,
    ["Grande"] = 6,
    ["Prime"] = 6,
    ["Fronteira"] = 6,
    ["Malta"] = 6,
    ["Kingdom"] = 6,
    ["Imperium"] = 6,
    ["GoatRP"] = 6,
    ["District99"] = 6,
    ["Krown"] = 6,
    ["Orizon"] = 6,
    ["Liberty99"] = 6,
    ["Royal"] = 6,
    ["Real"] = 6,
    ["Maresia"] = 6,
    ["Universo"] = 6,
}

---@return vector3[]
function GetFirstSpawnPosition()
    return CREATOR_CONFIG.FIRST_SPAWN_POSITIONS[CITY_NAME] or CREATOR_CONFIG.FIRST_SPAWN_POSITIONS['default']
end

CREATOR_CONFIG.CITIES_RAMO = {
    ["Maresia"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminoso",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/novos/police-officer.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânico",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/criminosa.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânica",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/mecanica.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/paramédica.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Malta"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminoso",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/novos/police-officer.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânico",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/criminosa.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânica",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/mecanica.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/paramédica.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["GoatRP"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminelle",
                description = "Vivez hors-la-loi et tracez votre propre chemin.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policière",
                description = "Maintenez l’ordre et protégez la ville.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/male/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mécanicienne",
                description = "Optimisez, réparez et maîtrisez les machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédicale",
                description = "Sauvez des vies et prenez soin de la ville avec dévouement.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminelle",
                description = "Vivez hors-la-loi et tracez votre propre chemin.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/female/criminoso.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policière",
                description = "Maintenez l’ordre et protégez la ville.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mécanicienne",
                description = "Optimisez, réparez et maîtrisez les machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/female/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédicale",
                description = "Sauvez des vies et prenez soin de la ville avec dévouement.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/goatrp/female/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Liberty99"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["CidadeNobre"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminoso",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/novos/police-officer.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânico",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            }
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/criminosa.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânica",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/mecanica.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/paramédica.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            }
        }
    },
    ["Orizon"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "مجرم",
                description = "اختر الفرع الذي تريد اتباعه في المدينة",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "شرطي",
                description = "حافظ على النظام واحمِ المدينة",
                image = "https://cdn.santagroup.gg/loadscreen/policial.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "ميكانيكي",
                description = "اضبط وأصلح وسيطر على المركبات",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "مسعف",
                description = "أنقذ الأرواح واعتنِ بالمواطنين بتفانٍ.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "مجرمة",
                description = "عيشي خارج القانون واصنعي طريقك الخاص.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "شرطية",
                description = "حافظي على النظام واحمي المدينة.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "ميكانيكية",
                description = "اضبطي وأصلحي وسيطري على المركبات.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "مسعفة",
                description = "أنقذي الأرواح واعتني بالمواطنين بتفانٍ.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Santa"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminoso",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/novos/police-officer.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânico",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/criminosa.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânica",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/mecanica.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/paramédica.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Grande"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminoso",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/novos/police-officer.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânico",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/criminosa.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânica",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/mecanica.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/paramédica.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Kingdom"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Royal"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Boomerang"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["District99"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Krown"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Live as an outlaw and forge your own path.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Police Officer",
                description = "Uphold the law and protect the city.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mechanic",
                description = "Tune, repair, and master the machines.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramedic",
                description = "Save lives and care for the city with dedication.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Real"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Vive fuera de la ley y forja tu propio camino.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policía",
                description = "Mantén el orden y protege la ciudad.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecánico",
                description = "Ajusta, repara y domina las máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salva vidas y cuida la ciudad con dedicación.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Vive fuera de la ley y forja tu propio camino.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policía",
                description = "Mantén el orden y protege la ciudad.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecánica",
                description = "Ajusta, repara y domina las máquinas.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salva vidas y cuida la ciudad con dedicación.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Prime"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminal",
                description = "Vive fuera de la ley y forja tu propio camino.",
                image = "https://cdn.santagroup.gg/onboarding/criminal.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policía",
                description = "Mantén el orden y protege la ciudad.",
                image = "https://cdn.santagroup.gg/onboarding/policial_masc.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecánico",
                description = "Ajusta, repara y domina las máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salva vidas y cuida la ciudad con dedicación.",
                image = "https://cdn.santagroup.gg/onboarding/param_dico.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Vive fuera de la ley y forja tu propio camino.",
                image = "https://cdn.santagroup.gg/onboarding/criminosa.webp",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policía",
                description = "Mantén el orden y protege la ciudad.",
                image = "https://cdn.santagroup.gg/onboarding/policial_fem.webp",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecánica",
                description = "Ajusta, repara y domina las máquinas.",
                image = "https://cdn.santagroup.gg/onboarding/mecanica.webp",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salva vidas y cuida la ciudad con dedicación.",
                image = "https://cdn.santagroup.gg/onboarding/param_dica.webp",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
    ["Fronteira"] = {
        ["male"] = {
            {
                id = "criminoso",
                name = "Criminoso",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/criminal.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/novos/police-officer.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânico",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/mecanico.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédico",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/male/paramedico.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        },
        ["female"] = {
            {
                id = "criminoso",
                name = "Criminosa",
                description = "Viva fora da lei e faça seu próprio caminho.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/criminosa.png",
                color = "#E70D4B",
                activeColor = "#C82951",
                inactiveColor = "#420a1a"
            },
            {
                id = "policial",
                name = "Policial",
                description = "Mantenha a ordem e proteja a cidade.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/policial.png",
                color = "#0D59E7",
                activeColor = "#588AE8",
                inactiveColor = "#1c3446"
            },
            {
                id = "mecanico",
                name = "Mecânica",
                description = "Tune, conserte e domine as máquinas.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/mecanica.png",
                color = "#E78C0D",
                activeColor = "#E7AD0D",
                inactiveColor = "#46341c"
            },
            {
                id = "paramedico",
                name = "Paramédica",
                description = "Salve vidas e cuide da cidade com dedicação.",
                image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/character-creator/ramo/maresia/female/paramédica.png",
                color = "#0DC8E7",
                activeColor = "#0DC8E7",
                inactiveColor = "#0a3242"
            },
        }
    },
}

CREATOR_CONFIG.CITIES_RAMO["Santa"] = CREATOR_CONFIG.CITIES_RAMO["Santa"] or CREATOR_CONFIG.CITIES_RAMO["Maresia"]
CREATOR_CONFIG.CITIES_RAMO["Base"] = CREATOR_CONFIG.CITIES_RAMO["Santa"]

-- Spawns alternativos por ramo; sorteados quando GlobalState["MultipleSpawns"] estiver ativo (toggle: `multiplespawn` no console)
CREATOR_CONFIG.CITIES_RAMO_MULTIPLE_SPAWNS = {
    ["Santa"] = {
        ["criminoso"] = {
            vector4(-1678.08, -1109.48, 13.28, 320.32), -- Pier Sul
            vector4(173.82, -992.84, 29.59, 161.58),    -- Praça
            vector4(1433.57,6530.47,18.53,167.25),     -- Pier Norte
        },
        ["paramedico"] = {
            vector4(-268.72, -600.11, 32.94, 189.93),
        },
        ["mecanico"] = {
            vector4(549.72, -180.59, 54.53, 90.71),
        },
        ["policial"] = {
            vector4(2507.74, -384.93, 94.11, 198.43),   -- Militar
            vector4(-2327.64, 3256.75, 32.82, 39.69),   -- Exército
            vector4(2589.97, 5322.06, 44.69, 104.89),   -- PRF
        },
    },
    -- Mecânico e paramédico têm um ponto só: caem no fixo de CITIES_RAMO_SPAWN_POSITIONS.
    ["CidadeNobre"] = {
        ["criminoso"] = {
            vector4(-1677.2, -1111.19, 13.28, 317.49),  -- Pier Sul
            vector4(172.3, -995.7, 29.57, 155.91),      -- Praça
            vector4(1426.46, 6519.25, 18.74, 175.75),   -- Pier Norte
        },
        ["policial"] = {
            vector4(2535.93, -404.07, 93.04, 0.0),      -- Militar
            vector4(-1848.47, 2993.02, 32.81, 51.03),   -- Exército
            vector4(2620.63, 5306.09, 47.4, 104.89),    -- PRF
        },
    },
}

CREATOR_CONFIG.CITIES_RAMO_MULTIPLE_SPAWNS["Base"] = CREATOR_CONFIG.CITIES_RAMO_MULTIPLE_SPAWNS["Santa"]

CREATOR_CONFIG.CITIES_RAMO_SPAWN_POSITIONS = {
    ["Maresia"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(-1089.18, -2061.85, 13.29),
        ["paramedico"] = vector3(1155.38, -1522.08, 34.84),
    },
    ["Malta"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2576.61, -373.59, 92.99),
        ["mecanico"] = vector3(548.95, -169.18, 54.53),
        ["paramedico"] = vector3(-313.91, -604.97, 32.77),
    },
    ["GoatRP"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(-1089.18, -2061.85, 13.29),
        ["paramedico"] = vector3(1155.38, -1522.08, 34.84),
    },
    ["Liberty99"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector4(546.65, -184.0, 54.53, 90.71),
        ["paramedico"] = vector4(-313.96, -604.93, 32.77, 221.11),
    },
    ["CidadeNobre"] = {
        ["criminoso"] = vector4(-1677.2, -1111.19, 13.28, 317.49),  -- Pier Sul
        ["policial"] = vector4(2535.93, -404.07, 93.04, 0.0),       -- Militar
        ["mecanico"] = vector4(80.64, -1731.52, 29.28, 136.07),     -- Oficina
        ["paramedico"] = vector4(-938.86, -766.45, 17.93, 175.75),  -- Hospital
    },
    ["Orizon"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector4(546.65, -184.0, 54.53, 90.71),
        ["paramedico"] = vector4(-313.96, -604.93, 32.77, 221.11),
    },
    ["Santa"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector4(549.72, -180.59, 54.53, 90.71),
        ["paramedico"] = vector4(-268.72, -600.11, 32.94, 189.93),
    },
    ["Grande"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector4(546.65, -184.0, 54.53, 90.71),
        ["paramedico"] = vector4(-313.96, -604.93, 32.77, 221.11),
    },
    ["Kingdom"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector4(556.28,-190.19,54.52,313.63),
        ["paramedico"] = vector4(-313.96, -604.93, 32.77, 221.11),
    },
    ["Royal"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(549.02,-167.06,54.53),
        ["paramedico"] = vector3(-316.36,-604.33,32.86),
    },
    ["Boomerang"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(546.65, -184.0, 54.53),
        ["paramedico"] = vector3(-313.96, -604.93, 32.77),
    },
    ["District99"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(-1089.18, -2061.85, 13.29),
        ["paramedico"] = vector3(1153.61,-1525.55,34.85),
    },
    ["Krown"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(546.65, -184.0, 54.53),
        ["paramedico"] = vector3(-313.96, -604.93, 32.77),
    },
    ["Real"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(546.65, -184.0, 54.53),
        ["paramedico"] = vector3(1153.61,-1525.55,34.85),
    },
    ["Prime"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(546.65, -184.0, 54.53),
        ["paramedico"] = vector3(1153.61,-1525.55,34.85),
    },
    ["Fronteira"] = {
        ["criminoso"] = vector3(-1676.14, -1109.76, 13.29),
        ["policial"] = vector3(2506.32, -384.60, 94.12),
        ["mecanico"] = vector3(-1089.18, -2061.85, 13.29),
        ["paramedico"] = vector3(1155.38, -1522.08, 34.84),
    },
}

CREATOR_CONFIG.CITIES_RAMO_SPAWN_POSITIONS["Base"] = CREATOR_CONFIG.CITIES_RAMO_SPAWN_POSITIONS["Santa"]

CREATOR_CONFIG.OLD_BOY = {
    ["Maresia"] = {
        title = "Bom Velhinho",
        description = "O que você tem interesse em fazer na cidade? Dá uma olhada nas opções e escolhe o caminho que mais combina com você, que já te deixamos direto com o pessoal pra te receber!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Malta"] = {
        title = "Bom Velhinho",
        description = "O que você tem interesse em fazer na cidade? Dá uma olhada nas opções e escolhe o caminho que mais combina com você, que já te deixamos direto com o pessoal pra te receber!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["GoatRP"] = {
        title = "Bon vieux",
        description = "Qu’est-ce qui vous intéresse de faire en ville ? Jetez un œil aux options et choisissez le chemin qui vous correspond le mieux. On vous mettra directement en contact avec ceux qui vont vous accueillir !",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Liberty99"] = {
        title = "Good old friend",
        description = "What are you interested in doing around town? Take a look at the options and pick the path that suits you best. We'll put you straight in touch with the people who'll welcome you in!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["CidadeNobre"] = {
        title = "Bom Velhinho",
        description = "O que você tem interesse em fazer na cidade? Dá uma olhada nas opções e escolhe o caminho que mais combina com você, que já te deixamos direto com o pessoal pra te receber!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Orizon"] = {
        title = "العجوز الطيب",
        description = "ما هي الأنشطة التي ترغب في القيام بها في المدينة؟؟ ألقِ نظرة على الخيارات واختر المسار الذي يناسبك أكثر، وسنوجهك مباشرة إلى الأشخاص المستعدين لاستقبالك!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Santa"] = {
        title = "Bom Velhinho",
        description = "O que você tem interesse em fazer na cidade? Dá uma olhada nas opções e escolhe o caminho que mais combina com você, que já te deixamos direto com o pessoal pra te receber!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Grande"] = {
        title = "Bom Velhinho",
        description = "O que você tem interesse em fazer na cidade? Dá uma olhada nas opções e escolhe o caminho que mais combina com você, que já te deixamos direto com o pessoal pra te receber!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Kingdom"] = {
        title = "Good old friend",
        description = "What are you interested in doing around town? Take a look at the options and pick the path that suits you best. We'll put you straight in touch with the people who'll welcome you in!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Royal"] = {
        title = "Good old friend",
        description = "What are you interested in doing around town? Take a look at the options and pick the path that suits you best. We'll put you straight in touch with the people who'll welcome you in!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Boomerang"] = {
        title = "Good old friend",
        description = "What are you interested in doing around town? Take a look at the options and pick the path that suits you best. We'll put you straight in touch with the people who'll welcome you in!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["District99"] = {
        title = "Good old friend",
        description = "What are you interested in doing around town? Take a look at the options and pick the path that suits you best. We'll put you straight in touch with the people who'll welcome you in!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Krown"] = {
        title = "Good old friend",
        description = "What are you interested in doing around town? Take a look at the options and pick the path that suits you best. We'll put you straight in touch with the people who'll welcome you in!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Real"] = {
        title = "Buen viejo amigo",
        description = "¿Qué te interesa hacer en la ciudad? Echa un vistazo a las opciones y elige el camino que más te convenga. ¡Te ponemos en contacto directo con la gente que te va a recibir!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
    ["Fronteira"] = {
        title = "Bom Velhinho",
        description = "O que você tem interesse em fazer na cidade? Dá uma olhada nas opções e escolhe o caminho que mais combina com você, que já te deixamos direto com o pessoal pra te receber!",
        image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/painel/emprego/velho.png"
    },
}

CREATOR_CONFIG.OLD_BOY["Base"] = CREATOR_CONFIG.OLD_BOY["Santa"]

CREATOR_CONFIG.RAMO_TITLE = {
    ["Maresia"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Malta"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["GoatRP"] = {
        title = "Sélectionner une voie",
        description = "Sélectionnez la voie que vous souhaitez suivre en ville.",
        select = "SÉLECTIONNER",
        confirmDescription = "Êtes-vous sûr de vouloir suivre la voie de",
        yes = "Oui",
        no = "Non"
    },
    ["Liberty99"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
    ["CidadeNobre"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Orizon"] = {
        title = "اختيار الفرع",
        description = "اختر الفرع الذي تريد اتباعه في المدينة.",
        select = "اختيار",
        confirmDescription = "هل أنت متأكد أنك تريد اتباع فرع",
        yes = "نعم",
        no = "لا"
    },
    ["Santa"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Grande"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Kingdom"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
    ["Royal"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
    ["Boomerang"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
    ["District99"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
    ["Krown"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
    ["Real"] = {
        title = "Seleccionar un camino",
        description = "Selecciona el camino que quieres seguir en la ciudad.",
        select = "SELECCIONAR",
        confirmDescription = "¿Estás seguro de que quieres seguir el camino de",
        yes = "Sí",
        no = "No"
    },
    ["Prime"] = {
        title = "Seleccionar un camino",
        description = "Selecciona el camino que quieres seguir en la ciudad.",
        select = "SELECCIONAR",
        confirmDescription = "¿Estás seguro de que quieres seguir el camino de",
        yes = "Sí",
        no = "No"
    },
    ["Fronteira"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Universo"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Alexandria"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Galaxy"] = {
        title = "Selecionar Ramo",
        description = "Selecione o ramo que você pretende seguir na cidade.",
        select = "SELECIONAR",
        confirmDescription = "Tem certeza que deseja seguir no ramo de",
        yes = "Sim",
        no = "Não"
    },
    ["Imperium"] = {
        title = "Select a path",
        description = "Select the path you want to follow in the city.",
        select = "SELECT",
        confirmDescription = "Are you sure you want to follow the path of",
        yes = "Yes",
        no = "No"
    },
}

CREATOR_CONFIG.CRIMINAL_FACTION_FOCUS_PROMPT = {
    [ "es-es" ] = {
        title = "Ruta criminal", descriptionPrefix = "¿Quieres aparecer directamente en la",
        focusLabel = "facción", descriptionSuffix = "?", yes = "Sí", no = "No",
    },
    [ "ar-sa" ] = {
        title = "المسار الإجرامي", descriptionPrefix = "هل تريد الظهور مباشرة عند",
        focusLabel = "العصابة", descriptionSuffix = "؟", yes = "نعم", no = "لا",
    },
    [ "Kingdom" ] = {
        title             = "Criminal Path",
        descriptionPrefix = "Do you want to spawn directly at the",
        focusLabel        = "gang",
        descriptionSuffix = "?",
        yes               = "Yes",
        no                = "No",
    },
    [ "Grande" ] = {
        title             = "Ramo Criminoso",
        descriptionPrefix = "Deseja nascer direto na",
        focusLabel        = "facção",
        descriptionSuffix = "?",
        yes               = "Sim",
        no                = "Não",
    },
    [ "Santa" ] = {
        title             = "Ramo Criminoso",
        descriptionPrefix = "Deseja nascer direto na",
        focusLabel        = "facção",
        descriptionSuffix = "?",
        yes               = "Sim",
        no                = "Não",
    },
}

-- ENG-3902: na Santa o ramo criminoso usa a confirmação simples dos outros ramos, sem píer.
-- ENG-3971: a cidade com entrada aqui roda o fluxo da Santa (modal simples e relog na fac em foco).
CREATOR_CONFIG.CRIMINAL_SIMPLE_CONFIRM = {
    [ "Santa" ] = {
        prefix   = "No ramo",
        suffix   = ", você fará parte de uma facção.",
        question = "Deseja seguir?",
    },
    [ "District99" ] = {
        prefix   = "On the",
        suffix   = " path, you will be part of a gang.",
        question = "Do you want to continue?",
    },
}

-- ENG-3970: texto da confirmação simples por idioma (convar language). A ativação continua
-- pela cidade em CRIMINAL_SIMPLE_CONFIRM; sem idioma aqui, vale o texto da própria cidade.
CREATOR_CONFIG.CRIMINAL_SIMPLE_CONFIRM_TEXT = {
    [ "pt-br" ] = { prefix = "No ramo", suffix = ", você fará parte de uma facção.", question = "Deseja seguir?" },
    [ "pt-pt" ] = { prefix = "No ramo", suffix = ", vais fazer parte de uma fação.", question = "Queres continuar?" },
    [ "en-us" ] = { prefix = "On the", suffix = " path, you will be part of a gang.", question = "Do you want to continue?" },
    [ "es-es" ] = { prefix = "En la rama", suffix = ", formarás parte de una facción.", question = "¿Quieres continuar?" },
    [ "ar-sa" ] = { prefix = "في فرع", suffix = "، ستكون جزءاً من عصابة.", question = "هل تريد المتابعة؟" },
}

---@class CharacterCreatorFactionFocusSpawn
---@field faction string
---@field x number
---@field y number
---@field z number
---@field cycleId string|number
---@field beginnerFocus boolean

---@return CharacterCreatorFactionFocusSpawn|nil
function CREATOR_CONFIG.GetFactionFocusSpawn()
    if not GetConvarBool( 'enable_factionfocus_v3', false ) then return end

    local display = GlobalState[ 'FACTIONFOCUS_DISPLAY' ]
    local spawn = type( display ) == "table" and display[ 1 ] or nil

    if not spawn
        or spawn.cycleId == nil
        or spawn.beginnerFocus ~= true
    then
        return
    end

    return spawn
end

CREATOR_CONFIG.NEW_TUTORIAL_POSITION = vector4(-792.88, 331.55, 210.80, 304.57)
