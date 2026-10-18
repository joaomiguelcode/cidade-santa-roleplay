---@enum eAffiliateActionSlot
eAffiliateActionSlot = {
    Vehicle = "vehicle",
    Weapon = "weapon",
    Pet = "pet",
    Collectible = "collectible",
}

---@alias affiliateWorld.NotifyType "Confirmed"|"Warning"

---@class affiliateWorld.AimTrainingDifficulty
---@field LABEL_KEY string
---@field MOVE_RATE number
---@field TASK_SPEED number
---@field SPAWN_VELOCITY number
---@field ROLL_DURATION_MS integer
---@field ROLL_COOLDOWN_MS integer
---@field SPAWN_INTERVAL_MS integer
---@field MAX_PER_LANE integer

---@class affiliateWorld.AimTrainingLane
---@field START vector4
---@field FINISH vector4

---@class affiliateWorld.AimTrainingConfig
---@field ENABLED boolean
---@field NPC_MODEL string
---@field NPC_HEALTH integer
---@field STATIC_TARGET_COUNT integer
---@field RESPAWN_DELAY_MS integer
---@field INFINITE_AMMO boolean
---@field RANGE_CENTER vector3
---@field RANGE_RADIUS number
---@field LANE_DELETE_DISTANCE number
---@field STUCK_DISTANCE number
---@field STUCK_INTERVAL_MS integer
---@field ROLL_ANIM_DICT string
---@field ROLL_ANIMS string[]
---@field BLIP { SPRITE: integer, COLOR: integer, SCALE: number }
---@field DIFFICULTY_PROP { MODEL: string, POSITION: vector4 }
---@field DIFFICULTIES affiliateWorld.AimTrainingDifficulty[]
---@field LANES affiliateWorld.AimTrainingLane[]

---@class affiliateWorld.Config
---@field ENTRY_POSITION vector4
---@field EXIT_FALLBACK_POSITION vector4
---@field BUCKET_BASE integer
---@field BUCKET_CAPACITY integer
---@field PUBLIC_WORLD_OWNER_ID integer
---@field PURCHASE_ATTRIBUTION_SECONDS integer
---@field TARGET_RANGE_POSITIONS vector4[]
---@field AIM_TRAINING affiliateWorld.AimTrainingConfig
---@field TELEPORT_AUTHORIZATION_TTL_SECONDS integer
---@field REVIVE_DELAY_MS integer
---@field PRODUCT_REQUEST_COOLDOWN_MS integer
---@field AFFILIATE_CALL_COOLDOWN_SECONDS integer
---@field MAX_REGULAR_MEMBERS integer
---@field INVITE_TTL_SECONDS integer
---@field INVITE_COOLDOWN_MS integer
---@field INVITE_ACCEPT_RECHECK_DELAY_MS integer
---@field WEAPONS_SKINS string[]
---@field BLOCKED_WEAPONS string[]
---@field GET_COLLECTIBLES_BY_COLLECTIONS_IDS table<string, boolean>
---@field PERMISSIONS table<string, integer>
---@field SPECTATE_PERMISSIONS table<string, integer>
---@field TELEPORT_PERMISSIONS table<string, integer>
---@field OPERATIONAL_SERVICE_GROUPS string[]

