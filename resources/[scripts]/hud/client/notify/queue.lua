------------------------------------------------
-- NOTIFY QUEUE
------------------------------------------------
notifyQueue = {}
activeNotifications = 0
MAX_NOTIFICATIONS = 5
------------------------------------------------
-- ANNOUNCE QUEUE
------------------------------------------------
announceQueue = {}
activeAnnouncements = 0
MAX_ANNOUNCEMENTS = 1
------------------------------------------------
-- SOCIALPARTY QUEUE
------------------------------------------------
socialpartyQueue = {}
activeSocialpartyInvites = 0
MAX_SOCIALPARTY_INVITES = 1
currentInviteTimeoutId = nil
processingInvite = false
inviteStartTime = 0
local partyInviteActive = nil
local DEFAULT_WORLD_BUCKET = 1
local ANNOUNCE_DEFAULT_WORLD_BYPASS = {
    adminNew = true,
    -- Aviso individual do Growth: o destino pode estar trabalhando em outro
    -- bucket e o delivery_system ja validou que o passaporte esta online.
    comercial = true,
}
local SOCIALPARTY_DEFAULT_WORLD_BYPASS_KIND = {
    [2] = true, -- /events: eSocialpartyKind.SocialeventWithCustomWorld
}
-- No Mundo Afiliado os bypasses acima nao valem: /adm, /festa e /events ficam ocultos.
-- O aviso comercial continua porque e individual, enviado ao passaporte pelo Growth.
local ANNOUNCE_AFFILIATE_WORLD_ALLOWED = {
    comercial = true,
}

local function IsInDefaultWorld()
    return tonumber( LocalPlayer.state.Route ) == DEFAULT_WORLD_BUCKET
end

local function IsInAffiliateWorld()
    return GetResourceState( 'new_hub' ) == 'started' and exports.new_hub:IsAffiliateWorldClientActive() == true
end

local function CanShowAnnouncementInCurrentWorld(css)
    if IsInAffiliateWorld() then
        return ANNOUNCE_AFFILIATE_WORLD_ALLOWED[css] == true
    end

    return ANNOUNCE_DEFAULT_WORLD_BYPASS[css] == true or IsInDefaultWorld()
end

local function CanShowSocialpartyInCurrentWorld(packet)
    if IsInAffiliateWorld() then
        return false
    end

    return SOCIALPARTY_DEFAULT_WORLD_BYPASS_KIND[packet and packet.kind] == true or IsInDefaultWorld()
end

local function IsInsidePenthouse()
    if GetResourceState('penthouse') ~= 'started' then
        return false
    end

    return exports['penthouse']:IsInsidePenthouse()
end

local function isCompetitiveMinigameActive()
    local activeMinigame = LocalPlayer["state"]["minigame:active"]
    return type( activeMinigame ) == 'string' and activeMinigame:find( 'Competitivo', 1, true ) ~= nil
end

gDeathStatueInviteOpen = false
gCargameInviteOpen = false
local gUnifiedQueueGeneration = 0
local gEventInviteQueueWaitScheduled = false
local gDominasProtectionUntil = 0
local gDominasOccupation = false

local function IsDominasProtected()
    return gDominasOccupation or GetGameTimer() < gDominasProtectionUntil
end
------------------------------------------------
-- UNIFIED QUEUE SYSTEM
------------------------------------------------
local unifiedQueue = {}
local isProcessingUnified = false
local unifiedQueueSequence = 0

local function CompleteUnifiedItem(generation, onComplete)
    return function()
        if generation ~= gUnifiedQueueGeneration then
            return
        end

        if onComplete then
            onComplete()
        end
    end
end

local function HideActiveUnifiedDisplay()
    processingInvite = false
    activeSocialpartyInvites = 0
    activeAnnouncements = 0
    partyInviteActive = nil

    if ClearToastRequestQueue then
        ClearToastRequestQueue()
    end

    TriggerEvent('toast.dismiss')
    SendNUIMessage({ action = "clearAllNotifications", data = {} })
