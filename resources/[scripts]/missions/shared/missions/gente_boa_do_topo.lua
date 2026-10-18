DEFINE_MISSION "gente_boa_do_topo" {
    group = eMissionGroup.Social,
    order = 1,
    name = _t("mission.gente_boa_do_topo.name"),
    description = _t("mission.gente_boa_do_topo.description"),
    icon = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
    rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    rewards = {
        skills = { social = 150 },
    },
    metadata = {
        hook = "missions:hook:retention_d1",
        recurring_count = true,
        count_step = 10,
        count_multiplier = 2,
        hide_for_faction_owner = true,
    },
}
