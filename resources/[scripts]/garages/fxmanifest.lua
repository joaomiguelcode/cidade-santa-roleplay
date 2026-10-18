-- shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_scripts {
	'@ox_lib/init.lua',
	'@sx/linker.lua',
	'translations.lua',
	'shared/vehicle_packing.lua',
	'shared/damagestates.lua',
	'shared/bulletproof.lua',
	'shared/vehicletypes.lua',
	'shared/whitelistdelete.lua',
	'shared/minigame-access.lua',
    'shared.lua',
    'shared/livery.lua',	
}

client_scripts {
    '@sleepless_interact/init.lua',
	"@vrp/config/Themes.lua",
	"@vrp/config/Native.lua",
    "@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	"client/core.lua",
	"client/bulletproof-damage.lua",
	"client/parsevehicles.lua",
}

server_scripts {
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	'server/vehicle-chest-computation.lua',
	"server/core.lua",
	"server/bulletproof-damage.lua",
	"server/temp-vehicle-chest-migration.lua",
	"server/impound.lua",
	"server/propertys.lua",
    "server/parsevehicles.lua",
    "server/blacklist.lua",
	"server/rental-vips.lua",
}

files {
	"web/*",
	"web/**/*",
    "servers/*.lua",
}
