---Configuração do cliente Murder
---Centraliza todas as configurações específicas do cliente

---@class MurderClientConfig
local MurderClientConfig = {}

-- Importa constantes compartilhadas
MurderClientConfig.NPC_COORDS = MurderConstants.NPC_COORDS
MurderClientConfig.ROLES = MurderConstants.ROLES
MurderClientConfig.WEAPONS = MurderConstants.WEAPONS
MurderClientConfig.TIMINGS = MurderConstants.TIMINGS
MurderClientConfig.UI_PHASES = MurderConstants.UI_PHASES

-- ============================================
-- CONVERSAÇÃO/NPC
-- ============================================
MurderClientConfig.CONVERSATION = {
    name = MurderTranslations.get('conversation_name'),
    tag = MurderTranslations.get('conversation_tag'),
    visible = true,
    description = MurderTranslations.get('conversation_description'),
    coords = MurderConstants.NPC_COORDS,
    icon = 'search',
    buckets = {
        [1] = true,
    },
    ped = {
        model = 's_m_m_ciasec_01',
        animationStages = {
            {
                dict = 'amb@world_human_stand_impatient@female@idle_a',
                anim = 'idle_a',
                timeout = 10000
            },
            {
                dict = 'amb@world_human_stand_impatient@female@idle_a',
                anim = 'idle_a',
                timeout = 60000
            },
            {
                dict = 'amb@world_human_stand_impatient@female@idle_a',
                anim = 'idle_a',
                timeout = 10000
            }
        }
    },
}

-- ============================================
-- CÂMERA
-- ============================================
MurderClientConfig.CAMERA = {
    positions = {
        vec3(2043.94, 2979.09, -57.90),
        vec3(2047.29, 2985.17, -57.90),
        vec3(2049.99, 2974.60, -57.90),
        vec3(2053.71, 2979.84, -57.90),
    },
    fov = 60.0,
    duration = 5000,
    transitionTime = 1000
}

-- ============================================
-- UI
-- ============================================
MurderClientConfig.UI = {
    showWeaponOnRole = {
        [MurderConstants.ROLES.ASSASSINO] = true,
        [MurderConstants.ROLES.DETETIVE] = true,
        [MurderConstants.ROLES.INOCENTE] = false
    },
    phases = MurderConstants.UI_PHASES
}

-- ============================================
-- SONS/EFEITOS
-- ============================================
MurderClientConfig.SOUNDS = {
    roleReveal = 'ROUND_ENDING_STINGER_CUSTOM',
    death = 'HUD_MINI_GAME_SOUNDSET',
    victory = 'CHECKPOINT_PERFECT',
}
