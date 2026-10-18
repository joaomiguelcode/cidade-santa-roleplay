lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["locked"] = "Locked",
        ["unLocked"] = "Unlocked",
        ["toLock"] = "Unlock",
        ["toUnlock"] = "Lock",
    },
    
    ["pt-br"] = {
        ["locked"] = "Trancado",
        ["unLocked"] = "Destrancado",
        ["toLock"] = "Para trancar",
        ["toUnlock"] = "Para destrancar",
    },

    ["fr-fr"] = {
        ["locked"] = "Verrouillé",
        ["unLocked"] = "Déverrouillé",
        ["toLock"] = "Verrouiller",
        ["toUnlock"] = "Déverrouiller",
    },

    ["pt-pt"] = {
        ["locked"] = "Trancado",
        ["unLocked"] = "Destrancado",
        ["toLock"] = "Para trancar",
        ["toUnlock"] = "Para destrancar",
    },

    ["es-es"] = {
        ["locked"] = "Cerrado",
        ["unLocked"] = "Abierto",
        ["toLock"] = "Cerrar",
        ["toUnlock"] = "Abrir",
    },

    ["de-de"] = {
        ["locked"] = "Verschlossen",
        ["unLocked"] = "Entsperrt",
        ["toLock"] = "Verschließen",
        ["toUnlock"] = "Entsperren",
    },

    ["ar-sa"] = {
        ["locked"] = "مقفل",
        ["unLocked"] = "مفتوح",
        ["toLock"] = "قفل",
        ["toUnlock"] = "فتح",
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