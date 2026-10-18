shared_script '@likizao_ac/client/library.lua'

fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'decibelsz, tadalas'

shared_scripts {
    '@sx/linker.lua',
    '@ox_lib/init.lua',
    '@vrp/lib/Utils.lua',
    'translations.lua',
    'init.lua',
    'shared/**'
}

client_scripts {
    'client/**'
}

files {
    'web/**/**',
    'web/assets/**',
    'web/locales/**'
}

server_scripts {
    'server/main.lua',
    'server/ui.tutorial.lua'
}

ui_page 'web/index.html'
ui_page_preload 'yes'