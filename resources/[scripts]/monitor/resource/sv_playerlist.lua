-- txAdmin sv_playerlist.lua
RegisterNetEvent('txsv:req:plist:getDetailed', function(requirePlayerNames)
    local src = source
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        local pSrc = tonumber(playerId)
        local passport = vRP and (vRP.Passport and vRP.Passport(pSrc) or vRP.getUserId(pSrc)) or pSrc
        table.insert(players, {
            id = pSrc,
            name = GetPlayerName(pSrc) or ('Player ' .. pSrc),
            ping = GetPlayerPing(pSrc),
            passport = passport
        })
    end
    TriggerClientEvent('txcl:plist:setDetailed', src, players)
end)
