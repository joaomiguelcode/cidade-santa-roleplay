fx_version "bodacious"
game "gta5"

lua54 'yes'

ui_page "web/index.html"

shared_script 'translations.lua'
shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'
shared_script 'shared/wallstreet_rules.lua'
shared_script 'shared/comercial_rules.lua'
shared_script 'shared/x1_invite_rules.lua'
shared_script 'shared/staff_ticket_rules.lua'

client_scripts {
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"client/client.lua",
    "client/ticket.lua",
    "client/costumers.lua",
    "client/ban_audit.lua",
    "client/telagem.lua",
    "client/wallstreet_punishment.lua",
    "client/waypoint.lua",
    "client/x1_invite.lua",
    "client/match_panel.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "@vrp/lib/Utils.lua",
    "@vrp/config/Rewards.lua",
    "@vrp/config/Item.lua",
	"@vrp/config/translations.lua",
	"server/server.lua",
	"server/waypoint.lua",
    "@painel/shared/recruit_config.lua",
    "server/player_classification.lua",
    "server/x1_invite.lua",
    "server/match_panel.lua",
    "server/prepare.lua",
    "server/tickets.lua",
    "server/code.lua",
    "server/costumers.lua",
	"server/analytics.lua",
    "server/ban_audit/constants.lua",
    "server/ban_audit/utils.lua",
    "server/ban_audit/state.lua",
    "server/ban_audit/restrict.lua",
    "server/ban_audit/dispute_api.lua",
    "server/ban_audit/flow.lua",
    "server/ban_audit/staff_modal.lua",
    "server/ban_audit/commands_exports.lua",
    "server/telagem.lua",
    "server/blacklist_gate.lua",
    "server/cleanups.lua",
    "server/wallstreet.lua",
    "server/comercial.lua",
    "server/ticket_cleanup.lua",
}

shared_scripts {
    "translations.lua",
	"shared/*"
}

files {
	"web/*",
	"web/**/*"
}
