lang = GetConvar( "language", "pt-br" ) or "pt-br"

local LOCALE_RESOURCE = "localization"

---@param targetLang string
---@return table<string, string>?
local function loadLocale( targetLang )
    local fileUrl = ( "locales/frontend-i18n-config/%s/survey.json" ):format( targetLang )
    local contents = LoadResourceFile( LOCALE_RESOURCE, fileUrl )

    if not contents then
        return nil
    end

    return json.decode( contents )
end

local translations = loadLocale( lang ) or loadLocale( "pt-br" ) or {}

---@param key string
---@return boolean
function CheckTranslation( key )
    return translations[ key ] ~= nil
end

---@param key string
---@return string
function _t( key )
    local value = translations[ key ]

    if value ~= nil then
        return value
    end

    return "Translation not found for key: " .. key .. " - Lang: " .. lang
end
