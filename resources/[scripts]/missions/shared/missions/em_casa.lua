DEFINE_MISSION "em_casa" {
	group = eMissionGroup.Connect,
	order = 6,
	name = _t("mission.em_casa.name"),
	description = _t("mission.em_casa.description"),
	icon = "https://cdn.santagroup.gg/onboarding/em_casa.svg",
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
		skills = { social = 100 },
	},
	metadata = {
		hook = "missions:hook:city_active_time_completed",
	},
}
