assert( IsSocialRankingCityEnabled,
    'hud: @social_ranking/shared/enabled_cities.lua nao carregou -- confira o fxmanifest' )

GAMIFIED_FEEDBACK_ENABLED = IsSocialRankingCityEnabled()

---@type FeedbackConfig
FEEDBACK_CONFIG = {
    defaultWorldBucket = 1,
}
