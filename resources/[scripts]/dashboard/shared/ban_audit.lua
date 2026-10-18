--- Tags persistidas em `banneds.tags` pelo fluxo /ban (Ban Audit).
---@enum (key) eBanAuditTag
banAuditTag =
{
    MUNDO_RESTRITO          = 'ban_audit',
    MUNDO_RESTRITO_MANTIDO = 'ban_audit_maintained',
    BANIMENTO               = 'ban_audit_full',
}

--- Tipo resolvido pela Tabela 1 do /ban (Ban Audit).
---@enum (key) eBanAuditType
banAuditType =
{
    BANIMENTO      = 'banimento',
    MUNDO_RESTRITO = 'mundo_restrito',
}

---@alias BanAuditOverlayPhase 'awaiting_email' | 'awaiting_auth'
---@alias BanAuditStatusVariant 'aguardando' | 'analise' | 'mantido' | 'restabelecido'
