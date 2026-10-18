-- txAdmin sv_logger.lua
RegisterNetEvent('txsv:logger:deathEvent', function(killer, deathReason)
    local src = source
    -- print(('[txAdmin:Death] Player %s died. Killer: %s, Reason: %s'):format(src, tostring(killer), tostring(deathReason)))
end)
