-- pededitor migration
MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS player_ped_skins (
        id INT AUTO_INCREMENT PRIMARY KEY,
        passport INT NOT NULL,
        model VARCHAR(100) NOT NULL,
        name VARCHAR(100),
        category VARCHAR(50) DEFAULT 'default',
        is_favorite TINYINT(1) DEFAULT 0,
        is_active TINYINT(1) DEFAULT 0,
        expires_at TIMESTAMP NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_passport (passport)
    )
]])
