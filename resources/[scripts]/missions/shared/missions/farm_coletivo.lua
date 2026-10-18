DEFINE_MISSION 'farm_coletivo' {
    group = eMissionGroup.Criminal,
    order = 4,
    enabled = false,
    name = _t("mission.farm_coletivo.name"),
    description = _t("mission.farm_coletivo.description"),
    icon = "https://cdn.santagroup.gg/onboarding/band.svg",
    rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "150 farm"
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    rewards = {
        skills = { crime = 75, social = 75 },
        farm = 150,
    },
    metadata = {
        hook = "missions:hook:farm_coletivo_completed"
    },
}
