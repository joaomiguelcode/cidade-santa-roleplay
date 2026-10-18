shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
    "translations.lua",
	"@vrp/config/Native.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"client/main.lua",
    
	"client/hot-bar/main.lua",
	"client/taskbar/main.lua",
	"client/hoverfy/main.lua"
}

server_scripts {
    "translations.lua",
    "@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@vrp/lib/Utils.lua",
	"server/main.lua"
}

files {
	"web-side/*",
	"web-side/**/*"
}