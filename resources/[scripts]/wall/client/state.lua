---@class WallPlayerIdentity
---@field id number
---@field name string
---@field purchased any
---@field nameTagIndex number?

---@class WallPlayerInfo
---@field identity WallPlayerIdentity
---@field job any
---@field staff any
---@field staffLabel string
---@field wall any
---@field banned any
---@field teste any
---@field tracking any
---@field bannedIp any
---@field removeWall any
---@field recording any
---@field discordId any
---@field kdRatio any
---@field forceRemoveWall any
---@field bugXp any
---@field staffOnDuty any
---@field projectCs any

---@type table
local Config = {
    Player = {
        menus = {
            {
                title = _t("editGroupsTitle"),
                options = {
                    { name = _t("removeOption"), key = 'RemGroup' },
                    { name = _t("addOption"), key = 'AddGroup' },
                    { name = _t("listOption"), key = 'ListGroups' },
                    { name = _t("banOption"), key = 'Ban' },
                    { name = _t("specOption"), key = 'Spec' },
                }
            },
            {
                title = _t("playerInteractionTitle"),
                options = {
                    { name = _t("godOption"), key = 'God' },
                    { name = _t("godSquareOption"), key = 'GodPraca' },
                    { name = _t("armorOption"), key = 'Armor' },
                    { name = _t("giveItemOption"), key = 'GiveItem' },
                    { name = _t("skinOption"), key = 'Skin' },
                    { name = _t("listLoginOption"), key = 'ListLogin' },
                    -- { name = _t("knockdownOption"), key = 'Knockdown' },
                }
            },
            {
                title = _t("playerInfoTitle"),
                options = {
                    { name = _t("copyIdOption"), key = 'GetPassport' },
                    { name = _t("discordIdOption"), key = 'GetDiscord' },
                    { name = _t("purchasedOption"), key = 'GetPurchased' },
                    { name = _t("whatsappOption"), key = 'GetWhatsApp' },
                    { name = _t("bansOption"), key = 'GetPlayerBans' },
                }
            },
            -- {
            --     title = '',
            --     options = {
            --         { name = _t("kickOption"), key = 'Kick' },
            --         { name = _t("banOption"), key = 'Ban' },
            --     }
            -- },
        }
    },

    Vehicle = {
        menus = {
            -- {
            --     title = '',
            --     options = {
            --         { name = _t("deleteOption"), key = 'Delete' },
            --         { name = _t("fixOption"), key = 'Fix' },
            --         { name = _t("tuningOption"), key = 'Tuning' },
            --         { name = _t("fuelOption"), key = 'Fuel' },
            --     }
            -- },
            -- {
            --     title = '',
            --     options = {
            --         { name = _t("changePlateOption"), key = 'ChangePlate' },
            --         { name = _t("toggleLockOption"), key = 'ToggleLock' },
            --     }
            -- },
            {
                title = _t("vehicleInfoTitle"),
                options = {
                    { name = _t("showOwnerOption"), key = 'ShowOwner' }
                }
            },
            -- {
            --     title = '',
            --     options = {
            --         { name = _t("driveOption"), key = 'Drive' },
            --         { name = _t("moveOption"), key = 'Move' },
            --         { name = _t("tpInOption"), key = 'TpIn' },
            --     }
            -- }
        }
    }
}

---@type table
local DefaultSettings = {
    Source = false,
    Passport = true,
    Health = true,
    Vehicle = true,
}

--- Carrega o WallConfig salvo (KVP) sobre os defaults, uma única vez no load do script.
---@return table
local function LoadSettings()

    local settings = {}

    for key, value in pairs(DefaultSettings) do
        settings[key] = value
    end

    local kvp = GetResourceKvpString("WallConfig")
    if not kvp or kvp == "" then
        return settings
    end

    local ok, decoded = pcall(json.decode, kvp)
    if not ok or type(decoded) ~= "table" then
        sx.logger:warn(('WallConfig KVP inválido, usando defaults: %s'):format(tostring(decoded)))
        return settings
    end

    for key in pairs(DefaultSettings) do
        if decoded[key] ~= nil then
            settings[key] = decoded[key]
        end
    end

    return settings
end

WallClient = {
    MenuConfig = Config,
    Settings = LoadSettings(),
    ViewDistance = 300, -- by default, the view distance is the same as fivem onesync
    FilterNewbie = false,
    CanShowTags = false,
    IsActive = false,
    Generation = 0,
    ---@type table<number, WallPlayerInfo>
    Players = {},
}

--- Diz se a geração recebida ainda é a ativa. Usado por toda thread para saber quando parar.
---@param gen number
---@return boolean
function WallClient.IsRunning(gen)
    return WallClient.IsActive and WallClient.Generation == gen
end

--- Persiste WallClient.Settings na KVP do resource.
---@return nil
function WallClient.SaveSettings()
    SetResourceKvp("WallConfig", json.encode(WallClient.Settings))
end

--- Converte o array cru vindo do server no formato WallPlayerInfo.
---@param raw table
---@return WallPlayerInfo?
function WallClient.ParsePlayerInfo(raw)

    if not raw or not raw[1] then
        return nil
    end

    local staff = raw[5]
    local staffLabel = ''

    if staff then
        if staff:find('[', 1, true) or staff:find('~', 1, true) then
            staffLabel = staff
        else
            staffLabel = ('[~r~%s~w~]'):format(staff)
        end
    end

    ---@type WallPlayerInfo
    local info = {
        identity = {
            id = raw[1],
            name = raw[2],
            purchased = raw[3],
            nameTagIndex = WallClient.CanShowTags and raw[13] or nil,
        },
        job = raw[4],
        staff = staff,
        staffLabel = staffLabel,
        wall = raw[6],
        banned = raw[7],
        teste = raw[8],
        tracking = raw[9],
        bannedIp = raw[10],
        removeWall = raw[11],
        recording = raw[12],
        discordId = raw[14],
        kdRatio = raw[15],
        forceRemoveWall = raw[16],
        bugXp = raw[17],
        staffOnDuty = raw[18],
        projectCs = raw[19],
    }

    return info
