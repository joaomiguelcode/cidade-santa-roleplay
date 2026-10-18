lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["title"] = "Objective",
        ["hide"] = {
            ["name"] = "Hint",
            ["description"] = "Hide Hint",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "Hint",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "Press to close."
    },
    ["pt-br"] = {
        ["title"] = "Objetivo",
        ["hide"] = {
            ["name"] = "Dica",
            ["description"] = "Esconder Dica",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "Dica",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "Pressione para fechar."
    },
    ["fr-fr"] = {
        ["title"] = "Objectif",
        ["hide"] = {
            ["name"] = "Astuce",
            ["description"] = "Masquer Astuce",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "Astuce",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "Appuyez pour fermer."
    },
    ["pt-pt"] = {
        ["title"] = "Objetivo",
        ["hide"] = {
            ["name"] = "Dica",
            ["description"] = "Esconder Dica",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "Dica",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "Pressione para fechar."
    },
    ["es-es"] = {
        ["title"] = "Objetivo",
        ["hide"] = {
            ["name"] = "Pista",
            ["description"] = "Ocultar Pista",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "Pista",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "Presiona para cerrar."
    },

    ["de-de"] = {
        ["title"] = "Ziel",
        ["hide"] = {
            ["name"] = "Hinweis",
            ["description"] = "Hinweis ausblenden",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "Hinweis",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "Drücke zum Schließen."
    },

    ["ar-sa"] = {
        ["title"] = "الهدف",
        ["hide"] = {
            ["name"] = "تلميح",
            ["description"] = "إخفاء التلميح",
            ["defaultKey"] = "Z"
        },
        ["testCommand"] = {
            ["name"] = "تلميح",
            ["description"] = "Lorem <br> consectetur."
        },
        ["close.hint.text"] = "اضغط للإغلاق."
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

---@param key string The translation key to retrieve (supports nested keys with dot notation, e.g., "close.hint.text")
---@return string|table Returns the translated string/table or error message
function _t(key)
    if CheckTranslation(key) then
        return translations[lang][key]
    else
        return "Translation not found for key: " .. key.. " - Lang: " .. lang
    end
end