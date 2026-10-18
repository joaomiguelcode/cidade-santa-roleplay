---Enumerações do framework
---Tipos e estados usados em todo o sistema
---@class FrameworkEnums
FrameworkEnums = {}

-- ============================================
-- GAME STATES (Cliente)
-- ============================================
---@enum GameState
FrameworkEnums.GameState = {
    NONE = 'NONE',
    QUEUE = 'QUEUE',
    MATCH_INTRO = 'MATCH_INTRO',
    MATCH_GAMEPLAY = 'MATCH_GAMEPLAY',
    MATCH_SPECTATOR = 'MATCH_SPECTATOR',
    MATCH_ENDED = 'MATCH_ENDED',
}

-- ============================================
-- MATCH STATES (Servidor)
-- ============================================
---@enum MatchState
FrameworkEnums.MatchState = {
    STARTING = 'starting',
    IN_PROGRESS = 'in_progress',
    ENDED = 'ended',
}

-- ============================================
-- ROUND STATES (Servidor)
-- ============================================
---@enum RoundState
FrameworkEnums.RoundState = {
    WAITING = 'waiting',
    IN_PROGRESS = 'in_progress',
    ENDED = 'ended',
}

-- ============================================
-- QUEUE STATES
-- ============================================
---@enum QueueState
FrameworkEnums.QueueState = {
    IDLE = 'idle',
    IN_QUEUE = 'in_queue',
    MATCH_STARTED = 'match_started',
}

-- ============================================
-- PLAYER STATUS
-- ============================================
---@enum PlayerStatus
FrameworkEnums.PlayerStatus = {
    ALIVE = 'alive',
    DEAD = 'dead',
    GHOST = 'ghost',
    WAITING = 'waiting',
}

-- ============================================
-- TEAM STRATEGIES
-- ============================================
---@enum TeamStrategy
FrameworkEnums.TeamStrategy = {
    RANDOM = 'random',
    BALANCED = 'balanced',
    DISTRIBUTION_TABLE = 'distributionTable',
}

-- ============================================
-- SPAWN STRATEGIES
-- ============================================
---@enum SpawnStrategy
FrameworkEnums.SpawnStrategy = {
    RANDOM = 'random',
    SEQUENTIAL = 'sequential',
}

-- ============================================
-- LEAVE REASONS
-- ============================================
---@enum LeaveReason
FrameworkEnums.LeaveReason = {
    VOLUNTARY = 'voluntary',
    DISCONNECT = 'disconnect',
    TIMEOUT = 'timeout',
    KICKED = 'kicked',
    INSUFFICIENT_PLAYERS = 'insufficient_players',
}

-- ============================================
-- ROUND END REASONS
-- ============================================
---@enum RoundEndReason
FrameworkEnums.RoundEndReason = {
    TEAM_ELIMINATION = 'team_elimination',
    TIME_LIMIT = 'time_limit',
    MANUAL = 'manual',
}

-- ============================================
-- HELPERS
-- ============================================

---Verifica se um valor é um GameState válido
---@param value string Valor a verificar
---@return boolean isValid
function FrameworkEnums.isValidGameState(value)
    for _, state in pairs(FrameworkEnums.GameState) do
        if state == value then
            return true
        end
    end
    return false
end

---Verifica se um valor é um MatchState válido
---@param value string Valor a verificar
---@return boolean isValid
function FrameworkEnums.isValidMatchState(value)
    for _, state in pairs(FrameworkEnums.MatchState) do
        if state == value then
            return true
        end
    end
    return false
end

---Verifica se um valor é um RoundState válido
---@param value string Valor a verificar
---@return boolean isValid
function FrameworkEnums.isValidRoundState(value)
    for _, state in pairs(FrameworkEnums.RoundState) do
        if state == value then
            return true
        end
    end
    return false
end

---Retorna todos os GameStates como lista
---@return string[] states
function FrameworkEnums.getAllGameStates()
    local states = {}
    for _, state in pairs(FrameworkEnums.GameState) do
        table.insert(states, state)
    end
    return states
end

---Retorna descrição amigável de um estado
---@param state string Estado
---@return string description
function FrameworkEnums.getStateDescription(state)
    local function frameworkText( key )
        if FrameworkTranslations then
            return FrameworkTranslations.get( key )
        end

        return key
    end

    local descriptions = {
        [FrameworkEnums.GameState.NONE] = frameworkText( 'state_none' ),
        [FrameworkEnums.GameState.QUEUE] = frameworkText( 'state_queue' ),
        [FrameworkEnums.GameState.MATCH_INTRO] = frameworkText( 'state_match_intro' ),
        [FrameworkEnums.GameState.MATCH_GAMEPLAY] = frameworkText( 'state_match_gameplay' ),
        [FrameworkEnums.GameState.MATCH_SPECTATOR] = frameworkText( 'state_match_spectator' ),
        [FrameworkEnums.GameState.MATCH_ENDED] = frameworkText( 'state_match_ended' ),
        
        [FrameworkEnums.MatchState.STARTING] = frameworkText( 'state_starting' ),
        [FrameworkEnums.MatchState.IN_PROGRESS] = frameworkText( 'state_in_progress' ),
        [FrameworkEnums.MatchState.ENDED] = frameworkText( 'state_ended' ),
        
        [FrameworkEnums.RoundState.WAITING] = frameworkText( 'state_waiting' ),
        [FrameworkEnums.RoundState.IN_PROGRESS] = frameworkText( 'state_in_progress' ),
        [FrameworkEnums.RoundState.ENDED] = frameworkText( 'state_ended' ),
    }
    
    return descriptions[state] or frameworkText( 'state_unknown' )
end
