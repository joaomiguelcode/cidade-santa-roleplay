-- Constantes para todos os minigames com prefixo "minigame_routes__"

---@type number
MINIGAME_ROUTES__DISTANCE = 10.0

---@type number
MINIGAME_ROUTES__DURATION = 0

---@type eMinigameDefFlags
MINIGAME_ROUTES__FLAGS =
        eMinigameDefFlags.MDF_NONE
        -- Esse minigame é iniciado pelos npcs do script "talknpc"
    |   eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT
        -- Esse minigame move os participants para um routing bucket privado ( 7 )
    |   eMinigameDefFlags.MDF__ON_CREATE__SWITCH_TO_PRIVATE_ROUTING_BUCKET
        -- Esse minigame, ao completar, cria outro minigame com o próximo ponto disponível
    |   eMinigameDefFlags.MDF__ON_COMPLETE__GOTO_NEXT_MINIGAME_POINT

---@type vector3
MINIGAME_ROUTES__POINTS__NORTH =
{
    vector3(1510.3, 829.63, 76.5),
    vector3(1804.36, 1932.84, 77.88),
    vector3(2279.32, 3006.98, 45.49),
    vector3(1701.55, 3506.56, 35.99),
    vector3(1267.86, 3538.34, 34.76),
    vector3(1288.83, 3641.39, 32.79),
    vector3(1554.26, 3740.1, 34.49),
    vector3(1693.67, 3824.67, 34.54),
    vector3(2092.91, 3735.54, 32.54),
    vector3(2804.15, 4442.08, 47.95),
    vector3(2577.83, 5100.81, 44.3),
    vector3(2280.93, 5025.75, 43.08),
    vector3(2009.62, 5085.32, 41.94),
    vector3(1665.64, 4865.5, 41.59),
    vector3(1977.9, 4607.12, 40.29),
    vector3(2483.64, 4469.41, 34.68),
    vector3(2530.73, 4163.91, 38.84),
    vector3(2864.73, 4146.39, 49.81),
    vector3(2837.83, 3556.71, 53.25),
    vector3(2571.0, 2624.79, 36.8),
    vector3(2536.25, 1986.43, 19.65),
    vector3(2464.16, 1291.17, 49.71),
    vector3(2527.96, 279.99, 107.75),
    vector3(2188.3, -512.0, 92.76),
    vector3(1745.2, -862.58, 70.58),
    vector3(1291.02, -1109.78, 50.67),
    vector3(813.42, -639.54, 40.37),
    vector3(689.19, -185.93, 46.19),
    vector3(1226.97, 508.8, 80.85),
}

---@type vector3
MINIGAME_ROUTES__POINTS__SOUTH =
{
    vector3(867.6, -219.17, 70.26),
    vector3(671.39, -36.69, 81.91),
    vector3(704.99, 203.11, 89.91),
    vector3(-2.24, 175.38, 98.54),
    vector3(-122.75, -80.83, 56.16),
    vector3(-1236.13, -299.93, 37.54),
    vector3(-1315.05, -503.85, 33.11),
    vector3(-1144.95, -810.38, 15.33),
    vector3(-1245.89, -1088.1, 8.14),
    vector3(-860.08, -1177.51, 5.32),
    vector3(-425.34, -1124.29, 29.42),
    vector3(-222.64, -1459.78, 31.24),
    vector3(-52.18, -1600.44, 29.23),
    vector3(136.13, -1758.15, 28.96),
    vector3(380.37, -1957.59, 24.5),
    vector3(723.46, -2071.17, 29.25),
    vector3(737.28, -2338.9, 25.02),
    vector3(1042.54, -2362.93, 30.45),
    vector3(1200.91, -2076.21, 43.73),
    vector3(1367.5, -1639.46, 53.16),
    vector3(1247.24, -1348.9, 35.28),
    vector3(1170.18, -1008.25, 44.84),
    vector3(1149.91, -756.42, 57.78),
    vector3(1022.02, -724.04, 57.61),
    vector3(949.94, -579.98, 58.23),
    vector3(1194.52, -476.21, 65.97),
    vector3(1091.58, -225.94, 69.29),
    vector3(987.96, -243.53, 68.61),
}