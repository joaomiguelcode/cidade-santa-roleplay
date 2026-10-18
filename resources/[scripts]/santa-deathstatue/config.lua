Config = {}

Config.Debug = false

Config.Fee = 0
Config.EventBucketMin = 9000
Config.EventBucketMax = 9999

Config.NotifyDuration = 180
Config.StartCountdownSecs = 5
Config.MinPlayers = 1
Config.EventHudExitKey = "G"
Config.EventHudSoundKey = "H"
Config.TutorialAutoHideSecs = 15

Config.Rounds = {
    [1] = {
        durationSecs = 150,
        defaultPoints = 25,
        pointsByPlace = { [1] = 100, [2] = 75, [3] = 50 },
    },
    [2] = {
        durationSecs = 150,
        defaultPoints = 25,
        pointsByPlace = { [1] = 100, [2] = 75, [3] = 50 },
    },
    [3] = {
        durationSecs = 150,
        defaultPoints = 25,
        pointsByPlace = { [1] = 100, [2] = 75, [3] = 50 },
    },
    [4] = {
        durationSecs = 150,
        defaultPoints = 25,
        pointsByPlace = { [1] = 100, [2] = 75, [3] = 50 },
    },
    [5] = {
        durationSecs = 150,
        defaultPoints = 25,
        pointsByPlace = { [1] = 100, [2] = 75, [3] = 50 },
    },
}
Config.MaxPlayersPerLobby = 40
Config.DefaultWorldBucket = 1

Config.DetectCameraOnRedLight = false
Config.LightSoundVolume = 1.0
Config.LightSoundPadMs = 200
Config.LightSoundDurationMs = {
    green = 1320,
    red = 864,
}
Config.GreenLightRandomTime = { Min = 1520, Max = 4000 }
Config.DollyWatchingRandomTime = { Min = 1064, Max = 4000 }

Config.Rewards = {
    -- FinishCrossingSocialXp = 80,
    Places = {
        -- socialXp comentado: cidade sem sistema Gente Boa.
        [1] = { --[[ socialXp = 1000, ]] money = 0, vipItem = "vipevento2" },
        [2] = { --[[ socialXp = 750, ]] money = 5000000 },
        [3] = { --[[ socialXp = 500, ]] money = 1000000 },
    },
}

Config.JoinSettleMs = 3000

Config.RedLightGraceMs = 800
Config.CaughtRagdollMs = 1500
Config.CaughtShotVolume = 1.0
Config.CaughtShotRagdollDelayMs = 90
Config.CaughtSniper = {
    Enabled = true,
    Model = "s_m_y_blackops_01",
    Coords = {
        vector4(-266.20, -3262.83, 301.14, 180.89),
        vector4(-265.97, -3311.91, 301.14, 4.75),
        vector4(-310.38, -3311.48, 301.14, 9.98),
        vector4(-310.60, -3262.59, 301.14, 183.60),
    },
    Scale = 2.0,
    ScaleZOffset = 0.92,
    Weapon = "WEAPON_HEAVYSNIPER",
    AimMs = 380,
    LaserAfterShotMs = 550,
    PrimeDelayMs = 400,
    PrimeMs = 260,
    LaserColor = { r = 255, g = 32, b = 32, a = 220 },
}
Config.FinishScoreDelayMs = 150
Config.MovementDetectDist = 0.45
Config.CameraInputThreshold = 0.02
Config.CameraDetectDelta = 1.5

Config.StartPoint = vector3(-228.45, -3287.14, 290.01)

Config.EntryPoint = vector4(-228.45, -3287.14, 290.01, 88.64)

Config.WaitingArea = vector4(-223.95, -3284.01, 301.19, 90.55)

