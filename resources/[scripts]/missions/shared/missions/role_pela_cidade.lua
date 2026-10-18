DEFINE_MISSION "role_pela_cidade" {
	enabled = false,
	group = eMissionGroup.Connect,
	order = 10,
	name = _t("mission.role_pela_cidade.name"),
	description = _t("mission.role_pela_cidade.description"),
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
		skills = { driving = 150, social = 150 },
	},
	metadata = {
		hook = "missions:hook:city_joyride_completed",
	},
}
