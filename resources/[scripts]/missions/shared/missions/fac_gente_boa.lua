DEFINE_MISSION "fac_gente_boa" {
    group = eMissionGroup.Social,
    order = 1,
    name = _t("mission.fac_gente_boa.name"),
    description = _t("mission.fac_gente_boa.description"),
    icon = "https://cdn.santagroup.gg/onboarding/nova_fam_lia.svg",
    dependencies = {},
    flags = eMissionFlags.NONE,
    rewards = {},
    metadata = {
        recurring_count = true,
        count_step = 15,
        count_increment = 15,
        faction_owner_only = true,
    },
}
