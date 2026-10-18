---@class DominationZoneDefinition
---@field id string Identificador estável da zona (não traduzir)
---@field label string Letra usada no título traduzido (não traduzir)
---@field type string 'capture' | 'safe'
---@field state string Estado inicial: 'neutral' | 'contested' | 'controlled' | 'safe'
---@field color number[] Cor RGB da zona {r, g, b}
---@field shape string 'circle' | 'polygon'
---@field minZ? number Altura minima opcional da zona fisica
---@field maxZ? number Altura maxima opcional da zona fisica
---@field boundaryBottomZ? number Altura mundial fixa da base da parede visual
---@field boundaryTopZ? number Altura mundial fixa do topo da parede visual
---@field boundaryHeight? number Altura da parede quando os pontos possuem perfil Z
---@field boundaryPoints? vector3[] Circunferencia visual com Z, gerada pelo zonecreator
---@field center? vector2 Centro da zona circular no plano do mapa
---@field radius? number Raio da zona circular em metros
---@field capturePoint? vector3 Centro da area logica de captura, nao exibida no mapa
---@field captureRadius? number Raio da area logica de captura
---@field captureMinZ? number Altura minima da area logica de captura
---@field captureMaxZ? number Altura maxima da area logica de captura
---@field points? table Polígono em coordenadas do mundo
---@field spawn? vector4 Ponto de entrada da zona safe
---@field rankingBoardAnchor? vector2 Ancora compartilhada das placas 3D
---@field rankingBoards? table<string, vector2|vector3|vector4> Posições independentes das placas 3D
---@field image? string Imagem exibida no seletor de entrada
---@field locationKey? string PvpTranslations key opcional para a localizacao

---Definições iniciais das zonas do modo Dominação. Os textos exibidos
---(título/status) NÃO ficam aqui: o servidor os resolve via PvpTranslations
---antes de enviar ao client.
DOMINATION_PED_BASE_HEALTH = 100
DOMINATION_PED_MAX_HEALTH = 400
DOMINATION_SAFE_HEAL_INTERVAL_MS = 500
DOMINATION_SAFE_HEAL_PERCENT_PER_TICK = 5
DOMINATION_SAFE_EXIT_PROTECTION_MS = 5000
DOMINATION_CAPTURE_DURATION_MS = 5 * 60 * 1000
-- Janela em que o progresso de uma captura interrompida fica congelado. A mesma
-- organizacao voltando ao ponto dentro dela retoma de onde parou; depois disso o
-- progresso e descartado.
DOMINATION_CAPTURE_RESUME_GRACE_MS = 2 * 60 * 1000
-- Hardpoint: a zona dominada some e outra, sorteada entre as fechadas (nunca a que
-- acabou de ser dominada), abre no lugar. Toda zona que abre no meio da partida
-- (rotacao ou populacao) fica travada por este tempo antes de liberar a captura.
DOMINATION_ZONE_OPEN_LOCK_MS = 30 * 1000
-- Buff do farm da captura. `enabled = false` desliga o sistema inteiro: o
-- /buffdominas recusa e o farm sai sem bonus. `bonus` e o bonus permanente, aditivo
-- como o do VIP (0.0 = sem buff, 1.0 = 2x). O /buffdominas liga um buff temporario
-- que nunca reduz o permanente. Os tetos evitam que um erro de digitacao no comando
-- inflacione a economia.
DOMINATION_FARM_BUFF = {
    enabled = true,
    bonus = 0.0,
    maxMultiplier = 4,
    maxMinutes = 24 * 60,
    -- Grupos que podem usar o /buffdominas (vRP.HasAnyGroupIn: nivel <= valor).
    permissions = {
        [ 'Admin' ] = 2,
    },
    -- Card "Aperte F3", o mesmo da Estatua Mortal (NotifyAnnounce do `hud`).
    announce = {
        key = 'F3',
        seconds = 15,
        -- Recorte da arte da bandeira (domination-invite.webp), 128px com borda
        -- transparente como o icone da estatua. Carregado pelo NUI do `hud`.
        image = 'nui://dminigames/web/domination-farm-buff-icon.png',
        color = '189, 200, 41',
    },
}
DOMINATION_DYNAMIC_ZONES = {
    minimum = 2,
    playersPerZone = 20,
    hysteresis = 10,
    closeDelayMs = 60 * 1000,
}
DOMINATION_CAPTURE_POINT_RADIUS = 10.0
DOMINATION_CAPTURE_POINT_HALF_HEIGHT = 4.0
DOMINATION_ZONE_STATE_COLORS = {
    neutral = { 145, 156, 170 },
    capturing = { 47, 128, 237 },
    contested = { 245, 166, 35 },
    controlled = { 232, 54, 78 },
    safe = { 38, 201, 151 },
    -- Zona recem-aberta e travada: mesma cor da neutra (nao tem dono).
    cooldown = { 145, 156, 170 },
}

