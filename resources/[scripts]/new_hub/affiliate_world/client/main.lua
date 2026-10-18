---@class affiliateWorld.ClientState
---@field active boolean
---@field worldId? integer
---@field sessionType? "individual"|"public"
---@field characterId? integer
---@field canManageWorld boolean
---@field canInvitePlayers boolean
---@field entryHealth? integer
---@field sessionGeneration integer
---@field onboardingOpen boolean
---@field callModalOpen boolean

---@class affiliateWorld.PendingRevive
---@field sessionGeneration integer

---@type affiliateWorld.ClientState
gAffiliateWorldClientState = {
    active = false,
    worldId = nil,
    sessionType = nil,
    characterId = nil,
    canManageWorld = false,
    canInvitePlayers = false,
    entryHealth = nil,
    sessionGeneration = 0,
    onboardingOpen = false,
    callModalOpen = false,
}

---@type affiliateWorld.PendingRevive?
local gAffiliateWorldPendingRevive = nil

---@type fun()?
local gAffiliateWorldWeaponBlockingTickAbort = nil

---@type table<number, boolean>
local gAffiliateWorldBlockedWeaponHashes = {}

for _, weaponName in ipairs(AFFILIATE_WORLD_CONFIG.BLOCKED_WEAPONS) do
    gAffiliateWorldBlockedWeaponHashes[GetHashKey(weaponName)] = true
end

local function UpdateAffiliateWorldWeaponBlocking()

    local selectedWeaponHash = GetSelectedPedWeapon(PlayerPedId())

    if gAffiliateWorldBlockedWeaponHashes[selectedWeaponHash] then
        DisablePlayerFiring(PlayerId(), true)
    end
end

local function StartAffiliateWorldWeaponBlocking()

    if gAffiliateWorldWeaponBlockingTickAbort then
        return
    end

    gAffiliateWorldWeaponBlockingTickAbort = sx.script.setTick(UpdateAffiliateWorldWeaponBlocking)
end

local function StopAffiliateWorldWeaponBlocking()

    if not gAffiliateWorldWeaponBlockingTickAbort then
        return
    end

    gAffiliateWorldWeaponBlockingTickAbort()
    gAffiliateWorldWeaponBlockingTickAbort = nil
end

---@param message string
---@param notifyType? affiliateWorld.NotifyType
function NotifyAffiliateWorldClient(message, notifyType)
    TriggerEvent("Notify", notifyType or "Warning", message, 5000, _t("affiliate_world_title"))
end

---@return boolean
function IsAffiliateWorldClientActive()
    return gAffiliateWorldClientState.active
end

exports("IsAffiliateWorldClientActive", IsAffiliateWorldClientActive)

---@param visible boolean
local function SetAffiliateWorldShortcutsVisible(visible)
    if GetResourceState("hud") ~= "started" then
        return
    end

    local success, errorMessage = pcall(function()
        exports.hud:SetAffiliateWorldShortcutsVisible(visible)
    end)

    if not success then
        sx.logger:warn(("Affiliate world shortcuts update failed visible=%s error=%s"):format(tostring(visible), tostring(errorMessage)))
    end
end

local function BeginAffiliateWorldClientSession()
    local ped = PlayerPedId()

    gAffiliateWorldClientState.sessionGeneration = gAffiliateWorldClientState.sessionGeneration + 1
    gAffiliateWorldClientState.entryHealth = DoesEntityExist(ped) and GetEntityHealth(ped) or nil
    gAffiliateWorldClientState.onboardingOpen = false
    gAffiliateWorldClientState.callModalOpen = false
    gAffiliateWorldPendingRevive = nil

    StartAffiliateWorldWeaponBlocking()
end

---@param ped integer
---@return boolean
local function IsAffiliateWorldPlayerDead(ped)
    return IsEntityDead(ped) or GetEntityHealth(ped) <= 100 or exports.survival:IsLocalPlayerDead()
end

---@param health integer
local function RestoreAffiliateWorldHealth(health)
    local ped = PlayerPedId()

    if not DoesEntityExist(ped) then
        return
    end

    local restoredHealth = math.max(health, 101)

    if not IsAffiliateWorldPlayerDead(ped) then
        SetEntityHealth(ped, restoredHealth)
        return
    end

    if IsEntityDead(ped) then
        NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped))
    end

    exports.survival:Revive(restoredHealth, false)
end

