lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["tutorial.waypoint.point_of_interest"] = "Point of Interest",
    },

    ["pt-br"] = {
        ["tutorial.waypoint.point_of_interest"] = "Ponto de Interesse",
    },

    ["fr-fr"] = {
        ["tutorial.waypoint.point_of_interest"] = "Point d'Intérêt",
    },

    ["pt-pt"] = {
        ["tutorial.waypoint.point_of_interest"] = "Ponto de Interesse",
    },

    ["es-es"] = {
        ["tutorial.waypoint.point_of_interest"] = "Punto de Interés",
    },

    ["de-de"] = {
        ["tutorial.waypoint.point_of_interest"] = "Sehenswürdigkeit",
    },

    ["ar-sa"] = {
        ["tutorial.waypoint.point_of_interest"] = "نقطة اهتمام",
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