end

local function HoldUnifiedQueueForEventInvite()
    gUnifiedQueueGeneration = gUnifiedQueueGeneration + 1
    isProcessingUnified = false
    HideActiveUnifiedDisplay()
end

RegisterNetEvent( 'hud:dominas:protection', function( seconds )
    if type( seconds ) ~= 'number' then return end
    local wasProtected = IsDominasProtected()
    gDominasProtectionUntil = GetGameTimer() + math.max( 0, math.min( seconds, 900 ) ) * 1000
    if not wasProtected and IsDominasProtected() then HoldUnifiedQueueForEventInvite() end
    ProcessUnifiedQueue()
end )

AddEventHandler( 'hud:dominas:occupation', function( occupied )
    local wasProtected = IsDominasProtected()
    gDominasOccupation = occupied == true
    if not wasProtected and IsDominasProtected() then HoldUnifiedQueueForEventInvite() end
    ProcessUnifiedQueue()
end )

-- ENG-3748: o convite F3 da Estatua Mortal/Colisao Cromatica nao passa pela fila; o resource consulta aqui.
exports( 'IsDominasProtected', IsDominasProtected )

-- ENG-3750: nos primeiros 15 min de jogo nenhum anuncio aparece (ADM, festa, evento, F3). Conta pelo
-- playtime total do new_hub (-1 antes da sessao comecar = ainda bloqueado), entao vale recrutado ou nao.
local NEWBIE_ANNOUNCE_BLOCK_SECONDS = 15 * 60

local function IsNewbieAnnounceBlocked()
    return ( exports.new_hub:GetPlaytimeSeconds() or -1 ) < NEWBIE_ANNOUNCE_BLOCK_SECONDS
end

exports( 'IsNewbieAnnounceBlocked', IsNewbieAnnounceBlocked )

