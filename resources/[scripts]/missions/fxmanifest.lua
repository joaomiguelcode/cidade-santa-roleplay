shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_scripts {
	"@ox_lib/init.lua",
	'@sx/linker.lua',
	'translations.lua',
    'shared/missions_groups.lua',
    'shared/missions_def.lua',
    'shared/missions_group_def.lua',
    'shared/missions_flags.lua',
    'shared/missions_ramo.lua',
    'shared/skill_def.lua',
    'shared/skills/*.lua',
	'shared/guided_route_definitions.lua',
	'shared/missions/*.lua',
}

client_scripts {
    '@sleepless_interact/init.lua',
	"@vrp/config/Themes.lua",
	"@vrp/config/Native.lua",
    "@vrp/config/Vehicle.lua",
	"@vrp/config/Groups.lua",
	"@vrp/lib/Utils.lua",
	"client/core.lua",
	"client/waypoints.lua",
	"client/guided_route.lua",
	"client/guided_route_mission_bridge.lua",
	"client/missions/*.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	"server/prepare.lua",
	"server/core.lua",
	"server/skills.lua",
	"server/rewards.lua",
	"server/missions.lua",
	"server/welcome.lua",
	"server/master_crime.lua",
}

files {
	"web/*",
	"web/**/*",
	"shared/onboarding_index.lua",
}
