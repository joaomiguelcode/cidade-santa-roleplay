DEFINE_MINIGAME 'minigame_routes__meth__south' {

    displayName = _t("meth_route_south"),

    points = MINIGAME_ROUTES__POINTS__SOUTH,

    distance = MINIGAME_ROUTES__DISTANCE,

    flags = MINIGAME_ROUTES__FLAGS,

    isAllowed =
    {
        groups = SWITCH(cityName, {
            { 'Santa', { "Vagos", "Azuis", "China", "Dixavas", "Umbrella", "Afetados", "Hollywood", "Brancos" } },
            { 'CidadeNobre', { "Amarelos", "Gang4", "LaMafia", "Azuis", "Callisto", "Afetados", "AlcateiaHsT" } },
            { 'Boomerang', { "Vermelhos", "Overdrive", "Gang6", "LaMafia", "Umbrella", "Azuis", "Callisto", "Afetados", "Amarelos", "AlcateiaHsT" } },
            { 'Grande', { "Vermelhos","Gang6", "Callisto", "Azuis", "LaMafia", "Afetados", "Amarelos", "AlcateiaHsT" } },
            { 'Fronteira', { "Vermelhos", "Gang6", "Vagos", "Callisto", "Azuis", "Umbrella", "LaMafia", "Afetados", "Amarelos", "AlcateiaHsT" } },
            { 'Malta', { "Overdrive", "Gang6", "Vagos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "AlcateiaHsT" } },
            { 'Kingdom', { "Vermelhos","Vagos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'District99', { "Vermelhos","Vagos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Krown', { "Vermelhos","Vagos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Orizon', { "Vermelhos","Vagos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Royal', { "Vermelhos","Vagos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Real', { "Vermelhos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
            { 'Prime', { "Vermelhos", "LaMafia", "Umbrella", "Azuis", "Afetados", "Cinzas", "Pinkmans", "Hollywood", "Amarelos", "AlcateiaHsT" } },
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