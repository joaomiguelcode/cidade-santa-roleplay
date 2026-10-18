fx_version "cerulean"
lua54 "yes"
game "gta5"

ui_page "audio/index.html"

shared_scripts {
    "@sx/linker.lua",
    "@ox_lib/init.lua",
    "@vrp/lib/Utils.lua",
    "translations.lua",
    "shared/cdn.lua",
}

client_scripts {
    "client/main.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/config.lua",
    "server/repository.lua",
    "server/schedules.lua",
    "server/scheduler.lua",
    "server/main.lua",
}

files {
    "audio/**",
}
