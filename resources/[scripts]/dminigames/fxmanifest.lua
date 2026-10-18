fx_version 'bodacious'
game 'gta5'


shared_script '@sx/linker.lua'
shared_script '@likizao_ac/client/library.lua'

authors {
    'decibelsz - backend',
}

lua54 'yes'

shared_scripts {
    '@vrp/lib/Utils.lua',
    'framework/modules/class.lua',
    'framework/init.lua',
    'framework/modules/utils/shared.lua',
    'framework/modules/utils/server.lua',
    'framework/modules/utils/client.lua',
    'framework/modules/cache.lua',
    'framework/modules/translation-manager.lua',
    'framework/shared/constants.lua',
    'framework/shared/enums.lua',
    'framework/shared/translations.lua',
    'framework/shared/spatial-zones.lua',
    'minigames/murder/shared/constants.lua',
    'minigames/murder/shared/translations.lua',
    'minigames/neighbor/shared/config.lua',
    'minigames/neighbor/shared/translations.lua',
    'minigames/pvp/shared/core/translations.lua',
    'minigames/pvp/shared/modes/royale/config.lua',

    -- PVP: enums e constantes competitivas
    'minigames/pvp/shared/core/gamemodes.lua',
    'minigames/pvp/shared/core/locations.lua',
    'minigames/pvp/shared/modes/competitive/bet-config.lua',
    'minigames/pvp/shared/modes/competitive/tournament-config.lua',
    'minigames/pvp/shared/modes/competitive/tournament-prize-config.lua',
    'minigames/pvp/shared/modes/competitive/maps.lua',
    'minigames/pvp/shared/modes/ffa_rifle/maps.lua',
    'minigames/pvp/shared/modes/ffa_pistol/maps.lua',
    'minigames/pvp/shared/modes/ffa_sniper/maps.lua',
    'minigames/pvp/shared/modes/domination/zones.lua',
    'minigames/pvp/shared/modes/domination/loot-config.lua',
}

