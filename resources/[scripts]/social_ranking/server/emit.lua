RankingEmit = {}

function RankingEmit.XPChanged(passport, currentXp, delta)
    TriggerClientEvent('social_ranking:onXPChange', -1, passport, currentXp, delta)
end

function RankingEmit.PodiumUpdated(podiumData)
    GlobalState['social_ranking:podium'] = podiumData
    TriggerClientEvent('social_ranking:syncPodium', -1, podiumData)
end
