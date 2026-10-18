lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "Enter FFA",
        ["Fuzil"] = "Assault Rifle",
        ["Domn"] = "Palacio Oni",
        ["Lobao"] = "Lobao",
        ["Pistola"] = "Pistol",
        ["enterArena"] = "Enter Arena",
        ["exitArena"] = "Exit",
    },

    ["pt-br"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "Entrar em FFA",
        ["Fuzil"] = "Fuzil",
        ["Domn"] = "Palacio Oni",
        ["Lobao"] = "Lobao",
        ["Pistola"] = "Pistola",
        ["enterArena"] = "Entrar na Arena",
        ["exitArena"] = "Sair",
    },

    ["fr-fr"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "Entrer dans le FFA",
        ["Fuzil"] = "Fusil",
        ["Domn"] = "Palais Oni",
        ["Lobao"] = "Lobao",
        ["Pistola"] = "Pistolet",
        ["enterArena"] = "Entrer dans l'Arena",
        ["exitArena"] = "Sortir",
    },

    ["pt-pt"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "Entrar em FFA",
        ["Fuzil"] = "Fuzil",
        ["Lobao"] = "Lobao",
        ["Pistola"] = "Pistola",
        ["Domn"] = "Palacio Oni",
        ["enterArena"] = "Entrar na Arena",
        ["exitArena"] = "Sair",
    },

    ["es-es"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "Entrar en FFA",
        ["Fuzil"] = "Rifle de Asalto",
        ["Domn"] = "Palacio Oni",
        ["Lobao"] = "Lobao",
        ["Pistola"] = "Pistola",
        ["enterArena"] = "Entrar en la Arena",
        ["exitArena"] = "Salir",
    },

    ["de-de"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "FFA betreten",
        ["Fuzil"] = "Sturmgewehr",
        ["Domn"] = "Palacio Oni",
        ["Lobao"] = "Lobao",
        ["Pistola"] = "Pistole",
        ["enterArena"] = "Arena betreten",
        ["exitArena"] = "Verlassen",
    },

    ["ar-sa"] = {
        ["Wellington"] = "Wellington",
        ["enterFFA"] = "دخول FFA",
        ["Fuzil"] = "بندقية هجومية",
        ["Domn"] = "قصر أوني",
        ["Lobao"] = "لوابو",
        ["Pistola"] = "مسدس",
        ["enterArena"] = "دخول الساحة",
        ["exitArena"] = "خروج",
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
