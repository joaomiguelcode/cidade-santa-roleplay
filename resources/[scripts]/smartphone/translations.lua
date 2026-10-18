lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "You cannot send an invoice to passport %s",
        ["wpp.cannot.delete.message"] = "You cannot delete these messages",
    },
    ["pt-br"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "Você não pode enviar uma fatura para o passaporte %s",
        ["wpp.cannot.delete.message"] = "Você não pode apagar estas mensagens",
    },
    ["fr-fr"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "Vous ne pouvez pas envoyer une facture au passeport %s",
        ["wpp.cannot.delete.message"] = "Vous ne pouvez pas supprimer ces messages",
    },
    ["pt-pt"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "Não pode enviar uma fatura para o passaporte %s",
        ["wpp.cannot.delete.message"] = "Não pode apagar estas mensagens",
    },
    ["es-es"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "No puedes enviar una factura al pasaporte %s",
        ["wpp.cannot.delete.message"] = "No puedes borrar estos mensajes",
    },

    ["de-de"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "Du kannst keine Rechnung an den Pass %s senden",
        ["wpp.cannot.delete.message"] = "Du kannst diese Nachrichten nicht löschen",
    },

    ["ar-sa"] = {
        ["matchSocial.appName"] = "Social",
        ["bank_send_invoice_cannot_send_to_character"] = "لا يمكنك إرسال فاتورة لجواز السفر %s",
        ["wpp.cannot.delete.message"] = "لا يمكنك حذف هذه الرسائل",
    },
}

---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    local dictionary = translations[lang] or translations['en-us']
    if dictionary[key] or translations['en-us'][key] then
        return true
    else
        if sx and sx.logger and sx.logger.debug then
            sx.logger:debug( ('[translations] Translation not found for key: %s - Lang: %s'):format( key, lang ) )
        end
        return false
    end
end

---@param key string The translation key to retrieve
---@return string Returns the translated string or error message
function _t(key)
    if CheckTranslation(key) then
        local dictionary = translations[lang] or translations['en-us']
        return dictionary[key] or translations['en-us'][key]
    else
        return ('Translation not found for key: %s - Lang: %s'):format(key, lang)
    end
end
