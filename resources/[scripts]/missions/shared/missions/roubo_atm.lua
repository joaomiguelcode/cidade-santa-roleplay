DEFINE_MISSION 'roubo_atm' {
    group = eMissionGroup.Criminal,
    order = 6,
    enabled = false,
    name = _t("mission.roubo_atm.name"),
    description = _t("mission.roubo_atm.description"),
    icon = "https://cdn.santagroup.gg/onboarding/band.svg",
    rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "250 farm"
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    rewards = {
        skills = { crime = 150 },
        farm = 250,
    },
    metadata = {
        hook = "missions:hook:roubo_atm_completed"
    },
}
