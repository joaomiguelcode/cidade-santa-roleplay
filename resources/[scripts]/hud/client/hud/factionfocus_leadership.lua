local gLeadershipData
local gLeadershipHiddenFocusId
local gLeadershipHubOpen = false
local gLeadershipMapOpen = false
local gLeadershipDisplay = GlobalState.FACTIONFOCUS_DISPLAY
local gLeadershipRefreshToken = 0
local gLeadershipRefreshPendingDelay
local gLeadershipStopped = false

local function Send( action, data )
    TriggerEvent( 'dashboard:factionFocus', { action = ( 'factionFocusLeadership:%s' ):format( action ), data = data } )
end

local function Hide()
    if not gLeadershipData then return end
    if gLeadershipHiddenFocusId == gLeadershipData.focusId then
        gLeadershipHiddenFocusId = nil
        Send( 'open', gLeadershipData )
    else
        gLeadershipHiddenFocusId = gLeadershipData.focusId
        Send( 'close', { focusId = gLeadershipData.focusId } )
    end
end

---@return boolean
local function IsCovered()
    return gLeadershipHubOpen or gLeadershipMapOpen
end

-- Hub e mapa (ENG-3972) cobrem a tela: some enquanto um deles estiver aberto e volta como estava, inclusive o F11.
local function SyncCover()
    if IsCovered() then
        Send( 'clear', nil )
    elseif gLeadershipData then
        Send( 'open', gLeadershipData )
        if gLeadershipHiddenFocusId == gLeadershipData.focusId then
            Send( 'close', { focusId = gLeadershipData.focusId } )
        end
    end
end

RegisterNetEvent( 'hud:factionFocusLeadership', function( event, data )
    if event == 'foco:saiu' then
        if not data or not data.focusId or not gLeadershipData or data.focusId == gLeadershipData.focusId then
            gLeadershipData = nil
            Send( 'clear', data )
        end
        return
    end
    if type( data ) ~= 'table' or type( data.focusId ) ~= 'string' or type( data.faction ) ~= 'string' then return end
    local changed = not gLeadershipData or gLeadershipData.focusId ~= data.focusId
    gLeadershipData = data
    if IsCovered() then return end
    Send( changed and gLeadershipHiddenFocusId ~= data.focusId and 'open' or 'update', data )
end )

exports( 'GetFactionFocusLeadershipState', function()
    if not gLeadershipData or IsCovered() then return { } end
    return { data = gLeadershipData, collapsed = gLeadershipHiddenFocusId == gLeadershipData.focusId }
end )

exports( 'HandleFactionFocusLeadershipKey', function( key )
    if not gLeadershipData or IsCovered() then return false end
    if key == 'Q' then
        if gLeadershipHiddenFocusId == gLeadershipData.focusId then return false end
        TriggerEvent( 'dashboard:factionFocus:ranking' )
        return true
    end
    if key == 'F11' then Hide(); return true end
    return false
end )

AddEventHandler( 'hud:factionFocusLeadership:hide', Hide )

AddEventHandler( 'hub:visibilityChanged', function( visible )
    gLeadershipHubOpen = visible == true
    SyncCover()
end )

AddEventHandler( 'hud:pauseMenu:visibilityChanged', function( visible )
    gLeadershipMapOpen = visible == true
    SyncCover()
end )

---@param immediate? boolean
local function Refresh( immediate )
    if gLeadershipStopped or gLeadershipRefreshPendingDelay == 0
        or ( gLeadershipRefreshPendingDelay and immediate ~= true ) then return end

    gLeadershipRefreshToken = gLeadershipRefreshToken + 1
    local token = gLeadershipRefreshToken
    -- Fase estavel por jogador: nao reinicia a janela a cada sinal de progresso.
    local delay = immediate == true and 0 or ( GetPlayerServerId( PlayerId() ) * 37 ) % 750
    gLeadershipRefreshPendingDelay = delay

    SetTimeout( delay, function()
        if gLeadershipStopped or token ~= gLeadershipRefreshToken then return end

        gLeadershipRefreshPendingDelay = nil
        TriggerServerEvent( 'hud:factionFocusLeadership:request' )
    end )
end

local function Revalidate()
    -- Sinal visual apenas; o servidor decide se o card pode voltar a abrir.
    gLeadershipData = nil
    Send( 'clear', nil )
    Refresh( true )
end

AddStateBagChangeHandler( 'FACTIONFOCUS_DISPLAY', 'global', function( _, _, value )
    local previous = type( gLeadershipDisplay ) == 'table' and gLeadershipDisplay[ 1 ]
    local focus = type( value ) == 'table' and value[ 1 ]
    gLeadershipDisplay = value

    -- Proximidade e marcador do waypoint nao alteram o estado privado da lideranca.
    if type( previous ) == 'table' and type( focus ) == 'table'
        and previous.cycleId == focus.cycleId
        and previous.faction == focus.faction
        and previous.convertedCount == focus.convertedCount
        and previous.targetConversions == focus.targetConversions then
        return
    end

    -- ENG-3984: sem foco na cidade o servidor ainda segura a NUI do foco encerrado; ele decide quando tirar.
    Refresh( type( focus ) ~= 'table' )
end )
RegisterNetEvent( 'net:routing_bucket_changed', Revalidate )
RegisterNetEvent( 'playerGroups:AddGroup', Revalidate )
RegisterNetEvent( 'playerGroups:RemoveGroup', Revalidate )
AddStateBagChangeHandler( 'isRecruitmentSuspended', ( 'player:%d' ):format( GetPlayerServerId( PlayerId() ) ), Revalidate )
AddEventHandler( 'onResourceStop', function( resource )
    if resource ~= GetCurrentResourceName() then return end

    gLeadershipStopped = true
    gLeadershipRefreshToken = gLeadershipRefreshToken + 1
    gLeadershipData = nil
    Send( 'clear', nil )
end )
-- O servidor autoriza os destinatarios; o cliente apenas apresenta o estado recebido.
CreateThread( function()
    Wait( 3500 )
    while not gLeadershipStopped do
        Refresh()
        Wait( 30000 )
    end
end )
