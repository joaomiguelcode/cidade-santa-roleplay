shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

lua54 'yes'

ui_page "web/index.html"

loadscreen "web/loading/index.html"
loadscreen_cursor "yes"
loadscreen_manual_shutdown "yes"

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'

client_scripts {
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"client/client.lua",
    "client/tos.lua",
    "client/playerdata.lua",
    "client/discord.lua",
    "client/whatsapp.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"server/server.lua",
    "server/influencers.lua",
    "server/app.lua",
    "server/tos.lua",
    "server/playerdata.lua",
    "server/discord.lua",
    "server/whatsapp.lua",
    "server/loadscreen-token.js",
    "server/loadscreen.lua",
}

shared_scripts {
    "translations.lua",
    "shared.lua",
	"shared/*"
}

files {
	"web/*",
	"web/**/*"
}
