-- ENG-3724: regras puras do convite X1 pós-recrutamento.
X1InviteRules = {
    TOTAL_MATCHES = 3,
    ITEMS_PER_MATCH = 240,
    MONEY_PER_MATCH = 250000,
    VALIDITY_SECONDS = 172800,
    PROTECTION_SECONDS = 900,
    DONE_SECONDS = 8,
    -- Tela de resultado do Competitivo (COMPETITIVE_MATCH_RESULT_DISPLAY_MS) cobre o fim da partida.
    RESULT_SCREEN_SECONDS = 15,
    COUNTS_FROM_ROUND = 5,
    VETERAN_ACTIVE_SECONDS = 120,
    DRAW_WAIT_MS = 40000,
}

---@param state table
---@param now number Tempo monotônico em milissegundos.
---@param armed boolean Arma de fogo sacada na mão.
---@return boolean ready
function X1InviteRules.TickInvite( state, now, armed )

    if state.shown then return false end

    if not state.readyAt then

        if not armed then return false end

        -- ENG-3748: 40s contados do saque; guardar a arma em seguida não cancela.
        state.readyAt = now + X1InviteRules.DRAW_WAIT_MS
    end

    if now < state.readyAt then return false end

    state.shown = true
    return true
end

-- ENG-3768: veterano saca a arma dentro do QG e acumula 2 min ativo lá dentro (1 chamada por segundo).
-- Sacar fora e entrar armado não conta: exige guardar e sacar de novo dentro do QG.
---@param offer table `qgArmed`/`qgSeconds` persistem na oferta.
---@param clock table Estado da sessão (`wasArmed`).
---@param armed boolean Arma de fogo sacada na mão.
---@param inside boolean Dentro do QG da própria facção.
---@param active boolean Fora de AFK.
---@return boolean ready
function X1InviteRules.TickVeteran( offer, clock, armed, inside, active )

    if not offer.qgArmed then
        if armed and inside and clock.wasArmed == false then offer.qgArmed = true end

        clock.wasArmed = armed
        return false
    end

    if inside and active then offer.qgSeconds = ( offer.qgSeconds or 0 ) + 1 end

    return ( offer.qgSeconds or 0 ) >= X1InviteRules.VETERAN_ACTIVE_SECONDS
end

-- A conclusão fica na tela por DONE_SECONDS depois que a tela de resultado fecha.
---@param doneAt number|nil Unix seconds da 3ª partida.
---@param now number Unix seconds.
---@return boolean
function X1InviteRules.DoneElapsed( doneAt, now )

    return now - ( doneAt or 0 ) >= X1InviteRules.RESULT_SCREEN_SECONDS + X1InviteRules.DONE_SECONDS
end

---@param shownAt number|nil Unix seconds da exibição do convite.
---@param now number Unix seconds.
---@return number
function X1InviteRules.ProtectionSeconds( shownAt, now )

    if not shownAt then return 0 end

    return math.max( 0, shownAt + X1InviteRules.PROTECTION_SECONDS - now )
end

-- Partida em andamento espera terminar; `done`/`closed` já saíram do fluxo. `match` com `autoJoin` já acabou
-- e só espera a volta automática para a fila (ENG-3780).
---@param offer table
---@param now number Unix seconds.
---@return boolean
function X1InviteRules.IsExpired( offer, now )

    return offer.expiresAt ~= nil and now >= offer.expiresAt
        and ( offer.mode ~= 'match' or offer.autoJoin == true ) and offer.mode ~= 'done' and offer.mode ~= 'closed'
end

-- Abandono ou desconexão de qualquer lado não conta para ninguém.
---@param payload table Evento `dminigames:x1invite:matchFinished`.
---@return boolean
function X1InviteRules.MatchCounts( payload )

    -- ENG-3745: encerrada a partir do 5º round conta de qualquer jeito (queda, abandono).
    if ( tonumber( payload.rounds ) or 0 ) >= X1InviteRules.COUNTS_FROM_ROUND then return true end

    if payload.reason ~= 'score' then return false end

    for _, participant in ipairs( payload.participants ) do
        if participant.abandoned then return false end
    end

    return true
end
