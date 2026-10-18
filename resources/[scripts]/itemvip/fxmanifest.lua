fx_version "cerulean"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_scripts {
    "@ox_lib/init.lua",
    "@sx/linker.lua",
    -- "Q.A/shared/*.lua", -- Q.A: comente esta linha para desabilitar a configuracao de testes.
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Item.lua",
    "translations.lua",
    "server/config.lua",
    "server/domain.lua",
    "server/repositories/repository.lua",
    "server/use-cases/use-cases.lua",
    "server/routes/routes.lua",
    -- "Q.A/server/*.lua", -- Q.A: comente esta linha para desabilitar os callbacks e o comando de testes.
}

client_scripts {
    "client/nui.lua",
    "client/events.lua",
    -- "Q.A/client/*.lua", -- Q.A: comente esta linha para desabilitar o menu de testes.
}

files { "web/index.html", "web/**/*" }
