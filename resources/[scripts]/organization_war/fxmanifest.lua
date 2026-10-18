shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_scripts {
    "@ox_lib/init.lua",
	"@vrp/lib/Utils.lua",
    "shared.lua",
}
client_scripts {
	"@vrp/config/Native.lua",
    "@vrp/config/Global.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server/server.lua",
	"server/event.lua"
}

files {
	'web/index.html',
	'web/*',
	'web/assets/*',
	'web/assets/weapons/*'
}

ui_page 'web/index.html'
