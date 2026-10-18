shared_script '@likizao_ac/client/library.lua'

fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'
shared_script '@vrp/lib/Utils.lua'

shared_scripts {
    'code/proxy_detector.lua',
    'code/shared/skin_def.lua',
    'code/shared/config.lua',
    'code/shared/translations.lua',
    'code/shared/main.lua',
}

ui_page 'code/web/index.html'

client_scripts {
    'code/client/pededitor_cam_helper.lua',
    'code/client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'code/migrations/*.lua',
    'code/server/main.lua',
    'code/server/ped_model_names.lua',
    'code/server/ped_model_audit.lua',
    'code/server/ped_redeem_domain.lua',
    'code/server/ped_redeem_repository.lua',
    'code/server/ped_redeem_use_case.lua',
    'code/server/ped_redeem_routes.lua',
}

files {
    'code/web/**/*',
}
