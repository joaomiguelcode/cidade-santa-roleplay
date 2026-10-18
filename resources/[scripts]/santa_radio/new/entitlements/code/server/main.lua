-- Entitlements system main
MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS player_entitlements (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            feature VARCHAR(100) NOT NULL,
            granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY uk_pass_feat (passport, feature)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)
