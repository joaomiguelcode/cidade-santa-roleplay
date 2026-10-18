RoyaleGroups = {
    ["Gang1"] = true,
    ["Mercenarios"] = true,
    ["LosTugas"] =  true,
    ["Caribe"] = true,
    ["Japao"] = true,
    ["Inglaterra"] = true,
    ["Noxus"] = true,
    ["LaMafia"] = true,
    ["Franca"] = true,
    ["Italia"] = true,
    ["Russia"] = true,
    ["Israel"] = true,
    ["Jamakeikos"] = true,
    ["Playboy"] = true,
    ["Mexico"] = true,
    ["Gringa"] = true,
    ["China"] = true,
    ["Gang2"] = true,
    ["Tropadu7"] = true,
    ["Tribo"] = true,
    ["Gang6"] = true,
    ["SonsofAnarchy"] = true,
    ["Fazendinha"] = true,
    ["Campinho"] = true,
    ["Gang3"] = true,
    ["Gang8"] = true,
    ["Gang7"] = true,
    ["Gang5"] = true,
    ["Warlocks"] = true,
    ["Groove"] = true,
    ["Outlaws"] = true,
    ["TopGear"] = true,
    ["Morro-do-Sacola"] = true,
    ["FerroVelho"] = true,
    ["CarClube"] = true,
    ["Virtude"] = true,
    ["Big"] = true,
    ["Kraken"] = true,
    ["Redline"] = true,
    ["Bennys"] = true,
    ["DriftKing"] = true,
    ["Forza"] = true,
    ["Overdrive"] = true,
    ["Anonymous"] = true,
    ["Ballas"] = true,
    ["Bellagio"] = true,
    ["Lavajato"] = true,
    ["Tequilas"] = true,
    ["Arcade"] = true,
    ["Callisto"] = true,
    ["Galaxy"] = true,
    ["Bahamas"] = true,
    ["Palazzo"] = true,
    ["Luxor"] = true,
    ["Barragem"] = true,
    ["Gang9"] = true,
    ["Banzas"] = true,
    ["Dixavas"] = true,
    ["Gang4"] = true,
    ["Sindicato"] = true,
    ["Vagos"] = true,
    ["Umbrella"] = true,
    ["Metgala"] = true,
    ["Afetados"] = true, 
    ["Pinkmans"] = true, 
    ["Hollywood"] = true,
    ["Azuis"] = true,
    ["Vermelhos"] = true,
    ["Amarelos"] = true,
    ["AlcateiaHsT"] = true,
    ["Verdes"] = true,
    ["Roxos"] = true,
    ["Laranjas"] = true,
    ["Marrons"] = true,
    ["Cinzas"] = true,
    ["Brancos"] = true,
    ["LosAztecas"] = true,
    ["Policia"] = true,
    ["Bombeiros"] = true,
    ["Paramedic"] = true,
    ["Mechanic"] = true,
    ["Rosas"] = true
}

---@param number number
---@param min    number
---@param max    number
function clamp(number, min, max)
    return math.min(math.max(number, min), max)
end

---@param a number
---@param b number
---@param t number
function lerp(a, b, t)
    return (1 - t) * a + t * b
end

GetServerTime =
    GetGameName() == 'fxserver'
        and GetGameTimer
        or  GetNetworkTimeAccurate

---@param safezone battleroyale.Safezone
---@return number
function GetCurrentSafezoneTransitionRadius( safezone )

    -- Caso esteja pausada, usar o timestamp em que foi pausada!
    local serverTime = safezone.transitionPausedAt or GetServerTime()

    local interp = clamp(( serverTime - safezone.transitionStartedAt ) / safezone.transitionDuration, 0.0, 1.0)

    local r = lerp( safezone.transitionStateFrom.radius    , safezone.transitionStateTo.radius    , interp )

    return r
end

TELEPORT_DEATH = vector3(438.31,222.08,103.15)

--- Bucket padrao do mundo Royale (`/world royale`); `ThayRoyale` pode usar bucket customizado.
BATTLEROYALE_DEFAULT_EVENT_BUCKET = 25

--- Demora X millisegundos para consumir X raio da safezone
---@type number
BATTLEROYALE_SAFEZONE_DURATION_MS_PER_RADIUS_UNIT = 500

--- AUMENTO DA VELOCIDADE POR INDEX DO SELECT OU SEJA (BATTLEROYALE_SAFEZONE_DURATION_MS_PER_RADIUS_UNIT - (BATTLEROYALE_SAFEZONE_DURATION_MS_PER_RADIUS_UNIT * count))
---@type number
BATTLEROYALE_SAFEZONE_DURATION_MS_PER_RADIUS_UNIT_STEP = 190.0

---@type number
BATTLEROYALE_DAMAGE_UPDATE_INTERVAL_SECONDS = 1


---@type number
QUANTITY_AVALIABLE_VELOCITY_STEPS = 2

---@enum eSafezoneDeletedReason
eSafezoneDeletedReason =
{
    UNKNOWN = 0,
    COMMAND_DELETE = 1,
}
