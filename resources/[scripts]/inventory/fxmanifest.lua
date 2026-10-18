shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_script '@sx/linker.lua'

shared_scripts {
	'shared/**',
	'@ox_lib/init.lua',
}

client_scripts {
   '@sleepless_interact/init.lua',
    "@vrp/config/Themes.lua",
	"@vrp/config/Native.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"translations.lua",
	"client/main.lua",
	"client/inventory/main.lua",
    "server/shops/config.lua",
	"client/shops/main.lua",
	"client/trunkchest/main.lua",
	"client/chest/chest.lua",
	"client/chest/main.lua",
	"client/chestpermission/main.lua",
	"client/factionarsenal/main.lua",
	"client/factiontrade/main.lua",
	"client/properties/main.lua",
	"client/inspect/main.lua",
	"client/deliver/main.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@vrp/lib/Utils.lua",
    "translations.lua",
	"server/migrations/legacy-item-rename.lua",
	"server/inventory/temporaryExclusiveWeapons.lua",
	"server/main.lua",
	"server/inventory/config.lua",
	"server/inventory/main.lua",
	"server/inventory/deliver.lua",
	"server/shops/config.lua",
	"server/shops/main.lua",
	"server/trunkchest/main.lua",
	"server/chestpermission/main.lua",
	"server/chest/main.lua",
	"server/factionarsenal/main.lua",
	"server/factiontrade/prices.lua",
	"server/factiontrade/main.lua",
	"client/chest/chest.lua",
	"server/properties/main.lua",
	"server/inspect/main.lua",
    "server/itemSpawn.lua"
}

files {
	"web/*",
	"web/**/*"
}