WAR_MODES = {
    "Pistola",
    "Rifle"
}

WAR_MODES_ITENS = {
    ["Pistola"] = "WEAPON_PISTOL_MK2",
    ["Rifle"] = "WEAPON_SPECIALCARBINE_MK2",
}

WAR_MAPS = {
    ["1x1"] = {
        ["name"] = "1x1",
        ["description"] = "Ideal para 2 jogadores",
        ["image"] = "https://i.ibb.co/kDbmhq3/1x1.png",
        ["spawn_points"] = {
            vector4(-1675.08,5884.88,211.36,226.78),
            vector4(-1663.72,5865.79,211.36,14.18),
        },
    }, 
    ["Arena"] = {
        ["name"] = "Arena",
        ["description"] = "Ideal para 12 jogadores",
        ["image"] = "https://i.ibb.co/h2YxvvD/arena.png",
        ["spawn_points"] = {
            vector4(-1895.64,5958.8,207.48,17.01),
            vector4(-1952.62,5927.41,207.48,119.06),
        },
    }, 
    ["Fazenda"] = {
        ["name"] = "Fazenda",
        ["description"] = "Ideal para 8 jogadores",
        ["image"] = "https://i.ibb.co/68gx2wk/Fazenda.png",
        ["spawn_points"] = {
            vector4(-1815.79,5754.9,209.38,36.86),
            vector4(-1842.76,5803.05,209.38,215.44),
        },
    }, 
    ["Predio"] = {
        ["name"] = "Predio",
        ["description"] = "Ideal para 3 jogadores",
        ["image"] = "https://i.ibb.co/ZWtpcLq/predio.png",
        ["spawn_points"] = {
            vector4(-1543.85,5947.64,213.54,121.89),
            vector4(-1577.19,5928.45,213.54,300.48),
        },
}
}

WAR_FINISH_COORDS = vector4(196.4,-924.3,29.99,0.0)

function ResolveWarWeaponModeFromLocale(raw)
    if type(raw) == "table" then
        raw = raw[1]
    end
    if type(raw) ~= "string" then
        return WAR_MODES[1] or "Pistola"
    end
    if WAR_MODES_ITENS[raw] then
        return raw
    end
    local lang = GetConvar("language", "pt-br")
    local path = ("locales/frontend-i18n-config/%s/organization_war.json"):format(lang)
    local contents = LoadResourceFile("localization", path)
    if not contents then
        contents = LoadResourceFile("localization", "locales/frontend-i18n-config/pt-br/organization_war.json")
    end
    if not contents then
        return WAR_MODES[1] or "Pistola"
    end
    local locale = json.decode(contents)
    if not locale then
        return WAR_MODES[1] or "Pistola"
    end
    for _, id in ipairs(WAR_MODES) do
        local lab = locale["weaponMode_" .. id]
        if lab == raw or id == raw then
            return id
        end
    end
    return WAR_MODES[1] or "Pistola"
end