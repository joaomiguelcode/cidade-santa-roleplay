DEFINE_MINIGAME 'minigame_routes__weed__north' {

    displayName = _t("weed_route_north"),

    points = MINIGAME_ROUTES__POINTS__NORTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Barragem", "Luxor", "Russia", "Marrons", "Banzas", "Gang4", "Sindicato", "Laranjas" } },
            { 'CidadeNobre', {"Kraken","Gang5", "Gringa", "Banzas", "Laranjas" } },
            { 'Boomerang', { "Barragem", "Gringa", "Gang7", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Grande', { "Barragem", "Gang7", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Fronteira', { "Barragem", "Gringa", "Gang7", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Malta', { "Barragem", "LosAztecas", "Noxus", "Gang7", "Banzas", "Sindicato", "Laranjas" } },
            { 'Kingdom', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang7", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'District99', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Krown', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Orizon', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Royal', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang7", "Gang8", "Banzas", "Sindicato", "Laranjas" } },
            { 'Real', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang7", "Gang8", "Sindicato", "Laranjas" } },
            { 'Prime', { "Barragem", "Gang9", "Noxus", "Dixavas", "Gang7", "Gang8", "Banzas", "Laranjas" } },
            { 'Universo', { "Barragem", "Banzas", "Dixavas", "Sindicato", "Laranjas" } },
            { 'Alexandria', { "Barragem", "Banzas", "Dixavas", "Gang4", "Sindicato", "Laranjas" } },
            { 'Maresia', { "Barragem", "Russia", "Gang2", "Noxus", "Big", "Banzas", "Dixavas", "Gang4", "Laranjas" } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'silk'    , amount = 6 },
            { id = 'weedleaf', amount = 6 },
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}