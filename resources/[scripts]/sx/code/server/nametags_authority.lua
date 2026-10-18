
RegisterNetEvent('sx:nametags:sync', function(rank, title)
    local src = source
    Player(src).state:set('sxRank', rank, true)
    Player(src).state:set('sxTitle', title, true)
end)
