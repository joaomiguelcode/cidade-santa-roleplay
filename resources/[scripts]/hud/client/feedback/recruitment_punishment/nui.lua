-- Cards de punição por recrutamento (ENG-3352). Módulo próprio, com evento NUI dedicado em vez
-- do `feedback:show` do aviso de qualidade. A tecla de AÇÃO (M) é compartilhada com aquele aviso
-- via `FeedbackActionKey`; a de OCULTAR (U) é exclusiva daqui e só age no card de Bloqueada.
---@class FeedbackRecruitmentPunishmentClientApi
FeedbackRecruitmentPunishmentClient = {}

---@class RecruitmentPunishmentShowPayload
---@field pendingCard integer -- 1 Risco | 2 Último aviso | 4 Suspenso | 5 Liberada
---@field remainingSeconds number? -- só quando pendingCard == 4

local TOGGLE_KEY = "U"

local CARD_BY_PENDING = { [1] = "risk", [2] = "last_warning", [4] = "blocked", [5] = "released" }

local SOUND_BY_CARD = {
    risk = QUALITY_FEEDBACK_CONFIG.sounds.negative,
    last_warning = QUALITY_FEEDBACK_CONFIG.sounds.negative,
    blocked = QUALITY_FEEDBACK_CONFIG.sounds.negative,
    released = QUALITY_FEEDBACK_CONFIG.sounds.positive,
}

-- `anchorMs` ancora o relógio: sem descontar o decorrido, o toggle do U rebobinaria a contagem.
---@type { cardType: string, title: string, description: string[], actionKey: string?, actionLabel: string?, remainingSeconds: number?, remainingLabel: string?, anchorMs: number? }?
local currentCard = nil

local cardHidden = false
local gToxicityVisible = false

-- Cada card reivindica uma função diferente; um `Release` fixo apagaria a de outro card.
local currentActionHandler = nil

---@param handler fun()?
---@return nil
local function ClaimAction( handler )
    currentActionHandler = handler
    if handler then
        FeedbackActionKey.Claim( handler )
    end
end

---@return nil
local function ReleaseAction()
    if currentActionHandler then
        FeedbackActionKey.Release( currentActionHandler )
        currentActionHandler = nil
    end
end

---@return nil
local function OpenPunishmentModal()
    if not currentCard or gToxicityVisible then
        return
    end

    -- Risco/Último aviso não têm suspensão ainda, logo não há prazo pra mandar.
    RecruitmentPunishmentModalClient.Open( currentCard.cardType, nil )
end

---@return nil
local function OpenRankingAndDismiss()
    if gToxicityVisible then return end
    TriggerEvent( "hub:OpenRanking", { category = "personal", openSaiba = true, openDailyBreakdown = false } )
    TriggerServerEvent( "recruitment_punishment:acknowledge" )
end

local ACTION_BY_CARD = {
    risk = OpenPunishmentModal,
    last_warning = OpenPunishmentModal,
    -- blocked: sem entrada de propósito -- o servidor abre o modal sozinho.
    released = OpenRankingAndDismiss,
}

---@return nil
local function SendCard()
    if gToxicityVisible then
        SendNUIMessage( { action = 'punishmentCard:hide' } )
        return
    end
    if not currentCard then
        return
    end

    local collapsible = currentCard.cardType == "blocked"

    local remainingSeconds = currentCard.remainingSeconds
    if remainingSeconds and currentCard.anchorMs then
        local elapsed = ( GetGameTimer() - currentCard.anchorMs ) / 1000
        remainingSeconds = math.max( 0, math.floor( remainingSeconds - elapsed ) )
    end

    SendNUIMessage( {
        action = "punishmentCard:show",
        data = {
            visible = true,
            type = currentCard.cardType,
            title = currentCard.title,
            description = currentCard.description,
            actionKey = currentCard.actionKey,
            actionLabel = currentCard.actionLabel,
            remainingSeconds = remainingSeconds,
            remainingLabel = currentCard.remainingLabel,
            collapsible = collapsible,
            collapsed = collapsible and cardHidden or false,
            toggleKey = collapsible and TOGGLE_KEY or nil,
        },
    } )
