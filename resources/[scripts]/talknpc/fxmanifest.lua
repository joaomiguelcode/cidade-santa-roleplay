shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

ui_page "web/index.html"

shared_script 'shared.lua'

client_scripts {
    "@vrp/config/Themes.lua",
	'client/*.lua',
}

-- files {
-- 	"web/*",
-- 	"web/**/*"
-- }