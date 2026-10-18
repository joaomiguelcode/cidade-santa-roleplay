shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'

game 'gta5'

lua54 'yes'

shared_scripts {
	'@sx/linker.lua',
	'@vrp/lib/Utils.lua',
	'init.lua',
	'shared/**/*.lua',
}

server_scripts {
	'code/server/config.lua',
	'code/server/fireworks.lua',
	-- 'gifts/server/**/*.lua',
}

client_scripts {
	'@sleepless_interact/init.lua',
	'code/client/fireworks.lua',
	-- 'gifts/client/**/*.lua',
}