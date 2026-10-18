lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["suspicious_entity"] = "Possible crash entity \"%s\".! %s",
        ["police"] = "Police",
    },
    
    ["pt-br"] = {
        ["suspicious_entity"] = "Possível entidade de crash \"%s\".! %s",
        ["police"] = "Policia",
    },

    ["fr-fr"] = {
        ["suspicious_entity"] = "Entité de crash possible \"%s\".! %s",
        ["police"] = "Police",
    },

    ["es-es"] = {
        ["suspicious_entity"] = "Posible entidad de crash \"%s\".! %s",
        ["police"] = "Policia",
    },

    ["pt-pt"] = {
        ["suspicious_entity"] = "Possível entidade de crash \"%s\".! %s",
        ["police"] = "Policia",
    },

    ["de-de"] = {
        ["suspicious_entity"] = "Mögliche Crash-Entität \"%s\".! %s",
        ["police"] = "Polizei",
    },

    ["ar-sa"] = {
        ["suspicious_entity"] = "Possible crash entity \"%s\".! %s",
        ["police"] = "Police",
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