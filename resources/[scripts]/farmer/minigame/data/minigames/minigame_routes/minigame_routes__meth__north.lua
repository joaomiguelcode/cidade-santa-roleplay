DEFINE_MINIGAME 'minigame_routes__meth__north' {

    displayName = _t("meth_route_north"),

    points = MINIGAME_ROUTES__POINTS__NORTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Vagos", "Azuis", "China", "Dixavas", "Umbrella", "Afetados", "Hollywood", "Brancos" } },
            { 'CidadeNobre', { "Amarelos", "Gang4", "Callisto", "Azuis", "LaMafia", "Afetados", "AlcateiaHsT" } },
            { 'Boomerang', { "Vermelhos", "Overdrive", "Gang6", "Callisto", "Azuis", "Umbrella", "LaMafia", "Afetados", "Amarelos", "AlcateiaHsT" } },
            { 'Grande', { "Vermelhos","Gang6", "Callisto", "Azuis", "LaMafia", "Afetados", "Amarelos", "AlcateiaHsT" } },
            { 'Fronteira', {"Vermelhos", "Gang6", "Vagos", "Callisto", "Azuis", "Umbrella", "LaMafia", "Afetados", "Amarelos", "AlcateiaHsT" } },
            { 'Malta', { "Overdrive", "Gang6", "Vagos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "AlcateiaHsT" } },
            { 'Kingdom', { "Vermelhos","Vagos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'District99', { "Vermelhos","Vagos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Krown', { "Vermelhos","Vagos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Orizon', { "Vermelhos","Vagos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Royal', { "Vermelhos","Vagos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Real', { "Vermelhos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Prime', { "Vermelhos", "Azuis", "Umbrella", "LaMafia", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Universo', { "Vagos", "LaMafia", "Umbrella", "Metgala", "Afetados", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Alexandria', { "Vagos", "LaMafia", "Umbrella", "Afetados", "Pinkmans", "Metgala", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Maresia', { "Vagos", "LaMafia", "Umbrella", "Afetados", "Pinkmans", "Metgala", "Hollywood", "Amarelos", "AlcateiaHsT" } }
        })
    },

    duration = MINIGAME_ROUTES__DURATION,

    rewards =
    {
        item =
        {
            { id = 'saline' , amount = 6 },
            { id = 'acetone', amount = 6 },
        }
    },

    hooks =
    {
        beforeComputeRewards = CommonBeforeComputeRewards,
    }
}