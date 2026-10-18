-- smartphone server-side implementation
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPC = Tunnel.getInterface('vRP')

CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS smartphone_contacts (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            name VARCHAR(100) NOT NULL,
            number VARCHAR(50) NOT NULL,
            INDEX idx_passport (passport)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS smartphone_messages (
            id INT AUTO_INCREMENT PRIMARY KEY,
            sender VARCHAR(50) NOT NULL,
            target VARCHAR(50) NOT NULL,
            message TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

local ActiveCalls = {}

RegisterNetEvent('smartphone:startCall', function(targetNumber)
    local src = source
    local passport = vRP.Passport and vRP.Passport(src) or vRP.getUserId(src)
    if not passport then return end
    
    local callerPhone = GetPlayerPhone(passport)
    -- Find player with targetNumber
    local rows = exports.oxmysql:executeSync('SELECT id FROM characters WHERE phone = ?', { targetNumber })
    if rows and rows[1] then
        local targetPassport = rows[1].id
        local targetSrc = vRP.Source and vRP.Source(targetPassport) or vRP.getUserSource(targetPassport)
        if targetSrc then
            ActiveCalls[src] = targetSrc
            ActiveCalls[targetSrc] = src
            TriggerClientEvent('smartphone:incomingCall', targetSrc, callerPhone)
            return
        end
    end
    TriggerClientEvent('Notify', src, 'negado', 'Número indisponível.', 5000)
end)

RegisterNetEvent('smartphone:acceptCall', function()
    local src = source
    local other = ActiveCalls[src]
    if other then
        local channel = 1000 + src
        pcall(function()
            exports['pma-voice']:setCallChannel(src, channel)
            exports['pma-voice']:setCallChannel(other, channel)
        end)
        TriggerClientEvent('smartphone:callAccepted', src)
        TriggerClientEvent('smartphone:callAccepted', other)
    end
end)

RegisterNetEvent('smartphone:endCall', function()
    local src = source
    local other = ActiveCalls[src]
    if other then
        pcall(function()
            exports['pma-voice']:setCallChannel(src, 0)
            exports['pma-voice']:setCallChannel(other, 0)
        end)
        ActiveCalls[other] = nil
        TriggerClientEvent('smartphone:callEnded', other)
    end
    ActiveCalls[src] = nil
    TriggerClientEvent('smartphone:callEnded', src)
end)

RegisterNetEvent('dminigames:neighbor:openFromApp', function(affiliateBusy)
    local src = source
    if GetResourceState('dminigames') == 'started' then
        TriggerClientEvent('dminigames:neighbor:openApp', src, affiliateBusy)
    end
end)
