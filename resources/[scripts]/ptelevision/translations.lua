lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["start_television"] = "Turn on TV",
        ["stop_television"] = "Turn off TV",
        ["television"] = "Television",
        ["videos"] = "Videos",
        ["videos_description"] = "Start a video or stream on the screen.",
        ["web_browser"] = "Web Browser",
        ["web_browser_description"] = "Access the internet.",
        ["channels"] = "TV Channels",
        ["channels_description"] = "TV List",
        ["interact_with_tv"] = "Interact with the screen individually",
        ["interact_with_tv_description"] = "Control the elements of the screen.",
        ["adjust_volume"] = "Volume Adjustment",
        ["adjust_volume_description"] = "Increase or decrease the volume.",
        ["close_menu"] = "Close Menu",
        ["to_start_television"] = "To turn on the screen",
        ["to_stop_television"] = "To turn off the screen",
    },
    
    ["pt-br"] = {
        ["start_television"] = "Ligar Telão",
        ["stop_television"] = "Desligar Telão",
        ["television"] = "Televisão",
        ["videos"] = "Vídeos",
        ["videos_description"] = "Inicie um video ou uma stream na tela.",
        ["web_browser"] = "Navegador WEB",
        ["web_browser_description"] = "Acesse a internet.",
        ["channels"] = "Canais de TV",
        ["channels_description"] = "Lista de TV",
        ["interact_with_tv"] = "Reagir com o telão individualmente",
        ["interact_with_tv_description"] = "Controle os elementos da tela.",
        ["adjust_volume"] = "Ajuste de volume",
        ["adjust_volume_description"] = "Aumente ou diminua o volume.",
        ["close_menu"] = "Feche o menu",
        ["to_start_television"] = "Para ligar o telão",
        ["to_stop_television"] = "Para desligar o telão",
    },

    ["fr-fr"] = {
        ["start_television"] = "Allumer l'écran",
        ["stop_television"] = "Éteindre l'écran",
        ["television"] = "Télévision",
        ["videos"] = "Vidéos",
        ["videos_description"] = "Lancer une vidéo ou un stream sur l'écran.",
        ["web_browser"] = "Navigateur web",
        ["web_browser_description"] = "Accéder à Internet.",
        ["channels"] = "Chaînes TV",
        ["channels_description"] = "Liste des chaînes",
        ["interact_with_tv"] = "Interagir avec l'écran",
        ["interact_with_tv_description"] = "Contrôler les éléments de l'écran.",
        ["adjust_volume"] = "Réglage du volume",
        ["adjust_volume_description"] = "Augmenter ou diminuer le volume.",
        ["close_menu"] = "Fermer le menu",
        ["to_start_television"] = "Pour allumer l'écran",
        ["to_stop_television"] = "Pour éteindre l'écran",
    },

    ["es-es"] = {
        ["start_television"] = "Encender Televisión",
        ["stop_television"] = "Apagar Televisión",
        ["television"] = "Televisión",
        ["videos"] = "Vídeos",
        ["videos_description"] = "Inicie um video ou una stream en la pantalla.",
        ["web_browser"] = "Navegador WEB",
        ["web_browser_description"] = "Accede a la internet.",
        ["channels"] = "Canais de TV",
        ["channels_description"] = "Lista de TV",
        ["interact_with_tv"] = "Interactuar con la pantalla individualmente",
        ["interact_with_tv_description"] = "Controle os elementos da tela.",
        ["adjust_volume"] = "Ajuste de volume",
        ["adjust_volume_description"] = "Aumente o diminua o volume.",
        ["close_menu"] = "Feche o menu",
        ["to_start_television"] = "Para encender la pantalla",
        ["to_stop_television"] = "Para apagar la pantalla",
    },

    ["pt-pt"] = {
        ["start_television"] = "Ligar Telão",
        ["stop_television"] = "Desligar Telão",
        ["television"] = "Televisão",
        ["videos"] = "Vídeos",
        ["videos_description"] = "Inicie um video ou uma stream na tela.",
        ["web_browser"] = "Navegador WEB",
        ["web_browser_description"] = "Acesse a internet.",
        ["channels"] = "Canais de TV",
        ["channels_description"] = "Lista de TV",
        ["interact_with_tv"] = "Reagir com o telão individualmente",
        ["interact_with_tv_description"] = "Controle os elementos da tela.",
        ["adjust_volume"] = "Ajuste de volume",
        ["adjust_volume_description"] = "Aumente ou diminua o volume.",
        ["close_menu"] = "Feche o menu",
        ["to_start_television"] = "Para ligar o telão",
        ["to_stop_television"] = "Para desligar o telão",
    },

    ["de-de"] = {
        ["start_television"] = "Fernseher einschalten",
        ["stop_television"] = "Fernseher ausschalten",
        ["television"] = "Fernsehen",
        ["videos"] = "Videos",
        ["videos_description"] = "Video oder Stream auf dem Bildschirm starten.",
        ["web_browser"] = "Webbrowser",
        ["web_browser_description"] = "Internet aufrufen.",
        ["channels"] = "TV-Kanäle",
        ["channels_description"] = "TV-Liste",
        ["interact_with_tv"] = "Mit dem Bildschirm interagieren",
        ["interact_with_tv_description"] = "Elemente des Bildschirms steuern.",
        ["adjust_volume"] = "Lautstärke einstellen",
        ["adjust_volume_description"] = "Lautstärke erhöhen oder verringern.",
        ["close_menu"] = "Menü schließen",
        ["to_start_television"] = "Bildschirm einschalten",
        ["to_stop_television"] = "Bildschirm ausschalten",
    },

    ["ar-sa"] = {
        ["start_television"] = "تشغيل التلفزيون",
        ["stop_television"] = "إيقاف التلفزيون",
        ["television"] = "تلفزيون",
        ["videos"] = "فيديوهات",
        ["videos_description"] = "ابدأ فيديو أو بث على الشاشة.",
        ["web_browser"] = "متصفح الويب",
        ["web_browser_description"] = "الوصول إلى الإنترنت.",
        ["channels"] = "قنوات التلفزيون",
        ["channels_description"] = "قائمة القنوات",
        ["interact_with_tv"] = "التفاعل مع الشاشة",
        ["interact_with_tv_description"] = "التحكم في عناصر الشاشة.",
        ["adjust_volume"] = "ضبط الصوت",
        ["adjust_volume_description"] = "زيادة أو تقليل الصوت.",
        ["close_menu"] = "إغلاق القائمة",
        ["to_start_television"] = "لتشغيل الشاشة",
        ["to_stop_television"] = "لإيقاف الشاشة",
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