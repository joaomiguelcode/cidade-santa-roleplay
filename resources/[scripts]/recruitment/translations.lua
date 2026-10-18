lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["recruitment.command"] = "recruitment",
        ["command.recruitment"] = "recruitment",
        ["job.legal"] = "💰 Legal Employment",
        ["job.chopshop"] = "🚗 Chop Shop",
        ["job.moneylaundering"] = "🎰 Money Laundering",
        ["job.weapons"] = "⚔️ Weapons",
        ["job.drugs"] = "🌿 Drugs",
    },
    ["pt-br"] = {
        ["recruitment.command"] = "recrutamento",
        ["command.recruitment"] = "recrutamento",
        ["job.legal"] = "💰 Emprego Legal",
        ["job.chopshop"] = "🚗 Desmanche",
        ["job.moneylaundering"] = "🎰 Lavagem",
        ["job.weapons"] = "⚔️ Armas",
        ["job.drugs"] = "🌿 Drogas",
    },

    ["fr-fr"] = {
        ["recruitment.command"] = "recrutement",
        ["command.recruitment"] = "recrutement",
        ["job.legal"] = "💰 Emploi légal",
        ["job.chopshop"] = "🚗 Dépôt-vente",
        ["job.moneylaundering"] = "🎰 Blanchiment",
        ["job.weapons"] = "⚔️ Armes",
        ["job.drugs"] = "🌿 Drogues",
    },

    ["pt-pt"] = {
        ["recruitment.command"] = "recrutamento",
        ["command.recruitment"] = "recrutamento",
        ["job.legal"] = "💰 Emprego Legal",
        ["job.chopshop"] = "🚗 Desmanche",
        ["job.moneylaundering"] = "🎰 Lavagem de Dinheiro",
        ["job.weapons"] = "⚔️ Armas",
        ["job.drugs"] = "🌿 Drogas",
    },
    ["es-es"] = {
        ["recruitment.command"] = "reclutamiento",
        ["command.recruitment"] = "reclutamiento",
        ["job.legal"] = "💰 Empleo Legal",
        ["job.chopshop"] = "🚗 Desguace",
        ["job.moneylaundering"] = "🎰 Blanqueo",
        ["job.weapons"] = "⚔️ Armas",
        ["job.drugs"] = "🌿 Drogas",
    },

    ["de-de"] = {
        ["recruitment.command"] = "rekrutierung",
        ["command.recruitment"] = "rekrutierung",
        ["job.legal"] = "💰 Legale Arbeit",
        ["job.chopshop"] = "🚗 Schrottplatz",
        ["job.moneylaundering"] = "🎰 Geldwäsche",
        ["job.weapons"] = "⚔️ Waffen",
        ["job.drugs"] = "🌿 Drogen",
    },

    ["ar-sa"] = {
        ["recruitment.command"] = "recruitment",
        ["command.recruitment"] = "recruitment",
        ["job.legal"] = "💰 Legal Employment",
        ["job.chopshop"] = "🚗 Chop Shop",
        ["job.moneylaundering"] = "🎰 Money Laundering",
        ["job.weapons"] = "⚔️ Weapons",
        ["job.drugs"] = "🌿 Drugs",
    },
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

