DEFINE_MINIGAME 'minigame_routes__money-laundering__north' {

    displayName = _t("money_laundering_route_north"),

    points = MINIGAME_ROUTES__POINTS__NORTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Ballas", "Gang1", "Roxos", "Gang2", "Kraken", "Bellagio", "Tequilas" } },
            { 'CidadeNobre', {"Gang1", "FerroVelho", "Hollywood", "Redline", "Bahamas" } },
            { 'Boomerang', { "Gang1", "FerroVelho", "Redline", "Tequilas", "Bahamas", "Luxor" } },
            { 'Grande', { "Pinkmans", "Caribe", "Inglaterra", "Putaria", "Gang1", "FerroVelho" } },
            { 'Fronteira', { "Pinkmans", "Putaria", "Gang1", "FerroVelho", "Tequilas" } },
            { 'Malta', { "Ballas", "Caribe", "Metgala", "Putaria", "Gang1", "Bellagio", "Redline", "Arcade", "Bahamas" } },
            { 'Kingdom', { "Ballas", "Callisto", "Metgala", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'GoatRP', { "Ballas", "Luxor" } },
            { 'District99', { "Ballas", "Callisto", "Metgala", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'Krown', { "Ballas", "Callisto", "Metgala", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'Orizon', { "Ballas", "Callisto", "Metgala", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'Royal', { "Ballas", "Callisto", "Metgala", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'Real', { "Ballas", "LosAztecas", "Callisto", "Metgala", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'Prime', { "Ballas", "LosAztecas", "Callisto", "Metgala", "Putaria", "Gang1", "Bellagio", "Redline", "Tequilas", "Arcade", "Bahamas", "Palazzo", "Luxor" } },
            { 'Universo', { "Ballas", "Bellagio", "Lavajato", "Tequilas", "Arcade", "Callisto", "Bahamas", "Palazzo", "Luxor" } },
            { 'Alexandria', { "Ballas", "Bellagio", "Lavajato", "Tequilas", "Arcade", "Callisto", "Bahamas", "Palazzo", "Luxor" } },
            { 'Maresia', { "Bennys", "Bellagio", "Lavajato", "Tequilas", "Arcade", "Callisto", "Bahamas", "Palazzo", "Luxor" } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'aguadestilada', amount = 6 },
            { id = 'cloro', amount = 6 },
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}
