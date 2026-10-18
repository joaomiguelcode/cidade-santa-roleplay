--- ENG-3292 - regras puras da blacklist do atendimento comercial.
--- Sem native e sem estado: e o que `tests/dashboard_comercial/test_rules.lua` carrega.

ComercialRules = {}

--- Motivo da punicao. E a CHAVE que o dashboard/NUI traduz, nao o texto de tela.
--- Separado do `lowActivity` da WallStreet porque a copy do modal e outra
--- ("sem atender clientes" vs "sem iniciar os iniciantes").
ComercialRules.REASON_LOW_ACTIVITY = 'comercialLowActivity'

--- Cargo do atendimento comercial. Niveis 1 a 5 do mesmo grupo `Afiliado`
--- (`vrp/config/Groups.lua`), nao grupos distintos.
ComercialRules.GROUP = 'Afiliado'

--- Universo avaliado: Afiliado 3, 4 e 5. Niveis 1 e 2 nao entram na regua -- mas
--- continuam bloqueados no set enquanto a blacklist estiver ativa.
ComercialRules.EVAL_MIN_LEVEL = 3
ComercialRules.EVAL_MAX_LEVEL = 5

--- Cargo cujo set e negado enquanto a blacklist estiver ativa: Afiliado em
--- qualquer nivel (1 a 5).
--- ponytail: so o grupo `Afiliado`. Os `AfiliadoA`..`AfiliadoF` sao grupos de
--- staff separados e a issue nao os cita; incluir na lista quando a Operacao pedir.
---@param permission string
---@return boolean
function ComercialRules.IsBlockedPermission( permission )

    return tostring( permission ):lower() == ComercialRules.GROUP:lower()
end

--- Cortes default da regua. O server sobrescreve pelos convars da cidade.
ComercialRules.DEFAULTS = {
    --- Corte inicial da ENG-3292: menos que 1 atendimento iniciado na janela pune,
    --- ou seja, so quem nao iniciou NENHUM. O alvo futuro e 5, ja parametrizado:
    --- subir a convar `comercial_min_tickets` liga o corte sem mexer no codigo.
    minTickets = 1,
    --- Janela movel, em dias.
    windowDays = 7,
    --- Carencia: quem recebeu o cargo ha menos que isso nao e avaliado.
    graceDays = 7,
}

--- Decide a punicao de UM afiliado a partir dos numeros da janela.
---@param tickets number    -- atendimentos INICIADOS na janela (matchmaking + manual)
---@param cuts    table|nil -- { minTickets }; default DEFAULTS
---@return string|nil  -- REASON_LOW_ACTIVITY ou nil
function ComercialRules.Evaluate( tickets, cuts )

    cuts = cuts or ComercialRules.DEFAULTS

    tickets = tonumber( tickets ) or 0

    if tickets < ( cuts.minTickets or ComercialRules.DEFAULTS.minTickets ) then
        return ComercialRules.REASON_LOW_ACTIVITY
    end

    return nil
end

return ComercialRules
