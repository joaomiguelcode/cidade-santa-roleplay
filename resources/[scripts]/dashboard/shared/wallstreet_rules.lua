--- ENG-3273/ENG-3288 - regras puras da blacklist da WallStreet.
--- Sem native e sem estado: e o que `tests/dashboard_wallstreet/test_rules.lua` carrega.

WallStreetRules = {}

--- Motivos de punicao. Sao as CHAVES que o dashboard traduz
--- (`sxarch::RemoveFromWallStreetDialog.tsx::REMOVAL_REASONS`), nao o texto de tela:
--- gravar "Baixa atividade" na coluna `reason` faz a Auditoria cair no fallback e
--- mostrar portugues cru em en/es.
WallStreetRules.REASON_LOW_ACTIVITY = 'lowActivity'
WallStreetRules.REASON_LOW_RETENTION = 'lowRetention'

--- Mesma lista fechada usada pelo `dashboard` (Server.RemoveWallStreetGroups), pelo
--- Growth (`controle-recrutamento/_lib.ts::WS_PASTAS`) e pela CodeAPI
--- (`REMOVAL_GROUPS`). Casa por `groups`.`group`, NUNCA por alias: o alias e o
--- codinome da pasta no jogo e muda por cidade (ENG-2571).
WallStreetRules.PASTAS = {
    'WallStreet', 'WhiteList', 'Introducao', 'Inclusao', 'Interacao',
    'Intercambio', 'Conexao', 'Contencao', 'Evolucao', 'Expansao',
    'Inovacao', 'Recovery', 'Retencao',
}

--- Universo avaliado pela rotina: portador do cargo WallStreet nivel 3, 4 ou 5.
--- WallStreet 1 e 2 nao e avaliado nem removido pela rotina automatica. As demais
--- pastas continuam saindo na REMOCAO de quem for punido, mas nao colocam ninguem
--- na fila de avaliacao.
WallStreetRules.EVAL_MIN_LEVEL = 3
WallStreetRules.EVAL_MAX_LEVEL = 5

--- Admin 1 a 3 nunca sao tocados; a remocao e o bloqueio valem de Admin 4 pra baixo.
WallStreetRules.REMOVABLE_ADMIN_LEVEL = 4

---@param permission string
---@return boolean
function WallStreetRules.IsPasta( permission )

    local name = tostring( permission ):lower()

    for _, pasta in ipairs( WallStreetRules.PASTAS ) do
        if pasta:lower() == name then
            return true
        end
    end

    return false
end

--- Cargo cujo set e negado enquanto a blacklist estiver ativa.
---@param permission string
---@param level      number|nil
---@return boolean
function WallStreetRules.IsBlockedPermission( permission, level )

    if WallStreetRules.IsPasta( permission ) then
        return true
    end

    return permission == 'Admin'
        and ( tonumber( level ) or 0 ) >= WallStreetRules.REMOVABLE_ADMIN_LEVEL
end

--- Cortes default da regua. O server sobrescreve pelos convars da cidade.
WallStreetRules.DEFAULTS = {
    --- Regra 1 (ENG-3273): menos que isso de iniciados na janela = baixa atividade.
    minRecruits = 5,
    --- Regra 2 (ENG-3288): amostra minima para a retencao significar alguma coisa.
    minSample = 5,
    --- Corte da retencao D1 em centesimos de ponto percentual: 2000 = 20,00%.
    --- Em centesimos porque a issue corta em "20,00% pune / 20,01% passa" e o
    --- float de 0.2 nao representa isso exatamente - a comparacao vira inteira.
    cutBps = 2000,
}

--- Retencao D1 em porcentagem com uma casa, mesma conta da CodeAPI
--- (`panel/retention.rs::retention_pct`). Denominador e o cohort MADURO.
---@param retained number
---@param mature   number
---@return number  -- 0 a 100
function WallStreetRules.RetentionPct( retained, mature )

    mature = tonumber( mature ) or 0

    if mature <= 0 then
        return 0
    end

    return math.floor( ( ( tonumber( retained ) or 0 ) / mature ) * 1000 + 0.5 ) / 10
end

--- Decide a punicao de UM membro a partir dos numeros da janela de 7 dias.
---
--- A ordem da ENG-3288 sai de graca do `elseif`: quem cai na regra 1 nao chega na
--- regra 2 no mesmo dia, sem precisar de marca de "ja punido".
---
--- `mature` (cohort com D+1 fechado) e o denominador E a amostra minima. Iniciado
--- de hoje ainda nao teve a chance de voltar: conta em `recruits` para a regra 1,
--- mas nao entra na regra 2 nem para punir nem para salvar.
---
---@param recruits number   -- iniciados distintos na janela
---@param mature   number   -- destes, os que ja tiveram o D+1 fechado
---@param retained number   -- destes, os que voltaram no D+1
---@param cuts     table|nil -- { minRecruits, minSample, cutBps }; default DEFAULTS
---@return string|nil  -- REASON_LOW_ACTIVITY, REASON_LOW_RETENTION ou nil
function WallStreetRules.Evaluate( recruits, mature, retained, cuts )

    cuts = cuts or WallStreetRules.DEFAULTS

    recruits = tonumber( recruits ) or 0
    mature = tonumber( mature ) or 0
    retained = tonumber( retained ) or 0

    if recruits < ( cuts.minRecruits or WallStreetRules.DEFAULTS.minRecruits ) then
        return WallStreetRules.REASON_LOW_ACTIVITY
    end

    if mature < ( cuts.minSample or WallStreetRules.DEFAULTS.minSample ) then
        return nil
    end

    -- retained/mature*10000 <= cutBps, sem divisao: so inteiro dos dois lados.
    if retained * 10000 <= mature * ( cuts.cutBps or WallStreetRules.DEFAULTS.cutBps ) then
        return WallStreetRules.REASON_LOW_RETENTION
    end

    return nil
end

--- "restam 6d 00h 20min" - dias, horas e minutos que faltam ate a liberacao.
---@param seconds  number
---@param template string  -- ex: '%dd %02dh %02dmin'
---@return string
function WallStreetRules.FormatCountdown( seconds, template )

    seconds = math.max( 0, math.floor( tonumber( seconds ) or 0 ) )

    return ( template ):format(
        math.floor( seconds / 86400 ),
        math.floor( ( seconds % 86400 ) / 3600 ),
        math.floor( ( seconds % 3600 ) / 60 )
    )
end

return WallStreetRules
