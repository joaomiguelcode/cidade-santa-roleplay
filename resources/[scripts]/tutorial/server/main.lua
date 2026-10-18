-- tutorial main server-side
local Tunnel = module('vrp', 'lib/Utils')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

vRP.prepare('tutorial/setCompleted', 'UPDATE characters SET tutorial = 1 WHERE id = @passport')

RegisterNetEvent('spawn:acceptTutorial', function()
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    Player(source).state:set('inTutorial', true, true)
end)

RegisterNetEvent('spawn:refuseTutorial', function()
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    Player(source).state:set('inTutorial', false, true)
    vRP.query('tutorial/setCompleted', { passport = passport })
end)

RegisterNetEvent('spawn:finishTutorial', function()
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    Player(source).state:set('inTutorial', false, true)
    vRP.query('tutorial/setCompleted', { passport = passport })
    
    -- Welcome reward
    vRP.giveBank(passport, 5000)
    TriggerClientEvent('Notify', source, 'sucesso', 'Parabéns por concluir o tutorial! Você recebeu $5.000 de incentivo inicial.')
end)