end

--- Ingere um mapa `{ [source] = raw }` em WallClient.Players.
---@param tbl table<string|number, table>
---@return nil
function WallClient.SetPlayers(tbl)

    for source, raw in pairs(tbl) do

        local info = WallClient.ParsePlayerInfo(raw)
        if info then
            WallClient.Players[tonumber(source)] = info
        end
    end
end

---@type table<number, { label: string|false, expiresAt: number }>
local gPassportLabelCache = {}
local PASSPORT_LABEL_TTL = 10000 -- ms

--- Busca o label customizado do passaporte, cacheado por 10s (inclusive resultado nil).
---@param passport number
---@return string?
function WallClient.GetPassportLabel(passport)

    if not passport then
        return nil
    end

    local cached = gPassportLabelCache[passport]
    local now = GetGameTimer()

    if cached and cached.expiresAt > now then
        if cached.label == false then
            return nil
        end

        return cached.label
    end

    local label = exports.admin:GetCustomPassportLabel(passport)

    if not cached then
        cached = {}
        gPassportLabelCache[passport] = cached
    end

    cached.label = label or false
    cached.expiresAt = now + PASSPORT_LABEL_TTL

    return label
end

--- Limpa o freecam e sinaliza o estado como inativo (usado no desligamento do wall).
---@return nil
function WallClient.Deactivate()

    WallClient.IsActive = false
    WallClient.Generation = WallClient.Generation + 1

    WallClient.Freecam.Clear()

    LocalPlayer.state:set("wall", false, false)

    if exports.gamemaster:IsInGamemasterMode() == "small" then
        TriggerEvent('gamemaster.spectatingCleanData')
    end
end

--- Liga/desliga os blips administrativos.
---@param status boolean
---@param playersInfos table?
---@param canShowTags boolean
---@return nil
function client.ToggleAdminBlips(status, playersInfos, canShowTags)

    WallClient.CanShowTags = canShowTags

    if playersInfos then
        WallClient.SetPlayers(playersInfos)
    end

    if status then
        if not WallClient.IsActive then
            WallClient.IsActive = true
            WallClient.Generation = WallClient.Generation + 1

            local gen = WallClient.Generation

            WallClient.StartRender(gen)
            WallClient.StartInteraction(gen)

            LocalPlayer.state:set("wall", true, false)
        end
    else
        WallClient.Deactivate()
    end
end

--- Atualiza infos de players (API mantida para o linker).
---@param tbl table
---@return nil
function client.UpdatePlayersInfos(tbl)
    WallClient.SetPlayers(tbl)
end

RegisterNetEvent("wall:UpdateSource", function(source, tbl)

    if not tbl or not tbl[1] then
        return
    end

    local info = WallClient.ParsePlayerInfo(tbl)
    if info then
        WallClient.Players[tonumber(source)] = info
    end
end)

RegisterNetEvent('net.wall.remove_source', function(source)

    WallClient.Players[tonumber(source)] = nil

    if WallClient.Freecam.Has(source) then
        WallClient.Freecam.Remove(source)
    end
end)

RegisterNetEvent("net.wall.disable", function()

    WallClient.Deactivate()

    TriggerServerEvent("server.wall.disable")
end)

--- Comando pra ajustar a distância de renderização dos blips.
RegisterCommand('blips-dist', function(_, args)

    local newDistance = args[1] and parseInt(args[1]) or 0

    if newDistance <= 0 then
        WallClient.ViewDistance = 300
        TriggerEvent('Notify', 'verde', 'Distância resetada: 300m.', 3000)
        return
    end

    if newDistance > 474 then
        newDistance = 474
    end

    WallClient.ViewDistance = newDistance
    TriggerEvent('Notify', 'verde', 'Nova distância: ' .. newDistance .. 'm.', 3000)
end)

RegisterCommand('wallconfig2', function(_, args)

    local keyboard = lib.inputDialog("Wall Config", {
        { type = 'checkbox', label = _t("configSourcePrompt"), checked = WallClient.Settings.Source or false },
        { type = 'checkbox', label = _t("configPassportPrompt"), checked = WallClient.Settings.Passport or false },
        { type = 'checkbox', label = _t("configHealthPrompt"), checked = WallClient.Settings.Health or false },
        { type = 'checkbox', label = _t("configVehiclePrompt"), checked = WallClient.Settings.Vehicle or false },
    })

    if keyboard then
        WallClient.Settings = {
            Source = keyboard[1],
            Passport = keyboard[2],
            Health = keyboard[3],
            Vehicle = keyboard[4],
        }

        WallClient.SaveSettings()
    end
end)

RegisterCommand('gamemaster.wall.spectatingCleanData', function(_, args)

    if WallClient.IsActive and exports.gamemaster:IsInGamemasterMode() == "small" then
        TriggerEvent('gamemaster.spectatingCleanData')
    end
end)

RegisterKeyMapping('gamemaster.wall.spectatingCleanData', 'Clean spectating data', 'keyboard', 'Escape')

RegisterCommand('filternewbie', function(_, args)
    WallClient.FilterNewbie = not WallClient.FilterNewbie
end)
