Collectibles = {}

function Collectibles.GetPlayerCollectibles(passport)
    return exports.oxmysql:executeSync('SELECT * FROM player_collectibles WHERE passport = ?', { passport }) or {}
end
