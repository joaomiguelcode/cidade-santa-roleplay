shared_script '@likizao_ac/client/library.lua'

fx_version "bodacious"
game "gta5"

lua54 'yes'

ui_page "web/index.html"

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'

shared_scripts {
    "translations.lua",
	"catalog_translations.lua",
	"weapon_skins_translations.lua",
	"shared/*",
    "affiliate_world/shared/config.lua",
    "affiliate_world/shared/translations.lua",
    "affiliate_world/shared/special_weapons.lua",
    "affiliate_world/shared/catalog/init.lua",
    "affiliate_world/shared/catalog/vehicles.lua",
    "affiliate_world/shared/catalog/weapons.lua",
    "affiliate_world/shared/catalog/pets.lua"
}

client_scripts {
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"client/client.lua",
	"client/ped_effects.lua",
	"client/org_ranking.lua",
	"client/ranking_reward.lua",
	"client/recruitment_punishment.lua",
	"client/battlepass.lua",
	"client/playsession_playtime_tracker.lua",
    "client/weaponview.lua",
    "client/weaponskins.lua",
    "client/promotion.lua",
    "client/news.lua",
    "client/missions.lua",
    "client/tutorial.lua",
    "client/store.lua",
    "client/vip_time.lua",
    "client/afl_store.lua",
    "affiliate_world/client/main.lua",
    "affiliate_world/client/public.lua",
    "affiliate_world/client/aim_training.lua",
    "affiliate_world/client/catalog.lua",
    "affiliate_world/client/weapons.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"server/server.lua",
	"server/prepare.lua",
	"server/battlepass.lua",
	"server/playsession_playtime_tracker.lua",
    "server/weaponskins.lua",
    "server/promotion.lua",
    "server/news.lua",
    "server/diamonds.lua",
    "server/vip_time.lua",
    "server/afl_coins.lua",
    "affiliate_world/server/bundle_deliveries.lua",
    "affiliate_world/server/bundles.lua",
    "affiliate_world/server/presentation.lua",
    "affiliate_world/server/state.lua",
    "affiliate_world/server/commerce.lua",
    "affiliate_world/server/persistence.lua",
    "affiliate_world/server/popularity.lua",
    "affiliate_world/server/main.lua",
    "affiliate_world/server/invites.lua",
    "affiliate_world/server/public.lua",
    "affiliate_world/server/product_definitions/init.lua",
    "affiliate_world/server/product_definitions/vehicle.lua",
    "affiliate_world/server/product_definitions/weapon_skin.lua",
    "affiliate_world/server/product_definitions/weapon.lua",
    "affiliate_world/server/product_definitions/pet.lua",
    "affiliate_world/server/product_definitions/collectible.lua",
    "affiliate_world/server/actions/vehicle.lua",
    "affiliate_world/server/actions/weapon.lua",
    "affiliate_world/server/actions/pet.lua",
    "affiliate_world/server/actions/collectible.lua",
    "affiliate_world/server/routes/catalog.lua",
    "affiliate_world/server/routes/lifecycle/bucket.lua",
    "affiliate_world/server/routes/lifecycle/player.lua",
    "affiliate_world/server/routes/lifecycle/resource_start.lua",
    "affiliate_world/server/routes/lifecycle/resource_stop.lua",
}

files {
	"web/*",
	"web/**/*"
}
