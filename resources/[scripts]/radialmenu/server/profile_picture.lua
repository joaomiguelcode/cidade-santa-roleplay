-- radialmenu profile picture server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('radialmenu:profilePicture', server)

vRP.prepare('radialmenu/updateProfilePicture', 'UPDATE characters SET profile_picture = @url WHERE id = @passport')

function server._CloseProfilePicture(sessionId)
    -- clean up session
end

function server.SaveProfilePicture(sessionId, url, useDefault)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return { ok = false, error = 'unauthenticated' } end
    
    local finalUrl = useDefault and '' or (url or '')
    vRP.query('radialmenu/updateProfilePicture', { passport = passport, url = finalUrl })
    Player(source).state:set('profilePicture', finalUrl, true)
    
    TriggerClientEvent('Notify', source, 'sucesso', 'Foto de perfil atualizada com sucesso!')
    return { ok = true, url = finalUrl }
end
