-- enterprise server main
MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS enterprises (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            owner_passport INT NOT NULL,
            balance INT DEFAULT 0,
            level INT DEFAULT 1,
            members LONGTEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)
