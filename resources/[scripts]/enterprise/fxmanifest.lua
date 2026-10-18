shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    'settings/translations.lua',
    '@vrp/lib/Utils.lua',
    '@sx/linker.lua',
    '@ox_lib/init.lua',
    'settings/shared.*.lua'
}

client_scripts {
    '@sleepless_interact/init.lua',
    'client/**'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'settings/framework.lua',
    'server/main.lua',
    'server/classes/**/*.lua',
    'server/routes/**/*.lua',
    'helpers/workflows-expires-at-helpers.lua'
    -- 'helpers/enterprise-tests.lua', -- desabilitar em produção!!!!
    -- 'helpers/examples.lua' -- desabilitar em produção!!!!
}


files { "web/**" }
ui_page "web/index.html"