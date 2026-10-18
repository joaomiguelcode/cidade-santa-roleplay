-- audio_scheduler main server-side
local Tunnel = module('vrp', 'lib/Utils')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

lib.callback.register('audio_scheduler:playNow', function(source, data)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return false, 'Sem permissão' end
    TriggerClientEvent('audio_scheduler:play', -1, data.url, data.volume or 0.5)
    return true
end)

RegisterCommand('audioscheduler', function(source, args)
    local passport = vRP.Passport(source)
    if vRP.hasPermission(passport, 'Admin') then
        TriggerClientEvent('audio_scheduler:open', source, AudioSchedulerConfig)
    end
end)
