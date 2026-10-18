-- reason -> { xp, lifetime }
--
-- lifetime = false  =>  the source already credits skills.social (a mission reward), so ranking
--                       writes WEEKLY ONLY. There is ONE Level Social store and it must not be
--                       written twice (PRD §3). For those reasons the lifetime magnitude is
--                       whatever the source grants, not `xp`.
-- lifetime = true   =>  ranking owns the lifetime bump too (no upstream credit).
--
-- NOTE (trail_mission): set to true by product decision. Some connect/criminal missions already
-- grant skills.social as their own reward, so for those this double-credits the lifetime store
-- (overcount vs PRD §3's one-store rule). Accepted; revisit with a per-call lifetime override if
-- the overcount matters.
---@class RankingXpDef
---@field xp       number  -- weekly XP awarded for this reason
---@field lifetime boolean -- true => ranking also bumps the lifetime social skill

---@type table<string, RankingXpDef>
RANKING_XP = {
    recruit_initiate          = { xp = 50,   lifetime = false }, -- missions increments recrutador_do_topo (+social); weekly ranking only
    recruit_returned_next_day = { xp = 900,  lifetime = true  }, -- deferred (retention)
    recruit_quality_day_bonus = { xp = 900,  lifetime = true  }, -- extra per D1 on a day whose cohort reaches 50% (ENG-2538)
    recruit_quality_sequence_bonus = { xp = 0, lifetime = true }, -- one-time 3/5/7 quality-day milestones (ENG-3287; amount is overridden)
    recruit_stayed_7_days     = { xp = 1200, lifetime = true  }, -- deferred (retention)
    trail_mission             = { xp = 150,  lifetime = true  }, -- ranking owns the lifetime bump (see note below)
    trail_complete_bonus      = { xp = 1000, lifetime = true  },
    city_event                = { xp = 60,   lifetime = true  }, -- deferred source; 1x/event (ENG-2421)
    feedback_received         = { xp = 10,   lifetime = true  },
    like_received             = { xp = 10,   lifetime = true  },
    active_time               = { xp = 200,  lifetime = true  }, -- degressivo por dia (ENG-2484): 1ª hora 200, 2ª-5ª 50, 6ª+ 0. `xp` = valor da 1ª hora (badge/front)
    match_participation       = { xp = 3000, lifetime = true  }, -- ENG-3760: 3.000/3.000/4.000 por parceiro válido distinto
    match_cartada_win         = { xp = 500,  lifetime = true  }, -- ENG-3761: teto de 2.500 por dia aplicado pelo Match da Cidade
    abandoned_initiates       = { xp = -500, lifetime = false }, -- SEM QUALIDADE (ENG-2834): desconto por iniciante largado num dia punido
    production_test_adjustment = { xp = 0, lifetime = false }, -- ajuste manual reversível e auditável, exclusivo do console
}

-- SEM QUALIDADE (ENG-2834). Dia FECHADO com volume alto e retorno baixo desconta XP do ciclo, um
-- `abandoned_initiates` por recruta que não voltou. O dia corrente nunca é avaliado — o snapshot já
-- só materializa coortes com `cohort_date < hoje`, então o gate herda esse recorte de graça.
--
-- Faixa 40%-49% NÃO pune: é a zona de quem chegou perto e não bateu o gate de qualidade (>=50%).
-- Por isso o corte é <=39% e não <50%; os dois gates deixam um vão neutro de propósito.
--
-- `minRecruits` é valor INICIAL, entra assim pra calibrar com dado de produção (PRD).
-- ENG-3357: calibrado de 6 para 5 com dado de produção. O sweep faz DELETE+INSERT da semana
-- corrente a cada varredura, então a semana em aberto se reprocessa sozinha no deploy; os dias
-- da semana anterior que ainda estão na janela de 7 dias saem por `recalc_abandoned_5.sql`.
NO_QUALITY_GATE = {
    minRecruits = 5,  -- volume mínimo do dia; abaixo disso nunca pune
    gatePct     = 40, -- taxa de retorno < 40% pune; 40% ou mais não
}

QUALITY_DAY_GATE = {
    minRetainedD1 = 3,
    gatePct = 50,
}

QUALITY_SEQUENCE_MILESTONES = {
    [3] = 2000,
    [5] = 4000,
    [7] = 8000,
}

-- Active-time degressive per-day schedule (ENG-2484). `hour` = cumulative active hour of the
-- day (1-based). Daily reset at server midnight is handled by the caller (counts today's rows).
-- Daily cap (400) and weekly cap (2800 = 7×400) are EMERGENT from this table, not enforced apart.
---@param hour number -- 1-based cumulative active hour of the day
---@return number xp
function ActiveTimeXpForHour( hour )
    if hour == 1 then return 200 end
    if hour >= 2 and hour <= 5 then return 50 end
    return 0
end
