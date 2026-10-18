-- missions core server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('missions', server)

RegisterCommand('missoes', function(source, args)
    local passport = vRP.Passport(source)
    if not passport then return end
    
    local data = {
        missions = vRP.query('missions/getUserMissions', { passport = passport }),
        skills = vRP.query('missions/getUserSkills', { passport = passport })
    }
    
    TriggerClientEvent('missions:openPanel', source, data)
end)
