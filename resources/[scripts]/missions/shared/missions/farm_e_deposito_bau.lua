DEFINE_MISSION 'farm_e_deposito_bau' {
	group = eMissionGroup.Criminal,

	order = 3,
	enabled = false,

	name = _t('mission.farm_e_deposito_bau.name'),

	description = _t('mission.farm_e_deposito_bau.description'),

	icon = "https://cdn.santagroup.gg/onboarding/band.svg",

	rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "150 farm"
        }
    },

	dependencies = {},

	flags = eMissionFlags.REQUIRES_FAC,

	auto_activate = true,

	rewards = {
		farm = 150,
		skills = { crime = 100 },
		title = _t('mission.farm_e_deposito_bau.reward.title'),
	},

	metadata = {
		hook = 'missions:hook:fac_farm_chest_deposited',
	},
}
