shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"

shared_script '@sx/linker.lua'

shared_scripts {
    "translations.lua",
    'shared.lua',
    "@ox_lib/init.lua",
    "@vrp/config/Groups.lua",
	"shared/drop/airdrop.lua",
	"shared/interphone/*.lua",
	"shared/groupConfig/*.lua",
	"shared/weapons/*",
	"shared/core.lua",
    "shared/phone.lua",
    "shared/paramedic/*",
	"shared/animations/paired_emotes.lua",
    "shared/easter/*.lua",
    "shared/afk-player/*.lua",
	"shared/bprotection/*.lua",
	"shared/trains/class.lua",
	"shared/trains/config.lua",
	"shared/trains/translations.lua",
}

client_scripts {
    '@sleepless_interact/init.lua',
	"@vrp/config/Native.lua",
    "@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
    "@vrp/config/Themes.lua",
	"@vrp/lib/Utils.lua",
	"client/core.lua",
	"client/alarm/*",
	"client/animations/*",
	"client/crowns/*",
	"client/drop/cl_airdrop_networking.lua",
	"client/drop/cl_airdrop_streaming.lua",
	"client/drop/cl_airdrop.lua",
	"client/drop/cl_airdropsystem.lua",
	"client/markers/*",
	"client/misc/*",
	"client/paramedic/*",
	"client/peds/*",
	"client/police/*",
	"client/robbery/*",
	"client/service/*",
	"client/skate/*",
	"client/tackle/*",
	"client/vdamage/*",
	"client/vehcontrol/*",
	"client/clothes/*",
	"client/culling/*",
	"client/wanted/*",
	"client/interphone/*",
	"client/houses/*",
	"client/lucky_wheel/*",
	"client/blipEvent/*",
	"client/timecycle/*",
	"client/easter/*",
    "client/elevator/*",
    "client/jump_prop/*",
    "client/tricks/*",
	"client/blocksound/*",
	"client/afk-player/*",
	"client/weapon-colors/*",
	"client/attach/*",
    "client/casino/*",
	"client/callmec/*",
	"client/playtime_socialarea/*",
	"client/averagefps/*",
	"client/bprotection/*",
	"client/trains/*",
}

server_scripts {
	"@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"@vrp/lib/Utils.lua",
	"server/core.lua",
    "server/alarm/*",
	"server/animations/*",
    "server/crowns/*",
	"server/drop/sv_airdrop_networking.lua",
	"server/drop/sv_airdrop.lua",
    "server/markers/*",
    "server/paramedic/*",
    "server/police/*",
    "server/robbery/*",
    "server/service/*",
    "server/tackle/*",
    "server/clothes/*",
    "server/culling/*",
    "server/notify-vip/*",
    "server/salary/*",
    "server/variables/*",
    "server/newbie/*",
    "server/economy/*",
    "server/vehcontrol/*",
    "server/wanted/*",
    "server/interphone/*",
	"server/houses/*",
	"server/lucky_wheel/*",
    "server/coins/*",
    "server/blipEvent/*",
    "server/tv/*",
    "server/groupConfig/*",
    "server/pension/*",
    "server/easter/*",
    "server/casino/*",
    "server/weapon-colors/*",
	"server/attachs/*",
    "server/afk-player/main.lua",
	"server/playtime_socialarea/*",
	"server/callmec/*",
	"server/averagefps/*",
	"server/bprotection/*",
    "server/suspects/*",
    "server/customspawn/*",
    "server/trains/*",
}

files {
	"web*",
	"web**/*",
    "web/houses/index.html",
    "web/houses/emerald-pile.png",
    "web/trains/board.html",
    'popgroups.ymt',
}

-- Usado para alterar quais modelos/peds/veiculos devem ser criado quando
-- a população do jogo está ativa.
--
-- @deprecated; não é usado mais.
-- data_file "DLC_POP_GROUPS" "popgroups.ymt"

-- data_file 'TIMECYCLEMOD_FILE' 'kings1.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings2.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings3.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings4.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings5.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings6.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings7.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings8.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings9.xml'
-- data_file 'TIMECYCLEMOD_FILE' 'kings10.xml'
