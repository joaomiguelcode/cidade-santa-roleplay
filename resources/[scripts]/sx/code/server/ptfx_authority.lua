
RegisterNetEvent('sx:ptfx:requestSync', function(ptfxId, coords, duration)
    local src = source
    TriggerClientEvent('sx:ptfx:play', -1, src, ptfxId, coords, duration)
end)
