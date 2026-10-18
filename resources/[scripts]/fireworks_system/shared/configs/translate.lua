LANGUAGE = GetConvar("language", "pt-br") or "pt-br"

translations = {
    ["en-us"] = {
        ['gift.pickup'] = 'Collect Fireworks 🎉',
        ['gift.no.reward'] = '🎉 Oops… looks like someone already collected these fireworks!',
        ['gift.notify.title'] = 'Fireworks',
        ['gift.blip.name'] = 'Fireworks',
        ['log.noclip'] = 'You cannot use noclip at this moment.',

        -- VIP Rewards
        ['gift.vip.reward.gold'] = '🥇 Congratulations! You received Gold VIP!',
        ['gift.vip.reward.silver'] = '🥈 Congratulations! You received Silver VIP!',

        -- Collectible Rewards
        ['gift.collectible.reward'] = '🎆 Congratulations! You received a 2026 Festive Collectible!',

        -- Discord Logs - Titles
        ['log.critical.teleport.invisible'] = '⚠️ CRITICAL: Invisible Admin Teleported to Fireworks',
        ['log.admin.teleport'] = '🎉 Admin Teleported to Fireworks',
        ['log.invisible.collection'] = '👻 User Collected Fireworks While Invisible',

        -- Discord Logs - Fields
        ['log.user.id'] = 'User ID',
        ['log.city'] = 'City',
        ['log.gift.id'] = 'Fireworks ID',
        ['log.item.received'] = 'Item Received',
        ['log.status'] = 'Status',
        ['log.status.invisible.teleported'] = 'Invisible + Teleported',
        ['log.status.invisible'] = 'Invisible',
        ['log.city.unknown'] = 'Unknown',

        ['log.abuse.of.power'] = 'Abuse of power - Contact your supervisor. + removal of permissions',
    },
    ["pt-br"] = {
        ['gift.pickup'] = 'Coletar Fogos 🎉',
        ['gift.no.reward'] = '🎉 Ops… parece que alguém já coletou esse fogo!',
        ['gift.notify.title'] = 'Fogos de Artifício',
        ['gift.blip.name'] = 'Fogos de Artifício',
        ['log.noclip'] = 'Você não pode usar o noclip neste momento.',

        -- Recompensas VIP
        ['gift.vip.reward.gold'] = '🥇 Parabéns! Você recebeu VIP Ouro!',
        ['gift.vip.reward.silver'] = '🥈 Parabéns! Você recebeu VIP Prata!',

        -- Recompensas Colecionáveis
        ['gift.collectible.reward'] = '🎆 Parabéns! Você recebeu um Colecionável Festivo de 2026!',

        -- Logs Discord - Títulos
        ['log.critical.teleport.invisible'] = '⚠️ CRÍTICO: Admin Invisível Teleportou para Presente',
        ['log.admin.teleport'] = '🎉 Admin Teleportou para Fogos de Artifício',
        ['log.invisible.collection'] = '👻 Usuário Coletou Fogos de Artifício Invisível',

        -- Logs Discord - Campos
        ['log.user.id'] = 'User ID',
        ['log.city'] = 'Cidade',
        ['log.gift.id'] = 'Presente ID',
        ['log.item.received'] = 'Item Recebido',
        ['log.status'] = 'Status',
        ['log.status.invisible.teleported'] = 'Invisível + Teleportado',
        ['log.status.invisible'] = 'Invisível',
        ['log.city.unknown'] = 'Desconhecida',

        ['log.abuse.of.power'] = 'Abuso de poder - Procure seu responsável. + remoção de poderes',
    },
    ["pt-pt"] = {
        ['gift.pickup'] = 'Recolher Fogos 🎉',
        ['gift.no.reward'] = '🎉 Ops… parece que alguém já recolheu esses fogos!',
        ['gift.notify.title'] = 'Fogos de Artifício',
        ['gift.blip.name'] = 'Fogos de Artifício',
        ['log.noclip'] = 'Não podes usar o noclip neste momento.',

        -- Recompensas VIP
        ['gift.vip.reward.gold'] = '🥇 Parabéns! Recebeste VIP Ouro!',
        ['gift.vip.reward.silver'] = '🥈 Parabéns! Recebeste VIP Prata!',

        -- Recompensas Colecionáveis
        ['gift.collectible.reward'] = '🎆 Parabéns! Recebeste um Colecionável Festivo de 2026!',

        -- Logs Discord - Títulos
        ['log.critical.teleport.invisible'] = '⚠️ CRÍTICO: Admin Invisível Teletransportou para Fogos de Artifício',
        ['log.admin.teleport'] = '🎉 Admin Teletransportou para Fogos de Artifício',
        ['log.invisible.collection'] = '👻 Utilizador Recolheu Fogos de Artifício Invisível',

        -- Logs Discord - Campos
        ['log.user.id'] = 'User ID',
        ['log.city'] = 'Cidade',
        ['log.gift.id'] = 'Fogos ID',
        ['log.item.received'] = 'Item Recebido',
        ['log.status'] = 'Estado',
        ['log.status.invisible.teleported'] = 'Invisível + Teletransportado',
        ['log.status.invisible'] = 'Invisível',
        ['log.city.unknown'] = 'Desconhecida',

        ['log.abuse.of.power'] = 'Abuso de poder - Procura o teu responsável. + remoção de poderes',
    },
    ["es-es"] = {
        ['gift.pickup'] = 'Recoger Fuegos 🎉',
        ['gift.no.reward'] = '🎉 ¡Vaya! ¡Parece que alguien ya recogió estos fuegos artificiales!',
        ['gift.notify.title'] = 'Fuegos Artificiales',
        ['gift.blip.name'] = 'Fuegos Artificiales',
        ['log.noclip'] = 'No puedes usar noclip en este momento.',

        -- Recompensas VIP
        ['gift.vip.reward.gold'] = '🥇 ¡Felicidades! ¡Recibiste VIP Oro!',
        ['gift.vip.reward.silver'] = '🥈 ¡Felicidades! ¡Recibiste VIP Plata!',

        -- Recompensas Coleccionables
        ['gift.collectible.reward'] = '🎆 ¡Felicidades! ¡Recibiste un Coleccionable Festivo de 2026!',

        -- Logs Discord - Títulos
        ['log.critical.teleport.invisible'] = '⚠️ CRÍTICO: Admin Invisible Teletransportó a Fuegos Artificiales',
        ['log.admin.teleport'] = '🎉 Admin Teletransportó a Fuegos Artificiales',
        ['log.invisible.collection'] = '👻 Usuario Recogió Fuegos Artificiales Invisible',

        -- Logs Discord - Campos
        ['log.user.id'] = 'ID de Usuario',
        ['log.city'] = 'Ciudad',
        ['log.gift.id'] = 'ID de Fuegos',
        ['log.item.received'] = 'Ítem Recibido',
        ['log.status'] = 'Estado',
        ['log.status.invisible.teleported'] = 'Invisible + Teletransportado',
        ['log.status.invisible'] = 'Invisible',
        ['log.city.unknown'] = 'Desconocida',

        ['log.abuse.of.power'] = 'Abuso de poder - Busca a tu responsable. + remoción de permisos',
    },
}

---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    if translations[LANGUAGE][key] then
        return true
    else
        print("[DEBUG] Translation not found for key: " .. key .. " - Lang: " .. LANGUAGE)
        return false
    end
end

---@param key string The translation key to retrieve
---@return string Returns the translated string or error message
function _t(key)
    if CheckTranslation(key) then
        return translations[LANGUAGE][key]
    else
        return "Translation not found for key: " .. key .. " - Lang: " .. LANGUAGE
    end
end