local function BuildCircularBoundaryPoints( centerX, centerY, radius, groundProfile )
    local points = {}
    local angleStep = ( math.pi * 2.0 ) / #groundProfile

    for index, groundZ in ipairs( groundProfile ) do
        local angle = ( index - 1 ) * angleStep

        points[ index ] = vector3(
            centerX + ( math.cos( angle ) * radius ),
            centerY + ( math.sin( angle ) * radius ),
            groundZ
        )
    end

    return points
end

---@class DominationCaptureZoneSeed
---@field id string
---@field label string
---@field center vector3
---@field radius number
---@field capturePoint? vector3
---@field captureRadius? number
---@field captureHalfHeight? number

local DOMINATION_BOUNDARY_DEPTH = 1000.0
local DOMINATION_BOUNDARY_HEIGHT = 1000.0

---@type DominationCaptureZoneSeed[]
local DOMINATION_CAPTURE_ZONE_SEEDS = {
    -- Entradas comentadas estao temporariamente desativadas e preservadas para reativacao.
    { id = 'joalheria', label = 'JOALHERIA', center = vector3( -636.55, -241.45, 38.10 ), radius = 100.0 },
    { id = 'banco_central', label = 'BANCO CENTRAL', center = vector3( 235.06, 216.85, 106.29 ), radius = 100.0 },
    -- { id = 'hospital', label = 'HOSPITAL', center = vector3( 327.24, -587.96, 43.30 ), radius = 40.0 },
    -- { id = 'marrom', label = 'MARROM', center = vector3( 370.53, -1676.98, 45.56 ), radius = 60.0 },
    { id = 'vanilla', label = 'VANILLA', center = vector3( 144.07, -1307.11, 29.18 ), radius = 50.0 },
    -- { id = 'mansoes', label = 'MANSOES', center = vector3( -1548.81, 13.10, 58.81 ), radius = 100.0 },
    { id = 'ballas', label = 'BALLAS', center = vector3( 96.94, -1857.04, 24.65 ), radius = 80.0 },
    -- { id = 'crips', label = 'CRIPS', center = vector3( 1283.68, -1731.08, 52.82 ), radius = 80.0 },
    { id = 'delegacia', label = 'DELEGACIA', center = vector3( 464.04, -989.95, 43.69 ), radius = 45.0 },
    -- { id = 'bloods', label = 'BLOODS', center = vector3( -1102.18, -1628.10, 4.40 ), radius = 60.0 },
    { id = 'veneza', label = 'VENEZA', center = vector3( -1034.10, -1072.94, 4.06 ), radius = 90.0 },
    -- { id = 'life_invader', label = 'LIFE INVADER', center = vector3( -1064.26, -241.68, 39.73 ), radius = 50.0 },
    { id = 'estacionamento', label = 'ESTACIONAMENTO', center = vector3( -321.00, -767.74, 33.97 ), radius = 68.0 },
    -- { id = 'fleeca_praia', label = 'FLEECA PRAIA', center = vector3( -2986.99, 483.02, 15.25 ), radius = 150.0 },
    -- { id = 'motel', label = 'MOTEL', center = vector3( 1564.11, 3572.85, 33.72 ), radius = 70.0 },
    -- { id = 'ferro_velho', label = 'FERRO VELHO', center = vector3( 2380.92, 3104.88, 48.14 ), radius = 90.0 },
    -- { id = 'mineradora', label = 'MINERADORA', center = vector3( 1031.89, 2344.90, 46.79 ), radius = 150.0 },
    -- { id = 'motoclube_norte', label = 'MOTOCLUBE NORTE', center = vector3( 48.23, 3673.05, 39.80 ), radius = 100.0 },
    { id = 'gas', label = 'GAS', center = vector3( -17.23, -686.69, 32.33 ), radius = 100.0 },
    -- { id = 'niobio', label = 'NIOBIO', center = vector3( 3531.23, 3708.13, 36.63 ), radius = 120.0 },
    { id = 'acougue', label = 'ACOUGUE', center = vector3( 973.24, -2162.68, 28.79 ), radius = 80.0 },
    -- { id = 'galinheiro', label = 'GALINHEIRO', center = vector3( -105.69, 6190.14, 31.02 ), radius = 90.0 },
    -- { id = 'madeireira', label = 'MADEIREIRA', center = vector3( -535.52, 5310.03, 84.38 ), radius = 100.0 },
    { id = 'motoclube_sul', label = 'MOTOCLUBE SUL', center = vector3( 976.64, -120.50, 74.13 ), radius = 44.0 },
    -- { id = 'container', label = 'CONTAINER', center = vector3( 985.13, -3109.71, 5.88 ), radius = 150.0 },
    -- { id = 'aeroporto', label = 'AEROPORTO', center = vector3( -968.69, -2606.07, 28.62 ), radius = 150.0 },
    -- { id = 'fazenda', label = 'FAZENDA', center = vector3( 1440.83, 1113.84, 114.22 ), radius = 100.0 },
    -- { id = 'posto_abandonado', label = 'POSTO ABANDONADO', center = vector3( -1142.23, -1989.57, 13.15 ), radius = 50.0 },
    { id = 'ferro_velho_sul', label = 'FERRO VELHO SUL', center = vector3( -570.84, -1638.67, 19.41 ), radius = 100.0 },
    -- { id = 'prefeitura', label = 'PREFEITURA', center = vector3( 2493.53, -384.57, 94.12 ), radius = 100.0 },
    -- { id = 'industria', label = 'INDUSTRIA', center = vector3( 2749.90, 1539.67, 24.49 ), radius = 100.0 },
    -- { id = 'yellow', label = 'YELLOW', center = vector3( 1989.97, 3047.09, 47.21 ), radius = 60.0 },
    -- { id = 'casa_abandonada', label = 'CASA ABANDONADA', center = vector3( 2450.02, 4974.47, 46.82 ), radius = 100.0 },
    { id = 'castelinho', label = 'CASTELINHO', center = vector3( -74.64, 350.56, 112.43 ), radius = 70.0 },
    { id = 'ammu_praca', label = 'AMMU PRACA', center = vector3( 14.45, -1104.57, 23.59 ), radius = 14.0, captureRadius = 5.0 },
    -- { id = 'ammu_porto', label = 'AMMU PORTO', center = vector3( 819.90, -2156.72, 29.62 ), radius = 13.0, captureRadius = 3.0 },
    -- { id = 'banco_paleto', label = 'BANCO PALETO', center = vector3( -106.26, 6468.87, 31.62 ), radius = 25.0 },
    { id = 'lester', label = 'LESTER', center = vector3( 714.25, -963.06, 30.39 ), radius = 25.0, captureRadius = 7.0 },
    -- { id = 'igreja_zancudo', label = 'IGREJA ZANCUDO', center = vector3( -302.28, 2803.52, 59.44 ), radius = 75.0 },
    { id = 'obs', label = 'OBS', center = vector3( 742.13, 580.23, 125.91 ), radius = 130.0 },
    -- { id = 'mansao_ilha', label = 'MANSAO ILHA', center = vector3( 4998.90, -5729.42, 19.88 ), radius = 150.0 },
    -- { id = 'fabricadora', label = 'FABRICADORA', center = vector3( 5155.40, -5145.53, 2.34 ), radius = 70.0 },
    -- { id = 'mini_porto', label = 'MINI-PORTO', center = vector3( 5130.38, -4625.37, 2.54 ), radius = 90.0 },
    -- { id = 'casa_do_ceo', label = 'CASA DO CEO', center = vector3( 4822.84, -5027.95, 31.71 ), radius = 50.0 },
    -- { id = 'forte_zancudo_1', label = 'FORTE ZANCUDO 1', center = vector3( -2381.53, 3253.61, 33.02 ), radius = 120.0 },
    -- { id = 'forte_zancudo_2', label = 'FORTE ZANCUDO 2', center = vector3( -1848.88, 3043.65, 32.80 ), radius = 160.0 },
    -- { id = 'tequi_la_la', label = 'TEQUI-LA-LA', center = vector3( -573.78, 300.90, 85.93 ), radius = 40.0 },
    -- { id = 'observatorio', label = 'OBSERVATORIO', center = vector3( -433.20, 1091.47, 332.53 ), radius = 60.0 },
    -- { id = 'mansoes_2', label = 'MANSOES 2', center = vector3( -99.39, 907.12, 236.20 ), radius = 150.0 },
    -- { id = 'maze_bank_arena', label = 'MAZE BANK ARENA', center = vector3( -235.33, -2002.26, 5.68 ), radius = 24.0 },
    -- { id = 'pelados', label = 'PELADOS', center = vector3( -1112.85, 4920.15, 217.78 ), radius = 70.0 },
    -- { id = 'prisao', label = 'PRISAO', center = vector3( 1698.26, 2583.28, 51.24 ), radius = 120.0 },
    -- { id = 'labirinto', label = 'LABIRINTO', center = vector3( -2249.76, 301.32, 174.59 ), radius = 150.0 },
    -- { id = 'estacionamento_praia', label = 'ESTACIONAMENTO PRAIA', center = vector3( -2017.02, -347.05, 48.10 ), radius = 30.0 },
    -- { id = 'aeroporto_paleto', label = 'AEROPORTO PALETO', center = vector3( -1919.18, 5136.94, 15.97 ), radius = 180.0 },
    -- { id = 'iate_paleto', label = 'IATE PALETO', center = vector3( -1410.21, 6751.33, 3.04 ), radius = 70.0 },
    -- { id = 'dp_vespucci', label = 'DP VESPUCCI', center = vector3( -1123.93, -851.88, 13.47 ), radius = 30.0 },
    -- { id = 'metro', label = 'METRO', center = vector3( -826.59, -124.07, 24.15 ), radius = 40.0 },
    { id = 'vagos', label = 'VAGOS', center = vector3( 345.65, -2049.26, 21.58 ), radius = 75.0 },
    -- { id = 'deposito_porto', label = 'DEPOSITO PORTO', center = vector3( -484.71, -2853.56, 17.59 ), radius = 94.0 },
    -- { id = 'los_santos', label = 'LOS SANTOS', center = vector3( -336.96, -137.12, 39.00 ), radius = 20.0, captureRadius = 3.0 },
    { id = 'festa_junina', label = 'FESTA JUNINA', center = vector3( 391.65, -337.38, 46.87 ), radius = 39.0 },
    -- { id = 'hotel', label = 'HOTEL', center = vector3( -1313.88, 310.98, 65.49 ), radius = 70.0 },
    { id = 'colorido', label = 'COLORIDO', center = vector3( -1219.69, -669.14, 35.53 ), radius = 57.0 },
    -- { id = 'evento_chiliad', label = 'EVENTO CHILIAD', center = vector3( 489.67, 5590.26, 794.14 ), radius = 40.0 },
}

