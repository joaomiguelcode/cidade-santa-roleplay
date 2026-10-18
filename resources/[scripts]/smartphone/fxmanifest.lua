shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

shared_script '@sx/linker.lua'

shared_scripts {
  '@vrp/lib/Utils.lua',
  'vrp_proxy_detour.lua',
  'translations.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
  'inject_me.js',
  'server.lua',
  'contacts.lua',
  'middlewares/definition.lua',
  'middlewares/data/*.lua',
}

client_scripts { 'client.lua', 'static-client.lua', 'locales.lua' }

ui_page 'dist/index.html'

files {
  'dist/*',
  'dist/match-social.html',
  'dist/match-social.svg',
}
