CollectiblePets = {}

function CollectiblePets.GetPlayerPets(passport)
    return exports.oxmysql:executeSync('SELECT * FROM player_collectible_pets WHERE passport = ?', { passport }) or {}
end
