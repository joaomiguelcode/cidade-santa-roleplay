-- ENG-3962: NUI azul "Legal em Foco" do líder da org legal em foco. Mesmo componente da NUI do líder
-- do Fac em Foco (factionfocus_leadership.lua) com prefixo e tema próprios; o servidor
-- (server/hud/legal_focus.lua) decide quem recebe e manda as atualizações do foco.
local PREFIX = 'legalFocusLeadership'

local gLegalLeadershipData
local gLegalLeadershipHiddenFocusId
local gLegalLeadershipHubOpen = false
local gLegalLeadershipMapOpen = false

local function Send( action, data )
    TriggerEvent( 'dashboard:factionFocus', { action = ( '%s:%s' ):format( PREFIX, action ), data = data } )
end

local function Hide()
    if not gLegalLeadershipData then return end
    if gLegalLeadershipHiddenFocusId == gLegalLeadershipData.focusId then
        gLegalLeadershipHiddenFocusId = nil
        Send( 'open', gLegalLeadershipData )
    else
        gLegalLeadershipHiddenFocusId = gLegalLeadershipData.focusId
        Send( 'close', { focusId = gLegalLeadershipData.focusId } )
    end
end

---@return boolean
local function IsCovered()
    return gLegalLeadershipHubOpen or gLegalLeadershipMapOpen
end

-- Hub e mapa (ENG-3972) cobrem a tela: some enquanto um deles estiver aberto e volta como estava, inclusive o F11.
local function SyncCover()
    if IsCovered() then
        Send( 'clear', nil )
    elseif gLegalLeadershipData then
        Send( 'open', gLegalLeadershipData )
        if gLegalLeadershipHiddenFocusId == gLegalLeadershipData.focusId then
            Send( 'close', { focusId = gLegalLeadershipData.focusId } )
        end
    end
end

RegisterNetEvent( 'hud:legalFocusLeadership', function( event, data )
    if event == 'foco:saiu' then
        if gLegalLeadershipData then
            gLegalLeadershipData = nil
            Send( 'clear', nil )
        end
        return
    end
    if type( data ) ~= 'table' or type( data.focusId ) ~= 'string' or type( data.faction ) ~= 'string' then return end
    local changed = not gLegalLeadershipData or gLegalLeadershipData.focusId ~= data.focusId
    gLegalLeadershipData = data
    if IsCovered() then return end
    Send( changed and gLegalLeadershipHiddenFocusId ~= data.focusId and 'open' or 'update', data )
end )

exports( 'GetLegalFocusLeadershipState', function()
    if not gLegalLeadershipData or IsCovered() then return { } end
    return { data = gLegalLeadershipData, collapsed = gLegalLeadershipHiddenFocusId == gLegalLeadershipData.focusId }
end )

exports( 'HandleLegalFocusLeadershipKey', function( key )
    if not gLegalLeadershipData or IsCovered() then return false end
    if key == 'Q' then
        if gLegalLeadershipHiddenFocusId == gLegalLeadershipData.focusId then return false end
        TriggerEvent( 'hub:OpenRanking', { category = 'organization' } )
        return true
    end
    if key == 'F11' then Hide(); return true end
    return false
end )

AddEventHandler( 'hud:legalFocusLeadership:hide', Hide )

AddEventHandler( 'hub:visibilityChanged', function( visible )
    gLegalLeadershipHubOpen = visible == true
    SyncCover()
end )

AddEventHandler( 'hud:pauseMenu:visibilityChanged', function( visible )
    gLegalLeadershipMapOpen = visible == true
    SyncCover()
end )

local function Revalidate()
    -- Sinal visual apenas; o servidor decide se a NUI pode voltar a abrir.
    gLegalLeadershipData = nil
    Send( 'clear', nil )
    TriggerServerEvent( 'hud:legalFocusLeadership:request' )
end

RegisterNetEvent( 'net:routing_bucket_changed', Revalidate )
RegisterNetEvent( 'playerGroups:AddGroup', Revalidate )
RegisterNetEvent( 'playerGroups:RemoveGroup', Revalidate )
AddEventHandler( 'onResourceStop', function( resource )
    if resource ~= GetCurrentResourceName() then return end

    gLegalLeadershipData = nil
    Send( 'clear', nil )
end )
CreateThread( function()
    Wait( 3500 )
    TriggerServerEvent( 'hud:legalFocusLeadership:request' )
end )
