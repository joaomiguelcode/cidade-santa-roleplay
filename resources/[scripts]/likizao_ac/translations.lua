lang = GetConvar("language", "pt-br") or "pt-br"

translations = {
    ["pt-br"] = {
        ["wall_activated"]   = "Wall ativado!",
        ["wall_disabled"]    = "Wall desativado!",
        ["no_permission"]    = "Você não tem permissão para usar este comando.",
        ["default_reason"]   = "Não informado",
        ["suspicious_msg"]   = "Usuário <b>%s</b> foi marcado como suspeito. [<b>%s</b>]<br>Confira o Discord!",
        ["banned_msg"]       = "Usuário <b>%s</b> foi banido pelo anticheat. [<b>%s</b>]",
        ["disconnect_msg"]   = "[LIKIZAO-AC]\nVocê foi banido pelo AntiCheat ⚠️\nCaso acredite que seja um erro, entre em contato via Discord.",
    },
    ["en-us"] = {
        ["wall_activated"]   = "Wall activated!",
        ["wall_disabled"]    = "Wall disabled!",
        ["no_permission"]    = "You do not have permission to use this command.",
        ["default_reason"]   = "Not informed",
        ["suspicious_msg"]   = "User <b>%s</b> flagged as suspicious. [<b>%s</b>]<br>Check Discord!",
        ["banned_msg"]       = "User <b>%s</b> banned by anticheat. [<b>%s</b>]",
        ["disconnect_msg"]   = "[LIKIZAO-AC]\nYou have been banned by the AntiCheat ⚠️\nIf you believe this is an error, contact via Discord.",
    },
    ["es-es"] = {
        ["wall_activated"]   = "Wall activado!",
        ["wall_disabled"]    = "Wall desactivado!",
        ["no_permission"]    = "No tienes permiso para usar este comando.",
        ["default_reason"]   = "No informado",
        ["suspicious_msg"]   = "Usuario <b>%s</b> marcado como sospechoso. [<b>%s</b>]<br>¡Consulta el Discord!",
        ["banned_msg"]       = "Usuario <b>%s</b> baneado por el anticheat. [<b>%s</b>]",
        ["disconnect_msg"]   = "[LIKIZAO-AC]\nHas sido baneado por el AntiCheat ⚠️\nSi crees que es un error, contacta via Discord.",
    },
    ["pt-pt"] = {
        ["wall_activated"]   = "Wall ativado!",
        ["wall_disabled"]    = "Wall desativado!",
        ["no_permission"]    = "Não tem permissão para usar este comando.",
        ["default_reason"]   = "Não informado",
        ["suspicious_msg"]   = "Utilizador <b>%s</b> foi marcado como suspeito. [<b>%s</b>]<br>Verifica o Discord!",
        ["banned_msg"]       = "Utilizador <b>%s</b> foi banido pelo anticheat. [<b>%s</b>]",
        ["disconnect_msg"]   = "[LIKIZAO-AC]\nFoste baneado pelo AntiCheat ⚠️\nSe acreditas que é um erro, entra em contacto via Discord.",
    },
}

function CheckTranslation(key)
    if translations[lang] and translations[lang][key] then
        return true
    end
    print(('[likizao_ac] translation not found for key "%s" (lang=%s)'):format(key, lang))
    return false
end

function _t(key)
    if CheckTranslation(key) then
        return translations[lang][key]
    end
    return translations["en-us"][key] or key
end
