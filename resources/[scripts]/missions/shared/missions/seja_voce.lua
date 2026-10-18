local WP_ICON = "https://cdn.santagroup.gg/a5de5927-49d4-4ce3-a837-928592583cc4-cloth.svg"
local WP_INDICATOR_DISTANCE = 80.0
local WP_MARKER_DISTANCE = 200.0
local WP_ENTER_DISTANCE = 5.0
local function waypointRemoveSelf(waypointId)
	exports.hud:waypointRemove(waypointId)
end

local function makeWaypoint(coords, titleKey)
	return {
		coords = coords,
		title = _t(titleKey),
		icon = WP_ICON,
		indicatorDistance = WP_INDICATOR_DISTANCE,
		markerDistance = WP_MARKER_DISTANCE,
		seeThroughWalls = true,
		alwaysVisibleDui = true,
		-- onWaypointEnter = {
		-- 	distance = WP_ENTER_DISTANCE,
		-- 	action = waypointRemoveSelf,
		-- },
	}
end
local function appendWaypointsFromCoords(dst, coordsList, titleKey)
	for i = 1, #coordsList do
		dst[#dst + 1] = makeWaypoint(coordsList[i], titleKey)
	end
end
-- Coords espelham os scripts (só xyz): skinshop Skinshops ~141–164; character-creator barbershop ~2–7; tattooshop ~2201–2205.
local SEJA_VOCE_LOCATION_GROUPS = {
	{
		titleKey = "mission.seja_voce.waypoint.clothing",
		coords = {
			vec3(74.88, -1400.08, 29.37),
			vec3(80.42, -1400.13, 29.37),
			vec3(-713.98, -146.54, 37.41),
			vec3(-708.26, -160.93, 37.41),
			vec3(-158.55, -296.5, 39.73),
			vec3(-165.56, -310.29, 39.73),
			vec3(-828.15, -1076.28, 11.32),
			vec3(-825.73, -1081.25, 11.32),
			vec3(-1198.52, -770.74, 17.32),
			vec3(-1457.27, -241.59, 49.81),
			vec3(-1445.59, -231.6, 49.81),
			vec3(9.86, 6516.37, 31.88),
			vec3(6.33, 6520.67, 31.88),
			vec3(1693.52, 4829.39, 42.06),
			vec3(1688.13, 4828.75, 42.06),
			vec3(128.66, -218.03, 54.56),
			vec3(614.17, 2756.72, 42.09),
			vec3(1190.18, 2710.78, 38.22),
			vec3(1190.29, 2705.29, 38.22),
			vec3(-3167.44, 1049.23, 20.86),
			vec3(-1105.96, 2707.06, 19.11),
			vec3(-1102.86, 2702.64, 19.11),
			vec3(426.2, -800.22, 29.49),
			vec3(420.57, -800.05, 29.49),
			vec3(-1691.54,-1127.43,14.01),
			vec3(-1050.32, -2011.89, 13.16),
			vec3(1133.63, -1518.37, 34.84),
			vec3(86.06,-1391.64,29.23),
			vec3(-719.94,-158.18,37.0),
			vec3(-152.79,-306.79,38.67),
			vec3(-816.39,-1081.22,11.12),
			vec3(-1206.51,-781.5,17.12),
			vec3(-1458.26,-229.79,49.2),
			vec3(-2.41,6518.29,31.48),
			vec3(1682.59,4819.98,42.04),
			vec3(129.46,-205.18,54.51),
			vec3(618.49,2745.54,42.01),
			vec3(1197.93,2698.21,37.96),
			vec3(-3165.74,1061.29,20.84),
			vec3(-1093.76,2703.99,19.04),
			vec3(414.86,-807.57,29.34),
		},
	},
	{
		titleKey = "mission.seja_voce.waypoint.barber",
		coords = {
			vec3(-813.37, -183.85, 37.57),
			vec3(138.13, -1706.46, 29.3),
			vec3(-1280.92, -1117.07, 7.0),
			vec3(1930.54, 3732.06, 32.85),
			vec3(1214.2, -473.18, 66.21),
			vec3(-33.61, -154.52, 57.08),
		},
	},
	{
		titleKey = "mission.seja_voce.waypoint.tattoo",
		coords = {
			vec3(1321.46, -1653.91, 52.27),
			vec3(-1155.66, -1427.18, 4.95),
			vec3(324.47, 180.0, 103.59),
			vec3(-3169.29, 1077.59, 20.83),
			vec3(1864.45, 3746.73, 33.03),
			vec3(-1712.14,-1113.10,14.01),
		},
	},

}

local waypoints = {}

for g = 1, #SEJA_VOCE_LOCATION_GROUPS do
	local group = SEJA_VOCE_LOCATION_GROUPS[g]

	appendWaypointsFromCoords(waypoints, group.coords, group.titleKey)
end

local missionCoords = {}

for i = 1, #SEJA_VOCE_LOCATION_GROUPS do
	local group = SEJA_VOCE_LOCATION_GROUPS[i]
	for j = 1, #group.coords do
		missionCoords[#missionCoords + 1] = group.coords[j]
	end
end

DEFINE_MISSION "seja_voce" {
	group = eMissionGroup.Connect,
	order = 2,
	name = _t("mission.seja_voce.name"),
	description = _t("mission.seja_voce.description"),
	icon = "https://cdn.santagroup.gg/onboarding/seja_voce.svg",
	rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        }
    },
	dependencies = { },
	flags = eMissionFlags.NONE,
	auto_activate = true,
	coords = missionCoords,
	rewards = {
		skills = { social = 130 },
		title = _t("mission.seja_voce.reward.title"),
	},
	metadata = {
		waypoints = waypoints,
		hook = "mark_seja_voce_seen",
	},
}
