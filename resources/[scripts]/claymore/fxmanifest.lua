fx_version 'bodacious'
game 'gta5'

lua54 "yes"
use_fxv2_oal 'yes'

ui_page 'web-side/build/index.html'

files {
	"stream/*",
}

escrow_ignore {
	"shared/config.lua",
	"main/server-side/utils.lua",
}

shared_scripts {
    "@vrp/lib/utils.lua",
    "shared/config.lua"
}

client_scripts {
	"main/client-side/*"
}

server_scripts {
	"main/server-side/*",
}


data_file 'DLC_ITYP_REQUEST' 'stream/claymore_p.ytyp'