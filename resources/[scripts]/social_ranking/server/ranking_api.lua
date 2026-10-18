RankingAPI = {}

function RankingAPI.GetXP(passport)
    local rows = exports.oxmysql:executeSync('SELECT * FROM social_ranking_xp WHERE passport = ?', { passport })
    return rows and rows[1] or { passport = passport, xp = 0, xp_week = 0, level = 1, effects_enabled = 1 }
end

function RankingAPI.AddXP(passport, amount, reason)
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    exports.oxmysql:executeSync([[
        INSERT INTO social_ranking_xp (passport, xp, xp_week, level)
        VALUES (?, ?, ?, 1)
        ON DUPLICATE KEY UPDATE xp = xp + VALUES(xp), xp_week = xp_week + VALUES(xp_week)
    ]], { passport, amount, amount })
    local current = RankingAPI.GetXP(passport)
    RankingEmit.XPChanged(passport, current.xp, amount)
end

function RankingAPI.GetTopPlayers(limit)
    limit = limit or 10
    local rows = exports.oxmysql:executeSync([[
        SELECT s.*, c.name, c.name2 FROM social_ranking_xp s
        LEFT JOIN characters c ON c.id = s.passport
        ORDER BY s.xp_week DESC LIMIT ?
    ]], { limit })
    return rows or {}
end
