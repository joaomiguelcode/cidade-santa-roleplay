-- worldstate commands server-side
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

RegisterCommand('clima', function(source, args)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return end
    if args[1] then
        SetWorldWeather(args[1])
        TriggerClientEvent('Notify', source, 'sucesso', 'Clima alterado para ' .. string.upper(args[1]))
    end
end)

RegisterCommand('tempo', function(source, args)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return end
    local h = parseInt(args[1] or 12)
    local m = parseInt(args[2] or 0)
    SetWorldTime(h, m)
    TriggerClientEvent('Notify', source, 'sucesso', ('Horário alterado para %02d:%02d'):format(h, m))
end)
