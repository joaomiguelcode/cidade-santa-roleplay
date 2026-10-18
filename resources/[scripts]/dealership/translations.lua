lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["dealership"] = "Open Dealership",
        
        -- Purchase Dialog
        ["purchase_vehicle_prompt"] = "Do you want to open the store to purchase the vehicle?",
        ["yes"] = "Yes",
        ["no"] = "No",
        
        -- Test Drive Dialog
        ["test_drive_prompt"] = "Start the test drive",
        ["test_drive_accept"] = "Yes, start test",
        ["test_drive_decline"] = "No, I'll come back later",
    },
    
    ["pt-br"] = {
        ["dealership"] = "Abrir Concessionaria",
        
        -- Purchase Dialog
        ["purchase_vehicle_prompt"] = "Deseja abrir a loja para efetuar a compra do veiculo?",
        ["yes"] = "Sim",
        ["no"] = "Não",
        
        -- Test Drive Dialog
        ["test_drive_prompt"] = "Iniciar o teste",
        ["test_drive_accept"] = "Sim, iniciar o teste",
        ["test_drive_decline"] = "Não, volto depois",
    },

    ["fr-fr"] = {
        ["dealership"] = "Ouvrir la concession",
        
        -- Purchase Dialog
        ["purchase_vehicle_prompt"] = "Voulez-vous ouvrir la boutique pour acheter le véhicule ?",
        ["yes"] = "Oui",
        ["no"] = "Non",
        
        -- Test Drive Dialog
        ["test_drive_prompt"] = "Démarrer l'essai",
        ["test_drive_accept"] = "Oui, démarrer l'essai",
        ["test_drive_decline"] = "Non, je reviendrai plus tard",
    },

    ["es-es"] = {
        ["dealership"] = "Abrir Concesionario",
        
        -- Purchase Dialog
        ["purchase_vehicle_prompt"] = "¿Deseas abrir la tienda para efectuar la compra del vehículo?",
        ["yes"] = "Sí",
        ["no"] = "No",
        
        -- Test Drive Dialog
        ["test_drive_prompt"] = "Iniciar la prueba",
        ["test_drive_accept"] = "Sí, iniciar la prueba",
        ["test_drive_decline"] = "No, vuelvo después",
    },

    ["pt-pt"] = {
        ["dealership"] = "Abrir Concessionário",
        
        -- Purchase Dialog
        ["purchase_vehicle_prompt"] = "Deseja abrir a loja para efetuar a compra do veículo?",
        ["yes"] = "Sim",
        ["no"] = "Não",
        
        -- Test Drive Dialog
        ["test_drive_prompt"] = "Iniciar o teste",
        ["test_drive_accept"] = "Sim, iniciar o teste",
        ["test_drive_decline"] = "Não, volto depois",
    },

    ["de-de"] = {
        ["dealership"] = "Autohaus öffnen",
        ["purchase_vehicle_prompt"] = "Möchtest du den Laden öffnen, um das Fahrzeug zu kaufen?",
        ["yes"] = "Ja",
        ["no"] = "Nein",
        ["test_drive_prompt"] = "Probefahrt starten",
        ["test_drive_accept"] = "Ja, Probefahrt starten",
        ["test_drive_decline"] = "Nein, ich komme später wieder",
    },

    ["ar-sa"] = {
        ["dealership"] = "افتح معرض السيارات",
        
        -- Purchase Dialog
        ["purchase_vehicle_prompt"] = "هل تريد فتح المتجر لشراء السيارة؟",
        ["yes"] = "نعم",
        ["no"] = "لا",
        
        -- Test Drive Dialog
        ["test_drive_prompt"] = "ابدأ التجربة",
        ["test_drive_accept"] = "نعم, ابدأ التجربة",
        ["test_drive_decline"] = "لا, سأعود لاحقا",
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