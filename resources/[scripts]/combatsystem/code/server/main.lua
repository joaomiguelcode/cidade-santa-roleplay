-- combatsystem server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local combatState = {}

local function SetPlayerCombat(source, reason, durationMs, isInfinite)
    local passport = vRP.Passport(source)
    if not passport then return end
    
    durationMs = durationMs or 15000
    local expireAt = GetGameTimer() + durationMs
    
    local data = {
        reason = reason or 'combat',
        expireAt = expireAt,
        isInfinite = isInfinite or false
    }
    
    combatState[source] = data
    Player(source).state:set('inCombat', true, true)
    TriggerClientEvent('net.combatsystem.updateCombat', source, data)
end

local function RemovePlayerCombat(source, reason)
    combatState[source] = nil
    Player(source).state:set('inCombat', false, true)
    TriggerClientEvent('net.combatsystem.updateCombat', source, nil)
end

RegisterNetEvent('net.combatsystem.setInCombat', function(reason)
    local source = source
    SetPlayerCombat(source, reason, 15000, false)
end)

RegisterNetEvent('net.combatsystem.removeCombat', function(reason, options)
    local source = source
    RemovePlayerCombat(source, reason)
end)

RegisterNetEvent('net.combatsystem.combatExpired', function()
    local source = source
    RemovePlayerCombat(source, 'expired')
end)

AddEventHandler('playerDropped', function()
    local source = source
    combatState[source] = nil
end)

exports('SetInCombat', SetPlayerCombat)
exports('RemoveCombat', RemovePlayerCombat)
exports('IsInCombat', function(source)
    return combatState[source] ~= nil
end)
