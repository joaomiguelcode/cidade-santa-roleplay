shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

shared_scripts {
	"@vrp/config/Groups.lua",
	"shared-side/core.lua",
    "translations.lua",
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*"
}