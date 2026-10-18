-- tutorial ui server-side
local Tunnel = module('vrp', 'lib/Utils')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local completedUiTutorials = {}

lib.callback.register('net.tutorial.ui.can-start-tutorial', function(source, id)
    local passport = vRP.Passport(source)
    if not passport then return false end
    completedUiTutorials[passport] = completedUiTutorials[passport] or {}
    return not completedUiTutorials[passport][id]
end)

RegisterNetEvent('net.tutorial.ui.finish-tutorial', function(id)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    completedUiTutorials[passport] = completedUiTutorials[passport] or {}
    completedUiTutorials[passport][id] = true
end)
