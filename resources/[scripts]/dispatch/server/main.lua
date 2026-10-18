-- dispatch server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local alertsEnabled = {}

RegisterNetEvent('dispatch:toggleAlerts', function(enabled)
    local source = source
    alertsEnabled[source] = enabled
end)

RegisterNetEvent('dispatch:send', function(data)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    data.passport = passport
    data.time = os.date('%H:%M:%S')
    
    local players = vRP.Players()
    for pSource, pPassport in pairs(players) do
        if alertsEnabled[pSource] ~= false then
            if vRP.hasPermission(pPassport, 'Police') or vRP.hasPermission(pPassport, 'Policia') or vRP.hasPermission(pPassport, 'Paramedic') or vRP.hasPermission(pPassport, 'Admin') then
                TriggerClientEvent('dispatch:onReportReceived', pSource, data)
            end
        end
    end
end)

exports('sendDispatch', function(data)
    local players = vRP.Players()
    for pSource, pPassport in pairs(players) do
        if alertsEnabled[pSource] ~= false then
            if vRP.hasPermission(pPassport, 'Police') or vRP.hasPermission(pPassport, 'Policia') or vRP.hasPermission(pPassport, 'Admin') then
                TriggerClientEvent('dispatch:onReportReceived', pSource, data)
            end
        end
    end
end)
