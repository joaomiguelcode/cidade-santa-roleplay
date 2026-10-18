-- txAdmin sv_player_mode.lua
RegisterNetEvent('txsv:req:changePlayerMode', function(mode, nearbyPlayers)
    local src = source
    if not IsSourceAdmin(src) then return end
    local ped = GetPlayerPed(src)
    if mode == 'godmode' then
        SetEntityInvincible(ped, true)
    elseif mode == 'noclip' then
        SetEntityInvincible(ped, true)
    else
        SetEntityInvincible(ped, false)
    end
end)

RegisterNetEvent('txsv:req:showPlayerIDs', function(enable)
    local src = source
    if not IsSourceAdmin(src) then return end
    TriggerClientEvent('txcl:setPlayerIDs', src, enable)
end)
