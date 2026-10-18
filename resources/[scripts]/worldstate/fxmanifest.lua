shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_script '@vrp/lib/Utils.lua'

shared_scripts {

	'shared/worldstate.lua',
	'shared/worldstate_clock.lua',
	'shared/worldstate_weather.lua',
}

client_scripts {
	'translations.lua',
	'client/gmtime.lua',
	'client/local_worldstate_clock.lua',
	'client/local_worldstate_weather.lua',
	'client/local_worldstatesync.lua',
	'client/local_worldstatecommand.lua',
	'client/main.lua',
}

server_scripts {
	'server/global_worldstate_clock.lua',
	'server/global_worldstate_weather.lua',
	'server/global_worldstatesync.lua',
	'server/global_worldstatecommand.lua',
	'server/main.lua',
}
