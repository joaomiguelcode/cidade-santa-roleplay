
---@alias i18n.i18nLanguage
---| '"pt-BR"'
---| '"en-GB'

---@class i18n.i18nOptions
---@field fallbackLng? i18n.i18nLanguage
---@field backend? i18n.i18nBackend

---@class i18n.i18n
---@field options i18n.i18nOptions

sx.i18n = { }

---@param opts i18n.i18nOptions
---@return i18n.i18n
function sx.i18n.init( opts )

    ---@type i18n.i18n
    local i18n =
    {
        options = opts,
    }

    return i18n
end

---@param i18n i18n.i18n
function sx.i18n.translate( i18n )

    
end

-- backend runs on sx?
-- requests path from backend
-- caches
-- listen to backend changes