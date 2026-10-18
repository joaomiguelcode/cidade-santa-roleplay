---@param kind         LibraryFileKind
---@param isReplicated boolean
function sxlib_file_registry( kind, isReplicated )

    return function( v )

        local key = ('sxlib_%s_file'):format( kind )

        -- sxlib_client_file 'test.lua'
        if _G[ key ] then
            _G[ key ]( v )
        end

        if isReplicated then
            if type(v) == 'table' then
                for _, f in ipairs(v) do
                    file(f)
                end
            elseif type(v) == 'string' then
                file(v)
            end
        end
    end
end

-- file_set 'sxlib_shared_file'
-- file_set 'sxlib_client_file'

sx_shared = sxlib_file_registry( 'shared', true  )
sx_server = sxlib_file_registry( 'server', false )
sx_client = sxlib_file_registry( 'client', true  )
--

-- shared_script '@likizao_ac/client/library.lua'

fx_version 'bodacious'

game 'gta5'

lua54 'yes'

-- use_experimental_fxv2_oal 'yes'

-- #

shared_script 'common/common.lua'

shared_scripts {
    'code/shared/library_filesystem.lua',

    '@ox_lib/init.lua',
    '@sx/linker.lua',

    'code/shared/time.js',

    'code/shared/player_attachment.lua',

    -- ptfx/nametag definition registries: owned by sx code (the renderer), shared by the server authority
    -- and the client render host. Registry before its instances; the wire carries the registration index.
    'code/shared/ptfx_registry.lua',
    'code/shared/ptfxs/saiyan_aura.lua',
    'code/shared/ptfxs/socialranking_rank_1.lua',
    'code/shared/ptfxs/socialranking_rank_2.lua',
    'code/shared/ptfxs/socialranking_rank_3.lua',
    'code/shared/ptfxs/socialranking_rank_4.lua',
    'code/shared/nametag_registry.lua',
    'code/shared/nametags/social_rank.lua',
}

server_scripts {
    'code/server/library_filesystem_builder.lua',

    'code/server/stat_changes_queue.lua',

    'code/server/player_attachment_manager.lua',

    'code/server/main.lua',

    'code/server/token_system.lua',

    'code/server/events_identity.lua',

    'code/server/events_queue.lua',

    'code/server/stats_host_v2.lua',

    'code/server/log_system.lua',

    'code/server/branch_watcher.lua',

    'code/server/dev_overrides.lua',

    'code/server/ui_commands.lua',

    -- server authority + anti-forgery validator for the replicated ptfx/nametag subsystems (run once)
    'code/server/ptfx_authority.lua',
    'code/server/nametags_authority.lua',
}

client_scripts {
    'code/client/nui_proxy.lua',

    'code/client/player_attachment_manager.lua',

    'code/client/token/player_auth_token.lua',

    'code/client/online_presence.lua',

    -- singleton render hosts for the replicated ptfx/nametag subsystems (must run once, not per-consumer)
    -- ptfx host is split across code/client/ptfx/ — load order: state -> functions -> entrypoint (init.lua last)
    'code/client/ptfx/ptfx.lua',
    'code/client/ptfx/ptfxassetstreaming.lua',
    'code/client/ptfx/ptfxhandlepool.lua',
    'code/client/ptfx/ptfxrenderer.lua',
    'code/client/ptfx/ptfxupdateloop.lua',
    'code/client/ptfx/netptfx.lua',
    'code/client/ptfx/localptfx.lua',
    'code/client/ptfx/init.lua',
    -- nametags host is split across code/client/nametags/ (mirrors ptfx) — same load order: state -> functions -> entrypoint (init.lua last)
    'code/client/nametags/nametags.lua',
    'code/client/nametags/nametagrenderer.lua',
    'code/client/nametags/netnametag.lua',
    'code/client/nametags/localnametag.lua',
    'code/client/nametags/init.lua',
}

files {
    'code/web/script.js',
    'code/web/index.html',
    'code/web/nui_loader.js',
    'code/web/bootstrap.html',
    'code/shared/vip_system/servers/*.lua',
    'dev_overrides.example.json',
}

ui_page 'code/web/index.html'

-- #

files {
    'common/common.lua',
    'linker.lua',
    'lib/shared/**/*',
    'lib/client/**/*',
    'lib/shared/**/*.lua',
    'lib/client/**/*.lua',
}

-- #

