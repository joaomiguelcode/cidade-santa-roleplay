---@alias GamifiedFeedbackProfile "individual"|"organization"
---@alias QualityRecruitmentOrigin "panel"|"setarfac"|"command"|"system"
---@alias GamifiedFeedbackQualityState "excellent"|"good"|"medium"|"low"|"bad"|"very_bad"
---@alias GamifiedFeedbackTimerState "disabled"|"waiting_first"|"waiting_recurrence"|"displaying"|"refreshing"
---@alias AchievementNotificationType "individual_return"|"individual_quality_return"|"individual_recruitment"|"organization_recruitment"|"organization_retention_milestone"

---@class AchievementNotification
---@field type AchievementNotificationType
---@field xp integer
---@field count integer|nil
---@field remaining integer|nil

---@class GamifiedFeedbackQualityWindow
---@field recruited integer
---@field returned integer

---@class GamifiedFeedbackSnapshot
---@field profile GamifiedFeedbackProfile
---@field qualityState GamifiedFeedbackQualityState
---@field qualityWindow GamifiedFeedbackQualityWindow

---@class GamifiedFeedbackPlayerContext
---@field source integer
---@field passport integer
---@field profile GamifiedFeedbackProfile
---@field job string

---@class GamifiedFeedbackRankingEntry
---@field qualityThermometer unknown

---@class GamifiedFeedbackText
---@field type string
---@field title string
---@field actionLabel string
---@field description string[]

---@class QualityRecruitmentSetContext
---@field origin QualityRecruitmentOrigin
---@field actorPassport integer|nil
---@class QualityRecruitmentCopy
---@field title string
---@field subtitle string
---@field banner string
---@field factsTitle string
---@field facts string[]
---@field commitment string
---@field commitmentHint string
---@field confirmLabel string
---@field rewardTitle string
---@field footer string
---@field rewardXp integer

---@class GamifiedFeedbackServerConfig
---@field apiUrlConvar string
---@field apiToken string
---@field defaultApiUrl string
---@field retryDelay string

---@class QualityFeedbackTiming
---@field initialDelay string
---@field displayDuration string
---@field postActionDelayMin string
---@field postActionDelayMax string
---@field recurrenceByState table<GamifiedFeedbackQualityState, string>

---@class FeedbackConfig
---@field defaultWorldBucket integer

---@class QualityFeedbackConfig
---@field timing QualityFeedbackTiming
---@field sounds table<string, FeedbackSound>

---@class FeedbackSound
---@field url string
---@field volume number

---@class OrgRankingConfig
---@field displayDuration string
---@field recurrence string
---@field top integer
---@field sound FeedbackSound
---@field soundsByLanguage table<string, FeedbackSound> -- chave = codigo de 2 letras do idioma
