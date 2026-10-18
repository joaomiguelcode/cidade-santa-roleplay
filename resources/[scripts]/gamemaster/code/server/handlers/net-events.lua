RegisterNetEvent('net.gamemaster.menuAction', function(action, args)
    local src = source
    gamemaster.server.actions.execute(action, src, args)
end)

RegisterNetEvent('net.spectator.changePlayerInSpectator', function(direction)
    local src = source
    local players = GetPlayers()
    if #players > 0 then
        gamemaster.server.spectatorService.start(src, tonumber(players[1]))
    end
end)

RegisterNetEvent('net.gamemaster.addGroup', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    if vRP and args and args.passport and args.group then
        vRP.SetPermission(args.passport, args.group)
        TriggerClientEvent('Notify', src, 'verde', 'Grupo ' .. args.group .. ' adicionado ao ID ' .. args.passport, 5000)
    end
end)

RegisterNetEvent('net.gamemaster.removeGroup', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    if vRP and args and args.passport and args.group then
        vRP.RemovePermission(args.passport, args.group)
        TriggerClientEvent('Notify', src, 'verde', 'Grupo ' .. args.group .. ' removido do ID ' .. args.passport, 5000)
    end
end)

RegisterNetEvent('net.gamemaster.reviveLocation', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
end)

RegisterNetEvent('net.gamemaster.revivePlayer', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    local target = tonumber(args and args.target or args)
    if target and vRP.Revive then
        vRP.Revive(target, 200)
        TriggerClientEvent('Notify', src, 'verde', 'Jogador revivido.', 5000)
    end
end)

RegisterNetEvent('net.gamemaster.openBackpack', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    local target = tonumber(args and args.target or args)
    if target and vRP.Passport then
        local pass = vRP.Passport(target)
        if pass then
            TriggerClientEvent('inventory:openTarget', src, pass)
        end
    end
end)

RegisterNetEvent('net.gamemaster.kickPlayer', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    local target = tonumber(args and args.target or args)
    if target then DropPlayer(target, 'Você foi desconectado por um administrador.') end
end)

RegisterNetEvent('net.gamemaster.banPlayer', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    local target = tonumber(args and args.target or args)
    if target and vRP.Passport then
        local pass = vRP.Passport(target)
        if pass and vRP.Kick then
            vRP.Kick(target, 'Você foi banido da Cidade Santa.')
        end
    end
end)

RegisterNetEvent('net.gamemaster.copyId', function(args, options)
    -- Stub
end)

RegisterNetEvent('net.gamemaster.giveItem', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    if args and args.item and args.amount and vRP.GiveItem then
        local target = tonumber(args.target or src)
        local pass = vRP.Passport(target)
        if pass then
            vRP.GiveItem(pass, args.item, tonumber(args.amount) or 1)
        end
    end
end)

RegisterNetEvent('net.gamemaster.teleportTo', function(args, options)
    local src = source
    if not gamemaster.server.validations.isAuthorized(src) then return end
    local target = tonumber(args and args.target or args)
    local tPed = GetPlayerPed(target)
    local myPed = GetPlayerPed(src)
    if DoesEntityExist(tPed) and DoesEntityExist(myPed) then
        local coords = GetEntityCoords(tPed)
        SetEntityCoords(myPed, coords.x, coords.y, coords.z, false, false, false, false)
    end
end)
