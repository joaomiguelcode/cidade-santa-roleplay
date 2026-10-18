DEFINE_MISSION "boa_impressao" {
	enabled = false,
	group = eMissionGroup.Connect,
	order = 9,
	name = _t("mission.boa_impressao.name"),
	description = _t("mission.boa_impressao.description"),
	icon = "https://cdn.santagroup.gg/onboarding/boa_impress_o.svg",
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
		hook = "missions:hook:tuplet_like_received",
	},
}
