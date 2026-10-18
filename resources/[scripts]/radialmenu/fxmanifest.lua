-- shared_script '@likizao_ac/client/library.lua'

fx_version 'bodacious'
use_experimental_fxv2_oal 'yes'

lua54 'yes'
games { 'gta5' }

name 'santa_radialmenu'
version '1.0.0'

shared_script '@sx/linker.lua'

client_scripts {
    "@vrp/config/Native.lua",
	"@vrp/config/Groups.lua",
    '@sleepless_interact/init.lua',
    "client/main.lua",
    "client/ox_radial.lua",
    "config/*.lua",
    "client/utils.lua",
    "client/profile_picture.lua",
}

shared_scripts {
    "@vrp/lib/Utils.lua",
    "locale/translate.lua",
    "@painel/shared/recruit_config.lua",
}

server_scripts {
    "server/*.lua",
}

ui_page 'web/build/index.html'
--ui_page 'http://localhost:3000'


files {
    'web/**/**',
    -- 'web/build/index.html',
    -- 'web/build/**',
}
