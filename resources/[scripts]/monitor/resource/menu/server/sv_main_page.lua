-- txAdmin sv_main_page.lua
RegisterNetEvent('txsv:req:tpToCoords', function(x, y, z)
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    if DoesEntityExist(ped) then
        SetEntityCoords(ped, tonumber(x) + 0.0, tonumber(y) + 0.0, tonumber(z) + 0.0, false, false, false, false)
    end
end)

RegisterNetEvent('txsv:req:tpToWaypoint', function()
    local src = source
    if not IsSourceAdmin(src) then return end
end)

RegisterNetEvent('txsv:req:tpToPlayer', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local tPed = GetPlayerPed(tonumber(targetId))
    local myPed = GetPlayerPed(src)
    if DoesEntityExist(tPed) and DoesEntityExist(myPed) then
        local coords = GetEntityCoords(tPed)
        SetEntityCoords(myPed, coords.x, coords.y, coords.z, false, false, false, false)
    end
end)

RegisterNetEvent('txsv:req:bringPlayer', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local tPed = GetPlayerPed(tonumber(targetId))
    local myPed = GetPlayerPed(src)
    if DoesEntityExist(tPed) and DoesEntityExist(myPed) then
        local coords = GetEntityCoords(myPed)
        SetEntityCoords(tPed, coords.x, coords.y, coords.z, false, false, false, false)
    end
end)

RegisterNetEvent('txsv:req:clearArea', function(radius)
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    ClearAreaOfPeds(coords.x, coords.y, coords.z, tonumber(radius) or 100.0, 1)
    ClearAreaOfVehicles(coords.x, coords.y, coords.z, tonumber(radius) or 100.0, false, false, false, false, false)
end)

RegisterNetEvent('txsv:req:healPlayer', function(targetId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local tPed = GetPlayerPed(tonumber(targetId))
    if DoesEntityExist(tPed) then
        SetEntityHealth(tPed, 200)
    end
    if vRP then
        local p = vRP.Passport and vRP.Passport(tonumber(targetId)) or vRP.getUserId(tonumber(targetId))
        if p then
            if vRP.UpgradeThirst then vRP.UpgradeThirst(p, 100) end
            if vRP.UpgradeHunger then vRP.UpgradeHunger(p, 100) end
            if vRP.Revive then vRP.Revive(tonumber(targetId), 200) end
        end
    end
end)

RegisterNetEvent('txsv:req:healMyself', function()
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    if DoesEntityExist(ped) then SetEntityHealth(ped, 200) end
    if vRP then
        local p = vRP.Passport and vRP.Passport(src) or vRP.getUserId(src)
        if p then
            if vRP.UpgradeThirst then vRP.UpgradeThirst(p, 100) end
            if vRP.UpgradeHunger then vRP.UpgradeHunger(p, 100) end
            if vRP.Revive then vRP.Revive(src, 200) end
        end
    end
end)

RegisterNetEvent('txsv:req:healEveryone', function()
    local src = source
    if not IsSourceAdmin(src) then return end
    for _, playerId in ipairs(GetPlayers()) do
        local pSrc = tonumber(playerId)
        local ped = GetPlayerPed(pSrc)
        if DoesEntityExist(ped) then SetEntityHealth(ped, 200) end
    end
end)

RegisterNetEvent('txsv:req:sendAnnouncement', function(msg)
    local src = source
    if not IsSourceAdmin(src) then return end
    TriggerClientEvent('Notify', -1, 'amarelo', '<b>[Anúncio txAdmin]</b> ' .. tostring(msg), 15000)
end)