local function EndAffiliateWorldClientSession()

    StopAffiliateWorldWeaponBlocking()

    local entryHealth = gAffiliateWorldClientState.entryHealth

    if not Client.ClearAffiliateWorldWeapon() then
        sx.logger:error("Affiliate world client session ended with temporary weapons still equipped")
    end

    gAffiliateWorldClientState.sessionGeneration = gAffiliateWorldClientState.sessionGeneration + 1
    gAffiliateWorldClientState.entryHealth = nil
    gAffiliateWorldClientState.onboardingOpen = false
    gAffiliateWorldClientState.callModalOpen = false
    gAffiliateWorldPendingRevive = nil

    if entryHealth then
        RestoreAffiliateWorldHealth(entryHealth)
    end
end

local function ScheduleAffiliateWorldRevive()
    if gAffiliateWorldPendingRevive then
        return
    end

    local pendingRevive = {
        sessionGeneration = gAffiliateWorldClientState.sessionGeneration,
    }

    gAffiliateWorldPendingRevive = pendingRevive

    SetTimeout(AFFILIATE_WORLD_CONFIG.REVIVE_DELAY_MS, function()
        if gAffiliateWorldPendingRevive ~= pendingRevive then
            return
        end

        gAffiliateWorldPendingRevive = nil

        if not IsAffiliateWorldClientActive() or gAffiliateWorldClientState.sessionGeneration ~= pendingRevive.sessionGeneration then
            return
        end

        local ped = PlayerPedId()

        if not DoesEntityExist(ped) or not IsAffiliateWorldPlayerDead(ped) then
            return
        end

        RestoreAffiliateWorldHealth(400)
    end)
end

function CloseAffiliateWorldPresentation()
    gAffiliateWorldClientState.onboardingOpen = false
    gAffiliateWorldClientState.callModalOpen = false

    SendNUIMessage({
        action = "closeAfiliadoPresentation",
    })

    SetNuiFocus(false, false)
end

function FinishAffiliateWorldOnboarding()
    gAffiliateWorldClientState.onboardingOpen = false

    SetNuiFocus(false, false)
end

function ResolveAffiliateWorldCall()
    SendNUIMessage({
        action = "afiliadoCallResolved",
    })
end

function Client.ResolveAffiliateWorldCall()
    ResolveAffiliateWorldCall()
end

local function PresentAffiliateWorldOnboarding()
    if not IsAffiliateWorldClientActive() then
        return
    end

    gAffiliateWorldClientState.onboardingOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openAfiliadoOnboarding" })
end

---@param collectibleStates table<string, { name: string, title: string, description: string }[]>
local function ResolveAffiliateWorldCollectibleStateTranslations(collectibleStates)

    for _, states in pairs(collectibleStates) do

        for _, state in ipairs(states) do
            local title = exports.scripted_interactions:GetPetTranslation(state.title)
            local description = exports.scripted_interactions:GetPetTranslation(state.description)

            state.title = title or state.title
            state.description = description or state.description
        end
    end

    return collectibleStates
end

local function PresentAffiliateWorldCatalog()

    local success, collectibleStates = pcall( function()
        return exports.scripted_interactions:GetCollectibleStates()
    end )

    if not success or type( collectibleStates ) ~= 'table' then
        sx.logger:warn( ('Failed to load affiliate collectible states error=%s'):format( tostring( collectibleStates ) ) )
        collectibleStates = { }
    else
        local eligibleStates = { }

        for collectionId in pairs(AFFILIATE_WORLD_CONFIG.GET_COLLECTIBLES_BY_COLLECTIONS_IDS) do
            local collectionSuccess, lookupKeys = pcall(function()
                return exports.santa_radio:GetCollectibleKeysByCollectionId(collectionId)
            end)

            if not collectionSuccess or type(lookupKeys) ~= 'table' then
                sx.logger:warn(('Failed to load affiliate collection keys collectionId=%s error=%s'):format(
                    collectionId,
                    tostring(lookupKeys)
                ))
            else
                for _, lookupKey in ipairs(lookupKeys) do
                    if collectibleStates[lookupKey] then
                        eligibleStates[lookupKey] = collectibleStates[lookupKey]
                    end
                end
            end
        end

        collectibleStates = eligibleStates
        collectibleStates = ResolveAffiliateWorldCollectibleStateTranslations(collectibleStates)
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openAfiliadoCatalog",
        data = {
            cityId = GetConvar("cityName", ""),
            sessionType = gAffiliateWorldClientState.sessionType,
            canInvitePlayers = gAffiliateWorldClientState.canInvitePlayers,
            collectibleStates = collectibleStates,
            collectibleStateTexts = {
                label = _t("affiliate_world_collectible_state_label"),
                placeholder = _t("affiliate_world_collectible_state_placeholder"),
                processing = _t("affiliate_world_collectible_state_processing"),
                testing = _t("affiliate_world_collectible_state_testing"),
            },
            purchaseFailed = _t("affiliate_world_purchase_failed"),
            purchaseSuccess = _t("affiliate_world_purchase_success"),
            catalogLoadFailed = _t("affiliate_world_catalog_load_failed"),
        },
    })
