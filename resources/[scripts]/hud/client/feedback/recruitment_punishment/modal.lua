-- Ponte Lua do modal de punição (React em `apps/huds/ui/recruitment-punishment`, portado do
-- `new_hub` em ENG-3161 sem lado Lua). Contrato NUI: `recruitmentPunishment:open`/`:close` e o
-- callback `recruitmentPunishment:acknowledge`.
---@class RecruitmentPunishmentModalClientApi
RecruitmentPunishmentModalClient = {}

-- Os nomes das variantes vêm do desenho original (tipo de suspensão), mas quem escolhe é o
-- ESTÁGIO do card: permanent = 4 fatos + Entendi; timed = 4 dicas + Estou ciente.
local VARIANT_BY_CARD = {
    risk = "permanent",
    last_warning = "timed",
}

-- Bloqueante: confirmar é a única saída.
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

---@return nil
local function Close()
    TriggerEvent( 'hud:automaticModal:cancel', 'recruitment' )
    if not gOpen then return end
    gOpen = false
    SetNuiFocus( false, false )
    SendNUIMessage( { action = "recruitmentPunishment:close" } )
end

---@param cardType string -- "risk" | "last_warning"
---@param remaining string? -- prazo já formatado; só a variante "timed" exibe
---@return boolean opened
local function OpenNow( cardType, remaining )
    local variant = VARIANT_BY_CARD[ cardType ]

    if not variant then
        -- sx.logger:warn( ( "hud recruitment punishment modal sem variante pro card=%s" ):format(
            -- tostring( cardType ) ) )
        return false
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
        action = "recruitmentPunishment:open",
        data = { variant = variant, remaining = remaining },
    } )

    return true
end

---@param cardType string
---@param remaining string?
---@return boolean queued
function RecruitmentPunishmentModalClient.Open( cardType, remaining )
    if not VARIANT_BY_CARD[cardType] then return false end
    TriggerEvent( 'hud:automaticModal:queue', 'recruitment', function()
        OpenNow( cardType, remaining )
    end )
    return true
end

---@return nil
function RecruitmentPunishmentModalClient.Register()
    -- O botão não devolve permissão: só registra a leitura. Quem tira o card é o servidor.
    RegisterNUICallback( "recruitmentPunishment:acknowledge", function( _data, callback )
        TriggerServerEvent( "recruitment_punishment:acknowledge" )
        Close()
        callback( { ok = true } )
    end )

    RegisterNetEvent( "hud:recruitmentPunishmentModal:close", Close )
end


