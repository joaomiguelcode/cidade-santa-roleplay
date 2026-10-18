
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface("dashboard",Client)
vSERVER = Tunnel.getInterface("dashboard")
cityName = GetConvar("cityName", "")
PlayerData = {}


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------

local function DashboardPlayerSession( session )
    if not session then return nil end
    return {
        accessToken = session.accessToken,
        expiresAt = session.expiresAt,
        user = session.user,
    }
end

local function SendDashboardPlayerSession( session )

    sx.logger:debug( ('Forwarding dashboard player session authenticated=%s'):format(
        tostring( session ~= nil ) ) )

    SendNUIMessage({
        action = 'setPlayerSession',
        data = DashboardPlayerSession( session ) or json.null,
    })
end

RegisterNetEvent( 'net.sx.setPlayerSession', function( session )

    SendDashboardPlayerSession( session )
end )

RegisterNetEvent( 'net.sx.clearPlayerSession', function()

    SendDashboardPlayerSession( nil )
end )

AddEventHandler( 'dashboard:factionFocus', function( message )
    if type( message ) ~= 'table' or type( message.action ) ~= 'string' then
        return
    end

    SendNUIMessage( message )
end )

RegisterNUICallback( 'factionFocus:hide', function( _, callback )
    TriggerEvent( 'hud:factionFocus:hide' )
    callback( { ok = true } )
end )

RegisterNUICallback( 'factionFocus:viewRanking', function( _, callback )
    callback( { ok = true } )
end )

RegisterNUICallback( 'factionFocusLeadership:getState', function( _, callback )
    callback( GetResourceState( 'hud' ) == 'started' and exports.hud:GetFactionFocusLeadershipState() or { } )
end )

RegisterNUICallback( 'factionFocusStaff:getState', function( _, callback )
    callback( GetResourceState( 'hud' ) == 'started' and exports.hud:GetFactionFocusStaffState() or { } )
end )

RegisterNUICallback( 'factionFocusStaff:hide', function( _, callback )
    TriggerEvent( 'hud:factionFocusStaff:hide' )
    callback({ ok = true })
end )

RegisterNUICallback( 'factionFocusStaff:markLocation', function( _, callback )
    TriggerEvent( 'hud:factionFocusStaff:markLocation' )
    callback({ ok = true })
end )

RegisterNUICallback( 'factionFocusLeadership:hide', function( _, callback )
    TriggerEvent( 'hud:factionFocusLeadership:hide' )
    callback({ ok = true })
end )

AddEventHandler( 'dashboard:factionFocus:ranking', function()
    local state = GetResourceState( 'hud' ) == 'started' and exports.hud:GetFactionFocusLeadershipState()
    if not state or not state.data then return end
    TriggerEvent( 'hub:OpenRanking', { category = 'organization' } )
end )

RegisterNUICallback( 'factionFocusLeadership:viewRanking', function( _, callback )
    TriggerEvent( 'dashboard:factionFocus:ranking' )
    callback({ ok = true })
end )

-- ENG-3962: NUI azul "Legal em Foco" do líder da org legal, mesmo componente com prefixo próprio.
RegisterNUICallback( 'legalFocusLeadership:getState', function( _, callback )
    callback( GetResourceState( 'hud' ) == 'started' and exports.hud:GetLegalFocusLeadershipState() or { } )
end )

RegisterNUICallback( 'legalFocusLeadership:hide', function( _, callback )
    TriggerEvent( 'hud:legalFocusLeadership:hide' )
    callback({ ok = true })
end )

RegisterNUICallback( 'legalFocusLeadership:viewRanking', function( _, callback )
    if GetResourceState( 'hud' ) == 'started' then exports.hud:HandleLegalFocusLeadershipKey( 'Q' ) end
    callback({ ok = true })
end )

RegisterNUICallback( 'getPlayerSession', function( _, callback )

    local resourceName = LIB_RESOURCE_NAME or 'sx'
    local ok, session = pcall( function()
        return exports[ resourceName ]:GetPlayerAuthTokenInfo()
    end )

    if not ok then
        sx.logger:warn( 'Dashboard NUI failed to read the current player session' )
    end

    sx.logger:debug( ('Dashboard NUI requested current player session available=%s'):format(
        tostring( ok and session ~= nil ) ) )

    callback( ok and DashboardPlayerSession( session ) or json.null )
end )

RegisterNUICallback( 'requestPlayerSession', function( _, callback )

    sx.logger:debug( 'Dashboard NUI requested a player session refresh' )
    TriggerServerEvent( 'net.sx.requestPlayerToken', true )
    callback({ ok = true })
end )

RegisterNUICallback( 'revokePlayerSession', function( _, callback )

    sx.logger:info( 'Dashboard NUI requested player session revocation' )
    TriggerServerEvent( 'net.sx.revokePlayerSession' )
    callback({ ok = true })
end )