client_scripts {
    '@vrp/config/Item.lua',
    '@vrp/config/translations.lua',

    -- Client Systems
    'framework/client/systems/player-state-manager.lua',
    'framework/client/systems/controls-manager.lua',
    'framework/client/systems/ghost-mode-manager.lua',
    'framework/client/systems/downed-player-manager.lua',

    -- Client Components
    'framework/client/components/weapon-handler.lua',
    'framework/client/components/weapon-slots.lua',

    -- Client Utils
    'framework/client/utils/render-diagnostics.lua',
    'framework/client/utils/boundary-utils.lua',

    -- Framework Classes (ordem importa)
    'framework/client/classes/conversation.lua',
    'framework/client/classes/camera.lua',
    'framework/client/classes/props.lua',
    'framework/client/classes/queue.lua',
    'framework/client/classes/gunpopup.lua',
    'framework/client/classes/map-zone-renderer.lua',
    'framework/client/classes/spatial-zone-tracker.lua',
    'framework/client/classes/spatial-zone-boundary-renderer.lua',
    'framework/client/classes/minigame.lua',

    -- Murder Config
    'minigames/murder/client/config.lua',

    -- PVP: utils antes do main (GetProfilePicture é usado por ui.lua)
    'minigames/pvp/client/app/utils.lua',

    -- Entry points dos minigames
    'minigames/murder/client/main.lua',
    'minigames/neighbor/client/main.lua',
    'minigames/neighbor/client/lb-phone-app.lua',
    'minigames/pvp/client/app/main.lua',

    -- PVP: ui.lua depois do main.lua (define GameModeToggleUI)
    'minigames/pvp/client/app/ui.lua',
    'minigames/pvp/client/app/event-announce.lua',

    -- PVP: spectate de torneios
    'minigames/pvp/client/modes/competitive/spectate.lua',

    -- PVP: modo competitivo
    'minigames/pvp/client/modes/competitive/main.lua',

    -- PVP: modos FFA
    'minigames/pvp/client/modes/ffa_rifle/main.lua',
    'minigames/pvp/client/modes/ffa_pistol/main.lua',
    'minigames/pvp/client/modes/ffa_sniper/main.lua',

    -- PVP: modo Dominacao
    'minigames/pvp/client/modes/domination/capture-point-renderer.lua',
    'minigames/pvp/client/modes/domination/ranking-board-renderer.lua',
    'minigames/pvp/client/modes/domination/loot-dui-probe.lua',
    'minigames/pvp/client/modes/domination/loot-renderer.lua',
    'minigames/pvp/client/modes/domination/main.lua',

    -- PVP: modo Royale
    'minigames/pvp/client/modes/royale/preparation-zone.lua',
    'minigames/pvp/client/modes/royale/safe-zone.lua',
    'minigames/pvp/client/modes/royale/hud.lua',
    'minigames/pvp/client/modes/royale/allies.lua',
    'minigames/pvp/client/modes/royale/revive.lua',
    'minigames/pvp/client/modes/royale/main.lua',
    'minigames/pvp/client/modes/royale/announce.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@vrp/config/translations.lua',
    '@vrp/config/Item.lua',
    -- Server Protection
    'framework/server/protection/anti-duplicate.lua',

    -- Server Systems
    'framework/server/systems/player-manager.lua',
    'framework/server/systems/stats-manager.lua',
    'framework/server/systems/ranking-manager.lua',
    'framework/server/systems/analytics-manager.lua',

    -- Framework Classes
    'framework/server/classes/queue.lua',
    'framework/server/classes/teams.lua',
    'framework/server/classes/spawnpoint.lua',
    'framework/server/classes/match.lua',
    'framework/server/classes/minigame.lua',

    -- PVP Competitive Systems (antes dos main.lua)
    'minigames/pvp/server/app/avatar.lua',
    'minigames/pvp/server/connection-stats.lua',
    'minigames/pvp/server/modes/competitive/analytics.lua',
    'minigames/pvp/server/modes/competitive/penalty-manager.lua',
    'minigames/pvp/server/modes/competitive/bet-manager.lua',
    'minigames/pvp/server/modes/competitive/lobby-manager.lua',
    'minigames/pvp/server/modes/competitive/weapon-vote-manager.lua',
    'minigames/pvp/server/modes/competitive/map-vote-manager.lua',
    'minigames/pvp/server/modes/competitive/challenge-manager.lua',
    'minigames/pvp/server/modes/competitive/spectate-manager.lua',
    'minigames/pvp/server/modes/competitive/tournament-manager.lua',
    'minigames/pvp/server/modes/competitive/x1-invite-manager.lua',
    'minigames/pvp/server/modes/competitive/main.lua',
    'minigames/pvp/server/modes/ffa_rifle/main.lua',
    'minigames/pvp/server/modes/ffa_pistol/main.lua',
    'minigames/pvp/server/modes/ffa_sniper/main.lua',

    -- PVP: modo Dominacao
    'minigames/pvp/server/modes/domination/ranking-manager.lua',
    'minigames/pvp/server/modes/domination/organization-resolver.lua',
    'minigames/pvp/server/modes/domination/capture-state-machine.lua',
    'minigames/pvp/server/modes/domination/loot-inventory.lua',
    'minigames/pvp/server/modes/domination/loot-store.lua',
    'minigames/pvp/server/modes/domination/main.lua',

    -- PVP: modo Royale
    'minigames/pvp/server/app/scheduled-events.lua',
    'minigames/pvp/server/app/scheduled-event-voice.lua',
    'minigames/pvp/server/modes/royale/config.lua',
    'minigames/pvp/server/modes/royale/schedule.lua',
    'minigames/pvp/server/modes/royale/safe-zone.lua',
    'minigames/pvp/server/modes/royale/main.lua',

    -- Entry points dos minigames
    'minigames/murder/server/main.lua',
    'minigames/neighbor/server/uno.lua',
    'minigames/neighbor/server/telemetry-schema.lua',
    'minigames/neighbor/server/telemetry.lua',
    'minigames/neighbor/server/main.lua',
    'minigames/pvp/server/app/main.lua',

}
ui_page 'web/index.html'
files {
    'web/index.html',
    'web/assets/*.*',
    'web/assets/**/*.*',
    'web/match-city/*.svg',
    'web/*.png',
    'web/cards/*.svg',
    'web/domination-store/*.png',
    'web/cartada-table.html',
    'web/map-zone-overlay.html',
    'web/domination-zone-boundary.html',
    'web/domination-zone-boundary.png',
    'web/domination-zone-boundary-cylinder.png',
    'web/domination-farm-buff-icon.png',
    'web/domination-capture-point.html',
    'web/domination-loot-probe.html',
    'web/domination-loot.html',
    'web/domination-loot.js',
    'files/decibelsz_santagroup_zoneprojector.gfx',
    'licenses/ScaleformUI-NOTICE.txt',
}
