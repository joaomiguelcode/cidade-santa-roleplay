---@class AchievementNotificationConfig
---@field cooldown string
---@field displayDuration string
---@field feedSound FeedbackSound
---@field bannerSound FeedbackSound

---@type AchievementNotificationConfig
ACHIEVEMENT_NOTIFICATION_CONFIG = {
    cooldown = "10s",
    displayDuration = "5s",
    feedSound = {
        url = "https://cdn.santagroup.gg/feedback-ranking/notificacao_xp.mp3",
        volume = 0.3,
    },
    bannerSound = {
        url = "https://cdn.santagroup.gg/feedback-ranking/missao_completa.m4a",
        volume = 0.3,
    },
}
