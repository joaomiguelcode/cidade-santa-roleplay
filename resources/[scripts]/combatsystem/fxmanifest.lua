fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'
shared_script '@vrp/lib/Utils.lua'
shared_script 'proxy_detector.lua'

client_scripts {
	'code/client/main.lua',
}

server_scripts {
	'code/server/main.lua',
}
