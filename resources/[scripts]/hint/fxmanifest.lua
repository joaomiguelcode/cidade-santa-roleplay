shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'hint'
version '1.0.0'

ui_page 'web/ui.html'

files {
	'config.lua',
	'web/**'
}

client_scripts {
    'translations.lua',
	'@ox_lib/init.lua',
	'client.lua'
}

dependency 'ox_lib'
