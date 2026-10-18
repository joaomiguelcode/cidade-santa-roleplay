-- Canonical ptfx definition registry. Lives in sx CODE (the renderer's world): the host renders and the
-- authority writes the wire, and sx code does not import sx lib, so the visual defs live here, not in lib.
-- Consumers know only the NAME (lib/shared/ptfx_names.lua) and forward it to the authority; the wire
-- carries the registration-order INDEX into byIndex. The index is stable because this file loads in the
-- same manifest order on sx server and client, so index N means the same def on both sides.

---@class PtfxLayer
---@field dict     string
---@field effect   string
---@field bone?    number   -- ped bone id; nil => attach to entity root
---@field offset   vector3
---@field rotation vector3
---@field scale    number
---@field colour?  { r: number, g: number, b: number } -- 0-255
---@field alpha?   number   -- 0.0-1.0
---@field lodDist  number   -- focus-distance (m) beyond which this layer culls (LOD); math.huge => no cull. Injected at normalize from the layer's layergroup.
---@field loopEveryMilliseconds? number -- nil (default): one persistent engine-looped handle. set: a one-shot fx re-fired this often (ms) while in range, for fx that don't self-loop. Rate is floored at the update tick.
---@field tick?    fun( handle: number, elapsedMs: number ) -- looped layers only: per-frame reposition of the live handle (e.g. SetParticleFxLoopedOffsets to rotate/orbit); nil => static. elapsedMs is the handle's age.

-- One LOD group in a DEFINE_PTFX spec: a set of layers that share a cull distance.
---@class PtfxLayerGroup
---@field lodDist? number      -- focus-distance (m) the group's layers cull beyond; omit => math.huge (no cull)
---@field layers   PtfxLayer[] -- the layers belonging to this group

-- The table passed to a DEFINE_PTFX 'name' { ... } call.
---@class PtfxSpec
---@field layergroups PtfxLayerGroup[]

---@class PtfxDef
---@field index  integer      -- registration order; the value that crosses the wire (key into byIndex)
---@field name   string       -- upper-cased DEFINE_PTFX name; the key consumers reference (key into byName)
---@field layers PtfxLayer[]  -- every layer, flattened from the spec's layergroups, sorted longest lodDist first

---@class PtfxRegistry
---@field byName  table<string, PtfxDef>
---@field byIndex PtfxDef[]
gPtfxRegistry = { byName = {}, byIndex = {} }

---@param layerDef PtfxLayer -- the authored layer table
---@param lodDist number -- cull distance carried from the layer's group (math.huge => no cull)
---@return PtfxLayer
local function NormalizeLayer( layerDef, lodDist )

    assert( type( layerDef.dict ) == 'string', 'Ptfx layer must have a dict' )
    assert( type( layerDef.effect ) == 'string', 'Ptfx layer must have an effect' )

    return {
        dict     = layerDef.dict,
        effect   = layerDef.effect,
        bone     = layerDef.bone,
        offset   = layerDef.offset or vector3( 0.0, 0.0, 0.0 ),
        rotation = layerDef.rotation or vector3( 0.0, 0.0, 0.0 ),
        scale    = layerDef.scale or 1.0,
        colour   = layerDef.colour,
        alpha    = layerDef.alpha,
        lodDist  = lodDist,
        loopEveryMilliseconds = layerDef.loopEveryMilliseconds,
        tick     = layerDef.tick,
    }
end

-- A def is authored as one or more LOD layergroups and flattened into def.layers. A group's layers cull
-- beyond its lodDist (shorter-range groups drop off with distance); omit lodDist for an always-on group.
-- def.layers is sorted longest lodDist first, so when the handle pool is tight the far hero layers are kept
-- and the nearer-only layers are the ones dropped. The index is the registration order and is what crosses
-- the wire; the name is the authoring key consumers reference.
--
-- A layer may carry a `tick( handle, elapsedMs )` for custom per-frame motion (the host runs it every frame
-- on each live handle of that layer). e.g. a particle that orbits its bone once per second:
--   { dict = '...', effect = '...', bone = ..., tick = function( handle, elapsedMs )
--         local a = ( elapsedMs / 1000.0 ) * 2.0 * math.pi
--         SetParticleFxLoopedOffsets( handle, math.cos( a ) * 0.5, math.sin( a ) * 0.5, 0.0, 0.0, 0.0, a )
--     end }
---@param name string
---@return fun( spec: PtfxSpec ): string
function DEFINE_PTFX( name )

    return function( spec )

        assert( type( spec ) == 'table', ('Ptfx "%s" definition must be a table'):format( name ) )
        assert( type( spec.layergroups ) == 'table', ('Ptfx "%s" must declare layergroups'):format( name ) )

        ---@type PtfxLayer[]
        local layers = {}

        for i = 1, #spec.layergroups do
            local group = spec.layergroups[ i ]
            local lodDist = group.lodDist or math.huge
            for j = 1, #group.layers do
                layers[ #layers + 1 ] = NormalizeLayer( group.layers[ j ], lodDist )
            end
        end

        table.sort( layers, function( a, b ) return a.lodDist > b.lodDist end )

        ---@type PtfxDef
        local def = {
            index  = #gPtfxRegistry.byIndex + 1,
            name   = name:upper(),
            layers = layers,
        }

        gPtfxRegistry.byName[ def.name ] = def
        gPtfxRegistry.byIndex[ def.index ] = def

        return def.name
    end
end
