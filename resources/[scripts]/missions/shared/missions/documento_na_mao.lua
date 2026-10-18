local function waypointRemoveSelf(waypointId)
	exports.hud:waypointRemove(waypointId)
end

DEFINE_MISSION "documento_na_mao" {
	group = eMissionGroup.Connect,
	order = 5,
	name = _t("mission.documento_na_mao.name"),
	description = _t("mission.documento_na_mao.description"),
	icon = "https://cdn.santagroup.gg/onboarding/documento_na_m_o.svg",
	rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        }
    },
	dependencies = {},
	flags = eMissionFlags.NONE,
	auto_activate = true,
	coords = { CONNECT_ONBOARDING_DOCUMENTO_COORDS },
	rewards = {
		skills = { social = 150 },
		title = _t("mission.documento_na_mao.reward.title"),
	},
	metadata = {
		hook = "missions:hook:passport_issued",
		waypoints = {
			{
				coords = CONNECT_ONBOARDING_DOCUMENTO_COORDS,
				title = _t("mission.documento_na_mao.waypoint.title"),
                icon = "https://cdn.santagroup.gg/403b61a9-8fba-44cb-9bc8-0aa964814e21-city.svg",
				family = 'mission_documento',
				seeThroughWalls = true,
				alwaysVisibleDui = true,
				-- onWaypointEnter = { distance = 5.0, action = waypointRemoveSelf },
			},
		},
	},
}
