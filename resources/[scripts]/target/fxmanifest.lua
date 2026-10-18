shared_script '@likizao_ac/client/library.lua'
shared_script 'shared.lua'
shared_script 'translations.lua'

shared_script '@sx/linker.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

dependencies {
    "PolyZone"
}

ui_page "web-side/index.html"

client_scripts {
    '@sleepless_interact/init.lua',
	"@vrp/config/Native.lua",
    "@vrp/config/Groups.lua",
	"@vrp/lib/Utils.lua",
	"@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
    "translations.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*"
}