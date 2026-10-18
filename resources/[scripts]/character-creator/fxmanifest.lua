fx_version "cerulean"
game "gta5"

shared_script '@sx/linker.lua'

shared_scripts {
    '@vrp/lib/utils.lua',
    '@ox_lib/init.lua',
    'utils.lua',
    'configuration/shared/*.lua',
    'types.lua'
}

client_scripts {
    '@sleepless_interact/init.lua',
    'configuration/client/*.lua',
    "client/main.lua",
    "client/events.lua",
    "client/managers/**/*.lua",
    "client/helpers/**/*.lua",
    "client/ui/**/*.lua",
    "client/adapters/**/*.lua"
}

server_scripts {
    '@vrp/lib/Utils.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/session.lua',
    'server/adapters/*.lua',
    'server/helpers/*.lua',
    'server/repository.lua',
    'server/main.lua',
}

files { "web/**" }
ui_page "web/index.html"
