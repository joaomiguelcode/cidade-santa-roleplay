local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

CreateThread(function()
    Wait(5000)
    RankingPodium.Update()
    print('[social_ranking] Podium loaded.')
    while true do
        Wait(300000) -- every 5 minutes
        RankingPodium.Update()
    end
end)
