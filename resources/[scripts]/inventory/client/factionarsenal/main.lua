-----------------------------------------------------------------------------------------------------------------------------------------
-- FACTION ARSENAL (CLIENT)
-----------------------------------------------------------------------------------------------------------------------------------------
local vSERVER = Tunnel.getInterface("inventory/factionarsenal")

local gSync = {
    job = nil,
    coords = nil,
    showPoint = false,
    isPolice = false,
}

local gHoverfyVisible = false
local gLastJob = nil
local gBlip = nil
local INTERACT_DISTANCE = 2.5
local MARKER_DISTANCE = 50.0
local BLIP_SPRITE = 40
local BLIP_SCALE = 0.4
local MARKER_TYPE = 40

---@param Coords table|vector3|nil
---@return vector3|nil
local function ToVec3(Coords)
    if Coords == nil then
        return nil
    end

    local CoordType = type(Coords)
    if CoordType == "vector3" or CoordType == "vector4" then
        return vector3(Coords.x, Coords.y, Coords.z)
    end

    if CoordType ~= "table" then
        return nil
    end

    local X = tonumber(Coords.x or Coords[1])
    local Y = tonumber(Coords.y or Coords[2])
    local Z = tonumber(Coords.z or Coords[3])
    if not X or not Y or not Z then
        return nil
    end
    return vector3(X, Y, Z)
end

local function HideHoverfy()
    if not gHoverfyVisible then
        return
    end
    gHoverfyVisible = false
    TriggerEvent("hoverfy:toggle", false, {})
end

local function ShowHoverfy()
    if gHoverfyVisible then
        return
    end
    gHoverfyVisible = true
    TriggerEvent("hoverfy:toggle", true, {
        key = "E",
        title = gSync.isPolice and _t("legalArsenalTakeConsumables") or "Pegar Equipamento",
        legend = "Pressione para pegar",
    })
end

local function RemoveArsenalBlip()
    if gBlip and DoesBlipExist(gBlip) then
        RemoveBlip(gBlip)
    end
    gBlip = nil
end

local function UpsertArsenalBlip(Coords)
    RemoveArsenalBlip()
    if not Coords then
        return
    end

    gBlip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(gBlip, BLIP_SPRITE)
    SetBlipDisplay(gBlip, 4)
    SetBlipAsShortRange(gBlip, true)
    SetBlipColour(gBlip, GetFactionPilotBlipColor())
    SetBlipScale(gBlip, BLIP_SCALE)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Arsenal")
    EndTextCommandSetBlipName(gBlip)
end

function ApplySync(Payload)
    if not IsFactionPilotCity() then
        HideHoverfy()
        RemoveArsenalBlip()
        gSync.showPoint = false
        gSync.coords = nil
        return
    end

    if type(Payload) ~= "table" then
        return
    end

    local isPolice = Payload.isPolice == true

    if gSync.isPolice ~= isPolice then
        HideHoverfy()
    end

    gSync.isPolice = isPolice
    gSync.job = Payload.job
    gSync.coords = ToVec3(Payload.coords)
    gSync.showPoint = Payload.showPoint == true and gSync.coords ~= nil

    if not gSync.showPoint then
        HideHoverfy()
        RemoveArsenalBlip()
        return
    end

    UpsertArsenalBlip(gSync.coords)
end

RegisterNetEvent("factionarsenal:sync", function(Payload)
    ApplySync(Payload)
end)

CreateThread(function()
    if not IsFactionPilotCity() then
        return
    end

    while true do
        local Idle = 1500

        if gSync.showPoint and gSync.coords then
            local PedCoords = GetEntityCoords(PlayerPedId())
            local Dist = #(PedCoords - gSync.coords)
            if Dist <= MARKER_DISTANCE then
                Idle = 0
                DrawMarker(MARKER_TYPE, gSync.coords.x, gSync.coords.y, gSync.coords.z, 0, 0, 0, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0), THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 94, false, false, 2, true, nil, nil, false)
                DrawMarker(27, gSync.coords.x, gSync.coords.y, gSync.coords.z - 0.9, 0, 0, 0, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0), THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 94, false, false, 2, true, nil, nil, false)
                if Dist <= INTERACT_DISTANCE then
                    ShowHoverfy()
                    if IsControlJustPressed(0, 38) then
                        vSERVER.Withdraw()
                        Wait(750)
                    end
                else
                    HideHoverfy()
                end
            else
                HideHoverfy()
                if Dist < 80.0 then
                    Idle = 250
                end
            end
        else
            HideHoverfy()
            Idle = 2500
        end

        Wait(Idle)
    end
end)

local function RequestSync()
    if not IsFactionPilotCity() then
        return
    end
    TriggerServerEvent("factionarsenal:requestSync")
end

