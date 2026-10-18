DEFINE_MINIGAME 'minigame_routes__hamburger__north' {

    displayName = _t("hamburger_route_north"),

    points = MINIGAME_ROUTES__POINTS__NORTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,
    requirements =
    {
        -- flags = eMinigameRequirementsFlags.CONSUME_ITEMS,

        items =
        {
            { id = 'hamburger3', amount = 1 },
        },
    },
    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Empresa1" } },
            { 'CidadeNobre', { "Empresa1" } },
            { 'Boomerang', { "Empresa1" } },
            { 'Grande', { "Empresa1" } },
            { 'Fronteira', { "Empresa1" } },
            { 'Malta', { "Empresa1" } },
            { 'Kingdom', { "Empresa1" } },
            { 'District99', { "Empresa1" } },
            { 'Krown', { "Empresa1" } },
            { 'Orizon', { "Empresa1" } },
            { 'Royal', { "Empresa1" } },
            { 'Real', { "Empresa1" } },
            { 'Prime', { "Empresa1" } },
            { 'Universo', { "Empresa1" } },
            { 'Alexandria', { "Empresa1" } },
            { 'Maresia', { "Empresa1" } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'dollars'    , amount = 1000 }
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}