MinigamePlayerManager = {}
MinigamePlayerManager.players = {}

function MinigamePlayerManager.SetPlayerState(passport, stateName, value)
    local src = vRP.Source(passport)
    if src then
        Player(src).state:set(stateName, value, true)
    end
end
