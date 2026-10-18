cityName = GetConvar("cityName", "")
-- Organization Ranking (Ranking das Organizações — PRD v1, ciclo de 15 dias, ativo nas cidades permitidas abaixo).
-- Second ranking domain living beside the player Social Ranking. XP is credited straight to the
-- ORGANIZATION (painel.id); there is no per-member economy (PRD §1).
--
-- reason -> xp. Unlike RANKING_XP there is no `lifetime` flag: every award also bumps
-- painel.organization_points (the lifetime level that never resets — PRD §1) inside EmitOrgXp.
---@type table<string, number>
ORG_RANKING_XP = {
    recruit_initiate          = 25,    -- symbolic on purpose (PRD §5)
    recruit_returned_next_day = 1200,  -- D1 (ladder, once per recruit lifetime)
    recruit_active_3_days     = 1300,  -- D3 (new — no player-ranking equivalent)
    recruit_stayed_7_days     = 1500,  -- D7
    quality_day_bonus         = 1200,  -- extra per D1 return on a QUALIDADE day (x2 — PRD §4)
    streak_3                  = 5000,  -- FERVENDO 3 consecutive quality days
    streak_5                  = 10000, -- FERVENDO 5
    streak_7                  = 20000, -- FERVENDO 7
    elite_day                 = 7000,  -- ELITE: 40+ online sustained 30min, 1x/day, max 3x/7d
    best_retention_week       = 20000, -- MELHOR RETENÇÃO: weekly winner, min 5 recruits
    active_members_25         = 1000,  -- MEMBROS ONLINE: 25+ online sustained 30min, 1x/day
    org_mission               = 150,   -- per completed organization mission
    org_trail_complete        = 1000,  -- weekly organization mission trail (sub-rhythm in the cycle)
    org_rating_week           = 300,   -- 7d window: half+ of members rated, avg 4.0+ (PRD §5)
    quality_recruitment_commitment = 50000,
    abandoned_initiates       = -800,  -- SEM QUALIDADE: por iniciante abandonado (ENG-2841/ENG-3290)
}

-- Reasons that move only the cycle bucket + ledger, never painel.organization_points. A penalidade
-- é contrapeso de ciclo (ENG-2841): rebaixar o nível vitalício da org por um dia ruim faria o level
-- andar pra trás, o que nenhuma outra regra faz.
---@type table<string, boolean>
ORG_XP_CYCLE_ONLY = {
    abandoned_initiates = true,
}

-- Same 15-day calendar as RankingAPI/rankings/level_social.py (QUALITY_CYCLE_ANCHOR/DAYS) — one
-- reset clock for the whole city (PRD §1). Keep the three values in sync with the API.
OrgRankingConfig = {
    enabled = IsOrgRankingCityEnabled(),
    cycleAnchor = { year = 2026, month = 7, day = 20 }, -- = QUALITY_CYCLE_ANCHOR
    cycleDays = 15,

    qualityGatePct = 50,
    qualityMinReturnedToday = 8,

    -- SEM QUALIDADE (ENG-2841, endurecido na ENG-3404) — espelho invertido da Qualidade: 6+
    -- recrutas ontem e MENOS de 45% voltando hoje cobra abandoned_initiates por recruta que não
    -- voltou. Entre 45% e 50% segue zona neutra (nem bônus nem penalidade), por isso os dois
    -- gates continuam sem compartilhar threshold.
    noQualityGatePct = 45,
    noQualityMinRecruitsYesterday = 6,

    presenceSampleIntervalSecs = 60,
    presenceSustainMinutes = 30,

    eliteMinOnline = 40,
    eliteWindowDays = 7,
    eliteMaxAwardsPerWindow = 3,

    activeMembersMinOnline = 25,

    bestRetentionWindowDays = 7,
    bestRetentionMinRecruits = 5,

    ratingWindowDays = 7,
    ratingMinAvg = 4.0,

    -- Alerta staff-side de recrutamento predatório (ENG-2646): org recrutando acima de N x a
    -- média da cidade com retorno D1 abaixo de X% entra em relatório interno. Não afeta o jogo.
    alertRecruitMultiplier = 3,
    alertMaxD1ReturnPct = 25,
    alertMinRecruits = 5, -- piso pra ter taxa significativa
    alertWebhook = 'orgRecruitmentAlert',

    -- Groups that live in `painel`/vRP but are not organizations (same exclusion the EventsSheets
    -- org caches apply). Compared lowercase.
    excludedGroups = { desempregado = true, iniciante = true },
}

