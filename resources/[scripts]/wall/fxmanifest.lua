shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'
lua54 "yes"

dependency 'lib'

shared_script "translations.lua"
shared_script "@vrp/lib/Utils.lua"
shared_script "shared/nametags.lua"
shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'
shared_script '@lib/index.lua'
shared_script '@lib/instance.lua'

server_script 'server/**/**'
client_scripts {
    'client/state.lua',
    'client/freecam.lua',
    'client/render.lua',
    'client/interaction.lua',
    'client/events.lua',
}

ui_page 'web/dist/index.html'
files { 'web/dist/**/*' }