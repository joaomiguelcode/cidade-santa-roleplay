lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["craftingOpen"] = "Open Crafting",
    },

    ["pt-br"] = {
        ["craftingOpen"] = "Abrir Crafting",
    },

    ["fr-fr"] = {
        ["craftingOpen"] = "Ouvrir le Crafting",
    },

    ["es-es"] = {
        ["craftingOpen"] = "Abrir Crafteo",
    },

    ["pt-pt"] = {
        ["craftingOpen"] = "Abrir Artesanato",
    },

    ["de-de"] = {
        ["craftingOpen"] = "Crafting öffnen",
    },

    ["ar-sa"] = {
        ["craftingOpen"] = "فتح التصنيع",
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