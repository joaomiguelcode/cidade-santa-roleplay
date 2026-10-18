shared_script '@likizao_ac/client/library.lua'
shared_script 'translations.lua'
shared_script '/shared/*.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

shared_script '@sx/linker.lua'

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/*",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"@vrp/lib/Utils.lua",
	"@vrp/config/Vehicle.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*",

}

shared_scripts {
	'new/entitlements/code/shared/entitlement_feature_def.lua',

	'new/collectibles/code/shared/animation_flags.lua',

	'new/collectibles/code/shared/collectible_def.lua',
	
	'new/collectibles/data/collectibles/**/*.lua',

	'new/collectibles/code/shared/queriable.lua',
	'new/collectibles/code/shared/me_collectibles_query.lua',
}

client_scripts {
	'new/collectibles/code/client/collectibles.lua',
	'new/collectibles/code/client/net-collectibles.lua',
}

server_scripts {
	'new/entitlements/data/server/entitlements/**/*.lua',

	'new/entitlements/code/server/entitlements.lua',
	'new/entitlements/code/server/main.lua',
	'new/entitlements/migrations/**/*.lua',

	'new/collectibles/migrations/001-create-collectibles.lua',
	'new/collectibles/migrations/002-create-collectible-pets.lua',

	'new/collectibles/code/server/pets.lua',
	'new/collectibles/code/server/collectibles.lua',
	'new/collectibles/code/server/main.lua',
}



client_script 'cl_weaponNames.lua'


dependency 'scripted_interactions'
