lang = GetConvar("language", "pt-br") or "pt-br"
cityName = GetConvar("cityName", "")
translations = {
    ["en-us"] = {
        ["last_position"] = "Last Position",
        ["tutorial.group.learning_movement"] = "Learning how to move",
        ["tutorial.step.walk_character"] = "Walk with your character",
        ["tutorial.step.jump_obstacle"] = "Jump over the obstacle",
        ["tutorial.step.crouch_obstacle"] = "Crouch under the obstacle",
    },
    ["pt-br"] = {
        ["last_position"] = "Última Posição",
        ["tutorial.group.learning_movement"] = "Aprendendo a se movimentar",
        ["tutorial.step.walk_character"] = "Ande com seu personagem",
        ["tutorial.step.jump_obstacle"] = "Pule sobre o obstáculo",
        ["tutorial.step.crouch_obstacle"] = "Passe por debaixo do obstáculo",
    },

    ["fr-fr"] = {
        ["last_position"] = "Dernière position",
        ["tutorial.group.learning_movement"] = "Apprendre à se déplacer",
        ["tutorial.step.walk_character"] = "Marche avec ton personnage",
        ["tutorial.step.jump_obstacle"] = "Saute par-dessus l'obstacle",
        ["tutorial.step.crouch_obstacle"] = "Passe sous l'obstacle",
    },

    ["pt-pt"] = {
        ["last_position"] = "Última Posição",
        ["tutorial.group.learning_movement"] = "A aprender a movimentar-te",
        ["tutorial.step.walk_character"] = "Anda com a tua personagem",
        ["tutorial.step.jump_obstacle"] = "Salta sobre o obstáculo",
        ["tutorial.step.crouch_obstacle"] = "Passa por baixo do obstáculo",
    },
    ["es-es"] = {
        ["last_position"] = "Última Posición",
        ["tutorial.group.learning_movement"] = "Aprendiendo a moverte",
        ["tutorial.step.walk_character"] = "Camina con tu personaje",
        ["tutorial.step.jump_obstacle"] = "Salta sobre el obstáculo",
        ["tutorial.step.crouch_obstacle"] = "Pasa por debajo del obstáculo",
    },

    ["de-de"] = {
        ["last_position"] = "Letzte Position",
        ["tutorial.group.learning_movement"] = "Bewegung lernen",
        ["tutorial.step.walk_character"] = "Lauf mit deinem Charakter",
        ["tutorial.step.jump_obstacle"] = "Springe über das Hindernis",
        ["tutorial.step.crouch_obstacle"] = "Geh unter dem Hindernis hindurch",
    },
    ["ar-sa"] = {
        ["last_position"] = "الموقع الأخير",
        ["tutorial.group.learning_movement"] = "تعلم كيفية التحرك",
        ["tutorial.step.walk_character"] = "تحرك بشخصيتك",
        ["tutorial.step.jump_obstacle"] = "اقفز فوق الحاجز",
        ["tutorial.step.crouch_obstacle"] = "مر من تحت الحاجز",
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