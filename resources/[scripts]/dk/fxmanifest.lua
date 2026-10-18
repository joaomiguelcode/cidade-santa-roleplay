fx_version 'adamant'
game 'gta5'

author 'potter7k'
description 'Scripts desenvolvidos por DK Development. Discord: https://discord.gg/NJjUn8Ad3P'

lua54 'yes'

shared_scripts {
    'config/shared/*'
}

server_scripts {
    '@vrp/lib/Utils.lua',
    'src/server.lua'
}

client_scripts {
    'src/client.lua',
    'config/client/*'
}