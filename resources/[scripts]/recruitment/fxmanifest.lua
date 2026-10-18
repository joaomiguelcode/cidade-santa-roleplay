shared_script '@likizao_ac/client/library.lua'
shared_script "shared.lua"

fx_version "adamant"
lua54 "yes"
game "gta5"
use_experimental_fxv2_oal "yes"

ui_page "client/web/index.html"

client_scripts {
    "translations.lua",
    "@vrp/config/Themes.lua",
	"@vrp/lib/Utils.lua",
    "client/utils.lua",
    "client/main.lua",
}

server_scripts {
    "translations.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@vrp/lib/Utils.lua",
    "@vrp/config/Groups.lua",
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua"
}

files {
    "client/web/*",
    "client/web/**/*"
}