---@type table<string, vector3>
local DOMINATION_CAPTURE_POINT_BY_ZONE_ID = {
    ['joalheria'] = vector3( -628.67, -253.03, 38.55 ),
    ['banco_central'] = vector3( 249.16, 217.90, 106.28 ),
    ['hospital'] = vector3( 331.93, -581.34, 43.32 ),
    ['marrom'] = vector3( 340.34, -1686.79, 52.33 ),
    ['vanilla'] = vector3( 109.03, -1289.24, 28.86 ),
    ['mansoes'] = vector3( -1560.82, -48.87, 56.49 ),
    ['ballas'] = vector3( 89.35, -1868.85, 24.01 ),
    ['crips'] = vector3( 1302.74, -1722.74, 54.22 ),
    ['delegacia'] = vector3( 445.50, -983.50, 30.68 ),
    ['bloods'] = vector3( -1079.71, -1659.63, 4.39 ),
    ['veneza'] = vector3( -1023.78, -1090.58, 2.00 ),
    ['life_invader'] = vector3( -1081.86, -250.84, 37.76 ),
    ['estacionamento'] = vector3( -342.61, -805.77, 54.77 ),
    ['fleeca_praia'] = vector3( -2968.10, 482.80, 15.46 ),
    ['motel'] = vector3( 1552.63, 3595.73, 41.78 ),
    ['ferro_velho'] = vector3( 2353.04, 3133.83, 48.20 ),
    ['mineradora'] = vector3( 1036.67, 2299.90, 44.82 ),
    ['motoclube_norte'] = vector3( 27.39, 3699.31, 39.69 ),
    ['gas'] = vector3( 7.53, -660.74, 33.44 ),
    ['niobio'] = vector3( 3616.25, 3738.42, 28.67 ),
    ['acougue'] = vector3( 951.71, -2109.23, 30.54 ),
    ['galinheiro'] = vector3( -133.41, 6216.49, 31.20 ),
    ['madeireira'] = vector3( -544.54, 5262.75, 79.90 ),
    ['motoclube_sul'] = vector3( 968.97, -127.67, 74.37 ),
    ['container'] = vector3( 930.78, -3156.54, 5.89 ),
    ['aeroporto'] = vector3( -1015.45, -2597.95, 39.04 ),
    ['fazenda'] = vector3( 1446.07, 1068.73, 114.32 ),
    ['posto_abandonado'] = vector3( -1145.20, -1972.48, 13.15 ),
    ['ferro_velho_sul'] = vector3( -555.40, -1658.65, 19.19 ),
    ['prefeitura'] = vector3( 2549.22, -389.43, 92.99 ),
    ['industria'] = vector3( 2706.65, 1557.60, 24.51 ),
    ['yellow'] = vector3( 1996.89, 3061.82, 47.04 ),
    ['casa_abandonada'] = vector3( 2467.50, 4953.63, 45.14 ),
    ['castelinho'] = vector3( -53.78, 349.49, 112.43 ),
    ['ammu_praca'] = vector3( 18.47, -1111.20, 29.79 ),
    ['ammu_porto'] = vector3( 811.86, -2151.38, 29.62 ),
    ['banco_paleto'] = vector3( -110.89, 6462.75, 31.64 ),
    ['lester'] = vector3( 708.03, -978.82, 24.12 ),
    ['igreja_zancudo'] = vector3( -293.22, 2839.62, 55.43 ),
    ['obs'] = vector3( 686.36, 577.79, 130.45 ),
    ['mansao_ilha'] = vector3( 4974.96, -5701.33, 19.88 ),
    ['fabricadora'] = vector3( 5169.01, -5125.32, 2.67 ),
    ['mini_porto'] = vector3( 5107.65, -4618.84, 2.57 ),
    ['casa_do_ceo'] = vector3( 4821.31, -5019.18, 31.54 ),
    ['forte_zancudo_1'] = vector3( -2349.05, 3267.19, 32.80 ),
    ['forte_zancudo_2'] = vector3( -1869.35, 2956.02, 32.80 ),
    ['tequi_la_la'] = vector3( -559.61, 286.56, 82.17 ),
    ['observatorio'] = vector3( -429.07, 1110.88, 327.69 ),
    ['mansoes_2'] = vector3( -86.97, 834.36, 235.91 ),
    ['maze_bank_arena'] = vector3( -234.66, -2000.64, 24.68 ),
    ['pelados'] = vector3( -1111.99, 4936.17, 218.37 ),
    ['prisao'] = vector3( 1663.85, 2605.31, 45.56 ),
    ['labirinto'] = vector3( -2299.28, 196.47, 167.60 ),
    ['estacionamento_praia'] = vector3( -2019.63, -361.05, 48.10 ),
    ['aeroporto_paleto'] = vector3( -1848.00, 5180.14, 6.97 ),
    ['iate_paleto'] = vector3( -1434.09, 6757.17, 8.96 ),
    ['dp_vespucci'] = vector3( -1113.55, -849.32, 13.44 ),
    ['metro'] = vector3( -837.34, -108.95, 28.18 ),
    ['vagos'] = vector3( 366.25, -2031.31, 22.27 ),
    ['deposito_porto'] = vector3( -521.74, -2897.35, 5.99 ),
    ['los_santos'] = vector3( -343.78, -123.07, 39.00 ),
    ['festa_junina'] = vector3( 394.91, -328.02, 46.90 ),
    ['hotel'] = vector3( -1275.39, 313.37, 65.51 ),
    ['colorido'] = vector3( -1210.34, -674.57, 40.35 ),
    ['evento_chiliad'] = vector3( 489.67, 5590.26, 794.14 ),
}

