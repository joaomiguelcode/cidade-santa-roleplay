shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

author 'DeadShot#0101,Andre BC#0640'
description 'painel'
version '0.0.1'

lua54 'yes'

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'

shared_scripts {
    'shared.lua',
    'translations.lua',
    'shared_farm.lua',
    'shared/recruit_config.lua',
}

client_scripts {
    "@vrp/lib/Utils.lua",
    "@vrp/config/Groups.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
    'client/client.lua',
    'client/bank.lua'
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Groups.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
    'server/squad.lua',
    'server/server.lua',
    'server/bank.lua',
    'server/prepare.lua',
    'server/vip_fac.lua',
    'server/permission.lua',
    'server/leadership.lua',
    'server/recruit_uniform.lua',
    'server/bank_withdraw_permission.lua',
    'server/farm.lua',
}



files {
	'web/index.html',
	'web/*',
	'web/**/*',
	'web/static/css/**/*',
	'web/static/js/**/*',
	'web/static/media/**/*',
	'web/assets/*'
}

ui_page 'web/index.html'
