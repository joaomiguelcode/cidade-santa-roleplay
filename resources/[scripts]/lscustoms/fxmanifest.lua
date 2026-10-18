shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
    "@vrp/config/Vehicle.lua",
    "translations.lua",
	"config.lua",
	"client-side/*",
}

server_scripts {
    "@vrp/lib/Utils.lua",
    "@vrp/config/Vehicle.lua",
    "translations.lua",
	"config.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}