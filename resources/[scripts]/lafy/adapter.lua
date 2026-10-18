-- lafy adapter server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('lafy', server)

RegisterCommand('som', function(source, args)
    local passport = vRP.Passport(source)
    if not passport then return end
    
    if args[1] == 'off' then
        TriggerClientEvent('lafy:toggleMute', source, true)
        TriggerClientEvent('Notify', source, 'importante', 'Som mutado.')
    elseif args[1] == 'on' then
        TriggerClientEvent('lafy:toggleMute', source, false)
        TriggerClientEvent('Notify', source, 'sucesso', 'Som desmutado.')
    elseif tonumber(args[1]) then
        local vol = math.max(0, math.min(100, tonumber(args[1])))
        TriggerClientEvent('lafy:setMasterVolume', source, vol / 100)
        TriggerClientEvent('Notify', source, 'sucesso', ('Volume definido para %d%%'):format(vol))
    else
        TriggerClientEvent('lafy:openUI', source)
    end
end)

exports('hasPermission', function(source)
    local passport = vRP.Passport(source)
    return passport ~= nil
end)
