local cityName = GetConvar('cityName', '')
local enabledCities = {
    District99 = true, Real = true, Prime = true, Maresia = true,
    Santa = true, Grande = true, CidadeNobre = true, Krown = true,
    Kingdom = true, Royal = true, Liberty99 = true, Malta = true, Orizon = true,
}

NeighborConfig = {
    enabled = enabledCities[cityName] == true,
    spawns = {
        { x = 2539.97, y = 6151.19, z = 164.23, heading = 153.08 },
        { x = 2539.40, y = 6148.83, z = 164.23, heading = 348.67 },
    },
    table = { x = 2539.52, y = 6150.49, z = 164.72, heading = 161.58, propZ = 164.23 },
    tableDui = { x = 2540.11, y = 6149.70, z = 164.24, heading = 127.37 },
    house = { x = 2539.52, y = 6150.49, z = 164.23, radius = 18.0 },
    doors = {
        { model = 100848840, x = 2539.79, y = 6150.94, z = 168.11 },
        { model = -2050436002, x = 2540.09, y = 6149.74, z = 168.11 },
        { model = 1042741067, x = 2533.00, y = 6142.64, z = 164.24 },
        { model = 1042741067, x = 2540.55, y = 6155.24, z = 164.26 },
    },
    unfrozenDoors = {
        { x = 2533.24, y = 6152.57, z = 164.24 },
        { x = 2538.64, y = 6152.19, z = 168.10 },
    },
    bucketBase = 700000,
    callBase = 700000,
    -- ENG-3852: só Novato com Novato tem preferência; os demais entram no pareamento livre.
    -- Mesmo par só se reencontra `pairCooldownSeconds` depois do fim do match anterior.
    -- Convars `matchcity_preference_seconds` e `matchcity_pair_cooldown_seconds` sobrescrevem sem deploy.
    preferenceSeconds = 45,
    pairCooldownSeconds = 180,
    -- ENG-3852: Novato/Veterano somam 3 min ativos em qualquer lugar permitido, fora de combate e AFK.
    -- Iniciante usa somente o app do celular.
    -- Servidor: set matchcity_allowed_buckets "1,6,7,13" (releitura a cada tick, sem deploy).
    activeInviteSeconds = GetConvarInt('matchcity_active_invite_seconds', 180),
    confirmationSeconds = GetConvarInt('matchcity_confirmation_seconds', 60),
    validActiveSeconds = 300,
    roundIdleSeconds = 180,
    roundCountdownSeconds = 5,
    skipFreePerSession = 3,
    skipCooldownSeconds = 300,
    contactCooldownSeconds = 120,
    contactReplySeconds = 60,
    -- ENG-3917: Match não paga XP. Valores > 0 voltam a pagar sem mudar código;
    -- `#participationXp` continua sendo o número de levas (progresso 0 de 3).
    winXp = 0,
    winDailyCap = 0,
    participationXp = { 0, 0, 0 },
}
