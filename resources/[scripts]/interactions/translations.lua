lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["open_interactions"] = "Abrir Interactions",
    },
    
    ["pt-br"] = {
        ["open_interactions"] = "Abrir Interactions",
    },

    ["fr-fr"] = {
        ["open_interactions"] = "Ouvrir les interactions",
    },

    ["es-es"] = {
        ["open_interactions"] = "Abrir Interacciones",
    },

    ["pt-pt"] = {
        ["open_interactions"] = "Abrir Interações",
    },

    ["de-de"] = {
        ["open_interactions"] = "Interaktionen öffnen",
    },
    ["ar-sa"] = {
        ["open_interactions"] = "Open Interactions",
    }
}

---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    if translations[lang][key] then
        return true
    else
        print("[DEBUG] Translation not found for key: " .. key.. " - Lang: " .. lang)
        return false
    end
end

---@param key string The translation key to retrieve
---@return string Returns the translated string or error message
function _t(key)
    if CheckTranslation(key) then
        return translations[lang][key]
    else
        return "Translation not found for key: " .. key.. " - Lang: " .. lang
    end
end