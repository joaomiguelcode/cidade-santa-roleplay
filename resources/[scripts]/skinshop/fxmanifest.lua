shared_script '@likizao_ac/client/library.lua'
shared_script '@sx/linker.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_script {
	'@ox_lib/init.lua',
	"shared-side/clothing_rule_types.lua",
	"shared.lua"
}

client_scripts {
	'translations.lua',
    '@sleepless_interact/init.lua',
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/clothing_rules_preview.lua",
	"client-side/core.lua",
	"client-side/clothing_rules_menu.lua"
}

server_scripts {
    'translations.lua',
	"@vrp/lib/Utils.lua",
	"@oxmysql/lib/MySQL.lua",
	"server-side/core.lua",

	"server-side/clothing_rules/main.lua",
	"server-side/clothing_rules/repository.lua",
	"server-side/clothing_rules/service.lua",
	"server-side/clothing_rules/routes.lua",
}

files {
	"web/*",
	"web/**/*"
}
