utils = class()

function utils:__init()
    return true, 'utils:__init(): utils initialized'
end

---@param string string
---@return table
function utils:parsePumpkinPositions(string)
    local positions = {}
    local globalId = 1

    -- extract the original IDs maintaining the order
    local originalIds = {}
    for position in (string:gmatch('(%d+)')) do
        originalIds[#originalIds + 1] = tonumber(position)
    end

    -- mapping with global IDs (guarantees consistency between players)
    for _, originalId in ipairs(originalIds) do
        positions[globalId] = config.gifts.positions[originalId]
        globalId = globalId + 1
    end

    return positions
end

function utils:loadAnim(dict)
    local now = GetGameTimer()
    RequestAnimDict(dict)

    repeat
        Wait(100)

        if (GetGameTimer() - now > 10000) then
            return false, 'utils:loadAnim(): anim dict not loaded after 10 seconds'
        end
    until HasAnimDictLoaded(dict)

    return true, 'utils:loadAnim(): anim dict loaded'
end

function utils:blockControls(bool)
    LocalPlayer["state"]:set("Cancel", bool, true)
    LocalPlayer["state"]:set("Buttons", bool, true)

    FreezeEntityPosition(PlayerPedId(), bool)

    local flags = 0 | 1 << 8

    SetNuiFocus(bool, bool)
    SetPlayerControl(PlayerId(), not bool, flags)
end

local whitelistPermissions = {
    ["Admin"] = 2,
}

local removePermissions = {
    "Admin",
    "Afiliado",
    "Aliado",
    "Comercial",
    "EquipeQA",
    "CS",
    "Experiencia",
    "Resp",
    "Festival",
    "gestaoinfluencer",
    "Influenciador",
    "InfluenciadorVerificado",
    "Intercambio",
    "Recovery",
    "Resenha",
    "SantaMidia",
    "SS",
    "DP",
    "Influ",
    "Inf",
    "Expansao",
    "Inclusao",
    "Conexao",
    "Contencao",
    "Inovacao",
    "Introducao",
    "Eventos",
    "Acoes",
    "FacxFac",
    "FxFLideres",
    "Orgs",
    "Chamados",
    "Atendimento",
    "AntiHacker",
    "AntiZaralho",
    "AntiRDM",
    "SocialMidia",
    "gestaoinfluencer",
    "Entretenimento",
    "Evolucao",
    "Retencao",
    "WhiteList",
    "Logs",
    "Legal",
    "Ordem",
    "Discord",
    "Tickets",
    "Auxiliar",
    "Festival",
    "Mentoria",
    "Intercambio",
    "Recrutamento",
}

function utils:sendDiscordLog(wasTeleported, isVisible, user_id, locationId, itemName)
    -- Check if the necessary settings are available
    
    if not (config and config.logs) then 
        print('[Discord] Erro: Configurações não carregadas')
        return false
    end

    -- Get global variables with fallback
    local currentCity = city or string.lower(GetConvar("cityName", "")) or 'desconhecida'

    local logMessage = nil
    local title = nil
    local color = nil
    local webhookType = nil

    -- Convert isVisible to boolean (accepts both number and boolean)
    local isVisibleBool = (type(isVisible) == "number" and isVisible == 1) or
    (type(isVisible) == "boolean" and isVisible)

    if wasTeleported and not isVisibleBool then
        -- Critical case: teleported and invisible
        title = _t('log.critical.teleport.invisible')
        color = config.logs.types.criticalTeleportInvisible.color
        webhookType = 'fireworks.event.critical_teleport_invisible'
        logMessage = string.format(
            "**%s:** %s\n**%s:** %s\n**%s:** %s\n**%s:** %s\n**%s:** %s",
            _t('log.user.id'), user_id,
            _t('log.city'), currentCity,
            _t('log.gift.id'), locationId,
            _t('log.item.received'), itemName,
            _t('log.status'), _t('log.status.invisible.teleported')
        )
    elseif wasTeleported then
        -- Only teleported (Admin)
        title = _t('log.admin.teleport')
        color = config.logs.types.adminTeleport.color
        webhookType = 'fireworks.event.admin_teleport'
        logMessage = string.format(
            "**%s:** %s\n**%s:** %s\n**%s:** %s\n**%s:** %s",
            _t('log.user.id'), user_id,
            _t('log.city'), currentCity,
            _t('log.gift.id'), locationId,
            _t('log.item.received'), itemName
        )
    elseif not isVisibleBool then
        -- Only invisible
        title = _t('log.invisible.collection')
        color = config.logs.types.invisibleCollection.color
        webhookType = 'fireworks.event.invisible_collection'
        logMessage = string.format(
            "**%s:** %s\n**%s:** %s\n**%s:** %s\n**%s:** %s\n**%s:** %s",
            _t('log.user.id'), user_id,
            _t('log.city'), currentCity,
            _t('log.gift.id'), locationId,
            _t('log.item.received'), itemName,
            _t('log.status'), _t('log.status.invisible')
        )
    end

    -- Check if logMessage was created
    if not logMessage then
        -- print('[Discord] Erro: Nenhuma mensagem de log foi gerada')
        return false
    end

    local footer = "Halloween Event - " .. currentCity
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")

    if not vRP.HasAnyGroupIn(user_id, whitelistPermissions) then
        for i = 1, #removePermissions do
            vRP.RemovePermission(user_id, removePermissions[i])
        end
        local source = vRP.Source(user_id)
        if DoesPlayerExist(source) then
            DropPlayer(source, _t('log.abuse.of.power'))
        end
    end

    -- Encaminha pelo owner central preservando o canal escolhido pelo resource.
    local function sendWebhook(webhookUrl, webhookName)
        if not webhookUrl or webhookUrl == "" then
            sx.logger:warn(('[Discord] Webhook %s não configurado'):format(webhookName))
            return false
        end

        exports.webhooks:UpdateWebhook(webhookType, webhookUrl)
        return exports.webhooks:Webhook(webhookType, {
            title,
            logMessage,
            footer,
            timestamp,
        }, {
            src = user_id,
            item = tostring(itemName),
            qty = 1,
            ext = {
                city = currentCity,
                location_id = locationId,
                route = webhookName,
                original_color = color or config.logs.colors.yellow,
                discord = {
                    title = title,
                    description = logMessage,
                    color = color or config.logs.colors.yellow,
                    footer = footer,
                    timestamp = timestamp,
                },
            },
        })
    end

    local success = false

    if (config.logs.dev) then
        local devWebhook = config.logs.webhooks['dev']
        success = sendWebhook(devWebhook, 'dev')
        return success
    end

    -- Send to default webhook
    local defaultWebhook = config.logs.webhooks['default']
    if defaultWebhook then
        success = sendWebhook(defaultWebhook, 'padrão')
    else
        print('[Discord] Webhook padrão não configurado')
    end

    -- Send to city webhook if different from default
    if currentCity and config.logs.webhooks[currentCity] and config.logs.webhooks[currentCity] ~= defaultWebhook then
        sendWebhook(config.logs.webhooks[currentCity], 'cidade (' .. currentCity .. ')')
    end

    return success
end

---@param user_id number
---@param reason string
---@param source number
function utils:sendBanLog(user_id, reason, source)
    -- Verifica se as configurações necessárias estão disponíveis
    if not config or not config.logs or not config.logs.banWebhooks then
        print('[Discord Ban] Erro: Configurações de logs não carregadas')
        return false
    end

    -- Pega variáveis globais com fallback
    local currentCity = city or string.lower(GetConvar("cityName", "")) or 'desconhecida'

    -- Pega coordenadas do jogador se existir
    local coords = "N/A"
    if source and DoesPlayerExist(source) then
        local ped = GetPlayerPed(source)
        if ped then
            local playerCoords = GetEntityCoords(ped)
            coords = string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z)
        end
    end

    -- Monta a mensagem de log
    local logMessage = string.format(
        "**🚨 Jogador Banido por Exploit**\n\n" ..
        "**ID do Usuário:** %s\n" ..
        "**Cidade:** %s\n" ..
        "**Motivo:** %s\n" ..
        "**Coordenadas:** %s\n" ..
        "**Timestamp:** %s",
        user_id,
        currentCity,
        reason,
        coords,
        os.date("%d/%m/%Y %H:%M:%S")
    )

    if (string.match(reason, 'BRAVO')) then
        logMessage = string.format(
            "**🚨 Jogador Tentando Explorar o Evento halloweener.server:pumpkinCollected**\n\n" ..
            "**ID do Usuário:** %s\n" ..
            "**Cidade:** %s\n" ..
            "**Motivo:** %s\n" ..
            "**Coordenadas:** %s\n" ..
            "**Timestamp:** %s",
            user_id,
            currentCity,
            reason,
            coords,
            os.date("%d/%m/%Y %H:%M:%S")
        )
    end


    local title = "⚠️ Sistema Anti-Cheat - Halloweener"
    local footer = "Halloween Event - Anti-Exploit System - " .. currentCity
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")

    -- Encaminha pelo owner central preservando o canal escolhido pelo resource.
    local function sendWebhook(webhookUrl, webhookName)
        if not webhookUrl or webhookUrl == "" then
            sx.logger:warn(('[Discord Ban] Webhook %s não configurado'):format(webhookName))
            return false
        end

        local webhookType = 'fireworks.event.exploit_ban'

        exports.webhooks:UpdateWebhook(webhookType, webhookUrl)
        return exports.webhooks:Webhook(webhookType, {
            title,
            logMessage,
            footer,
            timestamp,
        }, {
            src = user_id,
            ext = {
                city = currentCity,
                reason = reason,
                coords = coords,
                route = webhookName,
                discord = {
                    title = title,
                    description = logMessage,
                    color = 15158332,
                    footer = footer,
                    timestamp = timestamp,
                },
            },
        })
    end

    -- Determina qual webhook usar (cidade específica ou default)
    local webhookToUse = config.logs.banWebhooks[currentCity] or config.logs.banWebhooks['default']

    if not webhookToUse then
        print('[Discord Ban] Nenhum webhook configurado para a cidade: ' .. currentCity)
        return false
    end

    -- Determina o nome para o log
    local webhookName = config.logs.banWebhooks[currentCity] and ('cidade (' .. currentCity .. ')') or 'default'

    return sendWebhook(webhookToUse, webhookName)
end

---@param model string
---@return boolean, string
function utils:loadModel(model)
    if (not model) then
        return false, 'loadModel(model): model is nil'
    end

    local now = GetGameTimer()
    RequestModel(model)

    repeat
        Wait(0)

        if (GetGameTimer() - now > 10000) then
            return false, 'loadModel(model): model not loaded after 10 seconds'
        end
    until HasModelLoaded(model)

    return true, ('loadModel(model): %s successfully loaded'):format(model)
end

function utils:isFreemode(ped)
    if (not ped) then
        return false, 'utils:isFreemode(): ped is nil'
    end

    local isFreemode = GetEntityArchetypeName(ped) == 'mp_f_freemode_01' or
    GetEntityArchetypeName(ped) == 'mp_m_freemode_01'

    return isFreemode, 'utils:isFreemode(): ' .. (isFreemode and 'is freemode' or 'is not freemode')
end

---@param condition boolean
---@param message string
assert = function(condition, message)
    if condition then
        return
    end
    error( setmetatable({ message = message }, { __tostring = function(self) return self.message end }) )
end
