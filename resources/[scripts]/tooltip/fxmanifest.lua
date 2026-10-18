shared_script '@likizao_ac/client/library.lua'

fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'decibelsz, tadalas'

client_scripts {
    'client/**'
}

shared_script 'init.lua'

files {
    'web/**/**',
    'web/assets/**',
    'web/locales/**'
}

ui_page 'web/index.html'
ui_page_preload 'yes'