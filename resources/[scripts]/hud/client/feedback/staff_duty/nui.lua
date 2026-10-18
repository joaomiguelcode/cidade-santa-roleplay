-- Modal "fora de serviço" do toggle /staff (ENG-3704). React em `apps/huds/ui/staff-duty`.
-- Bloqueante: só sai por um dos dois botões. O server é quem decide quando abrir.
--
-- ponytail: não entra na fila `hud:automaticModal:queue` de propósito. Aquela fila espera o
-- sync da toxicidade e este modal precisa abrir no mesmo instante em que o comando foi negado.

---@class StaffDutyModalClientApi
StaffDutyModalClient = {}

local Translate = TranslateFeedbackHighlighted

local gOpen = false
local gVariant = "offDuty"

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

-- Textos por variante. `offDuty` e a tela 01/02 (entrar); `onDuty` e a 05/06 (sair, pedida
-- pela tentativa de sacar arma).
local STAFF_DUTY_VARIANTS = {
    offDuty = {
        key = "hud.staff_duty",
        confirmTone = "accent",
        icon = "shieldAlert",
        hint = true,
    },
    onDuty = {
        key = "hud.staff_duty.on_duty",
        confirmTone = "neutral",
        icon = "shieldCheck",
        hint = false,
    },
    -- ENG-3885: alerta de area restrita (god em QG). Confirmar executa o comando em espera no server.
    restrictedArea = {
        key = "hud.staff_duty.restricted_area",
        confirmTone = "accent",
        icon = "shieldAlert",
        hint = false,
    },
}

-- `{cmd}` vira uma <code> pra o React estilizar como pílula mono, igual ao selo.
---@return string
local function StaffDutyHint()
    return ( Translate( "hud.staff_duty.hint" ):gsub( "{cmd}", "<code>/staff</code>" ) )
end

---@param payload table?
---@return nil
local function ShowStaffDutyModal( payload )
    payload = type( payload ) == "table" and payload or {}

    local variant = STAFF_DUTY_VARIANTS[ payload.variant ] or STAFF_DUTY_VARIANTS.offDuty
    local cooldown = tonumber( payload.cooldownSeconds ) or 0

    TriggerEvent( "ui:exclusiveModalOpened" )

    local wasOpen = gOpen
    gOpen = true
    gVariant = STAFF_DUTY_VARIANTS[ payload.variant ] and payload.variant or "offDuty"
    SetNuiFocus( true, true )

    if not wasOpen then
        HoldFocus()
    end

    SendNUIMessage( {
        action = "staffDuty:open",
        data = {
            variant = gVariant,
            icon = variant.icon,
            confirmTone = variant.confirmTone,
            badge = _t( "hud.staff_duty.badge" ),
            title = Translate( variant.key .. ".title" ),
            body = Translate( variant.key .. ".body" ),
            footer = Translate( variant.key .. ".footer" ),
            -- So as telas de entrar ensinam a sair; no modal de arma a saida ja e o botao.
            hint = variant.hint and StaffDutyHint() or nil,
            confirmLabel = _t( variant.key .. ".confirm" ),
            dismissLabel = _t( variant.key .. ".dismiss" ),
            -- Espera: o botao principal vira contagem. O server revalida na resposta, entao
            -- isto e so apresentacao. Vai SEMPRE como numero (ENG-3723): com nil, o React
            -- fazia spread por cima do estado anterior e reaproveitava a contagem velha.
            cooldownSeconds = cooldown,
            cooldownLabel = _t( "hud.staff_duty.cooldown" ),
        },
    } )
end

---@return nil
local function HideStaffDutyModal()
    if not gOpen then return end

    gOpen = false
    SetNuiFocus( false, false )
    SendNUIMessage( { action = "staffDuty:close" } )
end

---@return nil
function StaffDutyModalClient.Register()
    RegisterNetEvent( "hud:staffDuty:open", function( payload )
        ShowStaffDutyModal( payload )
    end )

    RegisterNetEvent( "hud:staffDuty:badge", function( onDuty )
        SendNUIMessage( {
            action = "staffDuty:badge",
            data = {
                visible = onDuty == true,
                label = _t( "hud.staff_duty.badge_label" ),
                hint = _t( "hud.staff_duty.badge_hint" ),
                command = "/staff",
            },
        } )
    end )

    RegisterNetEvent( "hud:staffDuty:close", function()
        HideStaffDutyModal()
    end )

    -- ENG-3729: barra de entrada/saída de serviço. Local (sem rede): quem dispara é o freeze do
    -- `admin` no client, que é quem sabe quando ela começa e quando foi cancelada.
    -- ENG-3736: `kind = "noclip"` é a mesma barra pro NC em serviço, só troca o texto.
    AddEventHandler( "hud:staffDuty:progress", function( visible, entering, seconds, kind )
        local prefix = kind == "noclip" and "hud.staff_duty.progress_nc_" or "hud.staff_duty.progress_"

        SendNUIMessage( {
            action = "staffDuty:progress",
            data = {
                visible = visible == true,
                entering = entering == true,
                seconds = tonumber( seconds ) or 0,
                label = _t( prefix .. ( entering and "enter" or "leave" ) ),
            },
        } )
    end )

    RegisterNUICallback( "staffDuty:choice", function( data, callback )
        local accepted = data and data.accepted == true

        if gVariant == "onDuty" then
            -- Sempre avisa o server: a escolha entra no log mesmo quando foi "continuar".
            TriggerServerEvent( "admin:staffDuty:weaponChoice", accepted )
        elseif gVariant == "restrictedArea" then
            -- Cancelar tambem vai pro log.
            TriggerServerEvent( "admin:staffDuty:areaChoice", accepted )
        elseif accepted then
            TriggerServerEvent( "admin:staffDuty:enter" )
        end

        HideStaffDutyModal()
        callback( { ok = true } )
    end )
end

-- Fora do bootstrap do feedback gamificado: o gate de comando vale em toda cidade, mesmo onde
-- `GAMIFIED_FEEDBACK_ENABLED` está desligado.
StaffDutyModalClient.Register()
