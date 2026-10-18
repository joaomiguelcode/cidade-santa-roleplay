shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5" 

client_scripts {
    "translations.lua",
   "@vrp/lib/Utils.lua",
   "@vrp/config/Themes.lua",
   "client/*.lua",
}

files {
	"web/nui/*",
	"web/nui/**/*"
}

ui_page "web/nui/index.html"
                                                                                                                              