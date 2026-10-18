-- txAdmin sv_trollactions.lua
RegisterNetEvent('txsv:req:troll:setDrunk', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    TriggerClientEvent('txcl:troll:drunk', tonumber(targetId))
end)

RegisterNetEvent('txsv:req:troll:setOnFire', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local tPed = GetPlayerPed(tonumber(targetId))
    if DoesEntityExist(tPed) then
        StartEntityFire(tPed)
    end
end)

RegisterNetEvent('txsv:req:troll:wildAttack', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    TriggerClientEvent('txcl:troll:wildAttack', tonumber(targetId))
end)
