-- farmer staffgang main server-side
MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS staffgang_farms (
        id INT AUTO_INCREMENT PRIMARY KEY,
        templateId VARCHAR(100) NOT NULL,
        title VARCHAR(100),
        shopTitle VARCHAR(100),
        description TEXT,
        allowedGroupsText TEXT,
        isAfk TINYINT(1) DEFAULT 0,
        disabled TINYINT(1) DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
]])

MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS staffgang_points (
        id INT AUTO_INCREMENT PRIMARY KEY,
        farmId INT NOT NULL,
        data LONGTEXT NOT NULL,
        disabled TINYINT(1) DEFAULT 0
    )
]])

MySQL.query.await([[
    CREATE TABLE IF NOT EXISTS staffgang_shops (
        id INT AUTO_INCREMENT PRIMARY KEY,
        farmId INT NOT NULL,
        data LONGTEXT NOT NULL,
        disabled TINYINT(1) DEFAULT 0
    )
]])
