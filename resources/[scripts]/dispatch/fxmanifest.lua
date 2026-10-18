fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'decibelsz, tadalas'

shared_scripts {
    '@vrp/lib/Utils.lua',
    'init.lua',
    'shared/**'
}

client_scripts {
    'client/**'
}

server_scripts {
    'server/**'
}

files {
    'web/**/**',
    'web/assets/**',
    'web/locales/**',
}

ui_page 'web/index.html'
ui_page_preload 'yes'
