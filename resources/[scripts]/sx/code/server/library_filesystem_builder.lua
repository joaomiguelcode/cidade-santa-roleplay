
local serverFilesystem = {}
local clientFilesystem = {}

local sharedFiles = {
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

local serverOnlyFiles = {
    'lib/server/_server.lua',
    'lib/server/http.lua',
    'lib/server/outbox.lua',
    'lib/server/featureflag/featureflag.lua',
    'lib/server/services.lua',
    'lib/server/events.lua',
    'lib/server/stats.lua',
    'lib/server/player.lua',
    'lib/server/identity.lua',
    'lib/server/ptfx.lua',
    'lib/server/nametags.lua',
    'lib/server/stats/v2.lua',
}

local clientOnlyFiles = {
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

-- Populate serverFilesystem
for _, f in ipairs(sharedFiles) do
    if LoadResourceFile(RESOURCE_NAME, f) then
        serverFilesystem[#serverFilesystem + 1] = f
    end
end
for _, f in ipairs(serverOnlyFiles) do
    if LoadResourceFile(RESOURCE_NAME, f) then
        serverFilesystem[#serverFilesystem + 1] = f
    end
end

-- Populate clientFilesystem
for _, f in ipairs(sharedFiles) do
    if LoadResourceFile(RESOURCE_NAME, f) then
        clientFilesystem[#clientFilesystem + 1] = f
    end
end
for _, f in ipairs(clientOnlyFiles) do
    if LoadResourceFile(RESOURCE_NAME, f) then
        clientFilesystem[#clientFilesystem + 1] = f
    end
end

exports('getServerLibraryFilesystem', function()
    return serverFilesystem
end)

exports('getClientLibraryFilesystem', function()
    return clientFilesystem
end)

GlobalState:set(STATEBAG_KEY__SXLIB_CLIENT_FILESYSTEM, clientFilesystem, true)
GlobalState:set(STATEBAG_KEY__SXLIB_CLIENT_FILESYSTEM_IS_READY, true, true)
GlobalState:set(STATEBAG_KEY__SXLIB_SERVER_FILESYSTEM, serverFilesystem, false)
GlobalState:set(STATEBAG_KEY__SXLIB_SERVER_FILESYSTEM_IS_READY, true, false)
SetIsLibraryFilesystemReady(true)
print('^2[SX] Library filesystem built successfully with ' .. #serverFilesystem .. ' server files and ' .. #clientFilesystem .. ' client files.^0')
