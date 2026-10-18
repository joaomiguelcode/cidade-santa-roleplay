-- Client control for the generic ptfx subsystem: sx.client.ptfx.create(kind, id, name) / .remove(kind, id).
-- A local-only API that drives a ptfx through the singleton render host (code/client/ptfx/) via a local
-- event. `kind` is ePtfxKind.player (id = a server id, ped resolved each frame) or ePtfxKind.entity (id = a
-- local ped/object handle you own; remove it before deleting the handle). Lib is copied into every
-- consumer, so consumers call these; the host listens. (Server-authoritative effects come in over the
-- 'sxPtfx' statebag instead; the host merges both inputs.)
sx.client = sx.client or {}
sx.client.ptfx = sx.client.ptfx or {}

---@param kind SxKind -- ePtfxKind.player | ePtfxKind.entity
---@param id   number -- server id (player kind) or local entity handle (entity kind)
---@param name string -- a PTFX_* name constant
function sx.client.ptfx.create( kind, id, name )

    TriggerEvent( 'sx:client:ptfx:create', kind, id, name )
end

---@param kind SxKind
---@param id   number
function sx.client.ptfx.remove( kind, id )

    TriggerEvent( 'sx:client:ptfx:remove', kind, id )
end
