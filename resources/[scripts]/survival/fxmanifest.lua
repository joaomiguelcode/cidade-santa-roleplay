shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

shared_script {
	'@ox_lib/init.lua',
	"shared/kill-phrase-sounds.lua",
	"shared.lua",
	'@sx/linker.lua',
}

client_scripts {
   "translations.lua",
	"@vrp/config/Death.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "translations.lua",
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}
