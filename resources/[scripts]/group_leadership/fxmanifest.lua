fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts { '@sx/linker.lua', '@vrp/lib/Utils.lua' }
client_script 'client.lua'
server_script 'server.lua'
ui_page 'web/index.html'
files { 'web/**/*' }
dependencies { 'vrp', 'sx', 'painel' }
