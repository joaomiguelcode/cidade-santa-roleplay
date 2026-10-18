fx_version 'bodacious'
game 'gta5'
lua54 'yes'

author 'Likizão#4542'
description 'a really anticheat.'
url 'https://discord.gg/2SSfDCUVUj'

shared_scripts {
    'translations.lua',
    'config/shared_*.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'server/bridge.js',
    'server/server.lua',
    'config/sv_*.lua',
}

client_scripts {
    'client/client.lua',
    'client/library.lua',
}



--                                                    ~
--  /$$       /$$$$$$ /$$   /$$ /$$$$$$ /$$$$$$$$  /$$$$$$   /$$$$$$ 
-- | $$      |_  $$_/| $$  /$$/|_  $$_/|_____ $$  /$$__  $$ /$$__  $$
-- | $$        | $$  | $$ /$$/   | $$       /$$/ | $$  | $$| $$  | $$
-- | $$        | $$  | $$$$$/    | $$      /$$/  | $$$$$$$$| $$  | $$
-- | $$        | $$  | $$  $$    | $$     /$$/   | $$__  $$| $$  | $$
-- | $$        | $$  | $$|  $$   | $$    /$$/    | $$  | $$| $$  | $$
-- | $$$$$$$$ /$$$$$$| $$ |  $$ /$$$$$$ /$$$$$$$$| $$  | $$|  $$$$$$/
-- |________/|______/|__/  |__/|______/|________/|__/  |__/ |______/ #4542
        