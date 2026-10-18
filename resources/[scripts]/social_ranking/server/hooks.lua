RankingHooks = {}

function RankingHooks.OnPlayerKill(killerPassport, victimPassport)
    RankingAPI.AddXP(killerPassport, 50, 'kill')
end

function RankingHooks.OnMissionComplete(passport, missionKey)
    RankingAPI.AddXP(passport, 100, 'mission')
end
