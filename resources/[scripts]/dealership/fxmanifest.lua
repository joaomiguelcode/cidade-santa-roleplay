shared_script '@sx/linker.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_scripts {
	'shared/main.lua',
}

client_scripts {
    '@sleepless_interact/init.lua',
    "translations.lua",
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Global.lua",
	"client/main.lua",
	"client/converter.lua"
}

server_scripts {
    "translations.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	"server/main.lua",
	"server/converter.lua"
}

files {
	'web/**/**'
}
