translations = {
    ["en-us"] = {
        ["newbies"] = "newbies",
        ["command.newbies"] = "newbies",
        ["open_barbershop"] = "Open Barbershop",
        ["barbershop_plastic_request"] = "Do you want to pay $10,000,000 to perform plastic surgery?",
    },
    ["pt-br"] = {
        ["newbies"] = "iniciantes",
        ["command.newbies"] = "iniciantes",
        ["open_barbershop"] = "Abrir Barbearia",
        ["barbershop_plastic_request"] = "Deseja pagar 10 milhões para aplicar a plástica?",
    },

    ["fr-fr"] = {
        ["newbies"] = "débutants",
        ["command.newbies"] = "débutants",
        ["open_barbershop"] = "Ouvrir le salon de coiffure",
        ["barbershop_plastic_request"] = "Voulez-vous payer 10 millions pour effectuer une chirurgie esthétique?",
    },

    ["pt-pt"] = {
        ["newbies"] = "iniciados",
        ["command.newbies"] = "iniciados",
        ["open_barbershop"] = "Abrir Barbearia",
        ["barbershop_plastic_request"] = "Deseja pagar 10 milhões para aplicar a plástica?",
    },
    ["es-es"] = {
        ["newbies"] = "principiantes",
        ["command.newbies"] = "principiantes",
        ["open_barbershop"] = "Abrir Barbería",
        ["barbershop_plastic_request"] = "¿Desea pagar 10 millones para realizar una cirugía plástica?",
    },

    ["de-de"] = {
        ["newbies"] = "Anfänger",
        ["command.newbies"] = "Anfänger",
        ["open_barbershop"] = "Friseursalon öffnen",
        ["barbershop_plastic_request"] = "Möchten Sie 10 Millionen bezahlen, um eine Schönheitsoperation durchzuführen?",
    },

    ["ar-sa"] = {
        ["newbies"] = "المبتدئين",
        ["command.newbies"] = "المبتدئين",
        ["open_barbershop"] = "فتح صالون الحلاقة",
        ["barbershop_plastic_request"] = "هل تريد دفع 10 ملايين لإجراء عملية تجميل؟",
    },
}

---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    if translations[LANGUAGE][key] then
        return true
    else
        print("[DEBUG] Translation not found for key: " .. key.. " - Lang: " .. LANGUAGE)
        return false
    end
end

---@param key string The translation key to retrieve
---@return string Returns the translated string or error message
function _t(key)
    if CheckTranslation(key) then
        return translations[LANGUAGE][key]
    else
        return "Translation not found for key: " .. key.. " - Lang: " .. LANGUAGE
    end
end

