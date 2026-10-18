shared_script '@likizao_ac/client/library.lua'
shared_script 'shared.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_script '@sx/linker.lua'

ui_page "web-side/index.html"

shared_scripts {
	'translations.lua',
	'shared/world_grid.lua',
	'shared/door_system.lua',
	'shared/door_system.types.lua',
}

client_scripts {
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