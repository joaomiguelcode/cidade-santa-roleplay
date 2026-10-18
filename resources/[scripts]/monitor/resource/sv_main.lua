-- txAdmin sv_main.lua
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

TX_ADMINS = TX_ADMINS or {}

RegisterNetEvent('txsv:ackWarning', function(actionId)
    local src = source
    print(('[txAdmin] Player %s acked warning %s'):format(src, tostring(actionId)))
end)

RegisterNetEvent('txsv:startedWalking', function()
    local src = source
end)
