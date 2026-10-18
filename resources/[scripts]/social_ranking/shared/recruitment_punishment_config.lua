-- Ajustar a severidade da escada deve exigir mudar valores só aqui.

---@class RecruitmentPunishmentConfigType
---@field badDaysToSuspend number -- dias ruins consecutivos até aplicar a suspensão
RECRUITMENT_PUNISHMENT_CONFIG = {
    badDaysToSuspend = 3,
}

-- 1 dia por reincidência, teto de 7. Nunca existe suspensão permanente.
---@param recidivism number -- nº da suspensão deste personagem (1ª, 2ª...)
---@return number days
function RecruitmentPunishmentSuspensionDays( recidivism )
    return math.min( math.max( 1, math.floor( tonumber( recidivism ) or 1 ) ), 7 )
end

-- Protocolo compartilhado com o `hud` (ver CARD_BY_PENDING). RISK/LAST_WARNING pressupõem
-- badDaysToSuspend = 3; mudar aquele valor exige revisar os dois lados.
PENDING_CARD = {
    RISK = 1,
    LAST_WARNING = 2,
    BLOCKED = 4,
    RELEASED = 5,
}