local function AddToUnifiedQueue(itemType, data)
    unifiedQueueSequence = unifiedQueueSequence + 1
    table.insert(unifiedQueue, {
        type = itemType,
        data = data,
        sequence = unifiedQueueSequence,
        timestamp = GetGameTimer()
    })
    -- sx.logger:debug( ('Added %s to unified queue (sequence: %d, queue size: %d)'):format(itemType, unifiedQueueSequence, #unifiedQueue) )
    ProcessUnifiedQueue()
end

function ProcessUnifiedQueue()
    if isProcessingUnified then
        -- sx.logger:debug('Unified queue already processing, skipping')
        return
    end

    if #unifiedQueue == 0 then
        -- sx.logger:debug('Unified queue is empty')
        return
    end

    if gDeathStatueInviteOpen or gCargameInviteOpen or IsDominasProtected() then
        if not gEventInviteQueueWaitScheduled then
            gEventInviteQueueWaitScheduled = true
            SetTimeout(500, function()
                gEventInviteQueueWaitScheduled = false
                ProcessUnifiedQueue()
            end)
        end
        return
    end
    
    local item = unifiedQueue[1]
    local generation = gUnifiedQueueGeneration
    
    -- sx.logger:debug( ('Processing unified queue item: type=%s, sequence=%d'):format(item.type, item.sequence) )
    
    isProcessingUnified = true
    
    if item.type == 'announce' then
        ProcessSingleAnnounce(item.data, CompleteUnifiedItem(generation, function()
            table.remove(unifiedQueue, 1)
            isProcessingUnified = false
            ProcessUnifiedQueue()
        end))
    elseif item.type == 'socialparty' then
        ProcessSingleSocialparty(item.data, CompleteUnifiedItem(generation, function()
            table.remove(unifiedQueue, 1)
            isProcessingUnified = false
            ProcessUnifiedQueue()
        end))
    else
        sx.logger:error( ('Unknown unified queue item type: %s'):format(item.type) )
        table.remove(unifiedQueue, 1)
        isProcessingUnified = false
        ProcessUnifiedQueue()
    end
end

AddEventHandler('hud:deathstatueInviteOpen', function(open)
    local shouldOpen = open == true
    if shouldOpen == gDeathStatueInviteOpen then
        return
    end

    gDeathStatueInviteOpen = shouldOpen

    if gDeathStatueInviteOpen then
        HoldUnifiedQueueForEventInvite()
        return
    end

    ProcessUnifiedQueue()
end)

AddEventHandler('hud:cargameInviteOpen', function(open)
    local shouldOpen = open == true
    if shouldOpen == gCargameInviteOpen then
        return
    end

    gCargameInviteOpen = shouldOpen

    if gCargameInviteOpen then
        HoldUnifiedQueueForEventInvite()
        return
    end

    ProcessUnifiedQueue()
    SetTimeout(0, processNotifyQueue)
end)
------------------------------------------------

function HasActiveSocialpartyInvites()
    return activeSocialpartyInvites > 0 or processingInvite
end

function processNotifyQueue()
    if gCargameInviteOpen or #notifyQueue == 0 or activeNotifications >= MAX_NOTIFICATIONS then
        return
    end

    if isCompetitiveMinigameActive() then
        -- Só as marcadas com KeepInMinigame (ex.: farm do convite X1) passam pela tela do Competitivo.
        local kept = {}
        for _, queued in ipairs(notifyQueue) do
            if queued.KeepInMinigame then
                kept[#kept + 1] = queued
            end
        end
        notifyQueue = kept

        if #notifyQueue == 0 then
            return
        end
    end

    table.sort(notifyQueue, function(a, b)
        return (NotifyGroups[a.Css] or NotifyGroups["Warning"]) > (NotifyGroups[b.Css] or NotifyGroups["Warning"])
    end)

    local notification = table.remove(notifyQueue, 1)
    activeNotifications = activeNotifications + 1

    SendNUIMessage({ 
        action = "Notify", 
        data = notification 
    })

    SetTimeout(tonumber(notification.Timer) or 5000, function()
        activeNotifications = activeNotifications - 1
        processNotifyQueue()
    end)
end

function queueNotification(data)
    if not NotifyGroups[data.Css] then
        data.Css = "Warning"
    end

    table.insert(notifyQueue, data)
    processNotifyQueue()
end

function ProcessSingleAnnounce(announcement, onComplete, generation)
    generation = generation or gUnifiedQueueGeneration
    if generation ~= gUnifiedQueueGeneration then return end
    if gDeathStatueInviteOpen or gCargameInviteOpen or IsDominasProtected() then
        SetTimeout(500, function()
            ProcessSingleAnnounce(announcement, onComplete, generation)
        end)
        return
    end

    if not CanShowAnnouncementInCurrentWorld( announcement.Css ) then
        if onComplete then
            onComplete()
        end

        return
    end

    if HasNonDefaultRequests() then
        SetTimeout(500, function()
            ProcessSingleAnnounce(announcement, onComplete, generation)
        end)
        return
    end

    if activeAnnouncements >= MAX_ANNOUNCEMENTS then
        SetTimeout(500, function()
            ProcessSingleAnnounce(announcement, onComplete, generation)
        end)
        return
    end

    activeAnnouncements = activeAnnouncements + 1
    -- sx.logger:debug( ('Displaying announce: %s'):format(announcement.Title or 'untitled') )

    SendNUIMessage({ 
        action = "Announce", 
        data = announcement 
    })

    if announcement.Sound then
        TriggerEvent("sounds:Private", announcement.Sound, announcement.Volume)
    end

    SetTimeout(tonumber(announcement.Timer) or 5000, function()
        if generation ~= gUnifiedQueueGeneration then return end
        activeAnnouncements = math.max( 0, activeAnnouncements - 1 )
        -- sx.logger:debug('Announce completed')
        if onComplete then
            onComplete()
        end
    end)
end

function queueAnnouncement(data)
    if not CanShowAnnouncementInCurrentWorld( data.Css ) then
        return
    end

    if not AnnounceGroups[data.Css] then
        data.Css = "admin"
    end

    AddToUnifiedQueue('announce', data)
end

function clearAnnouncements()
    announceQueue = {}
    activeAnnouncements = 0
    
    for i = #unifiedQueue, 1, -1 do
        if unifiedQueue[i].type == 'announce' then
            table.remove(unifiedQueue, i)
        end
    end

    SendNUIMessage({ action = "clearAllNotifications", data = {}})
end

function clearSocialpartyInvites()
    socialpartyQueue = {}
    activeSocialpartyInvites = 0
    processingInvite = false
    partyInviteActive = nil
    
    for i = #unifiedQueue, 1, -1 do
        if unifiedQueue[i].type == 'socialparty' then
            table.remove(unifiedQueue, i)
        end
    end
    
    TriggerEvent('toast.dismiss')
end

RegisterNetEvent("Notify2")
AddEventHandler("Notify2",function(...)
    local notifyKey = ...
    if notifyKey == "#rescueVeicVip" and LocalPlayer["state"]["minigame:active"] then
        return
    end

    if isCompetitiveMinigameActive() then
        return
    end

    SendNUIMessage({ action = "ToggleNotify", data = { toggle = true} })
    Wait(100)
    if not Notify then
        return
    end

    if LocalPlayer["state"]["Creating"] then
        return
    end
    
    if LocalPlayer["state"]["inKart"] or LocalPlayer["state"]["hud2"] or LocalPlayer["state"]["hud3"] or LocalPlayer["state"]["hud4"] then
        return
    end

    local Notify,Variables = ...
    local Config = _n(Notify,Variables, lang)
    if Config then
        queueNotification({
            Css = Config["Css"],
            Message = Config["Message"],
            Timer = Config["Timer"] or 5000,
            Title = Config["Title"]
        })
    end
end)

AddStateBagChangeHandler("minigame:active", nil, function(bagName, _, value)
    if bagName ~= ("player:%s"):format(GetPlayerServerId(PlayerId())) then
        return
    end

    if not value then
        return
    end

    notifyQueue = {}
    SendNUIMessage({ action = "clearAllNotifications", data = {} })
end)

RegisterNetEvent("net.hud.clear.announcements", function()
    clearAnnouncements()
    clearSocialpartyInvites()
    
    unifiedQueue = {}
    isProcessingUnified = false
    
    -- sx.logger:debug('All announcements and invites cleared, unified queue reset')
end)

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(Css,Message,Timer,Title,KeepInMinigame)
    KeepInMinigame = KeepInMinigame == true

    if isCompetitiveMinigameActive() and not KeepInMinigame then
        return
    end

    if LocalPlayer["state"]["hud2"] or LocalPlayer["state"]["hud3"] or LocalPlayer["state"]["hud4"] then
        return
    end

    if not Notify then
        return
    end

    if LocalPlayer["state"]["Creating"] then
        return
    end

    if (LocalPlayer["state"]["PVP"] and not KeepInMinigame) or LocalPlayer["state"]["inKart"] then
        return
    end

    if string.find(Message, "suspeito") then
        local userId, reason = string.match(Message, "Usuário <b>(%d+)</b> foi marcado como suspeito%. %[<b>(.-)</b>%].*<br>")
        if userId and reason then
            local fullMessage = string.format(_t("suspicious_user_pattern"), userId, reason)
            if Message:find("Confira o Discord!") then
                fullMessage = fullMessage .. "<br>" .. _t("check_discord")
            end
            queueNotification({
                Css = "AntiCheat",
                Message = fullMessage,
                Title = _t("suspicious_user_title"),
                Timer = 15000
            })
            return
        end
    end

    if string.find(Message, "banido pelo anticheat") then
        local userId, reason = string.match(Message, "Usuário <b>(%d+)</b> banido pelo anticheat%. %[<b>(.-)</b>%]")
        if userId and reason then
            queueNotification({
                Css = "AntiCheat",
                Message = string.format(_t("banned_user_pattern"), userId, reason),
                Title = _t("banned_user_title"),
                Timer = 15000
            })
            return
        end
    end

    queueNotification({
        Css = NotifyGroups[Css] and Css or "Warning",
        Message = Message,
        Timer = Timer or 5000,
        Title = Title,
        KeepInMinigame = KeepInMinigame or nil
    })
end)

RegisterNetEvent("notify-premium-users")
---@param data NotifyPremiumUsersProps
AddEventHandler("notify-premium-users",function(data)
    if isCompetitiveMinigameActive() then
        return
    end

    if LocalPlayer["state"]["hud2"] or LocalPlayer["state"]["hud3"] or LocalPlayer["state"]["hud4"] then
        return
    end

    if not Notify then
        return
    end

    if LocalPlayer["state"]["Creating"] then
        return
    end

    if LocalPlayer["state"]["PVP"] or LocalPlayer["state"]["inKart"] then
        return
    end

    SendNUIMessage({ action = "Notify", data = data })
end)

RegisterCommand("testnotifyqueue", function()
    -- sx.logger:debug("testnotifyqueue")
    local testMessages = {
        { css = "Administration", msg = "Teste Notificação de Admin" },
        { css = "Warning", msg = "Teste Notificação de Aviso" },
        { css = "Information", msg = "Teste Notificação de Informação" },
        { css = "Hospital", msg = "Teste Notificação de Hospital" },
        { css = "Mechanic", msg = "Teste Notificação de Mecânico" },
        { css = "Attention", msg = "Teste Notificação de Atenção" },
        { css = "Payment", msg = "Teste Notificação de Pagamento" },
        { css = "Hospital", msg = "Teste Notificação de Hospital" },
        { css = "Mechanic", msg = "Teste Notificação de Mecânico" },
        { css = "Attention", msg = "Teste Notificação de Atenção" },
        { css = "Payment", msg = "Teste Notificação de Pagamento" },
        { css = "Administration", msg = "Teste Notificação de Admin" },
    
    }

    for _, notify in ipairs(testMessages) do
        queueNotification({
            Css = notify.css,
            Message = notify.msg,
            Timer = math.random(5000, 15000),
            Title = "Test Notification"
        })
    end
end)

RegisterNetEvent("Announce")
AddEventHandler("Announce",function(Css,Message,Timer,Title,Sound,Volume)
    if not CanShowAnnouncementInCurrentWorld( Css ) then
        return
    end

    if LocalPlayer["state"]["inKart"] then
        return
    end

    if LocalPlayer["state"]["hud2"] or LocalPlayer["state"]["hud3"] or LocalPlayer["state"]["hud4"] then
        return
    end

    if LocalPlayer["state"]["Route"] == 20 then
        return
    end

    if not Notify then
        return
    end
    
    if LocalPlayer["state"]["Creating"] then
        return
    end

    if IsNewbieAnnounceBlocked() then
        return
    end

    if AnnounceWithoutQueue[Css] and not gDeathStatueInviteOpen and not gCargameInviteOpen and not IsDominasProtected() then
        SendNUIMessage({ 
            action = "Announce", 
            data = {
                Css = Css,
                Message = Message,
                Timer = Timer or 5000,
                Title = Title,
                Sound = Sound,
                Volume = Volume
            } 
        })
        return
    end

    local Messages = Message:gsub("[<>]","")
    queueAnnouncement({
        Css = AnnounceGroups[Css] and Css or "admin",
        Message = Messages,
        Timer = Timer or 5000,
        Title = Title,
        Sound = Sound,
        Volume = Volume
    })
end)

function GetActiveAnnouncements()
    local active = {}
    
    for i = 1, activeAnnouncements do
        table.insert(active, {
            status = "active",
            timeLeft = "currently displaying"
        })
    end
    
    local totalTime = 0
    for i, announcement in ipairs(announceQueue) do
        totalTime = totalTime + (announcement.Timer or 5000)
        table.insert(active, {
            status = "queued",
            timeLeft = totalTime
        })
    end
    
    return active
end

function HasActiveAnnouncements()
    return activeAnnouncements > 0
end


RegisterCommand("testacnotify",function()
    TriggerEvent("Notify","vermelho","Usuário <b>123456</b> banido pelo anticheat. [<b>MENU</b>]",60000)
end)

---@enum eSocialpartyKind
eSocialpartyKind =
{
    Socialparty = 0,
    SocialpartyWithCustomWorld = 1,

    SocialeventWithCustomWorld = 2,
}

---@class socialparty.InviteSettings
---@field title
---@field subtitlePrefix
---@field bgColor? string -- RGBA

---@type table<eSocialpartyKind, socialparty.InviteSettings>
SOCIALPARTY_KIND_INVITE_SETTINGS =
{
    [ eSocialpartyKind.Socialparty                ] = { title = _t("partyTitle"), subtitlePrefix = _t("partyPrefix")     , bgColor = 'rgba(203, 96, 196, 0.8)' },
    [ eSocialpartyKind.SocialpartyWithCustomWorld ] = { title = _t("partyTitle"), subtitlePrefix = _t("partyPrefix")     , bgColor = 'rgba(203, 96, 196, 0.8)' },

    [ eSocialpartyKind.SocialeventWithCustomWorld ] = { title = _t("eventTitle"), subtitlePrefix = _t("eventPrefix")     , bgColor = 'rgba(237, 201, 33, 0.8)' },
}

---@param packet socialparty.InviteReceivedPacket | nil
---@return boolean
local function CanAcceptSocialpartyInvite(packet)
    if LocalPlayer["state"]["minigame:active"] then
        return false
    end

    if not CanShowSocialpartyInCurrentWorld(packet) then
        return false
    end

    if LocalPlayer[ 'state' ][ 'inKart' ] then
        return false
    end

    if LocalPlayer["state"]["Creating"] then
        return false
    end

    if LocalPlayer[ 'state' ][ 'hud2' ] or LocalPlayer[ 'state' ][ 'hud3' ] or LocalPlayer[ 'state' ][ 'hud4' ] then
        return false
    end
    
    if LocalPlayer[ 'state' ][ 'Handcuff' ] or LocalPlayer[ 'state' ][ 'HandcuffCarry' ] then
        return false
    end

    return true
end

---@type table<eSocialpartyKind, fun( invite: socialparty.InviteReceivedPacket ): nil>
SOCIALPARTY_KIND_INVITE_ACCEPTED_HANDLER =
{
    [ eSocialpartyKind.Socialparty ] = function ( invite )

        local position = invite.position

        local Ped = PlayerPedId()

        SetNewWaypoint( position.x, position.y )

        SetEntityCoords( Ped, position.x, position.y, position.z - 1,false,false,false,false)

        RequestCollisionAtCoord( position.x, position.y, position.z )

        -- TODO: Esses blips poderiam ser mais genericos?
        local blipId = AddBlipForCoord( invite.position.x, invite.position.y, invite.position.z )
        SetBlipSprite(blipId, 136)
        SetBlipColour(blipId, 2)
        SetBlipScale(blipId, 0.6)
        SetBlipAsShortRange(blipId, true)
        BeginTextCommandSetBlipName("STRING" )
        AddTextComponentString( 'Festinha' )
        EndTextCommandSetBlipName( blipId )

        -- TODO: Fazer isso mais genérico?
        SetTimeout( 30000, function()
            RemoveBlip( blipId )
        end)

        FreezeEntityPosition( Ped, true )

        while not HasCollisionLoadedAroundEntity( Ped ) do
            Wait( 0 )
        end

        DoScreenFadeIn(5000)

        while not IsScreenFadedIn() do
            Wait( 0 )
        end

        FreezeEntityPosition(Ped,false)
    end,

    [ eSocialpartyKind.SocialpartyWithCustomWorld ] = function ( invite )

        -- Fazer as mesmas coisas que o evento One faz...
        SOCIALPARTY_KIND_INVITE_ACCEPTED_HANDLER[ eSocialpartyKind.Socialparty ]( invite )

        ExecuteCommand( 'mundo Evento socialparty' )
    end,

    [ eSocialpartyKind.SocialeventWithCustomWorld ] = function( invite )

        -- Fazer as mesmas coisas que o evento SocialpartyWithCustomWorld faz.
        SOCIALPARTY_KIND_INVITE_ACCEPTED_HANDLER[ eSocialpartyKind.SocialpartyWithCustomWorld ]( invite )
    end,
}

function ProcessSingleSocialparty(inviteData, onComplete, generation)
    generation = generation or gUnifiedQueueGeneration
    if generation ~= gUnifiedQueueGeneration then return end
    if gDeathStatueInviteOpen or gCargameInviteOpen or IsDominasProtected() then
        SetTimeout(500, function()
            ProcessSingleSocialparty(inviteData, onComplete, generation)
        end)
        return
    end

    if not CanShowSocialpartyInCurrentWorld(inviteData and inviteData.packet) then
        if onComplete then
            onComplete()
        end

        return
    end

    if not CanAcceptSocialpartyInvite(inviteData and inviteData.packet) then
        if onComplete then
            onComplete()
        end

        return
    end

    if activeSocialpartyInvites >= MAX_SOCIALPARTY_INVITES then
        SetTimeout(500, function()
            ProcessSingleSocialparty(inviteData, onComplete, generation)
        end)
        return
    end

    local invite = inviteData
    -- sx.logger:debug( ('[socialparty] processing invite: %s'):format(invite.packet.id) )

    activeSocialpartyInvites = activeSocialpartyInvites + 1
    processingInvite = true
    local inviteAccepted = false

    TriggerEvent('sounds:Private', 'recrutamento', 0.09)

    local settings = SOCIALPARTY_KIND_INVITE_SETTINGS[invite.packet.kind] or {}
    local createdBy = invite.packet.createdBy or 'Desconhecido'
    local title = settings.title or 'Desconhecido'
    local subtitle    = (settings.subtitlePrefix or 'Desconhecido Prefix') .. ' (' .. createdBy ..')'
    local bgColor = settings.bgColor or 'rgba(0, 0, 0, 0.5)'
    local changesBucket = invite.packet.kind == eSocialpartyKind.SocialpartyWithCustomWorld or invite.packet.kind == eSocialpartyKind.SocialeventWithCustomWorld
    local requestId = TriggerEvent('request.start', invite.packet.body, {
        title = title,
        subtitle = subtitle,
        bgColor  = bgColor,

        canAccept = function()
            if generation ~= gUnifiedQueueGeneration or IsDominasProtected() then return false end
            if IsInsidePenthouse() and not changesBucket then
                TriggerEvent("Notify2", "#leaveHouseToAcceptPartyInvite")
                return false
            end

            return true
        end,

        onAccepted = function(source)
            if generation ~= gUnifiedQueueGeneration or IsDominasProtected() then return end
            -- sx.logger:debug( ('[socialparty] onAccepted for invite: %s, body: %s'):format(invite.packet.id, invite.packet.body) )

            if not exports.admin:SafeguardAccountHasDiscordAccountLink() then
                return
            end

            if not CanAcceptSocialpartyInvite(invite.packet) then
                -- sx.logger:debug('[socialparty] blocked by CanAcceptSocialpartyInvite()')
                return
            end

            if exports.combatsystem:IsInCombat( { showHint = true } ) then
                -- is combat active ?
                return
            end

            inviteAccepted          = true
            processingInvite        = false
            activeSocialpartyInvites = math.max(0, activeSocialpartyInvites - 1)

            TriggerEvent('survey:set-kvp', 'already_entered_socialparty:'..LocalPlayer["state"]["Passport"], true)
            TriggerServerEvent("missions:server:showProductionCompleted")
            -- echo the server-assigned party id back; the socialparty server validates it before awarding XP
            TriggerServerEvent("socialparty:accepted", invite.packet.socialpartyId)

            local handler = assert(SOCIALPARTY_KIND_INVITE_ACCEPTED_HANDLER[invite.packet.kind])
            Citizen.CreateThreadNow(function()
                local success, err = pcall(function()
                    handler(invite.packet)
                end)
                
                if not success then
                    sx.logger:error( ('[socialparty] Error in handler: %s'):format(err) )
                end
                
                -- sx.logger:debug('[socialparty] invite completed (accepted)')
                if onComplete then
                    onComplete()
                end
            end)
        end,
        
        onDismissed = function()
            if generation ~= gUnifiedQueueGeneration then return end
            -- sx.logger:debug( ('[socialparty] invite dismissed: %s'):format(invite.packet.id) )
            processingInvite = false
            activeSocialpartyInvites = math.max(0, activeSocialpartyInvites - 1)
            -- sx.logger:debug('[socialparty] invite completed (dismissed)')
            if onComplete then
                onComplete()
            end
        end
    }, 60, 'toast')
    partyInviteActive = requestId
    

    Citizen.CreateThreadNow(function()
        local startTime = GetGameTimer()
        local TIMEOUT_MS = 61000

        while generation == gUnifiedQueueGeneration and processingInvite and (GetGameTimer() - startTime) < TIMEOUT_MS do
            Wait(0)
        end

        if generation ~= gUnifiedQueueGeneration then return end

        if not inviteAccepted then
            -- sx.logger:debug( ('[socialparty] invite timed out: %s'):format(invite.packet.id) )
            TriggerEvent('toast.dismiss')
            processingInvite = false
            activeSocialpartyInvites = math.max(0, activeSocialpartyInvites - 1)
            
            -- Remove the active request if it exists
            if partyInviteActive then
                local request = GetRequestExt(partyInviteActive)
                if request then
                    RemoveRequestFromQueue(request)
                end
                partyInviteActive = nil
            end
            
            -- sx.logger:debug('[socialparty] invite completed (timeout)')
            if onComplete then
                onComplete()
            end
        end
    end)
end

---@param packet socialparty.InviteReceivedPacket
local function OnSocialpartyInviteReceived(packet)
    if IsNewbieAnnounceBlocked() then
        return
    end

    if not CanShowSocialpartyInCurrentWorld(packet) then
        return
    end

    if LocalPlayer["state"]["minigame:active"] then
        return
    end

    -- sx.logger:debug('OnSocialpartyInviteReceived')
    if not CanAcceptSocialpartyInvite(packet) then
        -- sx.logger:debug('Not CanAcceptSocialpartyInvite')
        return
    end
    
    AddToUnifiedQueue('socialparty', {packet = packet})
end

RegisterNetEvent( 'socialparty.invite_received', OnSocialpartyInviteReceived )

RegisterNetEvent("toast.dismiss", function()
    processingInvite = false
end)

RegisterNetEvent( 'net:routing_bucket_changed', function( bucket )
    if tonumber( bucket ) == DEFAULT_WORLD_BUCKET then
        return
    end

    -- ENG-3724: a partida do convite X1 troca o bucket; na proteção a fila sai depois.
    if IsDominasProtected() then
        return
    end

    clearAnnouncements()
    clearSocialpartyInvites()
end)
