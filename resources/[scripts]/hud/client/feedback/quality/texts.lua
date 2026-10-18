-- Highlight helpers (FEEDBACK_HIGHLIGHT_STYLES/TranslateFeedbackHighlighted) vêm de
-- shared/feedback/highlights.lua, compartilhados com recruitment_punishment/texts.lua.
local Translate = TranslateFeedbackHighlighted

---@param profile GamifiedFeedbackProfile
---@param qualityState GamifiedFeedbackQualityState
---@param type string
---@return GamifiedFeedbackText text
local function Text( profile, qualityState, type )
    local key = ( "hud.feedback.notification.%s.%s" ):format( profile, qualityState )

    return {
        type = type,
        title = Translate( key .. ".title" ),
        actionLabel = Translate( key .. ".action" ),
        description = {
            Translate( key .. ".line1" ),
            Translate( key .. ".line2" ),
            Translate( key .. ".line3" ),
        },
    }
end

local TEXT_TYPES = {
    excellent = "excelent",
    good = "good",
    medium = "medium",
    low = "low",
    bad = "bad",
    very_bad = "verybad",
}

---@param profile GamifiedFeedbackProfile
---@return table<GamifiedFeedbackQualityState, GamifiedFeedbackText> texts
local function BuildProfileTexts( profile )
    local texts = {}

    for qualityState, type in pairs( TEXT_TYPES ) do
        texts[qualityState] = Text( profile, qualityState, type )
    end

    return texts
end

---@type table<GamifiedFeedbackProfile, table<GamifiedFeedbackQualityState, GamifiedFeedbackText>>
GAMIFIED_FEEDBACK_TEXTS = {
    individual = BuildProfileTexts( "individual" ),
    organization = BuildProfileTexts( "organization" ),
}
