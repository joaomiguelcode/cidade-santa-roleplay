-- penthouse queries
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS penthouses (
            id INT AUTO_INCREMENT PRIMARY KEY,
            property_id VARCHAR(50) NOT NULL,
            building_id VARCHAR(50) NOT NULL,
            location_id VARCHAR(50) NOT NULL,
            owner_passport INT NOT NULL,
            house_name VARCHAR(100) DEFAULT 'Penthouse',
            tier INT DEFAULT 1,
            wallpapers LONGTEXT,
            settings LONGTEXT,
            monthly_price INT DEFAULT 50000,
            expires_at BIGINT DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY uk_prop (property_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS penthouse_visitors (
            id INT AUTO_INCREMENT PRIMARY KEY,
            property_id VARCHAR(50) NOT NULL,
            visitor_passport INT NOT NULL,
            access_level INT DEFAULT 1,
            is_banned TINYINT DEFAULT 0,
            UNIQUE KEY uk_vis (property_id, visitor_passport)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)
