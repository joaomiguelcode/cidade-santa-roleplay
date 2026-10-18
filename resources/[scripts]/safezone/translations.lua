lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["banned.remainTime"] = "You have %s remaining of advertence time.",
        ["banned.reason"] = "[GROUNDED] %s! [By]: %s\n You have %s remaining.",
        ["banned.reason2"] = "[GROUNDED] %s! [By]: %s.",
        ["days"] = "Days",
        ["hours"] = "Hours",
        ["minutes"] = "Minutes",
        ["seconds"] = "Seconds",
    },
    ["pt-br"] = {
        ["banned.remainTime"] = "Você tem %s restantes de advertência.",
        ["banned.reason"] = "[CASTIGO]: %s!  [Por]: %s\n Você tem %s restantes.",
        ["banned.reason2"] = "[CASTIGO]: %s!  [Por]: %s.",
        ["days"] = "Dias",
        ["hours"] = "Horas",
        ["minutes"] = "Minutos",
        ["seconds"] = "Segundos",
    },
    ["fr-fr"] = {
        ["banned.remainTime"] = "Vous avez %s restantes de temps d'avertissement.",
        ["banned.reason"] = "[GROUNDED] %s! [Par]: %s\n Vous avez %s restantes.",
        ["banned.reason2"] = "[GROUNDED] %s! [Par]: %s.",
        ["days"] = "Jours",
        ["hours"] = "Heures",
        ["minutes"] = "Minutes",
        ["seconds"] = "Secondes",
    },
    ["pt-pt"] = {
        ["banned.remainTime"] = "Você tem %s restantes de advertência.",
        ["banned.reason"] = "[CASTIGO]: %s!  [Por]: %s\n Você tem %s restantes.",
        ["banned.reason2"] = "[CASTIGO]: %s!  [Por]: %s.",
        ["days"] = "Dias",
        ["hours"] = "Horas",
        ["minutes"] = "Minutos",
        ["seconds"] = "Segundos",
    },
    ["es-es"] = {
        ["banned.remainTime"] = "Te quedan %s de advertencia.",
        ["banned.reason"] = "[CASTIGO]: %s!  [Por]: %s\n Te quedan %s.",
        ["banned.reason2"] = "[CASTIGO]: %s!  [Por]: %s.",
        ["days"] = "Días",
        ["hours"] = "Horas",
        ["minutes"] = "Minutos",
        ["seconds"] = "Segundos",
    },

    ["de-de"] = {
        ["banned.remainTime"] = "Du hast noch %s Verwarungszeit übrig.",
        ["banned.reason"] = "[VERWARNUNG]: %s! [Von]: %s\n Du hast noch %s übrig.",
        ["banned.reason2"] = "[VERWARNUNG]: %s! [Von]: %s.",
        ["days"] = "Tage",
        ["hours"] = "Stunden",
        ["minutes"] = "Minuten",
        ["seconds"] = "Sekunden",
    },

    ["ar-sa"] = {
        ["banned.remainTime"] = "You have %s remaining of advertence time.",
        ["banned.reason"] = "[GROUNDED] %s! [By]: %s\n You have %s remaining.",
        ["banned.reason2"] = "[GROUNDED] %s! [By]: %s.",
        ["days"] = "Days",
        ["hours"] = "Hours",
        ["minutes"] = "Minutes",
        ["seconds"] = "Seconds",
    },
}



---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    if not translations[lang] then
        print("[DEBUG] Translation not found for Lang: " .. lang)
        return false
    end
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
