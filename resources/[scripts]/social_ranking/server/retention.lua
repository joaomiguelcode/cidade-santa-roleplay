RankingRetention = {}

function RankingRetention.AwardDailyBonus(passport)
    RankingAPI.AddXP(passport, 200, 'daily_retention')
end