---@type affiliateWorld.Config
AFFILIATE_WORLD_CONFIG = {
    ENTRY_POSITION = vector4(-1564.97, -993.50, 13.09, 46.64),
    -- Usado somente se a origem autoritativa da sessao nao estiver mais disponivel.
    EXIT_FALLBACK_POSITION = vector4(193.10, -936.63, 31.23, 73.69),
    -- Range exclusivo 2000000..2009999; nao sobrepor ao Ban Audit 900000..1899999.
    BUCKET_BASE = 2000000,
    BUCKET_CAPACITY = 10000,
    -- Reservado para a sessao publica; buckets individuais comecam em BUCKET_BASE + 1.
    PUBLIC_WORLD_OWNER_ID = 0,
    PURCHASE_ATTRIBUTION_SECONDS = 30 * 60,
    -- Pontos do estande onde os bonecos de teste de arma podem aparecer. O client sempre
    -- resolve o Z pelo chao; conferir e ajustar com o mapa da cidade carregado em jogo.
    TARGET_RANGE_POSITIONS = {
        vector4(-1606.17, -999.39, 13.29, 225.30),
        vector4(-1607.53, -1001.36, 13.29, 224.93),
        vector4(-1610.25, -1004.09, 13.29, 226.34),
        vector4(-1599.31, -1005.30, 13.29, 227.09),
        vector4(-1600.87, -1007.16, 13.29, 225.73),
        vector4(-1602.56, -1009.34, 13.29, 227.79),
    },
    -- Treino de mira do Mundo Afiliado. Os NPCs sao locais (isNetwork = false):
    -- valem para sessao individual e publica, e cada jogador abate apenas os seus.
    AIM_TRAINING = {
        ENABLED = true,
        NPC_MODEL = "s_m_y_marine_01",
        -- Vida alta para o boneco continuar de pe em tiro de corpo; abate exige headshot.
        NPC_HEALTH = 50000,
        STATIC_TARGET_COUNT = 3,
        RESPAWN_DELAY_MS = 1200,
        INFINITE_AMMO = true,
        -- Area do treino. Fora dela a HUD some, os bonecos das pistas sao removidos e o
        -- resto da logica para. O centro precisa cobrir TARGET_RANGE_POSITIONS, LANES e
        -- DIFFICULTY_PROP; o valor abaixo e o meio da caixa que envolve as pistas e o alvo.
        RANGE_CENTER = vector3(-1590.41, -1015.67, 13.29),
        RANGE_RADIUS = 40.0,
        LANE_DELETE_DISTANCE = 3.5,
        STUCK_DISTANCE = 0.5,
        STUCK_INTERVAL_MS = 2000,
        ROLL_ANIM_DICT = "move_strafe@roll_fps",
        ROLL_ANIMS = {
            "combatroll_fwd_p1_00",
            "combatroll_fwd_p1_45",
            "combatroll_fwd_p1_90",
            "combatroll_fwd_p1_135",
            "combatroll_bwd_p1_180",
            "combatroll_bwd_p1_135",
        },
        BLIP = {
            SPRITE = 110,
            COLOR = 1,
            SCALE = 0.8,
        },
        -- Alvo fisico que cicla a dificuldade quando o jogador atira nele.
        DIFFICULTY_PROP = {
            MODEL = "prop_range_target_01",
            POSITION = vector4(-1567.59, -1034.53, 13.26, 48.31),
        },
        DIFFICULTIES = {
            {
                LABEL_KEY = "affiliate_world_aim_difficulty_easy",
                MOVE_RATE = 2.0,
                TASK_SPEED = 2.0,
                SPAWN_VELOCITY = 6.0,
                ROLL_DURATION_MS = 1000,
                ROLL_COOLDOWN_MS = 2500,
                SPAWN_INTERVAL_MS = 2600,
                MAX_PER_LANE = 2,
            },
            {
                LABEL_KEY = "affiliate_world_aim_difficulty_medium",
                MOVE_RATE = 3.5,
                TASK_SPEED = 2.5,
                SPAWN_VELOCITY = 9.0,
                ROLL_DURATION_MS = 800,
                ROLL_COOLDOWN_MS = 1600,
                SPAWN_INTERVAL_MS = 2000,
                MAX_PER_LANE = 3,
            },
            {
                LABEL_KEY = "affiliate_world_aim_difficulty_hard",
                MOVE_RATE = 5.5,
                TASK_SPEED = 3.5,
                SPAWN_VELOCITY = 13.0,
                ROLL_DURATION_MS = 650,
                ROLL_COOLDOWN_MS = 900,
                SPAWN_INTERVAL_MS = 1400,
                MAX_PER_LANE = 4,
            },
        },
        -- Pistas atras do estande, atravessando a linha de tiro. Mesma regra de
        -- TARGET_RANGE_POSITIONS: conferir no mapa da cidade antes de fechar.
        LANES = {
            {
                START = vector4(-1592.43, -1009.86, 13.29, 226.73),
                FINISH = vector4(-1575.63, -1024.22, 13.29, 227.13),
            },
            {
                START = vector4(-1594.35, -1012.10, 13.29, 226.34),
                FINISH = vector4(-1577.75, -1026.39, 13.29, 225.67),
            },
            {
                START = vector4(-1596.05, -1014.59, 13.29, 226.82),
                FINISH = vector4(-1579.76, -1028.63, 13.29, 227.78),
            },
        },
    },
    TELEPORT_AUTHORIZATION_TTL_SECONDS = 3,
    REVIVE_DELAY_MS = 5000,
    PRODUCT_REQUEST_COOLDOWN_MS = 750,
    AFFILIATE_CALL_COOLDOWN_SECONDS = 60,
    -- 0 = sem limite. Grupos em PERMISSIONS nao consomem vagas.
    MAX_REGULAR_MEMBERS = 2,
    INVITE_TTL_SECONDS = 30,
    INVITE_COOLDOWN_MS = 1000,
    INVITE_ACCEPT_RECHECK_DELAY_MS = 500,
    GET_COLLECTIBLES_BY_COLLECTIONS_IDS = {
        pets = true,
    },
    BLOCKED_WEAPONS = {
        "WEAPON_RPG",
        "WEAPON_RPG7",
        "WEAPON_HOMINGLAUNCHER",
        "WEAPON_GRENADELAUNCHER",
        "WEAPON_FIREWORK",
        "WEAPON_MINIGUN",
        "WEAPON_RAYMINIGUN",
    },
    WEAPONS_SKINS = {
        "COMPONENT_BATTLERIFLE_PENHASHOP_04",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_AGUA",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_ANIME",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_BIOHAZARD",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_GAME",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_PAPELAO",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_TOXIC_PUDDIN",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_TOXIC_V1",
        "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_WOLF",
        "COMPONENT_PL_ASSAULTRIFLE_GAME",
        "COMPONENT_PL_ASSAULTRIFLE_PUDDIN_PASCOA",
        "COMPONENT_PL_ASSAULTRIFLE_TOXIC_V3",
        "COMPONENT_PL_ASSAULTRIFLE_UNI",
        "COMPONENT_PL_CARBINERIFLE_ANIME",
        "COMPONENT_PL_CARBINERIFLE_BLOCKS",
        "COMPONENT_PL_CARBINERIFLE_FADE",
        "COMPONENT_PL_CARBINERIFLE_GAME",
        "COMPONENT_PL_CARBINERIFLE_LOVE",
        "COMPONENT_PL_CARBINERIFLE_MEDIC",
        "COMPONENT_PL_CARBINERIFLE_MK2_TOXIC",
        "COMPONENT_PL_CARBINERIFLE_ROSA",
        "COMPONENT_PL_COMBATPISTOL_ANIME",
        "COMPONENT_PL_COMBATPISTOL_FADE",
        "COMPONENT_PL_COMBATPISTOL_GAME",
        "COMPONENT_PL_COMBATPISTOL_GRAFITE",
        "COMPONENT_PL_PISTOL_AL",
        "COMPONENT_PL_PISTOL_FJ",
        "COMPONENT_PL_SNIPER_AL",
        "COMPONENT_PL_SNIPER_CUTI",
        "COMPONENT_PL_SNIPER_GAME",
        "WEAPON_APPISTOL_DARKMATTER",
        "WEAPON_APPISTOL_GRAVEYARD",
        "WEAPON_APPISTOL_KAWAI",
        "WEAPON_APPISTOL_SHOCKVOLT",
        "WEAPON_APPISTOL_SNAGDRAGON",
        "WEAPON_ABISSAL",
        "WEAPON_BAT_KAWAI",
        "WEAPON_BLACKSNAKE",
        "WEAPON_BULLPUP_ANIME",
        "WEAPON_BULLPUPRIFLE_MK2_LOBO",
        "WEAPON_CENOURA",
        "WEAPON_DRAGONRED_SNIPER",
        "WEAPON_G3LCHELLFIRE",
        "WEAPON_HEAVYSNIPER_MK2_LOBO",
        "WEAPON_KATANA_CENOURA",
        "WEAPON_ONI",
        "WEAPON_PABSS",
        "WEAPON_PINKFIRE",
        "WEAPON_PL_PENHASHOP_G3_PCJ_V2",
        "WEAPON_RAIJIN",
        "WEAPON_RPG7",
        "WEAPON_SHINIGAMI",
        "WEAPON_SHOCKVOLT_SNIPER",
        "WEAPON_SKORPION_SNIPER",
        "WEAPON_SNIPERRIFLE_CYBERTRIBAL",
        "WEAPON_SPECIALCARBINE_TOXIC",
        "WEAPON_THYZUK_SNIPER",
        "WEAPON_TIGER",
        "WEAPON_TIGER_PISTOL",
        "WEAPON_TIGER_SNIPER",
        "WEAPON_WOLFSTORM",
    },
    PERMISSIONS = {
        ["Admin"] = 1,
        ["Developers"] = 1,
        ["Afiliado"] = 5,
    },
    SPECTATE_PERMISSIONS = {
        ["Admin"] = 1,
        ["CS"] = 1,
        ["GestaoComercial"] = 1,
        ["Developers"] = 1,
    },
    TELEPORT_PERMISSIONS = {
        ["Admin"] = 1,
        ["Developers"] = 1,
        ["Afiliado"] = 5,
        ["CS"] = 1,
    },
    OPERATIONAL_SERVICE_GROUPS = {
        "Policia",
        "Tatica",
        "Civil",
        "Exercito",
        "Prf",
        "Militar",
        "Federal",
        "PoliciaPrisional",
        "Paramedic",
        "Bombeiros",
        "Bombeiro",
        "Mechanic",
    },
}
