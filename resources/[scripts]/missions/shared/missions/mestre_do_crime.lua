local REQUIRED_MISSIONS = {
    'vestir_uniforme',
    'entrar_na_radio',
    'farm_e_deposito_bau',
    'farm_coletivo',
    'conhecer_novos_farms',
    'roubo_atm',
    'roubo_lojinha',
    'arena_pista',
    'arena_1x1',
    'primeiro_bico',
    'parceiro_de_crime',
    'lenda_criminal',
}

DEFINE_MISSION 'mestre_do_crime' {
    group = eMissionGroup.Criminal,
    order = 17,
    enabled = false,
    name = _t("mission.mestre_do_crime.name"),
    description = _t("mission.mestre_do_crime.description"),
    icon = "https://cdn.santagroup.gg/onboarding/band.svg",
    rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = _t("reward.tooltip.farm_3000")
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    rewards = {
        farm = 3000,
        skills = { crime = 1000 },
        title = _t("mission.mestre_do_crime.reward.title"),
    },
    metadata = {
        hook = "missions:hook:crime_master_completed",
        required_missions = REQUIRED_MISSIONS,
        onBeforeComplete = function( passport, extraData )
            for i = 1, #REQUIRED_MISSIONS do
                local missionId = REQUIRED_MISSIONS[i]
                if not IsMissionCompleted( passport, missionId ) then
                    return false, (_t("notify.mission_pending")):format( missionId )
                end
            end
            return true
        end,
    },
}
