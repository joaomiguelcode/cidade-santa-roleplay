-- Canonical nametag definition registry. Lives in sx CODE (the renderer's world); sx code does not import
-- sx lib, so the visual defs live here, not in lib. Consumers know only the NAME
-- (lib/shared/nametag_names.lua); the wire carries the registration-order INDEX into byIndex. The index is
-- stable because this file loads in the same manifest order on sx server and client.

---@class NametagDef
---@field index number
---@field name  string
---@field label string                              -- displayed text
---@field emoji string|false                         -- optional glyph drawn centered above the label, or false
---@field color { r: number, g: number, b: number } -- 0-255

---@class NametagRegistry
---@field byName  table<string, NametagDef>
---@field byIndex NametagDef[]
gNametagRegistry = { byName = {}, byIndex = {} }

-- The index is the registration order and is what crosses the wire; the name is the authoring key.
---@param name string
---@return fun( spec: table ): string
function DEFINE_NAMETAG( name )

    return function( spec )

        assert( type( spec ) == 'table', 'Nametag definition must be a table' )
        assert( type( spec.label ) == 'string', 'Nametag must have a label' )

        ---@type NametagDef
        local def = {
            index = #gNametagRegistry.byIndex + 1,
            name  = name:upper(),
            label = spec.label,
            emoji = spec.emoji or false,
            color = spec.color or { r = 255, g = 255, b = 255 },
        }

        gNametagRegistry.byName[ def.name ] = def
        gNametagRegistry.byIndex[ def.index ] = def

        return def.name
    end
end
