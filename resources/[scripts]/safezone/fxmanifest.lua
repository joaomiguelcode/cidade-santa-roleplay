shared_script '@likizao_ac/client/library.lua'
shared_script 'shared.lua'
shared_script 'translations.lua'

fx_version "bodacious"
game "gta5"

dependencies {
    "PolyZone"
}

-- ui_page "web/index.html"

shared_script '@sx/linker.lua'

shared_scripts {
    "shared/safezones.lua",
    "shared/rdmzones.lua",
}

client_scripts {
	"@vrp/lib/Utils.lua",
	"@vrp/lib/Native.lua",
	"@vrp/config/Global.lua",
	"@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
    "server-side/server.lua",
    "server-side/bucketZones.lua",
    "server-side/rdm.lua",
    "server-side/warmode.lua"
}

-- files {
--     "web/index.html",
--     "web/*",
--     "web/**/*",
-- }