local Timer = GetGameTimer()

---O request que está em uso/evidencia no momento
---@type table<eRequestExtType, RequestExt[]>
local gRequestQueueByType = { }

-----------------------------------------------------------------------------------------------------------------------------------------
-- ALL
-----------------------------------------------------------------------------------------------------------------------------------------
---@param request RequestExt
local function RemoveRequestFromQueue( request )

    local queue = gRequestQueueByType[ request.type ] or { }

    for index, r in ipairs( queue ) do

        if r.id == request.id then

            table.remove( queue, index )

            return
        end
    end
end

function ClearToastRequestQueue()
    local queue = gRequestQueueByType[ 'toast' ]
    if not queue then
        return
    end

    for index = #queue, 1, -1 do
        local request = queue[ index ]
        if request then
            SendNUIMessage({ action = "pressedNo", data = request.id })
        end
        table.remove( queue, index )
    end
end

-- Fecha apenas pedidos do Match; a fila padrão de outros sistemas é preservada.
AddEventHandler('hud:matchCity:cancelContactRequests', function()
    local queue = gRequestQueueByType['default'] or {}
    for index = #queue, 1, -1 do
        local request = queue[index]
        if request.opts.variant == 'match-city-contact' then
            SendNUIMessage({ action = 'pressedNo', data = request.id })
            request:done(ToSource(GetPlayerServerId(PlayerId())), eRequestFailureReason.Cancelled)
            RemoveRequestFromQueue(request)
        end
    end
end)

RegisterNuiCallback("askResponse",function(data,cb)
    local id = data.request and data.request.id
    local request = GetRequestExt( id )

    if not request then
        cb({ ok = false })
        return
    end

    if request.type ~= 'toast' then
        if data.accepted then
            request:done( ToSource( GetPlayerServerId( PlayerId() ) ) )
        else
            request:done( ToSource( GetPlayerServerId( PlayerId() ) ), data.isTimeout and eRequestFailureReason.TimedOut or eRequestFailureReason.Cancelled )
        end

        RemoveRequestFromQueue( request )
    end

    cb({ ok = true })
end)

---@param request RequestExt
function PushRequest( request )

    TriggerEvent( 'hoverfy:removeHoverfy' )

    SendNUIMessage({
        action = 'addRequest',
        data =
        {
            id = request.id,
            type = request.type,

            message = request.message:gsub("[<>]",""),

            interval = request.opts.ttl * 1000, -- Converter para millisegundos
            title = request.opts.title,
            subtitle = request.opts.subtitle,
            bgColor = request.opts.bgColor,
            variant = request.opts.variant,
            requesterName = request.opts.requesterName,
            requesterAvatar = request.opts.requesterAvatar,
            contactLabel = request.opts.contactLabel,
            acceptLabel = request.opts.acceptLabel,
            declineLabel = request.opts.declineLabel,
            requesterId = request.opts.requesterId,
            declineKey = request.opts.declineKey,
        }
    })

    local queue = gRequestQueueByType[ request.type ]

    if not gRequestQueueByType[ request.type ] then
        queue = { }

        gRequestQueueByType[ request.type ] = queue
    end

    table.insert( queue, request )
end

---@param request RequestExt
function OnRequestExtTimedout( request )

    RemoveRequestFromQueue( request )
    if request.opts.variant == 'match-city-contact' then
        SendNUIMessage({ action = 'pressedNo', data = request.id })
    end
end

---@param requestServerId   RequestExtId
---@param message           string
---@param opts              RequestExtOptions
---@param type              eRequestExtType
local function StartRequestExtCreatedByServer( requestServerId, message, opts, type )

    opts.onAccepted = function()

        -- print('onAccept requestServerId=', requestServerId )

        TriggerServerEvent( 'request:accept', requestServerId )
    end

    opts.onRefused = function( source, failureReason )

        -- print('onRefuse requestServerId=', requestServerId, failureReason)

        local isTimeout = failureReason == eRequestFailureReason.TimedOut

        TriggerServerEvent( 'request:cancel', requestServerId, isTimeout )
    end

    local request = StartRequestExt( 'server', ToSource( GetPlayerServerId( PlayerId() ) ), message, opts, type )

    PushRequest( request )
end

---API antiga para a criação no client de requests vindas do servidor
---@param requestServerId   RequestExtId
---@param message           string
---@param ttl               number
function Creative.addRequest( requestServerId, message, ttl, presentation )
    if LocalPlayer["state"]["Creating"] then
        return
    end

    ttl = ttl or 10

    StartRequestExtCreatedByServer( requestServerId, message, {
        ttl = ttl,
        variant = type(presentation) == 'table' and presentation.variant or nil,
        requesterName = type(presentation) == 'table' and presentation.requesterName or nil,
        requesterAvatar = type(presentation) == 'table' and presentation.requesterAvatar or nil,
        contactLabel = type(presentation) == 'table' and presentation.contactLabel or nil,
        acceptLabel = type(presentation) == 'table' and presentation.acceptLabel or nil,
        declineLabel = type(presentation) == 'table' and presentation.declineLabel or nil,
    }, 'default' )
