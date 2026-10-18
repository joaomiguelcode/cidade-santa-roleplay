RegisterCommand('gm', function(source)
    if gamemaster.server.validations.isAuthorized(source) then
        TriggerClientEvent('gamemaster:openUI', source)
    end
end)

RegisterCommand('spec', function(source, args)
    if gamemaster.server.validations.isAuthorized(source) and args[1] then
        local target = tonumber(args[1])
        gamemaster.server.spectatorService.start(source, target)
    end
end)
