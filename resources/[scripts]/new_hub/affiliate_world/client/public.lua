---@class affiliateWorld.PublicPlayer
---@field ped integer
---@field name string
---@field characterId? integer
---@field product string

local AFFILIATE_PUBLIC_GHOST_ALPHA = 192
local AFFILIATE_VEHICLE_OWNER_REPLICATION_TIMEOUT_MS = 5000

local gAffiliatePublicTickAbort = nil
local gAffiliatePublicCharacterId = nil
local gAffiliatePublicPlayers = {}
local gAffiliatePublicVehicles = {}
local gAffiliatePublicRefreshAt = 0
local gAffiliatePublicLeaveVehicleAt = 0
local gAffiliatePublicCurrentVehicle = 0
local gAffiliatePublicVehicleOwnerDeadline = 0

local function ApplyAffiliatePublicGhost()
    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(AFFILIATE_PUBLIC_GHOST_ALPHA)
end

---@param value any
---@return string
local function SanitizeAffiliatePublicLabel(value)
    return tostring(value or ""):gsub("~", ""):sub(1, 48)
end

local function RefreshAffiliatePublicEntities()
    local players = {}

    for _, playerIndex in ipairs(GetActivePlayers()) do
        local serverId = GetPlayerServerId(playerIndex)
        local state = Player(serverId).state
        local ped = GetPlayerPed(playerIndex)

        if state["affiliateWorld:active"] == true and ped ~= 0 and DoesEntityExist(ped)
            and playerIndex ~= PlayerId() then
            players[#players + 1] = {
                ped = ped,
                name = SanitizeAffiliatePublicLabel(state["affiliateWorld:name"] or GetPlayerName(playerIndex)),
                characterId = state["affiliateWorld:characterId"],
                product = SanitizeAffiliatePublicLabel(state["affiliateWorld:product"]),
            }
        end
    end

    gAffiliatePublicPlayers = players

    local vehicles = {}

    for _, vehicle in ipairs(GetGamePool("CVehicle")) do
        if DoesEntityExist(vehicle) then
            local ownerCharacterId = Entity(vehicle).state["affiliateWorld:testOwner"]

            if type(ownerCharacterId) == "number" then
                vehicles[#vehicles + 1] = { entity = vehicle, ownerCharacterId = ownerCharacterId }
            end
        end
    end

    gAffiliatePublicVehicles = vehicles
end

---@param player affiliateWorld.PublicPlayer
local function DrawAffiliatePublicLabel(player)
    local position = GetEntityCoords(player.ped)
    local localPosition = GetEntityCoords(PlayerPedId())

    if #(position - localPosition) > 25.0 then
        return
    end

    local visible, screenX, screenY = World3dToScreen2d(position.x, position.y, position.z + 1.15)

    if not visible then
        return
    end

    local heading = ("%s | ID %s"):format(player.name, tostring(player.characterId or "?"))
    local label = player.product ~= "" and ("%s\n%s"):format(heading, player.product) or heading

    SetTextFont(4)
    SetTextScale(0.0, 0.32)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 230)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandDisplayText(screenX, screenY)
end

local function TickAffiliatePublicWorld()
    local now = GetGameTimer()

    if now >= gAffiliatePublicRefreshAt then
        -- Morte (NetworkResurrectLocalPlayer), /nc, safezone e outros sistemas desligam o ghost global; reaplica sempre.
        ApplyAffiliatePublicGhost()
        RefreshAffiliatePublicEntities()
        gAffiliatePublicRefreshAt = now + 500
    end

    local localPed = PlayerPedId()

    if not DoesEntityExist(localPed) then
        return
    end

    -- O modo ghost aplica alpha no ped local; o dono do client precisa continuar opaco.
    if GetEntityAlpha(localPed) ~= 255 then
        ResetEntityAlpha(localPed)
    end

    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 263, true)

    local localVehicle = GetVehiclePedIsIn(localPed, false)

    if localVehicle ~= gAffiliatePublicCurrentVehicle then
        gAffiliatePublicCurrentVehicle = localVehicle
        gAffiliatePublicVehicleOwnerDeadline = now + AFFILIATE_VEHICLE_OWNER_REPLICATION_TIMEOUT_MS
    end

    if localVehicle ~= 0 and now >= gAffiliatePublicLeaveVehicleAt then
        local ownerCharacterId = Entity(localVehicle).state["affiliateWorld:testOwner"]
        -- A garagem ja coloca o ped no motorista; a marca de dono pode chegar depois.
        local awaitingOwner = ownerCharacterId == nil and now < gAffiliatePublicVehicleOwnerDeadline

        if (not awaitingOwner and ownerCharacterId ~= gAffiliatePublicCharacterId)
            or GetPedInVehicleSeat(localVehicle, -1) ~= localPed then
            TaskLeaveVehicle(localPed, localVehicle, 16)
            gAffiliatePublicLeaveVehicleAt = now + 1500
        end
    end

    for _, player in ipairs(gAffiliatePublicPlayers) do
        if DoesEntityExist(player.ped) then
            -- Colisao ped a ped ja e tratada por SetLocalPlayerAsGhost.
            if localVehicle ~= 0 then
                SetEntityNoCollisionEntity(localVehicle, player.ped, true)
            end

            DrawAffiliatePublicLabel(player)
        end
    end

    for _, entry in ipairs(gAffiliatePublicVehicles) do
        local vehicle = entry.entity

        if DoesEntityExist(vehicle) and vehicle ~= localVehicle and entry.ownerCharacterId ~= gAffiliatePublicCharacterId then
            SetEntityNoCollisionEntity(localPed, vehicle, true)

            if localVehicle ~= 0 then
                SetEntityNoCollisionEntity(localVehicle, vehicle, true)
            end
        end
    end
end

local function StopAffiliatePublicWorld()
    -- So desfaz o ghost se foi este modulo que o ativou, para nao interferir em outros sistemas.
    if gAffiliatePublicTickAbort then
        gAffiliatePublicTickAbort()
        gAffiliatePublicTickAbort = nil

        SetLocalPlayerAsGhost(false)
        SetGhostedEntityAlpha(255)

        local localPed = PlayerPedId()

        if DoesEntityExist(localPed) then
            ResetEntityAlpha(localPed)
        end
    end

    gAffiliatePublicPlayers = {}
    gAffiliatePublicVehicles = {}
    gAffiliatePublicCharacterId = nil
    gAffiliatePublicCurrentVehicle = 0
    gAffiliatePublicVehicleOwnerDeadline = 0
    gAffiliatePublicLeaveVehicleAt = 0
end

---@param active boolean
---@param characterId? integer
function UpdateAffiliateWorldProtectedPresentation(active, characterId)
    if not active then
        StopAffiliatePublicWorld()
        return
    end

    gAffiliatePublicCharacterId = characterId

    if not gAffiliatePublicTickAbort then
        gAffiliatePublicRefreshAt = 0
        ApplyAffiliatePublicGhost()
        gAffiliatePublicTickAbort = sx.script.setTick(TickAffiliatePublicWorld)
    end
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        StopAffiliatePublicWorld()
    end
end)
