shared_script '@likizao_ac/client/library.lua'

fx_version "cerulean"
lua54 "yes"
game "gta5"

client_scripts {
    'client/**'
}

shared_scripts {
    "@sx/linker.lua",
    "helpers/survey-builder.lua",
    '@ox_lib/init.lua',
    '@vrp/lib/utils.lua',
    "shared/framework.lua",
    "shared/utils.lua",
    "shared/definition.lua",
    "shared/translate.lua",
    "shared/survey/**/*.lua"
}

server_scripts {
    '@vrp/lib/Utils.lua',
    "@oxmysql/lib/MySQL.lua",
    "server/lock-manager.lua",
    "server/services/*.lua",
    "server/strategies/**/*.lua",
    "server/survey-repository.lua",
    "server/survey-manager.lua",
    "server/utils.lua",
    "server/webhook-config.lua",
    "server/survey-low-rating-log.lua",
    "server/spam-detector.lua",
    "server/main.lua",
    "server/scheduler.lua",
    "server/routes/**/*.lua",
    "server/exports.lua",
    -- "helpers/tester.lua",
    -- "tests/survey.test.lua", -- Descomente para executar testes no start do resource
}

files { "web/**" }
ui_page "web/index.html"
