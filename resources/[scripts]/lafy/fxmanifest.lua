shared_script '@likizao_ac/client/library.lua'

fx_version 'bodacious'
game 'gta5'

client_scripts {
  'client.config.lua',
  'client.lua',
  'locales.lua'
}

server_scripts {
    '@vrp/lib/Utils.lua',
  'adapter.lua',
  'server.js',
}

lua54 'yes'

ui_page 'dist/index.html'
files { 'dist/**/*' }