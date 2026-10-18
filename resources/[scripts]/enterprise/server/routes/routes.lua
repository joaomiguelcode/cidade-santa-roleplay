-- enterprise callbacks & routes
lib.callback.register('enterprise/sleepless/interaction', function(source, action, enterpriseId)
    local passport = vRP.Passport(source)
    if not passport then return false end
    return {
        enterpriseId = enterpriseId,
        isOwner = true,
        members = {},
        balance = 50000
    }
end)

lib.callback.register('enterprise/sleepless/get-farm-points', function(source, enterpriseId)
    return {}
end)

RegisterNetEvent('enterprise/workflow_interaction', function(index, enterpriseId)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return end
    TriggerClientEvent('Notify', src, 'azul', 'Iniciando rota de entregas da empresa #' .. enterpriseId, 5000)
end)
