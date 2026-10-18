shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

author 'DeadShot#0101,Andre BC#0640'
description 'promoter_score'
version '1.0.0'

lua54 'yes'

shared_script '@sx/linker.lua'

client_scripts {
	"@vrp/lib/Utils.lua",
    "translations.lua",
  	'client/*.lua'
}

server_scripts {
	"@vrp/lib/Utils.lua",
    "translations.lua",
  	'server/*.lua'
} 

files {
	'web/build/index.html',
	'web/build/*',
	'web/build/**/*',
	'web/build/static/css/**/*',
	'web/build/static/js/**/*',
	'web/build/static/media/**/*'
}

ui_page 'web/build/index.html'