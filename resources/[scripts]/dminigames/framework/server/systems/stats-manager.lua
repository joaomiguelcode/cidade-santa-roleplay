MinigameStatsManager = {}

function MinigameStatsManager.AddWin(passport, mode)
    exports.oxmysql:executeSync([[
        INSERT INTO minigames_stats (passport, mode, wins, losses, kills, deaths)
        VALUES (?, ?, 1, 0, 0, 0)
        ON DUPLICATE KEY UPDATE wins = wins + 1
    ]], { passport, mode })
end
