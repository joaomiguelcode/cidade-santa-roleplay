lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["openHotbar"] = "Handle the hotbar.",
        ["tasktip"] = "PRESS THE NUMBER THAT APPEARS IN THE CENTER",
        ["verif_title"] = "HUMAN VERIFICATION",
        ["verif_desc"] = "Click on the image of:",
        ["icon_car"] = "CAR",
        ["icon_bird"] = "BIRD",
        ["icon_house"] = "HOUSE",
        ["icon_key"] = "KEY",
        ["icon_money"] = "MONEY",
        ["icon_heart"] = "HEART",
        ["icon_star"] = "STAR",
        ["icon_phone"] = "PHONE",
        ["icon_gift"] = "GIFT",
        ["FARM DE MUNIÇÃO"] = "AMMO FARM",
        ["Pressione para iniciar"] = "Press to start",
    },
    
    ["pt-br"] = {
        ["openHotbar"] = "Manusear a hotbar.",
        ["tasktip"] = "APERTE O NÚMERO QUE APARECE NO CENTRO",
        ["verif_title"] = "VERIFICAÇÃO HUMANA",
        ["verif_desc"] = "Clique na imagem de:",
        ["icon_car"] = "CARRO",
        ["icon_bird"] = "PÁSSARO",
        ["icon_house"] = "CASA",
        ["icon_key"] = "CHAVE",
        ["icon_money"] = "DINHEIRO",
        ["icon_heart"] = "CORAÇÃO",
        ["icon_star"] = "ESTRELA",
        ["icon_phone"] = "TELEFONE",
        ["icon_gift"] = "PRESENTE",
        ["FARM DE MUNIÇÃO"] = "FARM DE MUNIÇÃO",
        ["Pressione para iniciar"] = "Pressione para iniciar",
    },

    ["fr-fr"] = {
        ["openHotbar"] = "Manipuler la barre d'outils.",
        ["tasktip"] = "APPUIYEZ SUR LE NUMÉRO AU CENTRE",
        ["verif_title"] = "VÉRIFICATION HUMAINE",
        ["verif_desc"] = "Cliquez sur l'image de :",
        ["icon_car"] = "VOITURE",
        ["icon_bird"] = "OISEAU",
        ["icon_house"] = "MAISON",
        ["icon_key"] = "CLÉ",
        ["icon_money"] = "ARGENT",
        ["icon_heart"] = "CŒUR",
        ["icon_star"] = "ÉTOILE",
        ["icon_phone"] = "TÉLÉPHONE",
        ["icon_gift"] = "CADEAU",
        ["FARM DE MUNIÇÃO"] = "FARM DE MUNITIONS",
        ["Pressione para iniciar"] = "Appuyez pour commencer",
    },

    ["es-es"] = {
        ["openHotbar"] = "Manejar la barra de acceso rápido.",
        ["tasktip"] = "PRESIONA EL NÚMERO QUE APARECE EN EL CENTRO",
        ["verif_title"] = "VERIFICACIÓN HUMANA",
        ["verif_desc"] = "Haga clic en la imagen de:",
        ["icon_car"] = "COCHE",
        ["icon_bird"] = "PÁJARO",
        ["icon_house"] = "CASA",
        ["icon_key"] = "LLAVE",
        ["icon_money"] = "DINERO",
        ["icon_heart"] = "CORAZÓN",
        ["icon_star"] = "ESTRELLA",
        ["icon_phone"] = "TELÉFONO",
        ["icon_gift"] = "REGALO",
        ["FARM DE MUNIÇÃO"] = "GRANJA DE MUNICIÓN",
        ["Pressione para iniciar"] = "Presiona para iniciar",
    },

    ["pt-pt"] = {
        ["openHotbar"] = "Manusear a barra de atalhos.",
        ["tasktip"] = "PRESSIONE O NÚMERO QUE APARECE NO CENTRO",
        ["verif_title"] = "VERIFICAÇÃO HUMANA",
        ["verif_desc"] = "Clique na imagem de:",
        ["icon_car"] = "CARRO",
        ["icon_bird"] = "PÁSSARO",
        ["icon_house"] = "CASA",
        ["icon_key"] = "CHAVE",
        ["icon_money"] = "DINHEIRO",
        ["icon_heart"] = "CORAÇÃO",
        ["icon_star"] = "ESTRELA",
        ["icon_phone"] = "TELEMÓVEL",
        ["icon_gift"] = "PRESENTE",
        ["FARM DE MUNIÇÃO"] = "FARM DE MUNIÇÃO",
        ["Pressione para iniciar"] = "Pressione para iniciar",
    },

    ["de-de"] = {
        ["openHotbar"] = "Hotbar bedienen.",
        ["tasktip"] = "DRÜCKE DIE ZAHL IN DER MITTE",
        ["verif_title"] = "MENSCHLICHE VERIFIZIERUNG",
        ["verif_desc"] = "Klicke auf das Bild von:",
        ["icon_car"] = "AUTO",
        ["icon_bird"] = "VOGEL",
        ["icon_house"] = "HAUS",
        ["icon_key"] = "SCHLÜSSEL",
        ["icon_money"] = "GELD",
        ["icon_heart"] = "HERZ",
        ["icon_star"] = "STERN",
        ["icon_phone"] = "TELEFON",
        ["icon_gift"] = "GESCHENK",
        ["FARM DE MUNIÇÃO"] = "MUNITIONS-FARM",
        ["Pressione para iniciar"] = "Drücken zum Starten",
    },

    ["ar-sa"] = {
        ["openHotbar"] = "التعامل مع الشريط السريع.",
        ["tasktip"] = "اضغط على الرقم الذي يظهر في الوسط",
        ["verif_title"] = "التحقق البشري",
        ["verif_desc"] = "انقر على صورة:",
        ["icon_car"] = "سيارة",
        ["icon_bird"] = "طائر",
        ["icon_house"] = "منزل",
        ["icon_key"] = "مفتاح",
        ["icon_money"] = "مال",
        ["icon_heart"] = "قلب",
        ["icon_star"] = "نجمة",
        ["icon_phone"] = "هاتف",
        ["icon_gift"] = "هدية",
        ["FARM DE MUNIÇÃO"] = "زراعة الذخيرة",
        ["Pressione para iniciar"] = "اضغط للبدء",
    }

}

function CheckTranslation(key)
    if translations[lang][key] then
        return true
    else
        return false
    end
end

function _t(key)
    if CheckTranslation(key) then
        return translations[lang][key]
    else
        return key
    end
end
