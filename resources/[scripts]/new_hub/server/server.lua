local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRPC = Tunnel.getInterface('vRP')
vRP = Proxy.getInterface('vRP')

Server = {}
Tunnel.bindInterface('hub', Server)
vCLIENT = Tunnel.getInterface('hub')
cityName = GetConvar('cityName', 'Base')
News = {}

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS hub_news (
            id INT AUTO_INCREMENT PRIMARY KEY,
            title VARCHAR(100) NOT NULL,
            subtitle VARCHAR(200),
            previewImage VARCHAR(255),
            content LONGTEXT,
            author VARCHAR(100),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS battlepass (
            passport INT PRIMARY KEY,
            experience INT DEFAULT 0,
            level INT DEFAULT 1,
            hasPremium TINYINT DEFAULT 0,
            premium LONGTEXT,
            free LONGTEXT,
            completed TIMESTAMP NULL DEFAULT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

function Server.getNews()
    return vRP.Query('News/Get', {}) or {}
end

function Server.getProfile()
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return {} end
    local char = vRP.GetCharacter and vRP.GetCharacter(passport) or {}
    return {
        passport = passport,
        name = char.name or 'Cidadão',
        diamonds = vRP.GetDiamonds and vRP.GetDiamonds(passport) or 0
    }
end

exports('OpenGemsStore', function(context)
    return true
end)
