MinigameRankingManager = {}

function MinigameRankingManager.GetTop(mode, limit)
    return exports.oxmysql:executeSync('SELECT * FROM minigames_stats WHERE mode = ? ORDER BY wins DESC LIMIT ?', { mode, limit or 10 }) or {}
end
