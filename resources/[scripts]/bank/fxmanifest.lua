fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
    'translations.lua',
    '@sleepless_interact/init.lua',
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
    'translations.lua',
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/**/**"
}