end

---Evento enviado pelo servidor para criar novos requests no client
---@param requestServerId   RequestExtId
---@param message           string
---@param ttl               number              Em segundos!
---@param type?             eRequestExtType
---@param presentation?     RequestExtOptions
RegisterNetEvent( 'net:request:add_request', function( requestServerId, message, ttl, requestType, presentation )

    if LocalPlayer["state"]["Creating"] then
        return
    end
    
    presentation = type( presentation ) == 'table' and presentation or { }
    presentation.ttl = ttl

    StartRequestExtCreatedByServer( requestServerId, message, presentation, requestType or 'default' )
end)

---Evento executado pelo client para criar novos requests via script externos
---@param message   string
---@param opts      RequestExtOptions
---@param ttl?      number              Em segundos!
---@param type      eRequestExtType
AddEventHandler( 'request.start', function( message, opts, ttl, type )

    if LocalPlayer["state"]["Creating"] then
        return
    end
    opts.ttl = ttl

    local request = StartRequestExt( 'client', ToSource( GetPlayerServerId( PlayerId() ) ), message, opts, type )

    PushRequest( request )
end)

---@param requestType eRequestExtType
---@return RequestExt | nil
local function GetNextRequestOfType( requestType )

    local queue = gRequestQueueByType[ requestType ]

    if not queue then
        return
    end

    -- Qual o request em "foco"?
    local request = queue[ 1 ]

    return request
end

---@param requestType eRequestExtType
local function OnPressedRequestAccept( requestType )
    local request = GetNextRequestOfType( requestType )

    if not request then
        -- Sem toast ativo: só avança a fila unificada (announce/socialparty).
        if ProcessUnifiedQueue then
            ProcessUnifiedQueue()
        end
        return
    end

    local source = ToSource( GetPlayerServerId( PlayerId() ) )

    if request.opts.canAccept and not request.opts.canAccept( source, { numAccepted = request.numAccepted } ) then
        return
    end

    TriggerEvent("toast.dismiss")

    SendNUIMessage({ action = "pressedYes", data = request.id })
    TriggerEvent("hoverfy:returnHoverfy")
    
    -- Remove request from queue regardless of type
    request:done( source )
    RemoveRequestFromQueue( request )
    
    -- Process next socialparty if needed
    if requestType == 'toast' and ProcessUnifiedQueue then
        ProcessUnifiedQueue()
    end
end

---@param requestType eRequestExtType
---@param declineKey "N"|"U"
local function OnPressedRequestRefuse( requestType, declineKey )
    local request = GetNextRequestOfType( requestType )

    if not request then
        return
    end

    local configuredKey = request.opts.declineKey or "U"

    if configuredKey ~= declineKey then
        return
    end

    local source = ToSource( GetPlayerServerId( PlayerId() ) )

    SendNUIMessage({ action = "pressedNo", data = request.id })
    TriggerEvent("hoverfy:returnHoverfy")
    request:done( source, eRequestFailureReason.Cancelled )
    RemoveRequestFromQueue( request )
end

---@return boolean
function HasNonDefaultRequests()
    local count = 0
    for requestType, queue in pairs(gRequestQueueByType) do
        if requestType ~= 'default' then
            for _, request in pairs(queue) do
                count = count + 1
            end
        end
    end
    if count > 0 then
        return true
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- Y
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Y",function()
    TriggerEvent("race:PressedY")

    OnPressedRequestAccept( 'default' )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- U
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("U",function()
    OnPressedRequestRefuse( 'default', 'U' )
    TriggerEvent("race:PressedU")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- N
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("N",function()
    OnPressedRequestRefuse( 'default', 'N' )
end)

RegisterCommand("socialparty.accept",function()

    if (LocalPlayer["state"]["minigame:active"]) then
        return
    end

    if gDeathStatueInviteOpen then
        return
    end

    OnPressedRequestAccept( 'toast' )
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Y", _t("Y"), "keyboard", "Y")
RegisterKeyMapping("U", _t("U"), "keyboard", "U")
RegisterKeyMapping("N", "Recusar convite", "keyboard", "N")
RegisterKeyMapping("socialparty.accept", _t("socialparty.accept"), "keyboard", "F3")

exports("Request",function(...)
    return vSERVER.wrapper(...)
end)
