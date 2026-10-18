shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'

authors {
    'decibelsz - backend',
    'boynull - frontend',
    'santa group - ui/ux/design/idea/briefing',
}

lua54 'yes'

client_scripts {
    '@sleepless_interact/init.lua',
    'client/classes/callbacks.handlers.lua',
    'client/classes/callbacks.lua',
    'client/events/*.lua',
    'client/functions/*.lua',
    'client/statebags/*.lua',

}

server_scripts {
    'server/**'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@vrp/lib/Utils.lua',
    'shared/**',
    'init.lua'
}

files {
    'assets/**',
    'dist/**/**'
}

ui_page 'dist/index.html'
ui_page_preload 'yes'