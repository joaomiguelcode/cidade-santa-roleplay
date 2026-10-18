shared_script '@likizao_ac/client/library.lua'

fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

version '1.3.0'

shared_scripts {
	"@ox_lib/init.lua",
	'@sx/linker.lua',
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'imgs/*',
	'@ox_inventory/data/vehicles.lua',
	'imports/*.lua',
	'classes/*.lua',
	'bridge/**/client.lua',
}

server_scripts {
	'server/*.lua'
}

client_script {
  "@vrp/config/Themes.lua",
	'bridge/init.lua',
	"init.lua",
	'exports/*.lua',
	'client/*.lua',
}