RegisterNetEvent("dasboards:open", function(userPermissions, userInfos)
    print("dasboards:open", json.encode(userPermissions, {indent = true}))
    SetNuiFocus(true, true)
    local data = {
        visible                = true,
        cityId         = cityName or "",
        userPermissions        = userPermissions or {},
        userInfos              = {
            passport  = userInfos.passport or 0,
            name       = userInfos.name   or "",
            role       = userInfos.role   or "",
            avatar     = userInfos.avatar or ""
        }
    }
    Debug.print("dashboards:open:".. json.encode(data, {indent = true}))
    SendNUIMessage({
        action = "setVisible",
        data = data
    })
end)

RegisterNuiCallback('closeNui', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "setVisible",
        data = {
            visible = false,
        }
    })
    TriggerServerEvent("dashboard:closeNui")
    cb(true)
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    Callback(string.lower(cityName or ""))
end)

RegisterNUICallback("getCityId",function(Data,Callback)
    Callback(cityName or "")
end)

RegisterNUICallback('suspectClips:getStatus', function(_, callback)
    callback(vSERVER.GetSuspectClipStatus())
end)

RegisterNUICallback('getServerHost', function(Data, Callback)
    local api_url = GetConvar("api_url", "")
    if api_url == "" then
        local santagroupCities = {
            CidadeNobre = true, Maresia = true, Grande = true,
            Universo    = true, Alexandria = true, Santa = true,
        }
        api_url = santagroupCities[cityName] and "api.roleplayrp.com" or "apikng.roleplayrp.com"
    end
    Callback(api_url)
end)

