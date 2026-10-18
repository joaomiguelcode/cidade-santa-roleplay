lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["day"] = "day",
        ["night"] = "night",
    },
    ["pt-br"] = {
        ["day"] = "dia",
        ["night"] = "noite",
    },

    ["fr-fr"] = {
        ["day"] = "jour",
        ["night"] = "nuit",
    },

    ["es-es"] = {
        ["day"] = "día",
        ["night"] = "noche",
    },
    ["pt-pt"] = {
        ["day"] = "dia",
        ["night"] = "noite",
    },

    ["de-de"] = {
        ["day"] = "Tag",
        ["night"] = "Nacht",
    },
    ["ar-sa"] = {
        ["day"] = "نهار",
        ["night"] = "ليل",
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