---@param seed DominationCaptureZoneSeed
---@return DominationZoneDefinition zone
local function BuildCaptureZone( seed )
    local center = seed.center
    local capturePoint = seed.capturePoint or DOMINATION_CAPTURE_POINT_BY_ZONE_ID[ seed.id ]
    local captureHalfHeight = seed.captureHalfHeight or DOMINATION_CAPTURE_POINT_HALF_HEIGHT

    assert( capturePoint, ('Ponto central ausente para a zona %s'):format( seed.id ) )

    return {
        id = seed.id,
        label = seed.label,
        type = 'capture',
        state = 'neutral',
        color = DOMINATION_ZONE_STATE_COLORS.neutral,
        shape = 'circle',
        center = vector2( center.x, center.y ),
        radius = seed.radius,
        capturePoint = capturePoint,
        captureRadius = seed.captureRadius or DOMINATION_CAPTURE_POINT_RADIUS,
        captureMinZ = capturePoint.z - captureHalfHeight,
        captureMaxZ = capturePoint.z + captureHalfHeight,
        boundaryBottomZ = center.z - DOMINATION_BOUNDARY_DEPTH,
        boundaryTopZ = center.z + DOMINATION_BOUNDARY_HEIGHT,
    }
end

---@type DominationZoneDefinition[]
local DOMINATION_SAFE_ZONES = {
    {
        id = 'pier',
        label = 'PIER',
        type = 'safe',
        state = 'safe',
        color = { 38, 201, 151 },
        shape = 'circle',
        center = vector2( -1670.15, -947.52 ),
        radius = 54.92,
        spawn = vector4( -1670.15, -947.52, 7.68, 293.84 ),
        rankingBoards = {
            organizations = vector4( -1659.62, -954.37, 7.72, 347.10 ),
            players = vector4( -1662.59, -953.39, 7.71, 343.93 ),
        },
        image = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    {
        id = 'samir',
        label = 'SAMIR',
        type = 'safe',
        state = 'safe',
        color = { 38, 201, 151 },
        shape = 'circle',
        center = vector2( 1346.15, -569.39 ),
        radius = 72.82,
        boundaryHeight = 6.0,
        boundaryPoints = BuildCircularBoundaryPoints( 1346.15, -569.39, 72.82, {
            73.35, 73.42, 74.06, 74.51, 78.16, 74.78, 74.76, 75.12,
            74.16, 73.51, 74.84, 74.66, 73.96, 73.24, 72.23, 70.81,
            71.20, 71.84, 71.32, 70.98, 70.36, 70.35, 70.31, 70.25,
            69.93, 69.74, 69.40, 69.13, 68.04, 68.01, 67.92, 67.96,
            67.99, 68.01, 68.04, 68.06, 68.09, 68.13, 68.23, 68.45,
            68.62, 68.67, 68.76, 69.10, 69.86, 70.48, 71.08, 71.99,
            72.81, 73.29, 73.33, 73.34, 73.34, 73.34, 73.40, 73.40,
            73.34, 73.34, 73.39, 73.41, 73.34, 73.34, 73.34, 73.38,
        } ),
        spawn = vector4( 1381.40, -580.18, 74.37, 70.07 ),
        rankingBoards = {
            organizations = vector4( 1349.77, -589.64, 74.49, 308.19 ),
            players = vector4( 1347.21, -586.44, 74.49, 307.07 ),
        },
        image = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    -- Safe desativada temporariamente.
    --[[
    {
        id = 'norte',
        label = 'NORTE',
        type = 'safe',
        state = 'safe',
        color = { 38, 201, 151 },
        shape = 'circle',
        center = vector2( 1735.55, 3298.15 ),
        radius = 160.38,
        spawn = vector4( 1735.55, 3298.15, 41.22, 201.79 ),
        rankingBoards = {
            organizations = vector4( 1727.45, 3317.10, 41.22, 191.69 ),
            players = vector4( 1731.10, 3318.17, 41.22, 193.87 ),
        },
        image = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    ]]
    -- Safe desativada temporariamente.
    --[[
    {
        id = 'paleto',
        label = 'PALETO',
        type = 'safe',
        state = 'safe',
        color = { 38, 201, 151 },
        shape = 'circle',
        center = vector2( 1412.81, 6576.90 ),
        radius = 77.83,
        boundaryHeight = 6.0,
        boundaryPoints = BuildCircularBoundaryPoints( 1412.81, 6576.90, 77.83, {
            4.79, 5.17, 6.67, 8.58, 8.68, 7.83, 2.14, 0.27,
            -0.25, -0.65, -0.43, -0.48, -0.76, -0.96, -1.21, -1.46,
            -1.77, -2.35, -2.83, -3.18, -3.31, -2.69, -1.58, 0.74,
            -0.58, -0.25, 0.03, 2.51, 0.60, 0.29, 0.87, 1.55,
            2.55, 4.78, 10.79, 13.14, 14.01, 14.52, 18.17, 18.82,
            18.50, 18.53, 18.54, 18.55, 18.60, 18.65, 18.68, 18.71,
            18.72, 18.74, 18.81, 18.91, 18.99, 19.03, 19.19, 19.06,
            17.91, 16.11, 14.40, 12.75, 11.42, 10.03, 7.64, 6.01,
        } ),
        spawn = vector4( 1431.47, 6589.21, 12.95, 0.0 ),
        image = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    ]]
    -- Safe desativada temporariamente.
    --[[
    {
        id = 'ilha',
        label = 'ILHA',
        type = 'safe',
        state = 'safe',
        color = { 38, 201, 151 },
        shape = 'circle',
        center = vector2( 3935.33, -4702.85 ),
        radius = 134.02,
        boundaryHeight = 6.0,
        boundaryPoints = BuildCircularBoundaryPoints( 3935.33, -4702.85, 134.02, {
            1.91, 3.16, 3.19, 3.19, 3.18, 3.17, 2.80, 2.12,
            1.32, -0.37, -1.73, -3.19, -4.72, -5.89, -6.06, -5.99,
            -5.85, -5.67, -5.55, -5.60, -5.65, -5.59, -5.46, -5.06,
            -4.64, -4.00, -3.30, 0.85, 0.07, -2.50, -3.09, -2.99,
            -2.33, -2.18, -2.44, -2.30, -0.95, -1.64, -1.32, -1.29,
            -2.68, -3.09, -4.15, -4.98, -5.96, -5.84, -6.24, -5.78,
            -6.22, -7.29, -7.76, -7.91, -7.58, -6.81, -6.25, -6.80,
            -6.58, -6.35, -6.03, -5.02, -3.76, -2.82, -1.88, -1.07,
        } ),
        spawn = vector4( 3937.49, -4715.22, 4.14, 0.0 ),
        rankingBoards = {
            organizations = vector4( 3939.37, -4708.82, 4.19, 15.29 ),
            players = vector4( 3935.42, -4709.92, 4.19, 18.52 ),
        },
        image = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    ]]
    -- Safe desativada temporariamente.
    --[[
    {
        id = 'fazenda_norte',
        label = 'FAZENDA NORTE',
        type = 'safe',
        state = 'safe',
        color = { 38, 201, 151 },
        shape = 'circle',
        center = vector2( 2070.51, 5114.50 ),
        radius = 76.86,
        boundaryHeight = 6.0,
        boundaryPoints = BuildCircularBoundaryPoints( 2070.51, 5114.50, 76.86, {
            45.58, 46.23, 47.05, 48.21, 49.20, 50.13, 50.97, 51.65,
            52.20, 52.66, 53.07, 53.44, 53.64, 53.60, 53.61, 53.29,
            52.90, 52.24, 51.32, 50.63, 50.11, 49.52, 48.75, 47.94,
            47.13, 46.34, 45.51, 44.46, 44.45, 44.00, 43.22, 42.53,
            41.37, 41.82, 41.74, 41.63, 41.50, 41.35, 41.19, 41.03,
            40.85, 40.70, 40.61, 40.51, 40.42, 40.28, 40.19, 40.38,
            40.44, 40.40, 40.27, 39.97, 40.20, 40.60, 41.12, 41.64,
            42.02, 42.67, 43.24, 43.73, 44.05, 44.35, 44.96, 45.50,
        } ),
        spawn = vector4( 2077.64, 5117.62, 45.78, 0.0 ),
        image = 'https://cdn.santagroup.gg/hud/bgcardpvp.webp',
    },
    ]]
}

---@type DominationZoneDefinition[]
DOMINATION_ZONES = {}

for _, captureZoneSeed in ipairs( DOMINATION_CAPTURE_ZONE_SEEDS ) do
    DOMINATION_ZONES[ #DOMINATION_ZONES + 1 ] = BuildCaptureZone( captureZoneSeed )
end

for _, safeZone in ipairs( DOMINATION_SAFE_ZONES ) do
    local centerZ = safeZone.spawn.z

    safeZone.rankingBoardAnchor = safeZone.rankingBoardAnchor or safeZone.center
    safeZone.boundaryBottomZ = centerZ - DOMINATION_BOUNDARY_DEPTH
    safeZone.boundaryTopZ = centerZ + DOMINATION_BOUNDARY_HEIGHT
    DOMINATION_ZONES[ #DOMINATION_ZONES + 1 ] = safeZone
end
