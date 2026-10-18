local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPC = Tunnel.getInterface('vRP')

DashboardServer = {}
Tunnel.bindInterface('dashboard', DashboardServer)

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS dashboard_tickets (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            subject VARCHAR(100),
            message TEXT,
            status VARCHAR(20) DEFAULT 'open',
            staff_passport INT DEFAULT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS dashboard_bans (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            staff_passport INT NOT NULL,
            reason TEXT NOT NULL,
            expires_at BIGINT DEFAULT 0,
            disputed TINYINT DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

function DashboardServer.getOverview()
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return {} end
    local char = vRP.GetCharacter and vRP.GetCharacter(passport) or {}
    return {
        passport = passport,
        name = (char.name or 'Cidadão') .. ' ' .. (char.name2 or ''),
        bank = vRP.GetBank and vRP.GetBank(passport) or 0,
        wallet = vRP.InventoryItemAmount and vRP.InventoryItemAmount(passport, 'dollars') or 0,
        diamonds = vRP.GetDiamonds and vRP.GetDiamonds(passport) or 0,
        onlinePlayers = #GetPlayers()
    }
end
