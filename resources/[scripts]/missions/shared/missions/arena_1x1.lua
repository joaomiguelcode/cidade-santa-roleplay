DEFINE_MISSION 'arena_1x1' {
    group = eMissionGroup.Criminal,
    order = 9,
    enabled = false,
    name = _t("mission.arena_1x1.name"),
    description = _t("mission.arena_1x1.description"),
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
        skills = { shooting = 250 },
        farm = 250,
    },
    metadata = {
        hook = "missions:hook:arena_1x1_completed"
    },
}
