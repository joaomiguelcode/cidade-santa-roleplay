-- txAdmin sv_spectate.lua
local spectating = {}

RegisterNetEvent('txsv:req:spectate:start', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local targetSrc = tonumber(targetId)
    local tPed = GetPlayerPed(targetSrc)
    if DoesEntityExist(tPed) then
        spectating[src] = targetSrc
        local coords = GetEntityCoords(tPed)
        TriggerClientEvent('txcl:spectate:start', src, targetSrc, coords)
    end
end)

RegisterNetEvent('txsv:req:spectate:end', function()
    local src = source
    spectating[src] = nil
    TriggerClientEvent('txcl:spectate:end', src)
end)

RegisterNetEvent('txsv:req:spectate:cycle', function(storedTargetServerId, isNext)
    local src = source
    if not IsSourceAdmin(src) then return end
    local players = GetPlayers()
    if #players == 0 then return end
    local nextId = tonumber(players[1])
    spectating[src] = nextId
    local coords = GetEntityCoords(GetPlayerPed(nextId))
    TriggerClientEvent('txcl:spectate:cycle', src, nextId, coords)
end)
