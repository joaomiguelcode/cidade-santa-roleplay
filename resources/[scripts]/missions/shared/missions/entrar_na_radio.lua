DEFINE_MISSION 'entrar_na_radio' {
	
	group = eMissionGroup.Criminal,

	order = 2,

	name = _t('mission.entrar_na_radio.name'),

	description = _t('mission.entrar_na_radio.description'),

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
		title = _t('mission.entrar_na_radio.reward.title'),
	},

	metadata = {
		hook = 'missions:hook:fac_radio_joined',
	},
}
