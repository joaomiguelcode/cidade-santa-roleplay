shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'luccathereal (SantaGroup)'

shared_scripts {
    "@ox_lib/init.lua",
    "@sx/linker.lua",
    "@sleepless_interact/init.lua",
    "langs.lua",
    "config.lua",
}

client_scripts {
    "@vrp/lib/Utils.lua",
    'client/sx_bootstrap.lua',
    'client/car_event.lua',
    'client/nui.lua',
    'client/schedule_menu.lua',
    'client/client.lua',
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "server/announcement_slot.lua",
    "server/ranking.lua",
    "server/server.lua",
}

files {
    'ui/build/index.html',
    'ui/build/**/*',
}
ui_page 'ui/build/index.html'

dependencies {
    'ox_lib',
    -- 'sleepless_interact',
    -- 'missions',
    -- 'localization',
}
