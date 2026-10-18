fx_version("bodacious")
game("gta5")
lua54("yes")

ui_page("web/index.html")

shared_scripts({
	"@sx/linker.lua",
	"@ox_lib/init.lua", -- Q.A temporário
	"@likizao_ac/client/library.lua",
	"shared/*.lua",
	-- "Q.A/shared/*.lua",
})

client_scripts({
	"translations.lua",
	"@vrp/config/Native.lua",
	"@vrp/config/Vehicle.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"client/functions.lua",
	"client/main.lua",
	-- "Q.A/client/*.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"translations.lua",
	"@vrp/lib/Utils.lua",
	"@vrp/config/Vehicle.lua",
	"server/main.lua",
	"server/functions.lua",
})

files({
	"web/*",
	"web/**/*",
})
