-- Shared kind enum for the replicated-cosmetic subsystems (ptfx + nametags). One value space serves both:
--   * 'player' binds the effect to a PLAYER — `id` is a server id and the render host resolves the ped from
--     it each pass (so respawn/stream-in are picked up).
--   * 'entity' binds it to a LOCAL entity handle — `id` IS a ped/object handle the caller owns and must
--     remove before deleting.
-- These are exactly the literals the render hosts already store in an entry's `kind`. It lives in the sx
-- shared scope (loaded before the hosts) so the copied-into-consumers lib, the consumers themselves, and the
-- sx-only render host code all read the same global.
---@alias SxKind 'player' | 'entity'

---@type table<string, SxKind>
ePtfxKind = {
    player = 'player',
    entity = 'entity',
}
