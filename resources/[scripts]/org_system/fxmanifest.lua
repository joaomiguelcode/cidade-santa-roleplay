shared_script '@likizao_ac/client/library.lua'

fx_version "cerulean"
game "gta5"
lua54 "yes"

shared_scripts {
    "@vrp/lib/Utils.lua",
    'shared/shared.lua',
    'shared/shared_functions.lua',
}

client_scripts {
	"@vrp/config/Native.lua",
	"@PolyZone/client.lua",
    "@vrp/config/Vehicle.lua"
}

server_scripts {
    "@vrp/config/Vehicle.lua"
}