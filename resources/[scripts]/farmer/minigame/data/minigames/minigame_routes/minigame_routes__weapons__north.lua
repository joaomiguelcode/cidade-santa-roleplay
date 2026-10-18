DEFINE_MINIGAME 'minigame_routes__weapons__north' {

    displayName = _t("weapons_route_north"),

    points = MINIGAME_ROUTES__POINTS__NORTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Redline", "Lavajato", "Israel", "Putaria", "SonsofAnarchy", "AlcateiaHsT", "Pinkmans", "Tropadu7", "Caribe", "Japao", "Noxus", "LaMafia", "Gang6", "Metgala", "Gringa", "Franca", "Playboy", "Mexico" } },
            { 'CidadeNobre', { "Mercenarios", "Barragem", "Gang8", "Virtude", "Campinho", "Luxor", "Playboy", "Pinkmans", "Arcade", "Putaria", "Palazzo", "Dixavas", "Noxus", "Franca", "Japao", "Lavajato", "Italia", "Russia", "Israel", "Metgala", "Mexico", "China" } },
            { 'Boomerang', { "Mercenarios", "Playboy", "Hollywood", "Arcade", "LosAztecas", "Galaxy", "Putaria", "Palazzo", "Dixavas", "Noxus", "Franca", "Japao", "Lavajato", "Italia", "Russia", "Israel", "Metgala", "Mexico", "China" } },
            { 'Grande', { "Mercenarios", "Umbrella",  "Rosas", "Gringa", "Roxos", "Vagos", "Playboy", "Hollywood", "Arcade", "LosAztecas", "Galaxy", "Dixavas", "Noxus", "Lavajato", "Italia", "Russia", "Israel", "Metgala", "Mexico", "China" } },
            { 'Fronteira', { "Mercenarios", "Playboy", "Hollywood", "Arcade", "LosAztecas", "Galaxy", "Palazzo", "Dixavas", "Noxus", "Lavajato", "Italia", "Russia", "Israel", "Metgala", "Mexico", "China" } },
            { 'Malta', { "Mercenarios", "Vermelhos", "Amarelos", "Palazzo", "Dixavas", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Mexico", "China" } },
            { 'Kingdom', { "Mercenarios", "Inglaterra", "Caribe", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'District99', { "Mercenarios", "Franca", "Caribe", "Inglaterra", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Krown', { "Mercenarios","Caribe", "Inglaterra", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Orizon', { "Mercenarios", "Inglaterra", "Caribe", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Royal', { "Mercenarios", "Inglaterra", "Caribe", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Real', { "Mercenarios", "Inglaterra", "Caribe", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Playboy", "Mexico", "China" } },
            { 'Prime', { "Mercenarios", "Inglaterra", "Caribe", "Franca", "Japao", "Lavajato","Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Universo', { "Gang1", "Jamakeikos", "LosTugas", "Mercenarios", "Caribe", "Franca", "Japao", "Noxus", "Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Alexandria', { "Gang1", "Rosas", "Mercenarios", "Caribe", "Franca", "Japao", "Noxus", "Gringa", "Italia", "Russia", "Israel", "Playboy", "Mexico", "China" } },
            { 'Maresia', { "Gang1", "Redline", "Gang9", "Japao", "Jamakeikos", "Mercenarios", "Caribe", "Inglaterra", "LaMafia", "Gringa", "Franca", "Italia", "Israel", "Mexico", "China" } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'weaponbody', amount = 6 },
            { id = 'molas'     , amount = 6 },
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}
