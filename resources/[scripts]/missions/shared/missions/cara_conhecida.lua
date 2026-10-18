DEFINE_MISSION "cara_conhecida" {
	group = eMissionGroup.Connect,
	order = 8,
	name = _t("mission.cara_conhecida.name"),
	description = _t("mission.cara_conhecida.description"),
	icon = "https://cdn.santagroup.gg/onboarding/cara_conhecida.svg",
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
		skills = { social = 140 },
	},
	metadata = {
		hook = "missions:hook:tuplet_like_sent",
	},
}
