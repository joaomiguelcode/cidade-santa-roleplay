-- pvp app server main
MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS minigames_stats (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            mode VARCHAR(50) NOT NULL,
            wins INT DEFAULT 0,
            losses INT DEFAULT 0,
            kills INT DEFAULT 0,
            deaths INT DEFAULT 0,
            UNIQUE KEY uk_pass_mode (passport, mode)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

exports('IsMatchCityEnabled', function()
    return true
end)
