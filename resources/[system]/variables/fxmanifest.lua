shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'

dependency 'lib'

shared_scripts {
	'@lib/index.lua',
	'@lib/instance.lua',
	'functions.lua',
	'core.lua',
	'config/*'
}

client_scripts {
    "@vrp/config/Themes.lua",
	"@vrp/config/Native.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@vrp/lib/Utils.lua",
}