shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_scripts {
    "translations.lua",
	"shared-side/*",
    "@ox_lib/init.lua",
	"@vrp/lib/Utils.lua",
	'@sx/linker.lua',
	"shared-side/*",
}

client_scripts {
    '@sleepless_interact/init.lua',
    "@vrp/config/Themes.lua",
	"@vrp/config/Native.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
    "@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
	"client-side/core.lua",
	"client-side/afkfarm.lua",
	"client-side/mining.lua",
	-- "client-side/routes.lua",
	"client-side/jobs.lua",
	"client-side/bus.lua",
	"client-side/farmer.lua",
	"client-side/firedepartment.lua",
	-- "client-side/farm.lua",
	"client-side/pilot.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"server-side/core.lua",
	"server-side/afkfarm.lua",
	-- "server-side/routes.lua",
    "server-side/jobs.lua",
    "server-side/bus.lua",
    "server-side/farmer.lua",
    "server-side/firedepartment.lua",
    -- "server-side/farm.lua",
    "server-side/pilot.lua",
}


shared_scripts {
	'minigame/data/minigame_def_database.lua',

	'minigame/shared/minigamedef.lua',
	'minigame/shared/minigamepoint.lua',
	'minigame/shared/minigame.lua',

	'minigame/data/minigames/**/*.lua',

	'staffgang/shared/main.lua',
	'staffgang/shared/templates/cds.lua',
	'staffgang/shared/templates/fishing.lua',
	'staffgang/shared/templates/milking.lua',
	'staffgang/shared/templates/faction_farms.lua',
	'staffgang/shared/runtime_minigames.lua',
}

server_scripts {
	'minigame/server/minigame.lua',
	'minigame/server/minigamesec.lua',
	'minigame/server/customfarms.lua',

	"staffgang/server/main.lua",
	"staffgang/server/repository.lua",
	"staffgang/server/use-cases/farm.lua",
	"staffgang/server/use-cases/point.lua",
	"staffgang/server/use-cases/shop.lua",
	"staffgang/server/use-cases/runtime.lua",
	"staffgang/server/routes/farm.lua",
	"staffgang/server/routes/point.lua",
	"staffgang/server/routes/shop.lua",
	"staffgang/server/routes/runtime.lua",
}

client_scripts {
	'minigame/client/minigamepoint.lua',
	'minigame/client/minigame_update.lua',
	'minigame/client/minigame_update_init.lua',
	'minigame/client/minigame.lua',
	'minigame/client/farm_ghost.lua',

	"staffgang/client/main.lua",
	"staffgang/client/form.lua",
}
