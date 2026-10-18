DEFINE_MISSION 'primeiro_bico' {
    group = eMissionGroup.Criminal,
    order = 10,
    enabled = false,
    name = _t("mission.primeiro_bico.name"),
    description = _t("mission.primeiro_bico.description"),
    icon = "https://cdn.santagroup.gg/onboarding/band.svg",
    rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "300 farm"
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    rewards = {
        skills = { crime = 150, shooting = 50 },
        farm = 300,
    },
    metadata = {
        hook = "missions:hook:robbery_completed"
    },
}
