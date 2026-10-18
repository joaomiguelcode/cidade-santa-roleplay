DEFINE_MISSION "nova_familia" {
	group = eMissionGroup.Connect,
	order = 3,
	name = _t("mission.nova_familia.name"),
	description = _t("mission.nova_familia.description"),
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
		skills = { social = 160 },
		title = _t("mission.nova_familia.reward.title"),
	},
	metadata = {
		hook = "missions:hook:recruitment_accepted",
		hide_when_employed = true,
	},
}
