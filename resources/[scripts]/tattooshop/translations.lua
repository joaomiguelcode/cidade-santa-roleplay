lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["open_tattooshop"] = "Open Tattoo Shop",
        ["save"] = "Save",
        ["clear"] = "Clear",
        ["head"] = "Head",
        ["torso"] = "Torso", 
        ["leftarm"] = "Left Arm",
        ["rightarm"] = "Right Arm",
        ["leftleg"] = "Left Leg",
        ["rightleg"] = "Right Leg",
        ["hair"] = "Micropigmentation",
    },
    ["pt-br"] = {
        ["open_tattooshop"] = "Abrir Tattooshop",
        ["save"] = "Salvar",
        ["clear"] = "Limpar",
        ["head"] = "Cabeça",
        ["torso"] = "Torso",
        ["leftarm"] = "Braço Esquerdo",
        ["rightarm"] = "Braço Direito",
        ["leftleg"] = "Perna Esquerda",
        ["rightleg"] = "Perna Direita",
        ["hair"] = "Micropigmentação",
    },

    ["fr-fr"] = {
        ["open_tattooshop"] = "Ouvrir le salon de tatouage",
        ["save"] = "Enregistrer",
        ["clear"] = "Effacer",
        ["head"] = "Tête",
        ["torso"] = "Torse",
        ["leftarm"] = "Bras gauche",
        ["rightarm"] = "Bras droit",
        ["leftleg"] = "Jambe gauche",
        ["rightleg"] = "Jambe droite",
        ["hair"] = "Micropigmentation",
    },

    ["pt-pt"] = {
        ["open_tattooshop"] = "Abrir Loja de Tatuagens",
        ["save"] = "Gravar",
        ["clear"] = "Limpar",
        ["head"] = "Cabeça",
        ["torso"] = "Torso",
        ["leftarm"] = "Braço Esquerdo",
        ["rightarm"] = "Braço Direito",
        ["leftleg"] = "Perna Esquerda",
        ["rightleg"] = "Perna Direita",
        ["hair"] = "Micropigmentação",
    },
    ["es-es"] = {
        ["open_tattooshop"] = "Abrir Tatuajes",
        ["save"] = "Guardar",
        ["clear"] = "Limpiar",
        ["head"] = "Cabeza",
        ["torso"] = "Torso",
        ["leftarm"] = "Brazo Izquierdo",
        ["rightarm"] = "Brazo Derecho",
        ["leftleg"] = "Pierna Izquierda",
        ["rightleg"] = "Pierna Derecha",
        ["hair"] = "Micropigmentación",
    },

    ["de-de"] = {
        ["open_tattooshop"] = "Tattoostudio öffnen",
        ["save"] = "Speichern",
        ["clear"] = "Löschen",
        ["head"] = "Kopf",
        ["torso"] = "Torso",
        ["leftarm"] = "Linker Arm",
        ["rightarm"] = "Rechter Arm",
        ["leftleg"] = "Linkes Bein",
        ["rightleg"] = "Rechtes Bein",
        ["hair"] = "Mikropigmentierung",
    },

    ["ar-sa"] = {
        ["open_tattooshop"] = "فتح متجر الوشم",
        ["save"] = "حفظ",
        ["clear"] = "مسح",
        ["head"] = "الرأس",
        ["torso"] = "الجذع",
        ["leftarm"] = "الذراع الأيسر",
        ["rightarm"] = "الذراع الأيمن",
        ["leftleg"] = "الساق اليسرى",
        ["rightleg"] = "الساق اليمنى",
        ["hair"] = "الصبغة الدقيقة",
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
