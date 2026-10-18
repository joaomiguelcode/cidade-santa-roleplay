CURRENT_CITY_NAME = GetConvar('cityName', '')

---@enum eGamemodeCategories string
eGamemodeCategories = {
    Minigame = 'minigame',
    Pvp = 'pvp',
    Competitive = 'competitive',
}

---@enum eGamemodeTypes string
eGamemodeTypes = {
    COMPETITIVE = 'competitive',
    FFARifle    = 'ffa_rifle',
    FFAPistol   = 'ffa_pistol',
    FFASniper   = 'ffa_sniper',
    DOMINATION  = 'domination',
    ROYALE      = 'royale',
    Murder      = 'murder',
}

-- Nome funcional do MinigameServer/MinigameClient. Nao traduzir: ele entra em
-- nomes de eventos, state bags e lookup de instancias do framework.
PVP_COMPETITIVE_MINIGAME_NAME = 'Competitivo 5v5'
PVP_DOMINATION_MINIGAME_NAME = 'Domination'
PVP_DOMINATION_MAX_PLAYERS = 999

function PvpIsCompetitiveMinigameName( name )
    return tostring( name or '' ) == PVP_COMPETITIVE_MINIGAME_NAME
end

---@class QueueConfig
---@field category eGamemodeCategories
---@field type eGamemodeTypes
---@field name string
---@field description string
---@field minPlayers number
---@field maxPlayers? number
---@field image? string
---@field isLocked? boolean Indisponibilidade exibida no painel; a entrada e validada pelo servidor do modo.
---@field introGracePeriod? number
---@field weapon? string
---@field weaponAmmo? number
---@field weaponHud? string
---@field weaponImage? string
---@field weaponKillfeed? string
---@field slotItem? string
---@field respawnOnDeath? boolean
---@field matchDuration? number
---@field boundaryCheck? {enabled: boolean, maxDistance: number, showWarning: boolean, drawRadius: boolean}
---@field sla? table<string, string>

---@type QueueConfig[]
QUEUES = {
    {
        category    = eGamemodeCategories.Pvp,
        key         = eGamemodeTypes.COMPETITIVE,
        type        = eGamemodeTypes.COMPETITIVE,
        name        = PvpTranslations.get( 'competitive_name' ),
        description = PvpTranslations.get( 'competitive_description' ),
        minPlayers  = 1,
        maxPlayers  = 20,
        image       = 'https://cdn.santagroup.gg/minigame/banner1.webp',
    },
    {
        category    = eGamemodeCategories.Pvp,
        key         = eGamemodeTypes.FFARifle,
        type        = eGamemodeTypes.FFARifle,
        name        = PvpTranslations.get( 'ffa_rifle_name' ),
        description = PvpTranslations.get( 'ffa_rifle_description' ),
        minPlayers  = 1,
        maxPlayers  = 128,
        image       = 'https://cdn.santagroup.gg/minigame/banner2.webp',
    },
    {
        category    = eGamemodeCategories.Pvp,
        key         = eGamemodeTypes.FFAPistol,
        type        = eGamemodeTypes.FFAPistol,
        name        = PvpTranslations.get( 'ffa_pistol_name' ),
        description = PvpTranslations.get( 'ffa_pistol_description' ),
        minPlayers  = 1,
        maxPlayers  = 128,
        image       = 'https://cdn.santagroup.gg/minigame/banner3.webp',
    },
    {
        category    = eGamemodeCategories.Pvp,
        key         = eGamemodeTypes.FFASniper,
        type        = eGamemodeTypes.FFASniper,
        name        = PvpTranslations.get( 'ffa_sniper_name' ),
        description = PvpTranslations.get( 'ffa_sniper_description' ),
        minPlayers  = 1,
        maxPlayers  = 128,
        image       = 'https://cdn.santagroup.gg/minigame/banner5.webp',
    },
    {
        category    = eGamemodeCategories.Pvp,
        key         = eGamemodeTypes.DOMINATION,
        type        = eGamemodeTypes.DOMINATION,
        name        = PvpTranslations.get( 'domination_name' ),
        description = PvpTranslations.get( 'domination_description' ),
        minPlayers  = 1,
        maxPlayers  = PVP_DOMINATION_MAX_PLAYERS,
        image       = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    {
        category    = eGamemodeCategories.Pvp,
        key         = eGamemodeTypes.ROYALE,
        type        = eGamemodeTypes.ROYALE,
        name        = PvpTranslations.get( 'royale_name' ),
        description = PvpTranslations.get( 'royale_description' ),
        minPlayers  = 1,
        maxPlayers  = PVP_ROYALE_MAX_PLAYERS,
        image       = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
        isLocked    = true,
    },
    {
        category    = eGamemodeCategories.Minigame,
        key         = eGamemodeTypes.Murder,
        type        = eGamemodeTypes.Murder,
        name        = 'Murder',
        description = MurderTranslations.get( 'conversation_description' ),
        minPlayers  = MurderConstants.LIMITS.MIN_PLAYERS,
        maxPlayers  = MurderConstants.LIMITS.MAX_PLAYERS,
        image       = 'https://cdn.santagroup.gg/minigame/banner4.webp',
    },
}

---@type table<eGamemodeTypes, MinigameServer>
gameModeInstances = {}

GameModeConstants = {
    PARTY_STATES = {
        IDLE = 'idle',
    },
    DEFAULT_LIMITS = {
        MAX_PARTY_SIZE = 5,
    },
    DEFAULT_TIMINGS = {
        RECONNECT_TIMEOUT = 5 * 60000,
    },
}
