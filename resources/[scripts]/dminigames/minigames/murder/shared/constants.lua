---Constantes compartilhadas do minigame Murder
---@class MurderConstants
MurderConstants = {}

-- ============================================
-- COORDENADAS
-- ============================================
MurderConstants.NPC_COORDS = vector4(155.47,-966.34,29.78,251.30)

-- ============================================
-- ROLES
-- ============================================
MurderConstants.ROLES = {
    ASSASSINO = 'Assassinos',
    DETETIVE = 'Detetives',
    INOCENTE = 'Inocentes'
}

-- ============================================
-- ARMAS
-- ============================================
MurderConstants.WEAPONS = {
    KARAMBIT = {
        hash = 'WEAPON_KARAMBIT',
        ammo = 100,
        holsterKey = 157, -- Tecla 1
        image = 'https://santaimagens.roleplayrp.com/img/inventory/WEAPON_KARAMBIT.png'
    },
    REVOLVER = {
        hash = 'WEAPON_REVOLVER',
        ammo = 300,
        holsterKey = 157, -- Tecla 1
        image = 'https://santaimagens.roleplayrp.com/img/inventory/magnum.png'
    }
}

-- ============================================
-- TIMINGS
-- ============================================
MurderConstants.TIMINGS = {
    INTRO_GRACE_PERIOD = 5000, -- 5 segundos
    ROUND_TIME = 3 * 60000,    -- 3 minutos
    ROUND_TRANSITION = 5000,   -- 5 segundos entre rodadas
    INVINCIBILITY_TIME = 7000  -- 7 segundos de invencibilidade no spawn
}

-- ============================================
-- UI PHASES
-- ============================================
MurderConstants.UI_PHASES = {
    QUEUE = 'QUEUE',
    INTRO = 'INTRO',
    GAMEPLAY = 'GAMEPLAY',
    SPECTATOR = 'SPECTATOR',
    ENDED = 'ENDED',
    WAITING_NEXT_ROUND = 'WAITING_NEXT_ROUND'
}

-- ============================================
-- VICTORY CONDITIONS
-- ============================================
MurderConstants.VICTORY_REASONS = {
    TEAM_ELIMINATION = 'team_elimination',
    TIME_LIMIT = 'time_limit',
    DISCONNECT = 'disconnect'
}

-- ============================================
-- DISTRIBUIÇÃO DE ROLES
-- ============================================
MurderConstants.ROLE_DISTRIBUTION = {
    [2]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 0 },
    [3]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 1 },
    [4]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 2 },
    [5]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 3 },
    [6]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 4 },
    [7]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 5 },
    [8]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 6 },
    [9]  = { ['Assassinos'] = 1, ['Detetives'] = 1, ['Inocentes'] = 7 },
    [10] = { ['Assassinos'] = 2, ['Detetives'] = 1, ['Inocentes'] = 7 },
    [11] = { ['Assassinos'] = 2, ['Detetives'] = 1, ['Inocentes'] = 8 },
    [12] = { ['Assassinos'] = 2, ['Detetives'] = 2, ['Inocentes'] = 8 },
    [13] = { ['Assassinos'] = 2, ['Detetives'] = 2, ['Inocentes'] = 9 },
    [14] = { ['Assassinos'] = 2, ['Detetives'] = 2, ['Inocentes'] = 10 },
    [15] = { ['Assassinos'] = 3, ['Detetives'] = 2, ['Inocentes'] = 10 },
}

-- ============================================
-- SPAWNPOINTS
-- ============================================
MurderConstants.SPAWNPOINTS = {
    vec4(2043.94, 2979.09, -61.90, 278.69),
    vec4(2047.29, 2985.17, -61.90, 260.74),
    vec4(2049.99, 2974.60, -61.90, 356.77),
    vec4(2053.71, 2979.84, -61.90, 44.09)
}

-- ============================================
-- LIMITES
-- ============================================
MurderConstants.LIMITS = {
    MIN_PLAYERS = 3,
    MAX_PLAYERS = 15,
    MAX_QUEUE_TIME = 15 * 60000, -- 15 minutos
}
