-- Collectibles Migration 001
MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS player_collectibles (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            item_name VARCHAR(100) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)
