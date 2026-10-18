local AUTOMATIC_OPEN_RETRY_INTERVAL_MS = 250
local REOPEN_POPUP_EXPIRY_CHECK_INTERVAL_MS = 1000

local gCouponsOfferOpen = false
local gCouponsAutomaticOpenPending = false
local gCouponsFormerBeginnerOpenPending = false
local gCouponsFormerBeginnerScheduleId = 0
local gCouponsReopenPayload = nil
local gCouponsReopenExpiresAt = nil
local gCouponsReopenWindowCreated = false
local gCargameInviteOpen = false

local function IsCargameBlockingCoupons()
    return gCargameInviteOpen or LocalPlayer.state['minigame:active'] == 'cargame'
end

---@return number
local function GetFloatingSeconds()

    local seconds = tonumber(COUPONS_CONFIG.REOPEN_POPUP.DEFAULT_SECONDS) or 300

    return seconds > 0 and seconds or 300
end

local function ClearCouponsReopenWindow()

    gCouponsReopenPayload = nil
    gCouponsReopenExpiresAt = nil

    SendNUIMessage({ action = COUPONS_CONFIG.NUI.ACTIONS.HIDE_FLOATING, data = {} })
end

---@param seconds number
local function ShowCouponsReopenWindow(seconds)
    if IsCargameBlockingCoupons() then
        return
    end

    SendNUIMessage({
        action = 'showAdCuponsFloating',
        data = {
            key = COUPONS_CONFIG.REOPEN_POPUP.REOPEN_KEY,
            seconds = seconds,
            durationSeconds = GetFloatingSeconds(),
        },
    })
end

local function StartCouponsReopenWindow()

    if gCouponsReopenWindowCreated or not gCouponsReopenPayload then
        return
    end

    local seconds = GetFloatingSeconds()
    local expiresAt = GetGameTimer() + (seconds * 1000)

    gCouponsReopenWindowCreated = true
    gCouponsReopenExpiresAt = expiresAt

    ShowCouponsReopenWindow(seconds)

    CreateThread(function()

        while gCouponsReopenExpiresAt == expiresAt and GetGameTimer() < expiresAt do
            Wait(REOPEN_POPUP_EXPIRY_CHECK_INTERVAL_MS)
        end

        if gCouponsReopenExpiresAt == expiresAt then
            ClearCouponsReopenWindow()
        end
    end)
end

local function ResumeCouponsReopenWindow()

    local expiresAt = gCouponsReopenExpiresAt

    if not expiresAt then
        return StartCouponsReopenWindow()
    end

    local remainingMs = expiresAt - GetGameTimer()

    if remainingMs <= 0 then
        return ClearCouponsReopenWindow()
    end

    ShowCouponsReopenWindow(math.ceil(remainingMs / 1000))
end

---@return HudCouponOffersDto
local function GetCouponOffers()
    local success, response = pcall(lib.callback.await, COUPONS_CONFIG.CALLBACKS.GET_OFFERS, false)

    if not success then
        sx.logger:error(('[coupons] Falha ao buscar ofertas no server. error=%s'):format(tostring(response)))
        return { cupons = {} }
    end

    local offers = response and response.ok and response.data

    return type(offers) == 'table' and type(offers.cupons) == 'table' and offers or { cupons = {} }
end

---@param couponId any
---@param interactionType HudCouponInteractionType
---@param details? HudCouponInteractionDetails
---@return HudCouponResult
local function RecordCouponInteraction(couponId, interactionType, details)
    local success, response = pcall(
        lib.callback.await,
        COUPONS_CONFIG.CALLBACKS.RECORD_INTERACTION,
        false,
        couponId,
        interactionType,
        details
    )

    if not success then
        sx.logger:error(('[coupons] Falha ao registrar interação no client. couponId=%s interaction=%s error=%s'):format(
            tostring(couponId),
            interactionType,
            tostring(response)
        ))

        return {
            ok = false,
            message = _t('coupons.generic.noServerResponse'),
        }
    end

    return response or {
        ok = false,
        message = _t('coupons.generic.noServerResponse'),
    }
