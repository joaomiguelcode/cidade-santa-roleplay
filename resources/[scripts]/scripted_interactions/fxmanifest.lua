shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

-- dependency 'spawnin_emotes'

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'
shared_script '@sx/linker.lua'
shared_script '@vrp/lib/Utils.lua'

shared_scripts {
	'data/translations.lua',
	'code/shared/animation_flags.lua',
	'code/shared/scripted_interaction_def.lua',
	'code/shared/main.lua',
}

client_scripts {
	'code/client/main.lua',
	'code/client/events.lua',
	'code/client/pets.lua'
}

server_scripts {
	'code/server/main.lua',
	'code/server/pets.lua',
}

ui_page 'web/index.html'

files {
	'web/**/*',
}

--- # Data

shared_scripts {
	'data/scripted_interactions/**/*.lua',
	'data/pet_translations.lua',
}

shared_script 'code/shared/spawnin_emotes.lua'
