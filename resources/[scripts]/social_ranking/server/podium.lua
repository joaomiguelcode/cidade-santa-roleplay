RankingPodium = {}

function RankingPodium.Update()
    local top = RankingAPI.GetTopPlayers(3)
    local podium = {}
    for i = 1, 3 do
        local entry = top[i]
        if entry then
            local pSrc = vRP.Source(entry.passport)
            podium[i] = {
                passport = entry.passport,
                name = (entry.name or 'Cidadão') .. ' ' .. (entry.name2 or ''),
                rank = i,
                position = i,
                level = entry.level or 1,
                xpWeek = entry.xp_week or 0,
                customisations = {},
                isFemale = false,
                source = pSrc or false,
                effectsEnabled = (entry.effects_enabled ~= 0)
            }
        end
    end
    RankingEmit.PodiumUpdated(podium)
end
