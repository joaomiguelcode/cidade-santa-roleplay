shared_script '@likizao_ac/client/library.lua'

fx_version 'bodacious'
game 'gta5'
lua54 'yes'

author 'Santagroup'
description 'Social Ranking — city-aware XP ranking, plaza podium peds and reward visuals'

shared_script '@sx/linker.lua'
shared_script '@ox_lib/init.lua'
shared_script '@vrp/lib/Utils.lua'

shared_scripts {
    'shared/enabled_cities.lua',
    'shared/reasons.lua',
    'shared/config.lua',
    'shared/org_config.lua',
    'shared/recruitment_punishment_config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/schema.lua',
    'server/emit.lua',
    'server/hooks.lua',
    'server/activity.lua',
    'server/retention.lua',
    'server/recruitment_punishment.lua',
    'server/ranking_api_mock.lua',
    'server/ranking_api.lua',
    'server/match_xp_reversal.lua',
    'server/milestone.lua',
    'server/preferences.lua',
    'server/podium.lua',
    'server/rewards.lua',
    'server/daily_vip.lua',
    'server/mock_dev.lua',
    'server/org_schema.lua',
    'server/org_core.lua',
    'server/org_retention.lua',
    'server/org_presence.lua',
    'server/org_daily.lua',
    'server/org_hooks.lua',
    'server/org_jobs.lua',
    'server/org_alert.lua',
    'server/org_podium.lua',
	'server/org_daily_vehicle.lua',
    'server/org_dev.lua',
    'server/dev_commands.lua',
    'server/main.lua',
}

client_scripts {
    '@sleepless_interact/init.lua',
    'client/cards.lua',
    'client/billboard.lua',
    'client/peds.lua',
    'client/org_podium.lua',
    'client/reward_visuals.lua',
    'client/main.lua',
}

files {
    'web/org_podium.html', -- página local da DUI das placas do pódio de organizações (nui://)
    'web/org-podium/*',
}