end

---@param payload RecruitmentPunishmentShowPayload
---@return nil
local function OnShow( payload )
    local cardType = CARD_BY_PENDING[ tonumber( payload and payload.pendingCard ) ]
    local card = cardType and RECRUITMENT_PUNISHMENT_TEXTS[ cardType ]

    if not card then
        -- sx.logger:warn( ( "hud recruitment punishment card ignored pending_card=%s" ):format(
            -- tostring( payload and payload.pendingCard ) ) )
        return
    end

    local isBlocked = cardType == "blocked"

    -- No Bloqueada a `line2` sai: repetiria, congelado, o tempo que o relógio já mostra vivo.
    local description = isBlocked and { card.line1, card.line3 }
        or { card.line1, card.line2, card.line3 }

    -- Prioridade ANTES do card: invertido, o `SetPriority` apagaria o card recém-aberto.
    ClaimAction( ACTION_BY_CARD[ cardType ] )
    FeedbackClient.SetPriority( "recruitmentPunishment", true )
    -- O `SetPriority` só cala o aviso de qualidade. As missões vivem no mesmo canto da tela e
    -- não escutam aquele mecanismo, então precisam do próprio aviso -- mesmo padrão do
    -- `hud:AffiliateWorldShortcutsVisibilityChanged`.
    TriggerEvent( "hud:punishmentCard:priorityChanged", true )

    cardHidden = false
    currentCard = {
        cardType = cardType,
        title = card.title,
        description = description,
        actionKey = card.actionLabel and "M" or nil,
        actionLabel = card.actionLabel,
        remainingSeconds = isBlocked and tonumber( payload.remainingSeconds ) or nil,
        remainingLabel = isBlocked and card.clockLabel or nil,
        anchorMs = isBlocked and GetGameTimer() or nil,
    }
    SendCard()

    local sound = SOUND_BY_CARD[ cardType ]
    if sound then
        TriggerEvent( "sounds:Private", sound.url, sound.volume )
    end
end

---@return nil
local function OnHide()
    -- Ordem inversa do OnShow: liberar a prioridade antes deixaria o aviso de qualidade voltar
    -- e ser apagado pelo nosso hide.
    SendNUIMessage( { action = "punishmentCard:hide" } )
    ReleaseAction()
    FeedbackClient.SetPriority( "recruitmentPunishment", false )
    TriggerEvent( "hud:punishmentCard:priorityChanged", false )
    currentCard = nil
    cardHidden = false
end

-- RF-39: tentar recrutar tira o card do oculto, sem abrir modal. Vem do `painel`.
---@return nil
local function ForceShow()
    if not currentCard or not cardHidden then
        return
    end

    cardHidden = false
    SendCard()
end

---@return nil
function FeedbackRecruitmentPunishmentClient.Register()
    AddEventHandler( 'hud:toxicity:priorityChanged', function( visible )
        gToxicityVisible = visible == true
        SendCard()
    end )
    RegisterNetEvent( "hud:recruitmentPunishment:show", OnShow )
    RegisterNetEvent( "hud:recruitmentPunishment:hide", OnHide )
    RegisterNetEvent( "hud:punishmentCard:forceShow", ForceShow )

    -- Fora do `FeedbackActionKey`, que arbitra só o M. Só o Bloqueada é ocultável.
    RegisterCommand( "+hud_punishment_card_toggle", function()
        if gToxicityVisible or not currentCard or currentCard.cardType ~= "blocked" then
            return
        end

        cardHidden = not cardHidden
        SendCard()
    end, false )
    RegisterCommand( "-hud_punishment_card_toggle", function() end, false )
    RegisterKeyMapping( "+hud_punishment_card_toggle", _t( "hud.keymap.punishment_card_toggle" ), "keyboard", "U" )
end

