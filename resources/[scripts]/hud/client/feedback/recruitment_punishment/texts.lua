-- O `<b>`/`<r>` vira `<span style>` aqui; o React só sanitiza e injeta.
local Translate = TranslateFeedbackHighlighted

---@class RecruitmentPunishmentCardText
---@field title string
---@field actionLabel string? -- nil no "blocked" (RF-38: sem tecla de ação)
---@field line1 string
---@field line2 string -- não usada no "blocked": o prazo vive no bloco de relógio
---@field line3 string
---@field clockLabel string? -- só o "blocked": rótulo do bloco de relógio (RF-38)

---@param cardType string
---@return RecruitmentPunishmentCardText
local function Card( cardType )
    local key = ( "hud.feedback.notification.recruitment_punishment.%s" ):format( cardType )

    return {
        title = Translate( key .. ".title" ),
        actionLabel = cardType ~= "blocked" and Translate( key .. ".action" ) or nil,
        line1 = Translate( key .. ".line1" ),
        line2 = Translate( key .. ".line2" ),
        line3 = Translate( key .. ".line3" ),
        clockLabel = cardType == "blocked" and _t( key .. ".clock_label" ) or nil,
    }
end

---@type table<string, RecruitmentPunishmentCardText>
RECRUITMENT_PUNISHMENT_TEXTS = {
    risk = Card( "risk" ),
    last_warning = Card( "last_warning" ),
    blocked = Card( "blocked" ),
    released = Card( "released" ), -- único verde da escada
}
