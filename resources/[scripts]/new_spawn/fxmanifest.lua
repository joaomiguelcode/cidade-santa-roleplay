-- shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

lua54 'yes'

ui_page "web/index.html"

shared_script 'translations.lua'
shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'

client_scripts {
    "client/native_debug.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
    "@vrp/config/Themes.lua",
	"@vrp/config/Native.lua",
	"client/client.lua",
	"client/camera.lua",
	"client/new_camera/class.lua",
	"client/new_camera/config.lua",
	"client/new_camera/camera.lua",
	"client/new_camera/scene.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"server/server.lua",
	"server/prepare.lua",
}

shared_scripts {
    "translations.lua",
	"shared/*"
}

files {
	"web/*",
	"web/**/*"
}