CreateThread(function()
    Wait(2000)
    gLastJob = LocalPlayer.state and LocalPlayer.state.Job or nil
    RequestSync()
end)

AddStateBagChangeHandler("Job", nil, function(BagName, _, Value)
    local LocalBag = ("player:%s"):format(GetPlayerServerId(PlayerId()))
    if BagName ~= LocalBag then
        return
    end
    if Value == gLastJob then
        return
    end
    gLastJob = Value
    RequestSync()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI
-----------------------------------------------------------------------------------------------------------------------------------------
local gArsenalUiActive = false

local function PushArsenalConfig(Payload)
    if type(Payload) ~= "table" then
        return
    end
    SendNUIMessage({
        action = "updateFactionArsenalConfig",
        data = Payload,
    })
end

local function CloseArsenalUi()
    if not gArsenalUiActive then
        return
    end
    gArsenalUiActive = false
    SendNUIMessage({ action = "setVisible", data = false })
    SetNuiFocus(false, false)
end

local function OpenArsenalUi(isLegal)
    if not IsFactionPilotCity() then
        return
    end

    local Data

    if isLegal then
        Data = vSERVER.OpenLegalMenu()
    else
        Data = vSERVER.RequestConfig()
    end
    if not Data or not Data.ok then
        return
    end

    gArsenalUiActive = true
    SendNUIMessage({
        action = "setVisible",
        data = "faction-arsenal",
    })
    SetNuiFocus(true, true)
end

function IsFactionArsenalActive()
    return gArsenalUiActive
end

function CancelFactionArsenalFromEsc()
    CloseArsenalUi()
end

local function ApplyMutation(Result)
    if type(Result) ~= "table" or not Result.ok then
        PushArsenalConfig(vSERVER.RequestConfig())
        return { ok = false }
    end

    if type(Result.sync) == "table" then
        ApplySync(Result.sync)
    end

    if type(Result.config) == "table" then
        PushArsenalConfig(Result.config)
    else
        PushArsenalConfig(vSERVER.RequestConfig())
    end

    return Result
end

RegisterNUICallback("requestFactionArsenalConfig", function(_, Callback)
    Callback(vSERVER.RequestConfig() or { ok = false, roles = {} })
end)

RegisterNUICallback("factionArsenalSetPosition", function(_, Callback)
    Callback(ApplyMutation(vSERVER.SetPosition()))
end)

RegisterNUICallback("factionArsenalOpenRoles", function(_, Callback)
    Callback({ ok = true })
    if gArsenalUiActive then
        PushArsenalConfig(vSERVER.RequestConfig())
    end
end)

RegisterNUICallback("factionArsenalSelectRole", function(_, Callback)
    Callback({ ok = true })
end)

RegisterNUICallback("factionArsenalOpenRoleDetail", function(Data, Callback)
    Callback({ ok = true })
    if gArsenalUiActive and Data and Data.visible == true then
        PushArsenalConfig(vSERVER.RequestConfig())
    end
end)

RegisterNUICallback("factionArsenalSetRole", function(Data, Callback)
    Callback(ApplyMutation(vSERVER.SetRoleEnabled(Data and Data.roleId, Data and Data.enabled == true)))
end)

RegisterNUICallback("requestFactionArsenalKitItems", function(Data, Callback)
    Callback(vSERVER.RequestKitItems(
        Data and Data.roleId,
        Data and Data.currentKitItems
    ) or { items = {} })
end)

RegisterNUICallback("factionArsenalAddRoleKitItem", function(Data, Callback)
    Callback(vSERVER.AddRoleKitItem(Data and Data.roleId, Data and Data.item) or { ok = false })
end)

RegisterNUICallback("factionArsenalSaveRoleConfig", function(Data, Callback)
    Callback(ApplyMutation(vSERVER.SaveRoleConfig(
        Data and Data.roleId,
        Data and Data.enabled == true,
        Data and Data.cooldownMinutes,
        Data and Data.withdrawLimit,
        Data and Data.kitItems
    )))
end)

RegisterNUICallback("factionArsenalDisableAllRoles", function(_, Callback)
    Callback(ApplyMutation(vSERVER.DisableAllRoles()))
end)

RegisterNUICallback("factionArsenalRemovePosition", function(_, Callback)
    Callback({ ok = true })
    CreateThread(function()
        CloseArsenalUi()
        local Result = vSERVER.ClearPosition()

        if type(Result) == "table" and Result.ok then
            if type(Result.sync) == "table" then
                ApplySync(Result.sync)
            end
        end

        OpenArsenalUi()
    end)
end)

RegisterNUICallback("factionArsenalClose", function(_, Callback)
    CloseArsenalUi()
    Callback({ ok = true })
end)

RegisterCommand("arsenalfac", function()
    OpenArsenalUi()
end, false)

RegisterCommand("arsenallegal", function()
    OpenArsenalUi(true)
end, false)
