-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST PERMISSION (CLIENT)
-----------------------------------------------------------------------------------------------------------------------------------------
local vSERVER = Tunnel.getInterface("inventory/chestpermission")
local PermissionActive = false
local PermissionMode = nil
local PermissionConfig = nil
local InitialConfig = nil
local PermissionOptions = {}
local ShowSaleCommission = true

local function AsNuiArray(List)
    local Array = setmetatable({}, { __jsontype = "array" })

    if type(List) ~= "table" then
        return Array
    end

    for Index = 1, #List do
        Array[Index] = List[Index]
    end

    return Array
end

local function EmptyConfig(Mode)
    return {
        ok = false,
        mode = Mode == "role" and "role" or "member",
        target = { id = "", name = "", label = "" },
        options = AsNuiArray({}),
        showSaleCommission = ShowSaleCommission,
        saleCommissionPercentage = false,
        authorizedToWithdraw = false,
        authorizedToConfigureChest = false,
        limitsActive = true,
        limits = AsNuiArray({}),
    }
end

local function NormalizeConfigPayload(Result, Mode)
    local Payload = EmptyConfig(Mode)
    if type(Result) ~= "table" then
        return Payload
    end

    Payload.ok = Result.ok ~= false
    if Result.mode == "role" or Result.mode == "member" then
        Payload.mode = Result.mode
    end

    if type(Result.target) == "table" then
        Payload.target = {
            id = Result.target.id or "",
            name = Result.target.name or "",
            label = Result.target.label or "",
            role = Result.target.role,
        }
    end

    Payload.options = AsNuiArray(Result.options)
    Payload.limits = AsNuiArray(Result.limits)
    if Result.showSaleCommission ~= nil then
        Payload.showSaleCommission = Result.showSaleCommission ~= false
    end
    Payload.authorizedToWithdraw = Result.authorizedToWithdraw == true
    Payload.authorizedToConfigureChest = Result.authorizedToConfigureChest == true
    Payload.limitsActive = Result.limitsActive == true

    if Result.saleCommissionPercentage == nil or Result.saleCommissionPercentage == false then
        Payload.saleCommissionPercentage = false
    else
        Payload.saleCommissionPercentage = Result.saleCommissionPercentage
    end

    return Payload
end

local function RequestConfig(Mode)
    Mode = Mode == "role" and "role" or "member"

    if InitialConfig and InitialConfig.mode == Mode then
        local Payload = InitialConfig
        InitialConfig = nil
        return Payload
    end

    local Ok, Result = pcall(vSERVER.RequestConfig, Mode, PermissionOptions[Mode] ~= nil)
    if not Ok then
        sx.logger:error(("chest permission client RequestConfig failed error=%s"):format(Result))
        return EmptyConfig(Mode)
    end

    if type(Result) == "table" and Result.ok ~= false and Result.options == nil then
        Result.options = PermissionOptions[Mode]
    end

    local Payload = NormalizeConfigPayload(Result, Mode)
    if Payload.ok then
        PermissionConfig = Payload
        PermissionOptions[Payload.mode] = Payload.options
        ShowSaleCommission = Payload.showSaleCommission
    end

    return Payload
end

local function ClosePermissionUi()
    PermissionActive = false
    PermissionMode = nil
    PermissionConfig = nil
    InitialConfig = nil
    PermissionOptions = {}
    ShowSaleCommission = true
    SendNUIMessage({ action = "setVisible", data = false })
    SetNuiFocus(false, false)
    TriggerEvent("hud:Active", true)
end

RegisterNetEvent("chestpermission:open", function(Mode, Config)
    if not IsFactionPilotCity() then
        return
    end
    PermissionMode = Mode == "role" and "role" or "member"
    PermissionConfig = nil
    InitialConfig = nil
    PermissionOptions = {}
    ShowSaleCommission = true

    local Payload = type(Config) == "table" and NormalizeConfigPayload(Config, PermissionMode) or RequestConfig(PermissionMode)
    if not Payload.ok then
        return
    end

    PermissionConfig = Payload
    InitialConfig = Payload
    PermissionOptions[Payload.mode] = Payload.options
    ShowSaleCommission = Payload.showSaleCommission
    PermissionActive = true
    SendNUIMessage({ action = "setVisible", data = ("chest-permission/%s"):format(PermissionMode) })
    SendNUIMessage({ action = "updateChestPermissionConfig", data = Payload })
    SetNuiFocus(true, true)
    TriggerEvent("hud:Active", false)
end)

