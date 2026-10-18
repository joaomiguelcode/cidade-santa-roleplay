lang = GetConvar("language", "pt-br") or "pt-br"

translations = {
    ["en-us"] = {
        ["Party"] = "Open groups.",
        ["PartyTutorialCreateRoomTitle"] = "Create Room",
        ["PartyTutorialCreateRoomContent"] = "Create a room and wait for other players to join.",
        ["PartyTutorialEnterRoomTitle"] = "Join an existing room",
        ["PartyTutorialEnterRoomContent"] = "Join an existing room where other players are already waiting for you.",
    },
    ["pt-br"] = {
        ["Party"] = "Abrir grupos.",
        ["PartyTutorialCreateRoomTitle"] = "Criar Sala",
        ["PartyTutorialCreateRoomContent"] = "Crie uma sala e aguarde a entrada de outros jogadores.",
        ["PartyTutorialEnterRoomTitle"] = "Entrar em uma sala existente",
        ["PartyTutorialEnterRoomContent"] = "Entre em uma sala existente onde outros jogadores já estão te aguardando.",
    },
    ["fr-fr"] = {
        ["Party"] = "Ouvrir les groupes.",
        ["PartyTutorialCreateRoomTitle"] = "Créer une salle",
        ["PartyTutorialCreateRoomContent"] = "Créez une salle et attendez que d'autres joueurs la rejoignent.",
        ["PartyTutorialEnterRoomTitle"] = "Rejoindre une salle existante",
        ["PartyTutorialEnterRoomContent"] = "Rejoignez une salle existante où d'autres joueurs vous attendent déjà.",
    },
    ["pt-pt"] = {
        ["Party"] = "Abrir grupos.",
        ["PartyTutorialCreateRoomTitle"] = "Criar Sala",
        ["PartyTutorialCreateRoomContent"] = "Cria uma sala e aguarda a entrada de outros jogadores.",
        ["PartyTutorialEnterRoomTitle"] = "Entrar numa sala existente",
        ["PartyTutorialEnterRoomContent"] = "Entra numa sala existente onde outros jogadores já estão à tua espera.",
    },
    ["es-es"] = {
        ["Party"] = "Abrir grupos.",
        ["PartyTutorialCreateRoomTitle"] = "Crear sala",
        ["PartyTutorialCreateRoomContent"] = "Crea una sala y espera a que entren otros jugadores.",
        ["PartyTutorialEnterRoomTitle"] = "Entrar en una sala existente",
        ["PartyTutorialEnterRoomContent"] = "Entra en una sala existente donde otros jugadores ya te están esperando.",
    },
    ["de-de"] = {
        ["Party"] = "Gruppen öffnen.",
        ["PartyTutorialCreateRoomTitle"] = "Raum erstellen",
        ["PartyTutorialCreateRoomContent"] = "Erstelle einen Raum und warte, bis andere Spieler beitreten.",
        ["PartyTutorialEnterRoomTitle"] = "Einem bestehenden Raum beitreten",
        ["PartyTutorialEnterRoomContent"] = "Betritt einen bestehenden Raum, in dem andere Spieler bereits auf dich warten.",
    },

    ["ar-sa"] = {
        ["Party"] = "فتح المجموعات.",
        ["PartyTutorialCreateRoomTitle"] = "إنشاء غرفة",
        ["PartyTutorialCreateRoomContent"] = "أنشئ غرفة وانتظر دخول اللاعبين الآخرين.",
        ["PartyTutorialEnterRoomTitle"] = "الدخول إلى غرفة موجودة",
        ["PartyTutorialEnterRoomContent"] = "ادخل إلى غرفة موجودة حيث ينتظرك لاعبون آخرون بالفعل.",
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