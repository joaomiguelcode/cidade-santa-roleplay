lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["illegal_race"] = "Illegal Race",
        ["start_race"] = "Start Race",
        ["start_race_prompt"] = "[~g~E~w~] Start Race"
    },
    ["pt-br"] = {
        ["illegal_race"] = "Corrida Ilegal",
        ["start_race"] = "Iniciar Corrida",
        ["start_race_prompt"] = "[~g~E~w~] Iniciar Corrida"
    },
    ["fr-fr"] = {
        ["illegal_race"] = "Course Illégale",
        ["start_race"] = "Démarrer la Course",
        ["start_race_prompt"] = "[~g~E~w~] Démarrer la Course"
    },
    ["pt-pt"] = {
        ["illegal_race"] = "Corrida Ilegal",
        ["start_race"] = "Iniciar Corrida",
        ["start_race_prompt"] = "[~g~E~w~] Iniciar Corrida"
    },
    ["es-es"] = {
        ["illegal_race"] = "Carrera Ilegal",
        ["start_race"] = "Iniciar Carrera",
        ["start_race_prompt"] = "[~g~E~w~] Iniciar Carrera"
    },

    ["de-de"] = {
        ["illegal_race"] = "Illegales Rennen",
        ["start_race"] = "Rennen starten",
        ["start_race_prompt"] = "[~g~E~w~] Rennen starten"
    },

    ["ar-sa"] = {
        ["illegal_race"] = "سباق غير قانوني",
        ["start_race"] = "بدء السباق",
        ["start_race_prompt"] = "[~g~E~w~] بدء السباق"
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