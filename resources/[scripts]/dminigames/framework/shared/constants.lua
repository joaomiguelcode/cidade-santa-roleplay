---Constantes globais do framework
---@class FrameworkConstants
FrameworkConstants = {}

-- ============================================
-- TIMINGS PADRÃO
-- ============================================
FrameworkConstants.DEFAULT_TIMINGS = {
    QUEUE_CHECK_INTERVAL = 1000,        -- Intervalo de verificação da fila
    VISIBILITY_CHECK_INTERVAL = 500,    -- Intervalo de verificação de visibilidade
    CONTROLS_CHECK_INTERVAL = 0,        -- Intervalo de verificação de controles (0 = todo frame)
    ROUND_TRANSITION_TIME = 2000,       -- Tempo padrão entre rodadas
    INTRO_GRACE_PERIOD = 0,             -- Período de graça padrão
    DUPLICATE_REQUEST_TTL = 2000,       -- TTL para proteção anti-duplicação
    THREAD_STOP_DELAY = 100,            -- Delay ao parar threads
}

-- ============================================
-- LIMITES PADRÃO
-- ============================================
FrameworkConstants.DEFAULT_LIMITS = {
    MIN_PLAYERS = 3,
    MAX_PLAYERS = 16,
    MAX_QUEUE_TIME = 15 * 60000,        -- 15 minutos
    ABSOLUTE_MIN_PLAYERS = 2,           -- Mínimo absoluto para manter partida
}

-- ============================================
-- TECLAS DE CONTROLE
-- ============================================
FrameworkConstants.KEYS = {
    G = 47,                 -- G
    E = 38,                 -- Interação
    ENTER = 191,            -- Enter
    NUM_1 = 157,            -- Tecla 1 (holster)
    NUM_2 = 158,            -- Tecla 2
    TAB = 37,               -- Tab
    ESC = 322,              -- Sair da partida/fila
}

-- ============================================
-- ESTADOS DO MINIGAME (Cliente)
-- ============================================
FrameworkConstants.GAME_STATES = {
    NONE = 'NONE',                          -- Nenhum estado ativo
    QUEUE = 'QUEUE',                        -- Na fila
    MATCH_INTRO = 'MATCH_INTRO',            -- Intro da partida
    MATCH_GAMEPLAY = 'MATCH_GAMEPLAY',      -- Jogando
    MATCH_SPECTATOR = 'MATCH_SPECTATOR',    -- Especta por morrer
    MATCH_ENDED = 'MATCH_ENDED',            -- Partida terminou
}

-- ============================================
-- ESTADOS DO MATCH (Servidor)
-- ============================================
FrameworkConstants.MATCH_STATES = {
    STARTING = 'starting',
    IN_PROGRESS = 'in_progress',
    ENDED = 'ended',
}

-- ============================================
-- ESTADOS DA RODADA (Servidor)
-- ============================================
FrameworkConstants.ROUND_STATES = {
    WAITING = 'waiting',
    IN_PROGRESS = 'in_progress',
    ENDED = 'ended',
}

-- ============================================
-- ESTRATÉGIAS DE TIMES
-- ============================================
FrameworkConstants.TEAM_STRATEGIES = {
    RANDOM = 'random',
    BALANCED = 'balanced',
    DISTRIBUTION_TABLE = 'distributionTable',
}

-- ============================================
-- ESTRATÉGIAS DE SPAWNPOINTS
-- ============================================
FrameworkConstants.SPAWN_STRATEGIES = {
    RANDOM = 'random',
    SEQUENTIAL = 'sequential',
}

-- ============================================
-- RAZÕES DE SAÍDA
-- ============================================
FrameworkConstants.LEAVE_REASONS = {
    VOLUNTARY = 'voluntary',
    DISCONNECT = 'disconnect',
    TIMEOUT = 'timeout',
    KICKED = 'kicked',
    INSUFFICIENT_PLAYERS = 'insufficient_players',
}

-- ============================================
-- RAZÕES DE FIM DE RODADA
-- ============================================
FrameworkConstants.ROUND_END_REASONS = {
    TEAM_ELIMINATION = 'team_elimination',
    TIME_LIMIT = 'time_limit',
    MANUAL = 'manual',
}

-- ============================================
-- GHOST MODE
-- ============================================
FrameworkConstants.GHOST_MODE = {
    ALPHA = 150,                    -- Transparência do ghost
    TRANSITION_TIME = 500,          -- Tempo de fade
    RESPAWN_DELAY = 100,            -- Delay antes de respawn
}

-- ============================================
-- DIMENSÕES (Routing Buckets)
-- ============================================
FrameworkConstants.DIMENSIONS = {
    MAIN_WORLD = 0,
    MATCH_START = 100,              -- Matches começam em 100+
}

-- ============================================
-- EVENTOS DE REDE
-- ============================================
FrameworkConstants.EVENTS = {
    -- Servidor → Cliente
    MATCH_START = '.client:onMatchStart',
    MATCH_END = '.client:onMatchEnd',
    ROUND_START = '.client:onRoundStart',
    ROUND_END = '.client:onRoundEnd',
    PLAYER_DEATH = '.client:onMatchPlayerDeath',
    PLAYER_ADD = '.client:onMatchAdd',
    PLAYER_REMOVE = '.client:onMatchRemove',
    PLAYER_LEAVE = '.client:onPlayerLeave',
    ENABLE_GHOST_MODE = '.client:enableGhostMode',
    SYNC_PLAYERS_STATE = '.client:syncPlayersState',
    ROUND_RESET = '.client:onRoundReset',
    LATE_JOIN = '.client:onMatchLateJoin',
    WAITING_NEXT_ROUND = '.client:onPlayerWaitingNextRound',
    
    -- Cliente → Servidor
    PLAYER_DEATH_SERVER = '.server:onPlayerDeath',
    LEAVE_QUEUE = 'dminigames.server:leaveQueue',
    LEAVE_MATCH = 'dminigames.server:leaveMatch',
}

-- ============================================
-- LOG PREFIXES
-- ============================================
FrameworkConstants.LOG_PREFIXES = {
    ERROR = '❌',
    WARNING = '⚠️',
    SUCCESS = '✅',
    INFO = 'ℹ️',
    DEBUG = '🐛',
    PLAYER_ADD = '➕',
    PLAYER_REMOVE = '➖',
    BROADCAST = '📡',
    STATS = '📊',
    VICTORY = '🏁',
    DEATH = '☠️',
    GHOST = '👻',
}

-- ============================================
-- VALIDAÇÕES
-- ============================================
FrameworkConstants.VALIDATION = {
    MIN_USERNAME_LENGTH = 3,
    MAX_USERNAME_LENGTH = 32,
    MIN_MATCHID = 100000,
    MAX_MATCHID = 999999,
}