-- Pódios físicos de organizações (ENG-2645/ENG-2890). Diferente do pódio da praça (Gente Boa), aqui NÃO há ped
-- nem appearance: cada pedestal recebe só uma DUI flutuante com o brasão da posição e o ALIAS da
-- organização. O alias já chega no client replicado em GlobalState['AliasGroup'] (painel/server/server.lua),
-- então o bag do pódio carrega apenas o nome da org e o client resolve o alias.
--
-- As coords são o mundo direto (não são offsets locais como no PODIUM_ANCHOR da praça).
OrgPodiumConfig = {

    refreshSecs = 60,   -- poll do snapshot ranking/podium (o ciclo é de 15 dias; não precisa ser agressivo)
    organizationTypes = { 'faction', 'legal' },

    interactLabelsByLanguage = {
        pt = 'Ver Ranking de Organizações',
        en = 'View Organization Ranking',
        es = 'Ver Ranking de Organizaciones',
        fr = 'Voir le Classement des Organisations',
        ar = 'عرض تصنيف المنظمات',
        de = 'Organisations-Rangliste ansehen',
    },

    sites = {
        Grande = {
            {
                interact = vector3( -1668.71,-1140.38,14.22 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1668.87, -1141.75, 14.43, 351.5 ),
                    [2] = vector4( -1667.02, -1141.92, 14.11,   0.0 ),
                    [3] = vector4( -1670.57, -1140.83, 13.73, 351.5 ),
                },
            },
            {
                interact = vector3( -1662.09,-1081.93,14.31 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1661.3,-1080.77,14.5,138.9 ),
                    [2] = vector4( -1663.09,-1080.02,14.18,141.74 ),
                    [3] = vector4( -1660.06,-1082.28,13.81,144.57 ),
                },
            },
            {
                interact = vector3( -1613.02,-996.18,13.45 ),
                slots = { -- CDS Grande (ENG-2890)
                    [1] = vector4( -1613.97, -995.23, 13.66, 223.94 ),
                    [2] = vector4( -1615.12, -997.06, 13.34, 226.78 ),
                    [3] = vector4( -1612.57, -994.21, 12.95, 223.94 ),
                },
            },
            {
                organizationType = 'legal',
                interact = vector3( 2533.35, -384.37, 94.12 ),
                slots = { -- ranking de organizações legais
                    [1] = vector4( 2533.64, -384.40, 94.46,  87.88 ),
                    [2] = vector4( 2533.07, -382.50, 94.14, 104.89 ),
                    [3] = vector4( 2533.35, -386.22, 93.75,  93.55 ),
                },
            },
        },
        Santa = {
            {
                interact = vector3( -1668.71,-1140.38,14.22 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1668.87, -1141.75, 14.43, 351.5 ),
                    [2] = vector4( -1667.02, -1141.92, 14.11,   0.0 ),
                    [3] = vector4( -1670.57, -1140.83, 13.73, 351.5 ),
                },
            },
            {
                interact = vector3( -1662.09,-1081.93,14.31 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1661.3,-1080.77,15.5,138.9 ),
                    [2] = vector4( -1663.09,-1080.02,15.18,141.74 ),
                    [3] = vector4( -1660.06,-1082.28,14.81,144.57 ),
                },
            },
            {
                interact = vector3( -1613.02,-996.18,13.45 ),
                slots = { -- CDS Grande (ENG-2890)
                    [1] = vector4( -1613.97, -995.23, 13.66, 223.94 ),
                    [2] = vector4( -1615.12, -997.06, 13.34, 226.78 ),
                    [3] = vector4( -1612.57, -994.21, 12.95, 223.94 ),
                },
            },
            {
                organizationType = 'legal',
                interact = vector3( 2533.35, -384.37, 94.12 ),
                slots = { -- ranking de organizações legais
                    [1] = vector4( 2533.64, -384.40, 94.46,  87.88 ),
                    [2] = vector4( 2533.07, -382.50, 94.14, 104.89 ),
                    [3] = vector4( 2533.35, -386.22, 93.75,  93.55 ),
                },
            },
        },
        CidadeNobre = {
            {
                interact = vector3( -1668.71,-1140.38,14.22 ),
                slots = { 
                    [1] = vector4( -1668.87, -1141.75, 14.43, 351.5 ),
                    [2] = vector4( -1667.02, -1141.92, 14.11,   0.0 ),
                    [3] = vector4( -1670.57, -1140.83, 13.73, 351.5 ),
                },
            },
            {
                interact = vector3( -1662.09,-1081.93,14.31 ),
                slots = { 
                    [1] = vector4( -1661.3,-1080.77,15.5,138.9 ),
                    [2] = vector4( -1663.09,-1080.02,15.18,141.74 ),
                    [3] = vector4( -1660.06,-1082.28,14.81,144.57 ),
                },
            },
            {
                interact = vector3( -1613.02,-996.18,13.45 ),
                slots = { 
                    [1] = vector4( -1613.97, -995.23, 13.66, 223.94 ),
                    [2] = vector4( -1615.12, -997.06, 13.34, 226.78 ),
                    [3] = vector4( -1612.57, -994.21, 12.95, 223.94 ),
                },
            },
            {
                organizationType = 'legal',
                interact = vector3( 2526.0, -377.86, 93.36 ),
                slots = { -- ranking de organizações legais (praça da Nobre)
                    [1] = vector4( 2525.69, -376.52, 94.63, 172.92 ),
                    [2] = vector4( 2524.08, -377.05, 94.31, 172.92 ),
                    [3] = vector4( 2527.77, -376.98, 93.92, 187.09 ),
                },
            },
        },
        Kingdom = {
            {
                interact = vector3( -1668.71,-1140.38,14.22 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1668.87, -1141.75, 14.43, 351.5 ),
                    [2] = vector4( -1667.02, -1141.92, 14.11,   0.0 ),
                    [3] = vector4( -1670.57, -1140.83, 13.73, 351.5 ),
                },
            },
            {
                interact = vector3( -1662.09,-1081.93,14.31 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1661.3,-1080.77,14.5,138.9 ),
                    [2] = vector4( -1663.09,-1080.02,14.18,141.74 ),
                    [3] = vector4( -1660.06,-1082.28,13.81,144.57 ),
                },
            },
            {
                interact = vector3( -1613.02,-996.18,13.45 ),
                slots = { -- CDS (ENG-2890)
                    [1] = vector4( -1613.97, -995.23, 13.66, 223.94 ),
                    [2] = vector4( -1615.12, -997.06, 13.34, 226.78 ),
                    [3] = vector4( -1612.57, -994.21, 12.95, 223.94 ),
                },
            },
            {
                organizationType = 'legal',
                interact = vector3( 2533.35, -384.37, 94.12 ),
                slots = { -- ranking de organizações legais
                    [1] = vector4( 2533.64, -384.40, 94.46,  87.88 ),
                    [2] = vector4( 2533.07, -382.50, 94.14, 104.89 ),
                    [3] = vector4( 2533.35, -386.22, 93.75,  93.55 ),
                },
            },
        },
        Royal = {
            {
                interact = vector3( -1668.71,-1140.38,14.22 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1668.87, -1141.75, 14.43, 351.5 ),
                    [2] = vector4( -1667.02, -1141.92, 14.11,   0.0 ),
                    [3] = vector4( -1670.57, -1140.83, 13.73, 351.5 ),
                },
            },
            {
                interact = vector3( -1662.09,-1081.93,14.31 ),
                slots = { -- pier (ENG-2645)
                    [1] = vector4( -1661.3,-1080.77,14.5,138.9 ),
                    [2] = vector4( -1663.09,-1080.02,14.18,141.74 ),
                    [3] = vector4( -1660.06,-1082.28,13.81,144.57 ),
                },
            },
            {
                interact = vector3( -1613.02,-996.18,13.45 ),
                slots = { -- CDS (ENG-2890)
                    [1] = vector4( -1613.97, -995.23, 13.66, 223.94 ),
                    [2] = vector4( -1615.12, -997.06, 13.34, 226.78 ),
                    [3] = vector4( -1612.57, -994.21, 12.95, 223.94 ),
                },
            },
            {
                organizationType = 'legal',
                interact = vector3( 2533.35, -384.37, 94.12 ),
                slots = { -- ranking de organizações legais
                    [1] = vector4( 2533.64, -384.40, 94.46,  87.88 ),
                    [2] = vector4( 2533.07, -382.50, 94.14, 104.89 ),
                    [3] = vector4( 2533.35, -386.22, 93.75,  93.55 ),
                },
            },
        },
    },

    card = {
        offsetZ       = 1.15,   -- altura da placa acima da coord do pedestal
        nearDistance  = 30.0,   -- cria/desenha a DUI só dentro desse raio
        unloadDelayMs = 5000,   -- destrói a DUI esse tempo depois de sair do raio (reentrar cancela)
        width         = 512,    -- canvas da DUI em px
        height        = 420,    -- canvas mais baixo que largo: as três placas ficam a ~2m uma da outra
        scale         = 0.07,   -- tamanho base do sprite em perspectiva
        minSizeDistance = 20.0, -- abaixo dessa distância, compensa para a placa não encolher mais
        maxScale      = 0.14,   -- limita a compensação quando o jogador chega muito perto
        facingMinDot  = 0.20,   -- só desenha com a câmera apontando pro pedestal (evita sprite espelhado atrás)
    },
}

