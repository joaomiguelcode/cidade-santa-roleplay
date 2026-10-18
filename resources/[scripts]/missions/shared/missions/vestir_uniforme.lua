DEFINE_MISSION "vestir_uniforme" {
	group = eMissionGroup.Criminal,
	order = 1,
	name = _t("mission.vestir_uniforme.name"),
	description = _t("mission.vestir_uniforme.description"),
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
		title = _t("mission.vestir_uniforme.reward.title"),
	},
	metadata = {
		hook = "missions:hook:fac_uniform_worn",
	},
}
