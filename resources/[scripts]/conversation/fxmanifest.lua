fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_scripts {
	'@vrp/lib/Utils.lua',
	'init.lua',
	'@ox_lib/init.lua',
	'@sleepless_interact/init.lua',
	'@sx/linker.lua',
}

ui_page "web/index.html"

client_scripts {
	'code/client/*.lua',
}

files {
	'web/**/**/*',
}