OrgPodiumConfig.sites.Malta = OrgPodiumConfig.sites.Santa
OrgPodiumConfig.sites.Royal = OrgPodiumConfig.sites.Kingdom

-- Cidades novas usam os mesmos locais de Santa; locais especificos continuam acima.
for enabledCity, domains in pairs( RANKING_CITIES ) do

    if domains.orgs and not OrgPodiumConfig.sites[ enabledCity ] then
        OrgPodiumConfig.sites[ enabledCity ] = OrgPodiumConfig.sites.Santa
    end
end

---@param cityName? string -- default: a convar `cityName` deste servidor
---@return boolean enabled
function IsOrgPodiumEnabled( cityName )
    cityName = cityName or GetConvar( 'cityName', '' )
    return IsOrgRankingCityEnabled( cityName ) and OrgPodiumConfig.sites[ cityName ] ~= nil
end

-- Cada rank replica no seu próprio bag global, igual ao pódio da praça: um rank mudar não invalida os
-- outros dois no client.
---@param organizationType 'faction'|'legal'
---@param rank number
---@return string
function OrgPodiumBagKey( organizationType, rank )
    return ('orgRankingPodium:%s:%d'):format( organizationType, rank )
end

-- 'YYYY-MM-DD' start of the 15-day cycle containing `atTime` (defaults to now). Pure date math on
-- the anchor — negative indexes (dates before the anchor) floor correctly toward older cycles.
---@param atTime number?
---@return string cycleStart
---@return string cycleEnd -- exclusive ('YYYY-MM-DD' of the next cycle's first day)
function OrgCycleWindow( atTime )
    local anchor = OrgRankingConfig.cycleAnchor
    local anchorTs = os.time( { year = anchor.year, month = anchor.month, day = anchor.day, hour = 12 } )
    local t = os.date( '*t', atTime or os.time() )
    local dayTs = os.time( { year = t.year, month = t.month, day = t.day, hour = 12 } )
    local cycleIndex = math.floor( ( ( dayTs - anchorTs ) / 86400 ) / OrgRankingConfig.cycleDays )
    local startTs = anchorTs + cycleIndex * OrgRankingConfig.cycleDays * 86400
    local endTs = startTs + OrgRankingConfig.cycleDays * 86400
    return os.date( '%Y-%m-%d', startTs ), os.date( '%Y-%m-%d', endTs )
end
