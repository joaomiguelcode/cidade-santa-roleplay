-- cinematiccammaster server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

RegisterCommand(Cfg and Cfg.command or 'cam', function(source, args, rawCommand)
    local passport = vRP.Passport(source)
    if not passport then return end
    
    if not Cfg.usePermissions or vRP.hasPermission(passport, 'Admin') or vRP.hasPermission(passport, 'Staff') or vRP.hasPermission(passport, 'Moderator') then
        TriggerClientEvent('CinematicCam:OpenCam', source, true)
    else
        TriggerClientEvent('Notify', source, 'negado', 'Você não tem permissão para usar a câmera cinematográfica.')
    end
end)
