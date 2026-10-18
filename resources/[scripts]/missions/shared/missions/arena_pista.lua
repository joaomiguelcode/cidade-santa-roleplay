DEFINE_MISSION 'arena_pista' {
    group = eMissionGroup.Criminal,
    order = 7,
    enabled = false, 
    name = _t("mission.arena_pista.name"),
    description = _t("mission.arena_pista.description"),
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
        skills = { driving = 200 },
        farm = 250,
    },
    metadata = {
        hook = "missions:hook:arena_pista_completed"
    },
}
