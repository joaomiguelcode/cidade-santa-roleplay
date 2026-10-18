shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_script '@sx/linker.lua'

ui_page 'web/index.html' -- PRODUCTION
-- ui_page 'http://127.0.0.1:1904/' -- DEVELOPMENT

shared_scripts {
    '@vrp/lib/Utils.lua',
    '@ox_lib/init.lua',
    '@vrp/config/translations.lua',
    '@vrp/config/Item.lua',
    'proxy_detector.lua',
    'code/shared/main.lua',
    'code/shared/types.lua',
    'data/*.lua',
}

client_scripts {
    'code/client/core/main.lua',
    'code/client/core/state-service.lua',
    'code/client/core/utils-service.lua',
    'code/client/features/spectator/spectator-handler.lua',
    'code/client/features/spectator/spectator-interface-service.lua',
    'code/client/features/actions/service-handler.lua',
}

server_scripts {
    'code/server/core/main.lua',
    'code/server/services/validations-service.lua',
    'code/server/features/spectator/spectator-handler.lua',
    'code/server/features/spectator/spectator-service.lua',
    'code/server/features/spectator/spectator-target.lua',
    'code/server/features/actions/actions-service.lua',
    'code/server/features/spectator/spectator-interface-callbacks.lua',
    'code/server/handlers/commands.lua',
    'code/server/handlers/net-events.lua',
}

files {
	'web/*',
	'web/**/*'
}
