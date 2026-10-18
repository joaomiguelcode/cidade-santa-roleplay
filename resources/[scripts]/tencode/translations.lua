lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["closegang"] = "closegang",
        ["gang"] = "gang",
        ["gangFree"] = "Free Gang- Claim it on Discord | Call 'Gang Support'",
        ["callmedic"] = "Call Medic.",
        ["enterTencodes"] = "Handle police codes.",
        ["toggleRadar"] = "Toggle vehicle radar.",
        ["toggleFreeze"] = "Lock/Unlock vehicle radar.",

        ["text.code"] = "The officer %s is requesting %s. Open the map and search for the star.",
        ["text.title"] = "Code",
    },

    ["pt-br"] = {
        ["closegang"] = "facperto",
        ["gang"] = "fac",
        ["gangFree"] = "Fac Livre - Assuma no Discord | Call 'Pegar Fac'",
        ["callmedic"] = "Chamar Medico.",
        ["enterTencodes"] = "Manusear o código policial.",
        ["toggleRadar"] = "Ativar/Desativar radar das viaturas.",
        ["toggleFreeze"] = "Travar/Destravar radar das viaturas.",

        ["text.code"] = "O oficial %s está solicitando %s. Abra o mapa e procure pela estrela.",
        ["text.title"] = "Codigo",
    },

    ["fr-fr"] = {
        ["closegang"] = "facproche",
        ["gang"] = "fac",
        ["gangFree"] = "Fac Libre - Rejoignez sur Discord | Appelez 'Prendre Fac'",
        ["callmedic"] = "Appeler un médecin.",
        ["enterTencodes"] = "Manipuler le code policier.",
        ["toggleRadar"] = "Activer/Désactiver le radar des véhicules.",
        ["toggleFreeze"] = "Verrouiller/Déverrouiller le radar des véhicules.",
        
        ["text.code"] = "L'officier %s demande %s. Ouvrez la carte et cherchez l'étoile.",
        ["text.title"] = "Code",
    },

    ["es-es"] = {
        ["closegang"] = "facerca",
        ["gang"] = "fac",
        ["gangFree"] = "Fac Libre - Asume en Discord | Call 'Obtener Fac'",
        ["callmedic"] = "Llamar Médico.",
        ["enterTencodes"] = "Manejar el código policial.",
        ["toggleRadar"] = "Activar/Desactivar radar de los vehículos.",
        ["toggleFreeze"] = "Bloquear/Desbloquear radar de los vehículos.",

        ["text.code"] = "El oficial %s está solicitando %s. Abre el mapa y busca la estrella.",
        ["text.title"] = "Codigo",
    },

    ["pt-pt"] = {
        ["closegang"] = "facperto",
        ["gang"] = "fac",
        ["gangFree"] = "Fac Livre - Assuma no Discord | Chame 'Pegar Fac'",
        ["callmedic"] = "Chamar Médico.",
        ["enterTencodes"] = "Manusear o código policial.",
        ["toggleRadar"] = "Ativar/Desativar radar das viaturas.",
        ["toggleFreeze"] = "Travar/Destravar radar das viaturas.",

        ["text.code"] = "O oficial %s está solicitando %s. Abra o mapa e procure pela estrela.",
        ["text.title"] = "Codigo",
    },

    ["de-de"] = {
        ["closegang"] = "gangnah",
        ["gang"] = "Gang",
        ["gangFree"] = "Freie Gang – Übernahme im Discord | Rufe 'Gang-Support'",
        ["callmedic"] = "Medic rufen.",
        ["enterTencodes"] = "Polizeicode verwalten.",
        ["toggleRadar"] = "Fahrzeugradar ein-/ausschalten.",
        ["toggleFreeze"] = "Fahrzeugradar sperren/entsperren.",
        ["text.code"] = "Der Beamte %s fordert %s an. Öffne die Karte und suche den Stern.",
        ["text.title"] = "Code",
    },

    ["ar-sa"] = {
        ["closegang"] = "عصابة قريبة",
        ["gang"] = "عصابة",
        ["gangFree"] = "عصابة متاحة - ادعها على الديسكورد | اتصل 'بدعم العصابات'",
        ["callmedic"] = "استدعاء المسعف.",
        ["enterTencodes"] = "التعامل مع رموز الشرطة.",
        ["toggleRadar"] = "تبديل رادار المركبة.",
        ["toggleFreeze"] = "قفل/فتح رادار المركبة.",
        ["text.code"] = "الضابط %s يطلب %s. افتح الخريطة وابحث عن النجمة.",
        ["text.title"] = "الرمز",
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