-- Ponto único de inicialização do feedback no cliente.
---@return nil
local function bootstrap()
    if not GAMIFIED_FEEDBACK_ENABLED then
        -- sx.logger:info( "hud gamified feedback client disabled for this city" )
        return
    end

    FeedbackClient.Register()
    FeedbackQualityClient.Register()
    FeedbackOrganizationClient.Register()
    FeedbackRecruitmentClient.Register()
    FeedbackAchievementsClient.Register()
    FeedbackRecruitmentPunishmentClient.Register()
    RecruitmentPunishmentModalClient.Register()
    RankingMilestoneClient.Register()
    PunishmentModalClient.Register()

    -- sx.logger:info( "hud gamified feedback client initialized" )
end

bootstrap()
