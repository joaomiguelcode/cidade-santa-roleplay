-- Client control for the generic nametag subsystem: sx.client.nametags.create(kind, id, name) /
-- .remove(kind, id). Drives the singleton render host (code/client/nametags/) via local events. `kind` is
-- ePtfxKind.player (id = a server id, ped resolved each frame) or ePtfxKind.entity (id = a local ped/object
-- handle you own; remove it before deleting the handle).
sx.client = sx.client or {}
sx.client.nametags = sx.client.nametags or {}

---@param kind SxKind -- ePtfxKind.player | ePtfxKind.entity
---@param id   number -- server id (player kind) or local entity handle (entity kind)
---@param name string -- a NAMETAG_* constant (e.g. NAMETAG_SOCIAL_RANK)
function sx.client.nametags.create( kind, id, name )

    TriggerEvent( 'sx:client:nametags:create', kind, id, name )
end

---@param kind SxKind
---@param id   number
function sx.client.nametags.remove( kind, id )

    TriggerEvent( 'sx:client:nametags:remove', kind, id )
end