end

local function PresentAffiliateWorldCallModal()
    if not IsAffiliateWorldClientActive() or gAffiliateWorldClientState.onboardingOpen or gAffiliateWorldClientState.callModalOpen then
        return
    end

    gAffiliateWorldClientState.callModalOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openAfiliadoCallModal",
        data = {
            callWaitTime = "~2 min",
            cityId = GetConvar("cityName", ""),
        },
    })
end

---@param payload table
function Client.SetAffiliateWorldState(payload)
    payload = type(payload) == "table" and payload or {}
    local wasActive = gAffiliateWorldClientState.active
    local active = payload.active == true

    gAffiliateWorldClientState.active = active

    if active and not wasActive then
        BeginAffiliateWorldClientSession()
    elseif not active and wasActive then
        EndAffiliateWorldClientSession()
    end

    gAffiliateWorldClientState.worldId = payload.worldId
    gAffiliateWorldClientState.sessionType = payload.sessionType
    gAffiliateWorldClientState.characterId = payload.characterId
    gAffiliateWorldClientState.canManageWorld = payload.canManageWorld == true
    gAffiliateWorldClientState.canInvitePlayers = payload.canInvitePlayers == true
    UpdateAffiliateWorldProtectedPresentation(active, payload.characterId)
    UpdateAffiliateWorldAimTraining(active)

    if gAffiliateWorldClientState.active then
        TriggerEvent("inventory:CloseAll")
        SetAffiliateWorldShortcutsVisible(true)

        if payload.showOnboarding == true then
            PresentAffiliateWorldOnboarding()
        end
    else
        gAffiliateWorldClientState.onboardingOpen = false
        CloseAffiliateWorldPresentation()
        SetAffiliateWorldShortcutsVisible(false)
    end
end

RegisterNetEvent("net:routing_bucket_changed", function()

    if not IsAffiliateWorldClientActive() then
        return
    end

    CloseAffiliateWorldPresentation()
end)

AddEventHandler("gameEventTriggered", function(eventName, args)
    if eventName ~= "CEventNetworkEntityDamage" or not IsAffiliateWorldClientActive() then
        return
    end

    local ped = PlayerPedId()

    if args[1] ~= ped then
        return
    end

    local eventSaysFatal = args[6] == true or tonumber(args[6]) == 1

    if not eventSaysFatal and GetEntityHealth(ped) > 100 then
        return
    end

    CloseAffiliateWorldPresentation()
    ScheduleAffiliateWorldRevive()
end)

local function OpenAffiliateWorldCatalog()
    if not IsAffiliateWorldClientActive() then
        return
    end

    PresentAffiliateWorldCatalog()
end

local function ExitAffiliateWorld()
    if not IsAffiliateWorldClientActive() then
        return
    end

    local response = vSERVER.ExitAffiliateWorld()

    if not response or response.success ~= true then
        NotifyAffiliateWorldClient(response and response.message or _t("affiliate_world_action_failed"))
    end
end

---@param shouldNotify boolean | nil
---@return table response
function RequestAffiliateWorldStaffCall(shouldNotify)
    local response = vSERVER.CallAffiliateWorldStaff() or {
        success = false,
        message = _t("affiliate_world_call_failed"),
        color = "red",
    }
    
    if shouldNotify then
        NotifyAffiliateWorldClient(response.message, response.success and "Confirmed" or "Warning")
    end

    return response
end

RegisterCommand("affiliate_world_catalog", OpenAffiliateWorldCatalog, false)
RegisterKeyMapping("affiliate_world_catalog", _t("affiliate_world_hint_catalog"), "keyboard", "J")

RegisterCommand("affiliate_call", PresentAffiliateWorldCallModal, false)
RegisterKeyMapping("affiliate_call", _t("affiliate_world_hint_call"), "keyboard", "U")

RegisterCommand("affiliate_world_exit", ExitAffiliateWorld, false)
RegisterKeyMapping("affiliate_world_exit", _t("affiliate_world_hint_exit"), "keyboard", "O")

AddEventHandler("onClientResourceStart", function(resourceName)
    if resourceName == "hud" and IsAffiliateWorldClientActive() then
        SetAffiliateWorldShortcutsVisible(true)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    if IsAffiliateWorldClientActive() then
        gAffiliateWorldClientState.active = false
        EndAffiliateWorldClientSession()
    end

    SetAffiliateWorldShortcutsVisible(false)
    CloseAffiliateWorldPresentation()
end)