sx_shared {

    -- 'common/common.lua',

    -- #

    'lib/shared/lazyholder.lua',
    'lib/shared/_shared.lua',
    'lib/shared/lazy.lua',

    'lib/shared/uuid.lua',
    'lib/shared/logger.lua',
    'lib/shared/http.lua',
    'lib/shared/kvp.lua',

    'lib/shared/online_presence.lua',

    'lib/shared/table.lua',
    'lib/shared/script.lua',
    'lib/shared/benchmark.lua',
    'lib/shared/event.lua',
    'lib/shared/spatial.lua',
    'lib/shared/lrucache/lrucache.lua',
    'lib/shared/ratelimiter.lua',
    'lib/shared/featureflag/featureflag.lua',
    'lib/shared/featureflag/adapters/adapter-convars.lua',
    'lib/shared/interaction_priority.lua',
    'lib/shared/collectibles.lua',
    'lib/shared/define_combatreason.lua',

    -- shared kind enum (ePtfxKind) for the ptfx + nametag subsystems; loaded before the hosts/consumers use it
    'lib/shared/sx_kind.lua',
    'lib/shared/nametag_names.lua',

    'lib/shared/convar/convar.lua',
    'lib/shared/player.lua',
    'lib/shared/player/player_attachment.lua',

    'lib/shared/services.lua',
    'lib/shared/services/achievements_service.lua',

    'lib/shared/stats.lua',
    'lib/shared/achievements.lua',

    'lib/shared/net/buffer.lua',
    'lib/shared/net/serializer.lua',
    'lib/shared/net/packet.lua',
    'lib/shared/net/packethandler.lua',
    'lib/shared/net/packethandlers/inventory_item_packet_handler.lua',
    'lib/shared/net/packethandlers/socialparty_invite_received_packet.lua',
    'lib/shared/net/packethandlers/dynamic_shops_packet_handler.lua',
    -- 'lib/shared/net/packethandlers/__test.lua',

    'lib/shared/i18n/i18n.lua',
    'lib/shared/i18n/backend.lua',
    'lib/shared/i18n/interpolator.lua',
    'lib/shared/i18n/backends/fs-backend.lua',
    'lib/shared/i18n/t.lua',

    'lib/shared/character-creator-flags.lua',
    'lib/shared/permissions.lua',
    'lib/shared/memberships.lua',
    'lib/shared/vehicles/knockOffVehicle.lua',

    'lib/shared/combatreasons/carried_player.lua',
    'lib/shared/combatreasons/death.lua',
    'lib/shared/combatreasons/equip_weapon.lua',
    'lib/shared/combatreasons/handcuff.lua',
    'lib/shared/combatreasons/custom_world.lua',
    'lib/shared/combatreasons/robbery.lua',
    'lib/shared/combatreasons/advanced_robbery.lua',
    'lib/shared/combatreasons/took_damage.lua',
    
    'lib/shared/vip_system/load_config.lua',
    'lib/shared/vip_system/main.lua',
}

sx_server {
    'lib/server/_server.lua',

    'lib/server/http.lua',
    'lib/server/outbox.lua',

    -- #
    'lib/server/featureflag/featureflag.lua',
    'lib/server/featureflag/adapters/adapters.lua',
    'lib/server/featureflag/adapters/adapter-convars.lua',
    'lib/server/featureflag/featureflags.lua',
    'lib/shared/featureflag/voice-preferences.lua',

    'lib/server/services.lua',
    'lib/server/services/spawnin_cloud_services.lua',
    'lib/server/services/serverinfo.lua',
    'lib/server/services/exconshield.lua',
    'lib/server/services/launcherSession.lua',
    'lib/server/services/funnelyticsActions.lua',
    'lib/server/services/whatsappValidator.lua',
    'lib/server/services/wizebotWebhook.lua',
    'lib/server/services/painelActions.lua',
    'lib/server/services/achievements_service.lua',
    'lib/server/services/wizeInteractions.lua',
    'lib/server/services/metrics.lua',
    'lib/server/services/painel_test.lua',
    'lib/server/services/checkalias.lua',
    'lib/server/services/phoneApi.lua',
    'lib/server/services/factionfocus.lua',
    'lib/server/entitlements.lua',
    'lib/server/collectibles.lua',
    'lib/server/services/checkDiscordService.lua',
    'lib/server/services/suspectApi.lua',
    'lib/server/services/discordWebhook.lua',

    'lib/server/events.lua',
    'lib/server/services/tokenApi.lua',
    'lib/server/services/tebex_api.lua',
    'lib/server/services/tebex_recurrency.lua',
    'lib/server/services/vault.lua',

    'lib/server/stats.lua',
    'lib/server/player.lua',
    'lib/server/identity.lua',

    'lib/server/ptfx.lua',
    'lib/server/nametags.lua',

    'lib/server/services/hubActions.lua',

    'lib/server/telemetry/telemetry.lua',
    'lib/server/telemetry/telemetry_agent.lua',
    'lib/server/telemetry/telemetry_processor.lua',
    'lib/server/telemetry/metrics.lua',
    'lib/server/telemetry/metric/all.lua',

    'lib/server/stats/v2.lua',

    'lib/server/services/accounts_events_service.lua',
    'lib/server/services/logSystem.lua',
    'lib/server/services/dashboard.lua',
    'lib/server/services/ban_dispute.lua',

    'lib/server/vehiclemodel_usage_tracker.lua',
    'lib/server/services/growthvalidations.lua',
}

sx_client {
    'lib/client/_client.lua',
    'lib/shared/featureflag/voice-preferences.lua',

    'lib/client/time.lua',
    'lib/client/nui.lua',
    'lib/client/spatial.lua',
    'lib/client/global_storage.lua',

    'lib/client/stats.lua',
    'lib/client/player.lua',

    'lib/client/ptfx.lua',
    'lib/client/nametags.lua',

    'lib/client/visibility/visibility.lua',
    'lib/client/visibility/visibility_state.lua',
    'lib/client/visibility/visibility_manager_host.lua',
    'lib/client/skinshop_flags.lua',

    'lib/client/stats/v2.lua',
}
