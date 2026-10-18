DEFINE_MINIGAME 'minigame_routes__ammo__north' {

    displayName = _t("ammo_route_north"),

    points = MINIGAME_ROUTES__POINTS__NORTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "LosAztecas", "Gang7", "Arcade", "Campinho", "Callisto", "Bahamas", "LosTugas", "Gang4", "Gang3", "Gang8", "Gang5", "Cinzas", "Warlocks", "Groove", "Galaxy" } },
            { 'CidadeNobre', { "Gang2", "Gang6", "Gang9","Outlaws", "SonsofAnarchy", "Gang3", "CarClube", "DriftKing", "Bennys", "TopGear", "LosAztecas", "Vagos", "Ballas", "Cinzas", "Bellagio", "Verdes", "Tropadu7", "Tribo", "Anonymous", "Fazendinha", "Morro-do-Sacola", "Warlocks", "Inglaterra" } },
            { 'Boomerang', { "Gang2", "Vagos", "Ballas","Caribe", "Kraken", "Cinzas", "Bellagio", "Verdes", "Tropadu7", "Tribo", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Inglaterra" } },
            { 'Grande', { "Gang2", "Cinzas", "Luxor", "Franca", "Japao", "Bahamas", "Verdes", "Ballas", "Kraken", "Bellagio", "Tropadu7", "Tribo", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks" } },
            { 'Fronteira', { "Gang2", "Luxor", "Franca", "Japao", "Bahamas", "Verdes", "Ballas","Caribe", "Kraken", "Cinzas", "Bellagio", "Tropadu7", "Tribo", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Inglaterra" } },
            { 'Malta', { "Gang2", "Gang8", "Rosas", "Tequilas", "Callisto", "Luxor", "Playboy", "Tropadu7", "Tribo", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Inglaterra", "Galaxy" } },
            { 'Kingdom', { "Gang2", "Putaria", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'District99', { "Gang2", "Gang7", "Putaria", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Krown', { "Gang2", "Gang7", "Putaria", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Orizon', { "Gang2", "Gang7", "Putaria", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Liberty99', { "Gang2", "Gang7", "Putaria", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Royal', { "Gang2", "Putaria", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Real', { "Gang2", "Putaria", "Israel", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Prime', { "Gang2", "Sindicato", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Gang5", "Campinho", "Gang3", "Morro-do-Sacola", "Marrons", "Warlocks", "Galaxy" } },
            { 'Universo', { "Gang2", "Gang5","Anonymous", "Tropadu7", "Tribo", "Gang6", "Gang4", "Outlaws", "SonsofAnarchy", "Fazendinha", "Campinho", "Gang3", "Gang8", "Gang7", "Marrons", "Cinzas", "Azuis", "Warlocks", "Inglaterra", "Galaxy" } },
            { 'Alexandria', { "Gang2", "Gang9", "Tropadu7", "Tribo", "Gang6", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Campinho", "Gang3", "Gang8", "Gang7", "Gang5", "Marrons", "Cinzas", "Azuis", "Warlocks" } },
            { 'Maresia', { "Tropadu7", "Tribo", "Gang6", "Outlaws", "SonsofAnarchy", "Anonymous", "Fazendinha", "Campinho", "Sindicato", "Gang3", "Gang8", "Gang7", "Gang5", "Marrons", "Cinzas", "Azuis", "Warlocks", "Galaxy"  } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'polvora', amount = 6 },
            { id = 'capsula', amount = 6 },
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}