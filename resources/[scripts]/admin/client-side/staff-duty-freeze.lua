-- Toggle /staff (ENG-3729): congelado com barra por `freezeSeconds` ao entrar/sair de serviço.
-- ENG-3736: a mesma barra serve pro NC em serviço (`ncFreezeSeconds`); `kind` troca o texto.
--
-- O server é dono do tempo e da troca: só muda o estado quando o timer dele termina. Aqui só
-- congela, mostra a barra (HUD) e avisa se tomou dano ou morreu, o que cancela a troca.

local gFreezing = false

-- ENG-3786: na barra do NC o staff segue parado, mas com teclado/chat livres pra usar comando
-- (wall). So movimento, pulo, ataque e veiculo ficam desligados, nos grupos 0 e 1 (NC do vRP).
local NOCLIP_BLOCKED_CONTROLS = { 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 36, 44, 75, 140, 141, 142, 257, 263, 264 }
local CONTROL_CANCEL_NOCLIP = 167 -- F6

---@return nil
local function StopFreeze()
    gFreezing = false
    FreezeEntityPosition( PlayerPedId(), false )
    TriggerEvent( "hud:staffDuty:progress", false )
end

-- Dano = vida ou colete abaixo da última leitura. Vida subindo (regen, cura) só vira a nova base.
-- Já entrar morto também cancela: é o abuso de morrer e entrar em serviço pra usar god.
---@param entering boolean
---@param seconds integer
---@param kind string? -- "duty" | "noclip"
---@return nil
local function StartFreeze( entering, seconds, kind )
    if gFreezing then return end

    gFreezing = true

    local ped = PlayerPedId()
    local health = GetEntityHealth( ped )
    local armour = GetPedArmour( ped )
    local endsAt = GetGameTimer() + seconds * 1000

    FreezeEntityPosition( ped, true )
    TriggerEvent( "hud:staffDuty:progress", true, entering, seconds, kind )

    CreateThread( function()
        while gFreezing and GetGameTimer() < endsAt do
            ped = PlayerPedId()

            local nowHealth = GetEntityHealth( ped )
            local nowArmour = GetPedArmour( ped )

            if IsEntityDead( ped ) or nowHealth <= 100 or nowHealth < health or nowArmour < armour then
                TriggerServerEvent( "admin:staffDuty:freezeCancel" )
                break
            end

            health, armour = nowHealth, nowArmour

            if kind == "noclip" then
                for _, control in ipairs( NOCLIP_BLOCKED_CONTROLS ) do
                    DisableControlAction( 0, control, true )
                    DisableControlAction( 1, control, true )
                end

                -- F6 cancela so a entrada; o server nao conta como troca no progressivo.
                if entering and IsControlJustPressed( 0, CONTROL_CANCEL_NOCLIP ) then
                    TriggerServerEvent( "admin:staffDuty:freezeCancel" )
                    break
                end
            else
                -- Tudo desligado menos câmera, voz e pause: não anda, não atira, não abre chat.
                -- O grupo 1 também, porque o NC do vRP lê o movimento por `IsControlPressed(1, ...)`.
                DisableAllControlActions( 0 )
                DisableAllControlActions( 1 )
                EnableControlAction( 0, 1, true )   -- INPUT_LOOK_LR
                EnableControlAction( 0, 2, true )   -- INPUT_LOOK_UD
                EnableControlAction( 0, 249, true ) -- INPUT_PUSH_TO_TALK
                EnableControlAction( 0, 200, true ) -- INPUT_FRONTEND_PAUSE_ALTERNATE (ESC)
            end

            Wait( 0 )
        end

        StopFreeze()
    end )
end

RegisterNetEvent( "admin:staffDuty:freeze", StartFreeze )

AddEventHandler( "onResourceStop", function( resourceName )
    if resourceName == GetCurrentResourceName() and gFreezing then
        StopFreeze()
    end
end )