end

---@return boolean
local function IsPlayerBeginner()

    local groups = vRP.GetPlayerGroups() or {}

    return groups.Iniciante ~= nil or LocalPlayer.state.Iniciante
end

---@return boolean
local function IsPlayerReadyForCoupons()
    local playerState = LocalPlayer.state

    if IsCargameBlockingCoupons() then
        return false
    end

    -- Aguarda o frontend da HUD registrar os callbacks NUI.
    if not isNuiReady then
        return false
    end

    -- Aguarda o personagem terminar de carregar.
    if not playerState.Active then
        return false
    end

    -- Não interrompe estados que bloqueiam interações do jogador.
    if playerState.Cancel then
        return false
    end

    -- Não disputa foco com a criação de personagem.
    if playerState.Creating then
        return false
    end

    -- Não disputa foco com os fluxos de primeiro login e onboarding.
    if playerState.FirstLogin or playerState.newHubTutorial then
        return false
    end

    -- Não interrompe um minigame em andamento.
    if playerState['minigame:active'] then
        return false
    end

    -- Não rouba o foco de outra NUI.
    if IsNuiFocused() then
        return false
    end

    -- Não abre por cima do menu de pausa ou da tela de loading.
    if IsPauseMenuActive() or GetIsLoadingScreenActive() then
        return false
    end

    -- Aguarda a transição visual da tela terminar.
    if not IsScreenFadedIn() then
        return false
    end

    if IsScreenFadingIn() or IsScreenFadingOut() then
        return false
    end

    -- Não interrompe o jogador durante um combate.
    if GetResourceState('combatsystem') == 'started' and exports.combatsystem:IsInCombat() then
        return false
    end

    if GetResourceState('player') == 'started' and exports.player:IsResourceFoucused() then -- isso aqui é um filtro ele pega varias nuis exemplos ( "new_hub", "inventory", "character-creator", "garages", "hud")
        return false
    end

    return true
end

---@return boolean
local function IsPlayerInDefaultWorld()
    return tonumber(LocalPlayer.state.Route) == COUPONS_CONFIG.POST_BEGINNER.DEFAULT_WORLD_BUCKET
end

---@return number
local function GetFormerBeginnerOpenDelayMs()
    return COUPONS_CONFIG.POST_BEGINNER.OPEN_DELAY_SECONDS * 1000
end

---@return boolean
local function IsFormerBeginnerReadyForCoupons()
    return not IsPlayerBeginner() and IsPlayerInDefaultWorld() and IsPlayerReadyForCoupons()
end

