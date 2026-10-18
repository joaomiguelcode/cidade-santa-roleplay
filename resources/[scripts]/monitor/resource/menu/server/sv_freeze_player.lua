-- txAdmin sv_freeze_player.lua
RegisterNetEvent('txsv:req:freezePlayer', function(targetPlayerId)
    local src = source
    if not IsSourceAdmin(src) then return end
    local tPed = GetPlayerPed(tonumber(targetPlayerId))
    if DoesEntityExist(tPed) then
        FreezeEntityPosition(tPed, true)
    end
end)
