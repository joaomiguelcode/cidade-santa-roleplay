DEFINE_MINIGAME 'minigame_routes__cocaine__south' {

    displayName = _t("cocaine_route_south"),

    points = MINIGAME_ROUTES__POINTS__SOUTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Vermelhos", "Tribo", "Italia", "Inglaterra", "Verdes", "Rosas", "Amarelos" } },
            { 'CidadeNobre', { "Gang7", "Vermelhos", "Overdrive", "Tequilas", "Brancos", "Rosas", "Roxos" } },
            { 'Boomerang', { "DriftKing", "Gang9", "Brancos", "Rosas", "Roxos" } },
            { 'Grande', { "DriftKing", "Palazzo", "Tequilas", "Brancos" } },
            { 'Fronteira', { "DriftKing", "Brancos", "Rosas", "Roxos" } },
            { 'Malta', { "DriftKing", "Verdes", "Gang9", "Brancos", "Roxos" } },
            { 'Kingdom', { "Verdes", "LosAztecas", "Brancos", "Rosas", "Roxos" } },
            { 'District99', { "Verdes", "LosAztecas", "Brancos", "Rosas", "Roxos" } },
            { 'Krown', { "Verdes", "LosAztecas", "Brancos", "Rosas", "Roxos" } },
            { 'Orizon', { "Verdes", "LosAztecas", "Brancos", "Rosas", "Roxos" } },
            { 'Liberty99', { "Verdes", "LosAztecas", "Brancos", "Rosas", "Roxos" } },
            { 'Royal', { "Verdes", "LosAztecas", "Brancos", "Rosas", "Roxos" } },
            { 'Real', { "Verdes", "Vagos", "Brancos", "Rosas", "Roxos" } },
            { 'Prime', { "Verdes", "Vagos", "Brancos", "Rosas", "Roxos" } },
            { 'Universo', { "Vermelhos", "Verdes", "Gang9", "Brancos", "Rosas", "LosAztecas", "Roxos" } },
            { 'Alexandria', { "Vermelhos", "Verdes", "Gang9", "Brancos", "LosAztecas", "Roxos" } },
            { 'Maresia', { "Vermelhos", "LosAztecas", "Verdes", "Rosas", "Roxos", "Brancos" } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'cokeleaf', amount = 6 },
            { id = 'sulfuric', amount = 6 },
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}