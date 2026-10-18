gamemaster.server.actions = {}

function gamemaster.server.actions.execute(action, source, args, options)
    if not gamemaster.server.validations.isAuthorized(source) then return end
    
    if action == 'revive' then
        local target = tonumber(args)
        if target and vRP.Revive then
            vRP.Revive(target, 200)
            TriggerClientEvent('Notify', source, 'verde', 'Jogador revivido com sucesso.', 5000)
        end
    elseif action == 'teleportTo' then
        local target = tonumber(args)
        local tPed = GetPlayerPed(target)
        local myPed = GetPlayerPed(source)
        if DoesEntityExist(tPed) and DoesEntityExist(myPed) then
            local coords = GetEntityCoords(tPed)
            SetEntityCoords(myPed, coords.x, coords.y, coords.z, false, false, false, false)
        end
    elseif action == 'kick' then
        DropPlayer(tonumber(args), 'Desconectado pela moderação.')
    end
end
