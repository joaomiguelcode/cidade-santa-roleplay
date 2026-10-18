lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["accessBank"] = "Access Bank",
    },

    ["pt-br"] = {
        ["accessBank"] = "Acessar Banco",
    },

    ["fr-fr"] = {
        ["accessBank"] = "Accéder au Banco",
    },

    ["pt-pt"] = {
        ["accessBank"] = "Aceder ao Banco",
    },

    ["es-es"] = {
        ["accessBank"] = "Acceder al Banco",
    },

    ["de-de"] = {
        ["accessBank"] = "Bank zugreifen",
    },

    ["ar-sa"] = {
        ["accessBank"] = "الوصول إلى البنك",
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