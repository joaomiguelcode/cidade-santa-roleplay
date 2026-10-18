MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS social_ranking_xp (
            passport INT PRIMARY KEY,
            xp INT DEFAULT 0,
            xp_week INT DEFAULT 0,
            level INT DEFAULT 1,
            effects_enabled TINYINT DEFAULT 1,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS social_ranking_orgs (
            org_name VARCHAR(100) PRIMARY KEY,
            xp INT DEFAULT 0,
            xp_week INT DEFAULT 0,
            level INT DEFAULT 1,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)
