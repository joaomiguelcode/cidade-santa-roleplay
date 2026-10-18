shared_script '@likizao_ac/client/library.lua'

fx_version 'cerulean'
game 'gta5'

description 'sxsec-server'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

version '0.0.1'

server_scripts {
    '@vrp/lib/Utils.lua',
    'server/*',
}