local i18n = sx.i18n
    .init({
        backend = sx.i18n.backends.fsBackend( 'localization' ) -- Nome do resource que guardar os locales.
    })

---@param keys      string | string[]
---@param options?  table
function sx.t( keys, options )

    keys = type( keys ) == 'table' and keys or { keys }

    return sx.i18n.translate( i18n, keys, options )
end

local text = sx.t( 'item:weapon_assault_rifle', { name = 'hi' } )