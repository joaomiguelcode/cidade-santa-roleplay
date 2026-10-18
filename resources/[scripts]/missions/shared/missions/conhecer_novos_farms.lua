DEFINE_MISSION "conhecer_novos_farms" {
	group = eMissionGroup.Criminal,
	order = 5,
	enabled = false,
	name = _t("mission.conhecer_novos_farms.name"),
	description = _t("mission.conhecer_novos_farms.description"),
	icon = "https://cdn.santagroup.gg/onboarding/band.svg",
	rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "100 farm"
        }
    },
	dependencies = {},
	flags = eMissionFlags.REQUIRES_FAC,
	auto_activate = true,
	rewards = {
		farm = 100,
		skills = { social = 50 },
		title = _t("mission.conhecer_novos_farms.reward.title"),
	},
	metadata = {
		hook = "missions:hook:fac_new_farms_opened",
	},
}
