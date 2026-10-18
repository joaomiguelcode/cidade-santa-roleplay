-- pededitor main server-side
local Tunnel = module('vrp', 'lib/Utils')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

lib.callback.register('pededitor:getSkins', function(source)
    local passport = vRP.Passport(source)
    if not passport then return {} end
    return MySQL.query.await('SELECT * FROM player_ped_skins WHERE passport = @passport', { passport = passport })
end)

lib.callback.register('pededitor:applySkin', function(source, model)
    local passport = vRP.Passport(source)
    if not passport then return false end
    
    vRP.skinPed(source, model)
    return true
end)

lib.callback.register('pededitor:toggleFavorite', function(source, skinId)
    local passport = vRP.Passport(source)
    if not passport then return false end
    MySQL.update.await('UPDATE player_ped_skins SET is_favorite = NOT is_favorite WHERE id = @id AND passport = @passport', {
        id = skinId,
        passport = passport
    })
    return true
end)

RegisterCommand('ped', function(source, args)
    TriggerClientEvent('pededitor:open', source)
end)
