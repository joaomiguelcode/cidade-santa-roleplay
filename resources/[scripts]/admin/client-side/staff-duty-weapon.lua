-- Toggle /staff (ENG-3714/ENG-3725): staff em serviço não saca arma em nenhum mundo, exceto os
-- cargos de `weaponExempt` no `data/staff-duty.json`.
--
-- O bloqueio fica nesta flag local, escrita pelo server via `admin:staffDuty:sync` já com a
-- isenção por cargo resolvida -- o client não conhece a config.
-- Não é a state bag de propósito: o bloqueio precisa responder no mesmo frame do saque e a bag
-- depende de replicação. A bag `staffOnDuty` continua existindo para quem lê do server (o wall).
--
-- Quem de fato recusa o saque é o `inventory`, no topo de `putWeaponHands` -- ele é o único
-- caminho de arma na mão. O loop aqui embaixo é só rede de segurança para arma que venha por
-- fora do inventory.

local STAFF_DUTY_ATTEMPT_COOLDOWN_MS = 1500

local gBlockWeapon = false
local gStaffDutyLastAttempt = 0
-- ENG-3717: guardar a arma leva alguns frames; sem isto o loop avisaria o server todo frame
-- enquanto o ped ainda esta armado, e o modal reabriria com a contagem "reiniciando".
local gWasArmed = false

---@return boolean
local function ShouldBlockWeapon()
    return gBlockWeapon
end

-- O inventory tem máquina de estado própria pra arma equipada; guardar por `SetCurrentPedWeapon`
-- cru deixaria o inventory achando que a arma ainda está na mão.
---@return nil
local function HolsterWeapon()
    TriggerEvent( "inventory:CleanWeapons" )
end

-- Com debounce: o server responde abrindo o modal 05 e gravando a tentativa, e sem isto um
-- saque segurado geraria um log por frame.
---@return nil
local function ReportAttempt()
    local now = GetGameTimer()

    if now - gStaffDutyLastAttempt < STAFF_DUTY_ATTEMPT_COOLDOWN_MS then
        return
    end

    gStaffDutyLastAttempt = now
    TriggerServerEvent( "admin:staffDuty:weaponAttempt" )
end

RegisterNetEvent( "admin:staffDuty:sync", function( blockWeapon )
    gBlockWeapon = blockWeapon == true

    -- Entrou em serviço já armado: guarda na hora, sem modal.
    if ShouldBlockWeapon() and IsPedArmed( PlayerPedId(), 7 ) then
        HolsterWeapon()
    end
end )

-- Consumido pelo `inventory` no topo de `putWeaponHands`. Devolve true quando o saque deve ser
-- recusado, e já avisa o server -- quem chama só precisa do boolean.
exports( "StaffDutyWeaponBlock", function()
    if not ShouldBlockWeapon() then
        return false
    end

    ReportAttempt()

    return true
end )

-- Rede de segurança: arma que entre por fora do `inventory` (native de outro script, roda de
-- armas do GTA). Fora do bloqueio o loop dorme em 500ms.
CreateThread( function()
    while true do
        local interval = 500

        if ShouldBlockWeapon() then
            interval = 0

            local ped = PlayerPedId()

            DisablePlayerFiring( PlayerId(), true )
            SetCanPedEquipAllWeapons( ped, false )
            DisableControlAction( 0, 24, true )  -- INPUT_ATTACK
            DisableControlAction( 0, 257, true ) -- INPUT_ATTACK2
            DisableControlAction( 0, 37, true )  -- INPUT_SELECT_WEAPON (roda de armas)

            local armed = IsPedArmed( ped, 7 )

            if armed and not gWasArmed then
                HolsterWeapon()
                ReportAttempt()
            end

            gWasArmed = armed
        else
            gWasArmed = false
        end

        Wait( interval )
    end
end )
