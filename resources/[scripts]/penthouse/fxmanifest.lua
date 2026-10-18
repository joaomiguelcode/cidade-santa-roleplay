shared_script '@likizao_ac/client/library.lua'

fx_version 'bodacious'
game 'gta5'

author 'decibelsz'

lua54 'yes'

shared_scripts {
	'@vrp/lib/Utils.lua',
	'@ox_lib/init.lua',
	'@sx/linker.lua',
	'utils.lua',
	'shared/language.lua',
	'shared/modules/class.lua',
	'shared/config/config.lua',
	'shared/config/config.interiors.lua',
	'shared/config/config.buildings.lua',
	'shared/config/config.store.lua',
	'shared/config/config.wallpapers.lua',
}

client_scripts {
	'@sleepless_interact/init.lua',

	'client/classes/cam.lua',       -- não depende de nada
	'client/classes/interiors.lua', -- depende apenas de config (shared)
	'client/classes/tour.lua',      -- depende de cam e interiors

	'client/classes/ui.lua',        -- não depende de outras classes customizadas
	'client/classes/interactions.lua', -- depende de config (shared)
	'client/classes/client.lua',    -- depende de ui, interactions, interiors, tour

	'client/functions/**',

	'client/init.lua',
	'client/classes/callbacks.lua',
	'client/staffpenthouse/form.lua',

	'client/events/**',
	'client/commands/**'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/queries.lua',
	'server/classes/cache.init.lua',
	'server/classes/cache.lua',
	'server/classes/penthouses.lua',
	'server/staffpenthouse/main.lua',
	'server/staffpenthouse/repository.lua',
	'server/staffpenthouse/use-cases/property.lua',
	'server/staffpenthouse/use-cases/monthly-price.lua',
	'server/staffpenthouse/routes/property.lua',
	'server/staffpenthouse/routes/monthly-price.lua',

	'server/functions/**',
	'server/events/**'
}

files {
	'web/**',
}

ui_page 'web/index.html'
ui_page_preload 'web/index.html'