Config.WaitingSideWarps = {
    CooldownSecs = 15,
    InteractDist = 1.8,
    DrawDist = 20.0,
    Blip = {
        sprite = 36,
        color = 3,
        scale = 0.75,
    },
    Marker = {
        type = 1,
        scale = vector3(1.0, 1.0, 0.45),
        color = { r = 255, g = 255, b = 255, a = 140 },
        bobUpAndDown = false,
        faceCamera = false,
        rotate = true,
    },
    Points = {
        {
            coords = vector4(-224.05, -3306.71, 301.19, 14.20),
            destination = vector4(-372.08, -3306.95, 301.19, 49.27),
        },
        {
            coords = vector4(-223.88, -3267.30, 301.19, 182.58),
            destination = vector4(-372.10, -3267.27, 301.19, 180.20),
        },
        {
            coords = vector4(-372.08, -3306.95, 301.19, 49.27),
            destination = vector4(-224.05, -3306.71, 301.19, 14.20),
        },
        {
            coords = vector4(-372.10, -3267.27, 301.19, 180.20),
            destination = vector4(-223.88, -3267.30, 301.19, 182.58),
        },
    },
}

Config.LobbyBarrier = {
    x = -237.72,
    yMin = -3312.60,
    yMax = -3261.66,
    z = 290.01,
    heights = { 0.0, 1.2, 2.4, 3.6 },
}

Config.GameZone = {
    vector2(-237.73, -3261.66),
    vector2(-360.00, -3261.66),
    vector2(-360.00, -3312.63),
    vector2(-237.71, -3312.60),
}

Config.FinishZone = {
    vector2(-354.38, -3261.66),
    vector2(-354.38, -3312.63),
    vector2(-356.38, -3312.63),
    vector2(-356.38, -3261.66),
}

Config.LobbySpawns = {
    vector4(-228.45, -3287.14, 290.01, 88.64),
    vector4(-236.02, -3303.65, 290.01, 91.87),
    vector4(-235.47, -3270.46, 290.01, 95.87),
    vector4(-235.36, -3277.73, 290.01, 91.48),
    vector4(-235.34, -3295.91, 290.01, 91.46),
}

Config.FieldStart = {
    vector4(-237.72, -3287.14, 290.01, 270.0),
}

Config.SpawnCoords = {
    GameFinished = {
        vector4(-228.45, -3287.14, 290.01, 88.64),
    },
}

Config.ChangeOutfitOnJoin = false

Config.PlayerOutfits = {
    ["male"] = {
        { [1]={38,0}, [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={75,0} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={75,1} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={75,2} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={75,3} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={74,0} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={74,1} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={74,2} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={74,3} },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={0,0}  },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={0,1}  },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={0,2}  },
        { [1]={0,0},  [3]={0,0}, [4]={5,0}, [5]={0,0}, [6]={43,0}, [7]={0,0}, [8]={0,0}, [9]={0,0}, [10]={0,0}, [11]={0,3}  },
    },
    ["female"] = {
        { [1]={0,0}, [3]={0,0}, [4]={66,0}, [5]={0,0}, [6]={80,0}, [7]={0,0}, [8]={2,0}, [9]={0,0}, [10]={0,0}, [11]={147,0} },
    },
}

Config.Dolly = {
    Model = "u_m_y_juggernaut_01",
    Coords = vector4(-359.62, -3286.45, 290.01, 268.87),
    WatchingHeading = 268.87,
    NotWatchingHeading = 90.0,
    Scale = 5.0,
    ScaleZOffset = 3.7,
}

Config.AutoScheduleTimes = {
    "18:00",
    "21:00",
}

Config.Ranking = {
    PageSize = 10,
}

Config.RankingNpc = {
    Enabled = false,
    Model = "u_m_y_juggernaut_01",
    Coords = vector4(161.90, -995.84, 29.55, 163.82),
    InteractDistance = 2.0,
    RenderDistance = 10.0,
}

Config.Announce = {
    Title = nil, -- usa _t("eventTitle")
    Sender = nil, -- usa _t("eventPrefix")
    KeyPrompt = "F3",
    BgColor = "rgb(96, 130, 203)",
}
