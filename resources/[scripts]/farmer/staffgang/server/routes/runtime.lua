-- staffgang routes runtime
lib.callback.register('farmer:staffgang:start-farm', function(source, farmId, pointId)
    local passport = vRP.Passport(source)
    if not passport then return { success = false, message = 'unauthenticated' } end
    return { success = true }
end)

RegisterCommand('staffgang', function(source, args)
    local passport = vRP.Passport(source)
    if vRP.hasPermission(passport, 'Admin') then
        TriggerClientEvent('farmer:staffgang:open-menu', source)
    end
end)
