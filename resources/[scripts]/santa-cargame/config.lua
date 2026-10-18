Config = {}

-- Cidades brasileiras e Malta. Nas outras o server para o resource.
Config.EnabledCities = {
    santa = true,
    grande = true,
    cidadenobre = true,
    maresia = true,
    fronteira = true,
    malta = true,
}

Config.Enabled = Config.EnabledCities[string.lower(GetConvar("cityName", ""))] == true

-- Liga o trace do evento no server e no client. Desligar depois de comparar local x QA.
Config.Debug = false

Config.Fee = 0
Config.EventBucketMin = 9000
Config.EventBucketMax = 9999
Config.DefaultWorldBucket = 1

-- Tempo em que o convite fica aberto.
Config.NotifyDuration = 180
Config.MinPlayers = 1
Config.MaxPlayersPerLobby = 30

-- Contagem antes do primeiro round.
Config.StartCountdownSecs = 5
-- Pausa entre dois rounds.
Config.InterRoundCountdownSecs = 5
-- Duracao total de cada round.
Config.RoundDurationSecs = 60
-- Tempo aleatorio para chegar a uma cor segura antes do piso cair.
Config.TargetColorCountdownSecs = { Min = 5, Max = 5 }
-- Tempo aleatorio em que os blocos removidos continuam fora do grid.
Config.CollapseWindowSecs = { Min = 5, Max = 5 }
-- No modo normal, quantidade de cores seguras mostradas em cada ciclo.
Config.NormalSafeColorsPerCycle = { Min = 1, Max = 2 }
-- Na morte subita, quantidade de cores removidas permanentemente por ciclo.
Config.SuddenDeathColorsRemovedPerCycle = 2
Config.TotalRounds = 10
Config.SuddenDeathRound = 10
-- Tempo de exibicao da classificacao final.
Config.FinalStandingsSecs = 12
Config.GhostAlpha = 150
-- Distancia abaixo do grid para registrar a queda e cancelar os pontos do ciclo.
Config.FallDetectionOffsetZ = 2.0
-- Distancia abaixo do grid para reposicionar o jogador e o veiculo.
Config.FallRespawnOffsetZ = 12.0
-- Limite para o client montar e confirmar o grid, incluindo as ultimas pecas.
-- Na partida vale por jogador: o rebuild nao espera ack e so quem estourar sai.
Config.GridReadyTimeoutSecs = 25
-- Tolerancia adicional somente na entrada inicial do jogador.
Config.EntryReadyGraceSecs = 5
-- Limite para o veiculo networkado aparecer no client.
Config.VehicleReadyTimeoutSecs = 15
Config.VehicleSpawnAttempts = 3
-- Duracao do fade de entrada e saida.
Config.EntryFadeMs = 300
-- Intervalo do monitor server-side de quedas e veiculos.
Config.MonitorIntervalMs = 250

Config.Grid = {
    Rows = 15,
    Columns = 15,
    Center = vector4(-3087.97, -1834.31, 485.18, 105.00),
    TileSizeX = 7.6799984,
    TileSizeY = 5.535583,
    PoolPerColor = 25,
    SpawnEdgeMargin = 2,
    ApplyBatchSize = 50,
    HiddenZOffset = 200.0,
}

Config.Colors = {
    [1] = { model = "eventobloco_01", name = "AMARELO", hex = "#f6d84a" },
    [2] = { model = "eventobloco_02", name = "AZUL", hex = "#3285f5" },
    [3] = { model = "eventobloco_03", name = "ROXO", hex = "#8b4fd9" },
    [4] = { model = "eventobloco_04", name = "MARROM", hex = "#7a4a2e" },
    [5] = { model = "eventobloco_05", name = "LARANJA", hex = "#f28a2e" },
    [6] = { model = "eventobloco_06", name = "PRETO", hex = "#17191d" },
    [7] = { model = "eventobloco_07", name = "ROSA", hex = "#ee70b7" },
    [8] = { model = "eventobloco_08", name = "VERDE", hex = "#51c96b" },
    [9] = { model = "eventobloco_09", name = "VERMELHO", hex = "#e84949" },
}

Config.VehicleModel = "pantocolor"
Config.VehicleType = "automobile"
Config.VehicleSpawnZOffset = 1.25
Config.Vehicle = {
    Invincible = true,
    CanBurstTyres = false,
    LockDoors = true,
}

Config.SoloTest = {
    Enabled = true,
}

Config.Rewards = {
    Places = {
        [1] = { vipItem = "vipevento2" },
        [2] = { money = 5000000 },
        [3] = { money = 1000000 },
    },
}

Config.EventHudExitKey = "G"
-- Tempo ate o tutorial desaparecer sozinho.
Config.TutorialAutoHideSecs = 15
Config.ChangeOutfitOnJoin = false
-- Hora (0-23) travada via `worldstate` do lobby ate sair do evento, pra ficar escuro
-- e a HUD ficar mais legivel. nil desliga o travamento.
Config.NightLockHour = 0
-- Sons da contagem central (inicio, troca de round, morte subita), tocados pelo `hud`.
-- `TickUrl` toca a cada numero; `EndUrl` toca uma vez quando a contagem chega ao fim.
Config.CountdownSound = {
    TickUrl = "https://cdn.santagroup.gg/1stick.mp3",
    EndUrl = "https://cdn.santagroup.gg/start_sound.mp3",
    Volume = 0.8,
}

-- Nome do personagem (nao Steam) acima do carro, so durante o evento.
Config.Nametag = {
    OffsetZ = 1.52,
    MaxDistance = 90.0,
    Scale = 0.40,
}

Config.AutoScheduleTimes = {
    "18:00",
    "21:00",
}

Config.Ranking = {
    Points = {
        -- Sequencia: 10, 10, 10, 12, 14, 16... Ate o jogador cair.
        basePerCycle = 10,
        increaseAfterCycles = 3,
        increasePerCycle = 2,
        -- Enquanto estiver como fantasma, recebe metade dos pontos do ciclo.
        ghostMultiplier = 0.5,
        suddenDeathWinnerBonus = 50,
    },
}

Config.Announce = {
    Title = nil,
    Sender = nil,
    KeyPrompt = "F3",
    BgColor = "#6442BE",
}
