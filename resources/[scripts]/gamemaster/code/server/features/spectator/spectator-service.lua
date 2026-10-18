gamemaster.server.spectatorService = {}

function gamemaster.server.spectatorService.start(source, targetSource)
    local ped = GetPlayerPed(targetSource)
    if DoesEntityExist(ped) then
        local coords = GetEntityCoords(ped)
        SetPlayerRoutingBucket(source, GetPlayerRoutingBucket(targetSource))
        TriggerClientEvent('net.spectator.start', source, targetSource, coords)
    end
end

function gamemaster.server.spectatorService.stop(source)
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('net.spectator.stop', source)
end