---@param offers HudCouponOffersDto
---@param allowEmpty? boolean
---@return boolean opened
local function OpenCouponsModal(offers, allowEmpty)
    if type(offers) ~= 'table' or type(offers.cupons) ~= 'table' or (not allowEmpty and #offers.cupons < 1 and not offers.banner) then
        return false
    end

    offers.reopenKey = COUPONS_CONFIG.REOPEN_POPUP.REOPEN_KEY
    offers.floatingSeconds = GetFloatingSeconds()

    gCouponsReopenPayload = offers
    gCouponsOfferOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({ action = COUPONS_CONFIG.NUI.ACTIONS.OPEN, data = offers })

    return true
end

local function CancelFormerBeginnerCouponsOpen()
    gCouponsFormerBeginnerScheduleId = gCouponsFormerBeginnerScheduleId + 1
    gCouponsFormerBeginnerOpenPending = false
end

local function StartFormerBeginnerCouponsOpen()
    CancelFormerBeginnerCouponsOpen()

    local scheduleId = gCouponsFormerBeginnerScheduleId
    local openAt = GetGameTimer() + GetFormerBeginnerOpenDelayMs()

    CreateThread(function()
        local remainingMs = openAt - GetGameTimer()

        if remainingMs > 0 then
            Wait(remainingMs)
        end

        if scheduleId ~= gCouponsFormerBeginnerScheduleId then
            return
        end

        gCouponsFormerBeginnerOpenPending = true

        while gCouponsFormerBeginnerOpenPending and scheduleId == gCouponsFormerBeginnerScheduleId do
            if IsFormerBeginnerReadyForCoupons() then
                local offers = GetCouponOffers()

                if not gCouponsFormerBeginnerOpenPending or scheduleId ~= gCouponsFormerBeginnerScheduleId then
                    return
                end

                if IsFormerBeginnerReadyForCoupons() then
                    gCouponsFormerBeginnerOpenPending = false
                    OpenCouponsModal(offers)
                    return
                end
            end

            Wait(AUTOMATIC_OPEN_RETRY_INTERVAL_MS)
        end
    end)
end

---@param notifyNui? boolean
---@param clearReopenWindow? boolean
local function CloseCouponsModal(notifyNui)
    gCouponsAutomaticOpenPending = false
    gCouponsOfferOpen = false
    SetNuiFocus(false, false)

    if notifyNui then
        SendNUIMessage({ action = COUPONS_CONFIG.NUI.ACTIONS.CLOSE, data = {} })
    end
end

local function QueueAutomaticCouponsOpen()
    if gCouponsAutomaticOpenPending or IsPlayerBeginner() then
        return
    end

    gCouponsAutomaticOpenPending = true

    -- O evento pode chegar durante o spawn ou antes da NUI ficar pronta.
    -- Mantém somente essa abertura automática pendente até o bloqueio terminar.
    CreateThread(function()
        while gCouponsAutomaticOpenPending and not IsPlayerReadyForCoupons() do
            Wait(AUTOMATIC_OPEN_RETRY_INTERVAL_MS)
        end

        if not gCouponsAutomaticOpenPending or IsPlayerBeginner() then
            gCouponsAutomaticOpenPending = false
            return
        end

        gCouponsAutomaticOpenPending = false
        OpenCouponsModal(GetCouponOffers())
    end)
end

local function OpenAvailableCoupons()
    if IsPlayerBeginner() then
        return
    end

    local offers = GetCouponOffers()

    if gCouponsOfferOpen or (#offers.cupons < 1 and not offers.banner) then
        return
    end

    if not IsPlayerReadyForCoupons() then
        return QueueAutomaticCouponsOpen()
    end

    gCouponsAutomaticOpenPending = false
    OpenCouponsModal(offers)
end

local function OpenCouponsSystem()
    if not IsPlayerReadyForCoupons() then
        return
    end

    gCouponsAutomaticOpenPending = false
    OpenCouponsModal(GetCouponOffers(), true)
end

local function ReopenCouponsModal()

    if not (gCouponsReopenPayload and gCouponsReopenExpiresAt) then
        return
    end

    if GetGameTimer() >= gCouponsReopenExpiresAt then
        ClearCouponsReopenWindow()
        return
    end

    if gCouponsOfferOpen or not IsPlayerReadyForCoupons() then
        return
    end

    OpenCouponsModal(gCouponsReopenPayload, true)
end

---@param offers HudCouponOffersDto
local function UpdateCouponsModal(offers)
    if not gCouponsOfferOpen or type(offers) ~= 'table' or type(offers.cupons) ~= 'table' then
        return
    end

    SendNUIMessage({
        action = COUPONS_CONFIG.NUI.ACTIONS.UPDATE,
        data = { cupons = offers.cupons },
    })
end

---@param data HudAdCouponNotifyDto
local function ShowCouponNotify(data)
    if type(data) ~= 'table' or type(data.cupom) ~= 'table' or type(data.key) ~= 'string' then
        return
    end

    SendNUIMessage({
        action = COUPONS_CONFIG.NUI.ACTIONS.SHOW_NOTIFY,
        data = data,
    })
end

local function HideCouponNotify()
    SendNUIMessage({ action = COUPONS_CONFIG.NUI.ACTIONS.HIDE_NOTIFY })
end

AddEventHandler('hud:cargameInviteOpen', function(open)
    gCargameInviteOpen = open == true

    if gCargameInviteOpen then
        if gCouponsOfferOpen then
            CloseCouponsModal(true)
        end

        SendNUIMessage({ action = COUPONS_CONFIG.NUI.ACTIONS.HIDE_FLOATING, data = {} })
        return
    end

    SetTimeout(0, function()
        if not IsCargameBlockingCoupons() and gCouponsReopenPayload then
            ResumeCouponsReopenWindow()
        end
    end)
end)

AddStateBagChangeHandler('minigame:active', nil, function(bagName, _, value)
    if bagName ~= ('player:%s'):format(GetPlayerServerId(PlayerId())) then
        return
    end

    if value == 'cargame' then
        SendNUIMessage({ action = COUPONS_CONFIG.NUI.ACTIONS.HIDE_FLOATING, data = {} })
    elseif not value and not gCargameInviteOpen and gCouponsReopenPayload then
        SetTimeout(0, ResumeCouponsReopenWindow)
    end
end)

RegisterCommand(_t(COUPONS_CONFIG.COMMANDS.PLAYER), OpenCouponsSystem, false)
RegisterCommand(COUPONS_CONFIG.REOPEN_POPUP.COMMAND, ReopenCouponsModal, false)
RegisterKeyMapping(
    COUPONS_CONFIG.REOPEN_POPUP.COMMAND,
    _t(COUPONS_CONFIG.REOPEN_POPUP.KEY_MAPPING),
    'keyboard',
    COUPONS_CONFIG.REOPEN_POPUP.REOPEN_KEY
)

RegisterNetEvent(COUPONS_CONFIG.EVENTS.SHOW, OpenAvailableCoupons)

RegisterNetEvent('playerGroups:RemoveGroup', function(group)
    if group == 'Iniciante' then
        StartFormerBeginnerCouponsOpen()
    end
end)

RegisterNetEvent('playerGroups:AddGroup', function(group)
    if group == 'Iniciante' then
        CancelFormerBeginnerCouponsOpen()
    end
end)

RegisterNetEvent(COUPONS_CONFIG.EVENTS.CLOSE, function()
    CloseCouponsModal(true)
    ClearCouponsReopenWindow()
end)

RegisterNetEvent(COUPONS_CONFIG.EVENTS.SHOW_NOTIFY, ShowCouponNotify)
RegisterNetEvent(COUPONS_CONFIG.EVENTS.HIDE_NOTIFY, HideCouponNotify)

RegisterNUICallback(COUPONS_CONFIG.NUI.CALLBACKS.CLOSE, function(_, callback)
    CloseCouponsModal(false)
    callback({ ok = true })

    CreateThread(function()

        Wait(0)

        ResumeCouponsReopenWindow()
    end)
end)

RegisterNUICallback(COUPONS_CONFIG.NUI.CALLBACKS.BANNER_CLICK, function(data, callback)
    RecordCouponInteraction(nil, COUPONS_CONFIG.INTERACTIONS.BANNER_CLICK, data)
    callback({ ok = true })
end)

RegisterNUICallback(COUPONS_CONFIG.NUI.CALLBACKS.STORE_OPEN, function(data, callback)
    RecordCouponInteraction(nil, COUPONS_CONFIG.INTERACTIONS.STORE_OPEN, data)
    callback({ ok = true })
end)

RegisterNUICallback(COUPONS_CONFIG.NUI.CALLBACKS.COPY, function(data, callback)
    callback(RecordCouponInteraction(data and data.id, COUPONS_CONFIG.INTERACTIONS.COPY, data))
end)

RegisterNUICallback(COUPONS_CONFIG.NUI.CALLBACKS.USE, function(data, callback)
    callback(RecordCouponInteraction(data and data.id, COUPONS_CONFIG.INTERACTIONS.USE_NOW, data))
end)

RegisterNUICallback('close', function()
    CloseCouponsModal(true)
    ClearCouponsReopenWindow()
end)

AddStateBagChangeHandler(COUPONS_CONFIG.GLOBAL_STATE.OFFERS, 'global', function(_, _, value)
    UpdateCouponsModal(value)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    CloseCouponsModal(false)
    CancelFormerBeginnerCouponsOpen()
    ClearCouponsReopenWindow()
end)
