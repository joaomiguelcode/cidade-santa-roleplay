-- Modal centralizado de punição (React em `apps/huds/ui/punishment-modal`). Nunca decide qual
-- motivo mostrar: só traduz o que o servidor mandar.
---@class PunishmentModalClientApi
PunishmentModalClient = {}

-- O ENTENDI só tem consequência em recruitment: é ele que inicia o relógio da suspensão.
-- low_activity ainda não tem regra de negócio, só exibe o aviso.
local ACK_HANDLERS = {
    recruitment = function()
        TriggerServerEvent( "recruitment_punishment:acknowledge" )
    end,
}

-- Bloqueante: sem ESC, sem clique fora, até o ENTENDI.
local gOpen = false

---@return nil
local function HoldFocus()
    CreateThread( function()
        while gOpen do
            DisableControlAction( 0, 200, true ) -- INPUT_FRONTEND_PAUSE (ESC)
            DisableControlAction( 0, 322, true ) -- INPUT_FRONTEND_PAUSE_ALTERNATE
            SetNuiFocus( true, true )
            Wait( 100 )
        end
    end )
end

---@param reason string
---@param count number
---@param singular string
---@param plural string
---@return string
local function Unit( count, singular, plural )
    return ( "%d %s" ):format( count, _t( count == 1 and singular or plural ) )
end

---@param seconds number?
---@return string?
local function FormatRemaining( seconds )
    seconds = tonumber( seconds )
    if not seconds then return nil end
    seconds = math.max( 0, math.floor( seconds ) )

    if seconds < 3600 then
        return Unit( math.max( 1, math.floor( seconds / 60 ) ), "hud.time.minute", "hud.time.minutes" )
    end

    if seconds < 86400 then
        local hours = math.floor( seconds / 3600 )
        local minutes = math.floor( ( seconds % 3600 ) / 60 )
        if minutes == 0 then
            return Unit( hours, "hud.time.hour", "hud.time.hours" )
        end
        return ( "%s %s %s" ):format(
            Unit( hours, "hud.time.hour", "hud.time.hours" ),
            _t( "hud.time.and" ),
            Unit( minutes, "hud.time.minute", "hud.time.minutes" ) )
    end

    local days = math.floor( seconds / 86400 )
    local hours = math.floor( ( seconds % 86400 ) / 3600 )
    if hours == 0 then
        return Unit( days, "hud.time.day", "hud.time.days" )
    end
    return ( "%s %s %s" ):format(
        Unit( days, "hud.time.day", "hud.time.days" ),
        _t( "hud.time.and" ),
        Unit( hours, "hud.time.hour", "hud.time.hours" ) )
end

---@param substitutions table<string, string|number>? -- ex.: { seconds = 7200 } pro {time} do highlight
---@return nil
local function ShowPunishmentModal( reason, substitutions )
    local copy = PUNISHMENT_MODAL_TEXTS[ reason ]
    if not copy then
        -- sx.logger:warn( ( "hud punishment modal ignored unknown reason=%s" ):format( tostring( reason ) ) )
        return
    end

    local highlight = copy.highlight
    if highlight and substitutions then
        -- `seconds` e o contrato atual; `time` continua aceito para nao quebrar chamador antigo.
        local resolved = {}
        for placeholder, value in pairs( substitutions ) do
            resolved[ placeholder ] = value
        end
        if resolved.seconds ~= nil then
            resolved.time = FormatRemaining( resolved.seconds ) or resolved.time
            resolved.seconds = nil
        end
        for placeholder, value in pairs( resolved ) do
            highlight = highlight:gsub( "{" .. placeholder .. "}", tostring( value ) )
        end
    end

    -- O `hud` não escuta este evento, então não corre o risco de se fechar sozinho.
    TriggerEvent( "ui:exclusiveModalOpened" )

    local wasOpen = gOpen
    gOpen = true
    SetNuiFocus( true, true )
    if not wasOpen then
        HoldFocus()
    end

    SendNUIMessage( {
        action = "punishmentModal:open",
        data = {
            reason = reason,
            title = copy.title,
            body = copy.body,
            highlight = highlight,
            footer = copy.footer,
            footerTone = copy.footerTone,
            badge = copy.badge,
            confirmLabel = copy.confirm,
        },
    } )
end

---@return nil
local function HidePunishmentModal()
    TriggerEvent( 'hud:automaticModal:cancel', 'punishment' )
    if not gOpen then return end
    gOpen = false
    SetNuiFocus( false, false )
    SendNUIMessage( { action = "punishmentModal:close" } )
end

---@return nil
function PunishmentModalClient.Register()
    RegisterNetEvent( "hud:punishmentModal:open", function( reason, substitutions )
        TriggerEvent( 'hud:automaticModal:queue', 'punishment', function()
            ShowPunishmentModal( reason, substitutions )
        end )
    end )

    RegisterNetEvent( "hud:punishmentModal:close", function()
        HidePunishmentModal()
    end )

    RegisterNUICallback( "punishmentModal:acknowledge", function( data, callback )
        local handler = data and ACK_HANDLERS[ data.reason ]
        if handler then
            handler()
        end
        HidePunishmentModal()
        callback( { ok = true } )
    end )
end