RegisterCommand('ticket', function()
    TriggerServerEvent("dashboard:createTicket", "admin", "teste", "ticket")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("handleSpectate", function(data, cb)
    local Passport = data.user_id
    local score    =  data.score
    print(json.encode(data, {indent = true}))
    if score and score > 0 then
        TriggerServerEvent("dashboard:handleSpectate", Passport, score)
    else
        TriggerServerEvent("dashboard:handleSpectate", Passport)
    end
    cb(true)
end)

RegisterNUICallback("handleSpectateAll", function(data, cb)
    local score    =  data.group
    print(json.encode(data, {indent = true}))
    ExecuteCommand("specg " .. score)
    cb(true)
end)

RegisterNUICallback("handleTeleport", function(data, cb)
    local Passport = data.user_id
    TriggerServerEvent("dashboard:handleTeleport", Passport)
    cb(true)
end)

-- Remover da WallStreet (tela de Retencao). Diferente das callbacks acima, esta
-- NAO e fire-and-forget: e uma acao destrutiva, entao a tela precisa saber o
-- que de fato saiu. Por isso vai pelo Tunnel (vSERVER), que devolve resposta,
-- em vez de TriggerServerEvent. Quem autoriza e quem remove e o servidor --
-- o `passport` daqui e so o ALVO, nunca quem esta removendo.
RegisterNUICallback("wallstreet:remove", function(data, cb)
    local result = vSERVER.RemoveWallStreetGroups(data.passport)
    cb(result or { ok = false, error = "no_response", removed = {} })
end)


RegisterNUICallback("purchase:attend", function(data, cb)
    print("purchase:attend: " .. json.encode(data, {indent = true}))
    local userId = data.passport-- Id do usuário
    local timestamp = data.dateTimestamp -- Timestamp da ultima compra
    local status = data.status -- 'cancel' | 'attend'
    TriggerServerEvent("dashboard:handleTeleport", userId)
    cb(true)
end)
 
RegisterNuiCallback('call:getHome', function(data, cb)
    cb({
        title = _t('welcome_to_help_tool'),
        description = {
            _t('help_tool_description'),
            _t('help_tool_description_2')
        },
        items = HELP_CONFIG
    })
end)

RegisterNuiCallback('call:optionClick', function(data, cb)
    TriggerServerEvent("dashboard.analytics:click-option", data.item)
end)

RegisterNuiCallback('call:sendSearched', function(data, cb)
    TriggerServerEvent("dashboard.analytics:search-input", data.value)
end)

RegisterNuiCallback('call:questionClick', function(data, cb)
    TriggerServerEvent("dashboard.analytics:click-question-help", data.item)
end)

RegisterCommand("openDashboard", function()
    if (LocalPlayer["state"]["minigame:active"]) then
        return
    end

    if exports.dashboard:BlockIfInRestrictWorld() then
        return
    end

    TriggerServerEvent("dashboard:openDashboard")
end)
RegisterKeyMapping("openDashboard", "Open Dashboard", "keyboard", "F1")


RegisterNuiCallback('getRulesLinks', function(data, cb)
    print("getRulesLinks: " .. json.encode(data, {indent = true}))
    local type = data.type
    local groupId = data.groupId

    if type == "wallstreet" then
        print("wallstreet")
        cb({
            wallstreetRulesUrl = WallStreetRules
        })
    elseif type == "group" then
        print("group")
        cb({
            groupRulesUrl = GroupRules[groupId]
        })
    end
end)

RegisterNuiCallback('openUrl', function(data, cb)
    local url = data.url
    if url then
        TriggerEvent("player:OpenURL", url)
    end
    cb(true)
end)

local gAffiliateAgentMatchmakingTicketStatus = 'none'

---@type string | nil
local gAffiliateAgentMatchmakingTicketId = nil

---@type table | nil
local gAffiliateAgentMatchmakingTicketProposal = nil

---@type affialiates.TicketStatus | 'none' -- 'none' tá separado porque não é um STATUS realmente
local gAffiliateAgentTicketStatus = 'none'

local gAffiliateCommercialActive = false

---@return boolean eligible
local function IsAffiliateGrowthVisibilityEligible()

    local playerGroups = vRP.GetPlayerGroups() or {}
    local affiliateLevel = tonumber( playerGroups[ 'Afiliado' ] )

    return affiliateLevel ~= nil and affiliateLevel >= 1 and affiliateLevel <= 5
end

---@return boolean active
local function ComputeAffiliateCommercialActive()

    if not IsAffiliateGrowthVisibilityEligible() then
        return false
    end

    return gAffiliateAgentMatchmakingTicketStatus ~= 'none'
end

---@return nil
local function RefreshAffiliateCommercialActive()

    local active = ComputeAffiliateCommercialActive()

    if active == gAffiliateCommercialActive then
        return
    end

    gAffiliateCommercialActive = active
    TriggerEvent( 'dashboard:affiliateCommercialActiveChanged', active )
end

---@return boolean active
function IsAffiliateCommercialActive()

    return ComputeAffiliateCommercialActive()
end

exports( 'IsAffiliateCommercialActive', IsAffiliateCommercialActive )

local gAffiliateServiceActive = false
local AFFILIATE_MATCHMAKING_SERVICE_STATUS = {
    pending = true,
    ['pending-approval'] = true,
    matched = true,
}

---@return boolean
local function IsAffiliateServiceActive()

    return AFFILIATE_MATCHMAKING_SERVICE_STATUS[ gAffiliateAgentMatchmakingTicketStatus ] == true
        or gAffiliateAgentTicketStatus == 'OPEN'
end

local function RefreshAffiliateServiceState()

    local active = IsAffiliateServiceActive()

    if active == gAffiliateServiceActive then return end

    gAffiliateServiceActive = active
    LocalPlayer.state:set( 'affiliate:inService', active or nil, true )
    TriggerServerEvent( 'dashboard:setAffiliateServiceActive', active )
    TriggerEvent( 'dashboard:affiliateServiceChanged', active )
end

exports( 'IsAffiliateInService', IsAffiliateServiceActive )

RegisterNUICallback( 'canStartAffiliateService', function( _, callback )

    local allowed = vSERVER.CanStartAffiliateService()

    if not allowed then
        TriggerEvent( 'Notify', 'amarelo', _t( 'affiliate.service.match_active' ), 5000, 'AFILIADOS' )
    end

    callback({ allowed = allowed == true })
end )

AddEventHandler( 'onClientResourceStop', function( resource )

    if resource ~= GetCurrentResourceName() or not gAffiliateServiceActive then return end

    LocalPlayer.state:set( 'affiliate:inService', nil, true )
    TriggerServerEvent( 'dashboard:setAffiliateServiceActive', false )
    TriggerEvent( 'dashboard:affiliateServiceChanged', false )
end )
RegisterNUICallback( 'clearAffiliatesAgentMatchmakingTicket', function( data, cb )

    -- gAffiliateAgentMatchmakingTicketStatus   = 'none'
    -- gAffiliateAgentMatchmakingTicketProposal = nil

    print('clearAffiliatesAgentMatchmakingTicket')

    SetAffiliatesAgentMatchmakingTicketStatus({
        status = 'none',
    })

    cb({ ok = true })
end)

---@type promise | nil
local gAwaitingSpectatorModeEnableChangePromise = nil

---@param spectatedPassport string | nil
local function SetSpectatorModeEnabledAwaitable( spectatedPassport )

    print('SetSpectatorModeEnabledAwaitable', spectatedPassport)

    local p = promise.new()

    gAwaitingSpectatorModeEnableChangePromise = p

    local cookie = AddStateBagChangeHandler( 'Spectate', nil, function( bagName, key, value )
        p:resolve()
    end)

    SetTimeout( 5000, function()

        --[[
        Tempo máximo para a gente aguardar a troca de estado do spectator!
        --]]

        p:resolve()
    end)

    local function OnSettled()

        print( ('SetSpectatorModeEnabledAwaitable::OnSettled') )

        RemoveStateBagChangeHandler( cookie )

        gAwaitingSpectatorModeEnableChangePromise = nil
    end

    p:next( OnSettled, OnSettled )

    if spectatedPassport then

        TriggerServerEvent( "dashboard:handleSpectate", spectatedPassport )
    else

        -- exports.admin:ExitSpectatorMode()
        TriggerEvent( 'actions:Cancel', true )
    end
end

local function AwaitSpectatorModeEnabledChangeSettled()

    print( ('AwaitSpectatorModeEnabledChangeSettled'), gAwaitingSpectatorModeEnableChangePromise ~= nil )

    if not gAwaitingSpectatorModeEnableChangePromise then
        return
    end

    Citizen.Await( gAwaitingSpectatorModeEnableChangePromise )
end

local gWasInFreecamModeWhenPendingTicketStatus = false


function SetAffiliatesAgentMatchmakingTicketStatus( data )

    print('setAffiliatesAgentMatchmakingTicketStatus', json.encode(data, {indent = true}))

    assert( data )
    assert( type( data.status ) == 'string', 'status must be a string' )

    local prevAffiliateAgentMatchmakingTicketStatus = gAffiliateAgentMatchmakingTicketStatus

    local statusChanged = prevAffiliateAgentMatchmakingTicketStatus ~= data.status

    gAffiliateAgentMatchmakingTicketStatus   = data.status
    gAffiliateAgentMatchmakingTicketProposal = data.proposal or gAffiliateAgentMatchmakingTicketProposal
    if data.ticket and data.ticket.id then
        gAffiliateAgentMatchmakingTicketId = data.ticket.id
    elseif data.status == 'none' then
        gAffiliateAgentMatchmakingTicketId = nil
    end

    RefreshAffiliateCommercialActive()
    RefreshAffiliateServiceState()

    print('statusChanged', statusChanged, prevAffiliateAgentMatchmakingTicketStatus, '->', gAffiliateAgentMatchmakingTicketStatus)

    -- if not statusChanged then
    --     return
    -- end

    print('gWasInFreecamModeWhenPendingTicketStatus', gWasInFreecamModeWhenPendingTicketStatus)

    if      prevAffiliateAgentMatchmakingTicketStatus == 'pending' then

        -- Estava aguardando um Match, possivelmente achou ou cancelou o Matchmaking

        print('prevAffiliateAgentMatchmakingTicketStatus == "pending"', LocalPlayer.state.Invisible)

        if LocalPlayer.state.Invisible then

            -- Estava no noclip, vamos salvar esse estado para tentar recuperar caso tenhamos achado um Match!

            gWasInFreecamModeWhenPendingTicketStatus = true
        end

    elseif  prevAffiliateAgentMatchmakingTicketStatus == 'pending-approval' then

        if gAffiliateAgentMatchmakingTicketStatus == 'none' then

            print('is none')

            attempts = 50

            -- é possivel que a gente entre no spectator e saia ao mesmo tempo
            -- então o cliente não tem tempo de saber que ele ta entrando no espectador
            -- mas pra tentar cancelar, a gente verificar se ele ta no espectator....

            while attempts > 0 do

                SetSpectatorModeEnabledAwaitable( nil )
    
                Wait( 100 )

                attempts = attempts - 1

                print( 'attempts=', attempts )
            end
        elseif  gAffiliateAgentMatchmakingTicketStatus ~= 'matched' then

            print('is not matched')

            --[[
            Não vamos desabilitar o spectator quando o proximo state for
            'matched' porque o proprio 'matched' ativa o spectator, então a gente só flickaria o personagem
            ]]

            SetSpectatorModeEnabledAwaitable( nil )

        end
    end

    if      gAffiliateAgentMatchmakingTicketStatus == 'pending' then

        -- Entrou no status de 'pending', talvez ai iniciar o matchmaking
        -- ou depois de recusar um Match.

        if gWasInFreecamModeWhenPendingTicketStatus then

            -- Provavelmente recusou um match e estava no noclip antes de entrar no espectador do 'pending-approval'
            -- então vamos retormar o noclip!

            gWasInFreecamModeWhenPendingTicketStatus = false

            AwaitSpectatorModeEnabledChangeSettled()

            if not LocalPlayer.state.Invisible then

                ExecuteCommand( 'nc' )
            end
        end

    elseif  gAffiliateAgentMatchmakingTicketStatus == 'pending-approval' then

        assert( gAffiliateAgentMatchmakingTicketProposal, 'gAffiliateAgentMatchmakingTicketProposal is nil' )

        if not LocalPlayer.state.Invisible then

            -- Entrar no noclip ao começar o pending-approval para evitar que personagem
            -- fique voando enquanto está visivel!
            
            ExecuteCommand( 'nc' )
        end

        SetSpectatorModeEnabledAwaitable( gAffiliateAgentMatchmakingTicketProposal.customerProfilePassport )

    elseif  gAffiliateAgentMatchmakingTicketStatus == 'matched' then

        assert( gAffiliateAgentMatchmakingTicketProposal, 'gAffiliateAgentMatchmakingTicketProposal is nil' )

        if not LocalPlayer.state.Invisible then

            -- garantir que não esteja ["Invisible"] antes de entrar/sair do noclip

            -- Aguardar sair completamente do spectator mode!
            -- AwaitSpectatorModeEnabledChangeSettled()

            ExecuteCommand( 'nc' )
        end 

        TriggerServerEvent( "dashboard:handleTeleport", gAffiliateAgentMatchmakingTicketProposal.customerProfilePassport )
    end

    -- Atualizar depois porque quando atualiza para um status diferente da proposal, a gente pode perder esses dados!
    gAffiliateAgentMatchmakingTicketProposal = data.proposal
end

RegisterNUICallback( 'setAffiliatesAgentMatchmakingTicketStatus', function( data, cb )

    SetAffiliatesAgentMatchmakingTicketStatus( data )

    cb({ ok = true })
end)

local WAIT_DEBUG_VISIBLE = 1000

function DebugInvisible()
    -- local pedId = PlayerPedId()

    -- SetEntityVisible(pedId, true, 0)

    -- Wait(WAIT_DEBUG_VISIBLE)

    -- SetEntityVisible(pedId, false, 0)
end

RegisterKeyMapping( 'cancelAffiliatesAgentMatchmakingTicket', 'Cancel Affiliates Agent Matchmaking Ticket', 'keyboard', 'G' )
RegisterKeyMapping( 'acceptAffiliatesAgentMatchmakingTicketProposal', 'Accept Affiliates Agent Matchmaking Ticket Proposal', 'keyboard', 'Y' )
RegisterKeyMapping( 'rejectAffiliatesAgentMatchmakingTicketProposal', 'Reject Affiliates Agent Matchmaking Ticket Proposal', 'keyboard', 'U' )

local TIMEOUT_TO_RESET_SPECTATOR = 1200

function CancelAffiliatesAgentMatchmakingTicket()
    if gAffiliateAgentMatchmakingTicketStatus == 'none' then
        return
    end

    print('CancelAffiliatesAgentMatchmakingTicket', gAffiliateAgentMatchmakingTicketStatus)
    SendNUIMessage({ action = 'cancelAffiliatesAgentMatchmakingTicket' })

    SetSpectatorModeEnabledAwaitable( nil )

    -- resolver problemas de race condition depois ( alguma hora )
    -- estamos tentando replicar o comportamento do F6 da vrp para cancelar o espectador
    SetTimeout(TIMEOUT_TO_RESET_SPECTATOR, function()
        local pedId = PlayerPedId()

        NetworkSetInSpectatorMode(false)
        
        TriggerEvent("Notify:Text","")

        while IsEntityPositionFrozen(pedId) do -- meu deus ( resetando e forçando para visible )
            FreezeEntityPosition(pedId, false)
            Wait(5)
        end

        DebugInvisible()
    end)
end

AddEventHandler( 'actions:Cancel', function(  )
    local invoking = GetInvokingResource()

    if not (invoking and invoking == "vrp") then -- evento está vindo do F6 da vrp diretamente
        return
    end

    -- O F6 ja tira o spec então não precisamos enviar o evento para cancelar o spec
    CancelAffiliatesAgentMatchmakingTicket()
end)

exports('GetStatusAffiliatesAgentMatchmakingTicket', function()
    return gAffiliateAgentMatchmakingTicketStatus
end)

RegisterCommand( 'cancelAffiliatesAgentMatchmakingTicket', function(source, args, rawCommand)
    TriggerEvent('net.player.cancel_spectate')
    CancelAffiliatesAgentMatchmakingTicket()
end)

---@param accepted boolean
local function SendAffiliatesAgentMatchmakingTicketProposalResponse( accepted )

    local proposalId = gAffiliateAgentMatchmakingTicketProposal
        and gAffiliateAgentMatchmakingTicketProposal.id or nil

    print( ('SendAffiliatesAgentMatchmakingTicketProposalResponse accepted=%s ticketId=%s proposalId=%s'):format(
        tostring( accepted ), tostring( gAffiliateAgentMatchmakingTicketId ),
        tostring( proposalId ) ) )

    SendNUIMessage({
        action = 'affiliatesAgentMatchmakingTicketProposalResponse',
        data = {
            accepted = accepted,
            mmTicketId = gAffiliateAgentMatchmakingTicketId,
            proposalId = proposalId,
        }
    })
end

---@param enable boolean
---@param silently boolean?
local function ToggleAffiliatesAgentTicketMoreInfo( enable, silently )

    print( 'ToggleAffiliatesAgentTicketMoreInfo', enable )

    if gAffiliateAgentTicketStatus ~= 'OPEN' then

        return
    end

    SetNuiFocus( enable, enable )

    if not silently then

        SendNUIMessage({
            action = "AFFILIATES_CARD_MOREINFO",
            data = enable
        })
    end
end

RegisterCommand( 'acceptAffiliatesAgentMatchmakingTicketProposal', function()

    print('acceptAffiliatesAgentMatchmakingTicketProposal', gAffiliateAgentMatchmakingTicketStatus)

    if gAffiliateAgentMatchmakingTicketStatus == 'pending-approval' then
        CreateThread(function()
            DebugInvisible()
        end)

        SendAffiliatesAgentMatchmakingTicketProposalResponse( true )
    end
end)

RegisterCommand( 'rejectAffiliatesAgentMatchmakingTicketProposal', function()

    print('rejectAffiliatesAgentMatchmakingTicketProposal', gAffiliateAgentMatchmakingTicketStatus)
    
    if gAffiliateAgentMatchmakingTicketStatus == 'pending-approval' then

        SendAffiliatesAgentMatchmakingTicketProposalResponse( false )
    end
end)

--#region
-- Tickets!

RegisterKeyMapping( 'closeAffiliatesAgentTicket', 'Close Ticket', 'keyboard', 'G' )

RegisterCommand( 'closeAffiliatesAgentTicket', function()

    print('closeAffiliatesAgentTicket')

    SendNUIMessage({
        action = 'attemptCloseAffiliatesAgentTicket',
    })
end)

RegisterKeyMapping( 'ToggleAffiliatesAgentTicketMoreInfo2', 'Toggle Affiliates Agent Ticket More Info', 'keyboard', 'Q' )

RegisterCommand( 'ToggleAffiliatesAgentTicketMoreInfo2', function()

    -- ENG-3779: com o card do convite X1 aberto, o Q é dele.
    if X1InviteOwnsKey( 'q' ) then return end

    -- actived = not actived

    -- Não é um toggle, só consegue apertar para abrir, porque vai ficar sem o focuskeepinput
    -- a ação de fechar vai vir do frontend
    ToggleAffiliatesAgentTicketMoreInfo( true )
end)

---@alias affialiates.TicketStatus 'OPEN' | 'COMPLETED'

---@param data { status: affialiates.TicketStatus | 'none', ticketSource: 'MATCHMAKING' | 'DIRECT' }
RegisterNuiCallback( 'setAffiliatesAgentTicketStatus', function( data, cb )

    print('setAffiliatesAgentTicketStatus', json.encode(data, {indent = true}))

    assert( data.status, 'status is required' )
    assert( type( data.status ) == 'string', 'status must be a string' )
    assert( data.status == 'none' or data.status == 'OPEN' or data.status == 'COMPLETED', 'status must be "none", "OPEN" or "COMPLETED"' )

    local prevAffiliateAgentTicketStatus = gAffiliateAgentTicketStatus

    gAffiliateAgentTicketStatus = data.status
    RefreshAffiliateServiceState()

    if prevAffiliateAgentTicketStatus ~= 'none' then
        ToggleAffiliatesAgentTicketMoreInfo( false, true )
    end

    --[[
    As vezes o estado alterado no frontend e a gente envia o mesmo estado novamente, então não precisamos fazer nada!
    --]]
    if 
        data.status == 'OPEN' 
        and prevAffiliateAgentTicketStatus ~= gAffiliateAgentTicketStatus --[[ Somente se o estado anterior já não era esse ]] 
        and data.ticketSource ~= 'DIRECT' 
    then

        local camPos = GetFinalRenderedCamCoord()
        -- local camRot = GetFinalRenderedCamRot( 2 )
        -- local camDir = RotationToDirection( camRot )

        -- local camLookAt = camPos + ( camDir * 100.0 )

        SetSpectatorModeEnabledAwaitable( nil )

        AwaitSpectatorModeEnabledChangeSettled()

        SetEntityCoords( PlayerPedId(), camPos.x, camPos.y, camPos.z )

        if not LocalPlayer.state.Invisible then

            do
                --[[
                Gambiarra! quando executamos o comando "/nc", até que o personagem fique realmente invisivel
                pode demorar vários milisegundo, então a gente faz esse "predict" pra não ter o personagem visivel momentaneamente!
                --]]

                -- Necessario para AC
                LocalPlayer["state"]["Invisible"] = true
                SetEntityVisible( PlayerPedId(), false, false )
            end

            ExecuteCommand( 'nc' )
        end

        -- SetGameplayCoordHint( camLookAt.x, camLookAt.y, camLookAt.z, 10000, 8.0, 1080.0,  0 )

        -- SetGameplayCamRawPitch( camRot.y )
        -- SetGameplayCamRawYaw( camRot.x )
    end

    cb({ ok = true })
end)

RegisterNUICallback( 'onBeforeCloseTicket', function( data, cb )

    print('onBeforeCloseTicket', json.encode(data, {indent = true}))

    TriggerServerEvent( "dashboard:onBeforeCloseTicket", data.id, data.ticketId )

    cb({ ok = true })
end)

RegisterNuiCallback( 'affiliatesAgentTicketCancelConfirmationOpenStatusChanged', function( data, cb )

    -- print('affiliatesAgentTicketCancelConfirmationOpenStatusChanged', json.encode(data, {indent = true}))

    SetNuiFocus( data.isOpen, data.isOpen )

    cb({ ok = true })
end)

RegisterNuiCallback( 'AFFILIATES_CLOSE_CARD_MOREINFO', function( data, cb )

    -- silently porque o frontend já altera o status
    ToggleAffiliatesAgentTicketMoreInfo( false, true )

    cb({ ok = true })
end)

---@param ticketId string id do ticket
---@param result table resultado da survey
RegisterNetEvent( 'dashboard:closeTicket', function( ticketId, surveyResultReason, surveyResultComment )

    print('dashboard:closeTicket', ticketId, surveyResultReason, surveyResultComment)

    SendNUIMessage({
        action = 'closeTicket',
        data = {
            ticketId = ticketId,
            surveyResultReason = surveyResultReason,
            surveyResultComment = surveyResultComment,
        }
    })
end)

---@param ticketId string id do ticket
---@param surveyResultRating number resultado da survey
---@param surveyResultComment string comentário da survey
RegisterNetEvent( 'net.dashboard.customer_feedback_survey_results', function( ticketId, surveyResultRating, surveyResultComment )

    print('net.dashboard.customer_feedback_survey_results', ticketId, surveyResultRating, surveyResultComment)


    --@todo: implementar a lógica de feedback do cliente para enviar para front --> api --> salvar o feedback do client em relação ao afiliado

    -- SendNUIMessage({
    --     action = 'closeTicket',
    --     data = {
    --         ticketId = ticketId,
    --         surveyResultRating = surveyResultRating,
    --         surveyResultComment = surveyResultComment,
    --     }
    -- })
end)

--

---@param input { customerProfilePassport: string }
local function CreateCommercialDirectTicket( input )

    print('CreateCommercialDirectTicket', json.encode(input, {indent = true}), type( input.customerProfilePassport ))

    assert( type( input.customerProfilePassport ) == 'string', 'customerProfilePassport must be a string' )

    SendNUIMessage({
        action = 'createTicket',
        data = input,
    })
end

exports( 'CreateCommercialDirectTicket', CreateCommercialDirectTicket )


local eNotifyKeys =
{
    AGENT_NOT_FOUND                    = '#tickets.errors.agent_not_found',
    AGENT_PROFILE_NOT_FOUND            = '#tickets.errors.agent_profile_not_found',
    AGENT_HAS_OPEN_TICKET              = '#tickets.errors.agent_has_open_ticket',
    CUSTOMER_HAS_OPEN_TICKET           = '#tickets.errors.customer_has_open_ticket',
    PROFILE_NOT_FOUND                  = '#tickets.errors.profile_not_found',
    PROFILE_INVALID_PASSPORT           = '#tickets.errors.profile_invalid_passport',
    PROFILE_NO_CUSTOMER                = '#tickets.errors.profile_no_customer',
    CUSTOMER_TIER_TOO_LOW              = '#tickets.errors.customer_tier_too_low',
    APP_MISMATCH                       = '#tickets.errors.app_mismatch',
    PROFILE_USER_MISMATCH              = '#tickets.errors.profile_user_mismatch',
    VALIDATION_ERROR                   = '#tickets.errors.validation_error',
    API_UNAVAILABLE                    = '#tickets.errors.api_unavailable',
    INTERNAL_ERROR                     = '#tickets.errors.generic',
    UNKNOWN_ERROR                      = '#tickets.errors.generic',
    PROFILE_HAS_TICKET_SOURCE_COOLDOWN = '#tickets.errors.profile_has_ticket_source_cooldown',
}

local eDetailedNotifyKeys =
{
    AGENT_HAS_OPEN_TICKET    = '#tickets.errors.agent_has_open_ticket_details',
    CUSTOMER_HAS_OPEN_TICKET = '#tickets.errors.customer_has_open_ticket_details',
    PROFILE_NOT_FOUND        = '#tickets.errors.profile_not_found_details',
    PROFILE_INVALID_PASSPORT = '#tickets.errors.profile_invalid_passport_details',
    PROFILE_NO_CUSTOMER      = '#tickets.errors.profile_no_customer_details',
    APP_MISMATCH             = '#tickets.errors.app_mismatch_details',
}

---@param value unknown
---@return string|nil
local function TicketErrorText( value )

    if type( value ) ~= 'string' and type( value ) ~= 'number' then
        return nil
    end

    local text = tostring( value ):gsub( '[<>]', '' ):sub( 1, 80 )

    return text ~= '' and text or nil
end


---@param errorCode string
---@param errorData table
---@return string notifyKey
---@return table notifyVariables
local function ResolveTicketErrorNotification( errorCode, errorData )

    local variables = {
        customer_name = TicketErrorText( errorData.customerName ),
        customer_passport = TicketErrorText( errorData.customerPassport or errorData.passport ),
        agent_name = TicketErrorText( errorData.openTicketAgentName ),
        agent_passport = TicketErrorText( errorData.openTicketAgentPassport ),
        open_customer_name = TicketErrorText( errorData.openTicketCustomerName ),
        open_customer_passport = TicketErrorText( errorData.openTicketCustomerPassport ),
        agent_server = TicketErrorText( cityName ) or TicketErrorText( errorData.agentAppId ),
        customer_server = TicketErrorText( errorData.customerAppId ),
    }

    local hasDetails =
        errorCode == 'AGENT_HAS_OPEN_TICKET' and variables.open_customer_name and variables.open_customer_passport or
        errorCode == 'CUSTOMER_HAS_OPEN_TICKET' and variables.customer_name and variables.customer_passport and variables.agent_name or
        errorCode == 'PROFILE_NOT_FOUND' and variables.customer_passport or
        errorCode == 'PROFILE_INVALID_PASSPORT' and variables.customer_name and variables.customer_passport or
        errorCode == 'PROFILE_NO_CUSTOMER' and variables.customer_name and variables.customer_passport or
        errorCode == 'APP_MISMATCH' and variables.customer_name and variables.customer_passport and variables.agent_server and variables.customer_server

    if hasDetails then
        return eDetailedNotifyKeys[ errorCode ], variables
    end

    return eNotifyKeys[ errorCode ] or eNotifyKeys.UNKNOWN_ERROR, variables
end

---@param seconds number|nil
---@return string
local function FormatCooldownRemaining( seconds )
    local safeSeconds = math.max(0, tonumber(seconds) or 0)

    local minutes = math.floor(safeSeconds / 60)
    local remainingSeconds = safeSeconds % 60

    if minutes > 0 then
        return ("%dm %02ds"):format(minutes, remainingSeconds)
    end

    return ("%ds"):format(remainingSeconds)
end

RegisterNUICallback( 'onCreateTicketError', function( data, cb )

    sx.logger:debug( ('onCreateTicketError data=%s'):format( json.encode( data ) ) )

    local errorCode = data.error_code or 'UNKNOWN_ERROR'
    local errorData = type(data.error_data) == 'table' and data.error_data or {}

    local notifyKey, notifyVariables = ResolveTicketErrorNotification( errorCode, errorData )

    if not eNotifyKeys[ errorCode ] then
        sx.logger:warn( ('Unknown ticket creation error code "%s"; using generic notification'):format( errorCode ) )
    end

    if errorCode == 'PROFILE_HAS_TICKET_SOURCE_COOLDOWN' then
        local cooldownText = FormatCooldownRemaining( errorData.cooldown_remaining_seconds )

        notifyVariables.msg = cooldownText
        TriggerEvent( 'Notify2', notifyKey, notifyVariables )
    else
        TriggerEvent( 'Notify2', notifyKey, notifyVariables )
    end

    cb({ ok = true })
end)

--#endregion
---@param player number
function OnCreateProfilePicture(player)
    local handle = RegisterPedheadshotTransparent(player)
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end

    local txd = GetPedheadshotTxdString(handle)

    UnregisterPedheadshot(handle)
    return txd
end

RegisterNuiCallback('getPlayerPhoto', function(data, cb)
    local picture = OnCreateProfilePicture(PlayerPedId())
    local avatar = ('https://nui-img/%s/%s'):format(picture, picture)
    print('getPlayerPhoto', avatar)
    cb(avatar)
end)

RegisterNuiCallback('attendPurchase', function(data, cb)
    print('attendPurchase', json.encode(data, {indent = true}))
    local purchaseId = data.purchaseId
    TriggerServerEvent("dashboard:attendPurchase", purchaseId)
    cb(true)
end)
RegisterNuiCallback('handleBanSuspect', function(data, cb)
    sx.logger:debug( ('handleBanSuspect data=%s'):format( json.encode( data ) ) )

    if type( data ) == 'table' and tonumber( data.user_id ) and type( data.reason ) == 'string' then

        TriggerServerEvent( 'admin:banSuspect', {
            user_id = tonumber( data.user_id ),
            reason  = data.reason,
        })
    end

    cb(true)
end)
RegisterNUICallback('toxicity:getTimeZone', function(_, cb)
    cb(GetConvar('toxicityTimeZone', 'UTC'))
end)
