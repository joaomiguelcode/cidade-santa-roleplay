-- O `<b>`/`<r>` vira `<span style>` aqui; o React só sanitiza e injeta.
local Translate = TranslateFeedbackHighlighted

---@class PunishmentModalCopy
---@field title string
---@field body string
---@field highlight string? -- só o motivo recruitment usa (o prazo)
---@field footer string
---@field footerTone "secondary"|"tertiary"
---@field badge string -- selo do topo; igual nos dois motivos
---@field confirm string -- rotulo do botao de fechar

---@param reason string
---@return PunishmentModalCopy
local function Copy( reason )
    local key = ( "hud.punishment_modal.%s" ):format( reason )

    return {
        title = Translate( key .. ".title" ),
        body = Translate( key .. ".body" ),
        highlight = reason == "recruitment" and Translate( key .. ".highlight" ) or nil,
        footer = Translate( key .. ".footer" ),
        footerTone = reason == "recruitment" and "secondary" or "tertiary",
        badge = Translate( "hud.punishment_modal.badge" ),
        confirm = Translate( "hud.punishment_modal.confirm" ),
    }
end

---@type table<string, PunishmentModalCopy>
PUNISHMENT_MODAL_TEXTS = {
    low_activity = Copy( "low_activity" ),
    recruitment = Copy( "recruitment" ),
}
