-- likizao_ac server-side
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

RegisterNetEvent('likizao_ac:detection', function(reason)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    print(('^1[LIKIZAO_AC] Detecção: Jogador %d (%s) motivo: %s^0'):format(source, passport, reason))
    vRP.setBanned(passport, true)
    DropPlayer(source, '[LIKIZAO_AC] Atividade suspeita detectada. Banido.')
end)