RegisterNetEvent("chestpermission:update", function(Payload)
    if not PermissionActive or type(Payload) ~= "table" then
        return
    end

    local Config = {}
    for Key, Value in pairs(PermissionConfig or {}) do
        Config[Key] = Value
    end
    for Key, Value in pairs(Payload) do
        Config[Key] = Value
    end

    PermissionConfig = NormalizeConfigPayload(Config, PermissionMode)
    InitialConfig = nil
    PermissionOptions[PermissionConfig.mode] = PermissionConfig.options
    ShowSaleCommission = PermissionConfig.showSaleCommission
    SendNUIMessage({ action = "updateChestPermissionConfig", data = PermissionConfig })
end)

RegisterNetEvent("chestpermission:updateAuthorizedList", function(Payload)
    if not PermissionActive or type(Payload) ~= "table" then
        return
    end

    SendNUIMessage({
        action = "updateChestPermissionAuthorizedList",
        data = { items = AsNuiArray(Payload.items) },
    })
end)

RegisterNetEvent("chestpermission:close", ClosePermissionUi)

function IsChestPermissionActive()
    return PermissionActive
end

function CancelChestPermissionFromEsc()
    if not PermissionActive then
        return
    end
    vSERVER.Close(true)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChestPermissionConfig", function(Data, Callback)
    local Mode = Data and Data["mode"]
    Callback(RequestConfig(Mode))
end)

RegisterNUICallback("chestPermissionSetMode", function(Data, Callback)
    PermissionMode = Data and Data["mode"] == "role" and "role" or "member"
    Callback(vSERVER.SetMode(PermissionMode))
end)

RegisterNUICallback("chestPermissionSelectTarget", function(Data, Callback)
    Callback(vSERVER.SelectTarget(Data and Data["mode"], Data and Data["targetId"]))
end)

RegisterNUICallback("chestPermissionSetTarget", function(Data, Callback)
    Callback(vSERVER.SetTarget(Data and Data["mode"], Data and Data["targetId"]))
end)

RegisterNUICallback("chestPermissionSetWithdrawAuthorization", function(Data, Callback)
    Callback(vSERVER.SetWithdrawAuthorization(
        Data and Data["mode"],
        Data and Data["targetId"],
        Data and Data["authorizedToWithdraw"] == true
    ))
end)

RegisterNUICallback("chestPermissionSetConfigureAuthorization", function(Data, Callback)
    Callback(vSERVER.SetConfigureAuthorization(
        Data and Data["mode"],
        Data and Data["targetId"],
        Data and Data["authorizedToConfigureChest"] == true
    ))
end)

RegisterNUICallback("chestPermissionSetSaleCommission", function(Data, Callback)
    Callback(vSERVER.SetSaleCommission(
        Data and Data["mode"],
        Data and Data["targetId"],
        Data and Data["saleCommissionPercentage"]
    ))
end)

RegisterNUICallback("requestChestPermissionAuthorizedList", function(Data, Callback)
    local Result = vSERVER.RequestAuthorizedList(Data and Data["mode"], Data and Data["targetId"])
    Callback({ items = AsNuiArray(type(Result) == "table" and Result.items or nil) })
end)

RegisterNUICallback("chestPermissionRemoveAuthorizedTarget", function(Data, Callback)
    Callback(vSERVER.RemoveAuthorizedTarget(
        Data and Data["mode"],
        Data and Data["targetId"]
    ))
end)

RegisterNUICallback("chestPermissionSave", function(Data, Callback)
    local configData = Data and Data["config"]
    local config

    -- O estado da NUI inclui todo o catálogo; envie só os campos que Save utiliza.
    if type(configData) == "table" then
        config = {
            authorizedToWithdraw = configData.authorizedToWithdraw == true,
            authorizedToConfigureChest = configData.authorizedToConfigureChest == true,
            saleCommissionPercentage = configData.saleCommissionPercentage,
        }
    end

    Callback(vSERVER.Save(
        Data and Data["mode"],
        Data and Data["targetId"],
        config
    ))
end)

RegisterNUICallback("chestPermissionClose", function(_, Callback)
    Callback(vSERVER.Close(false))
end)
