local jumpForce = 18.0 -- pulo mais alto
local rotationTime = 1800 -- mais tempo para o flip (1.8s)
local flipAngle = 360.0 -- ângulo do flip
local isJumpStarted = false

-- Função de easing (ease-in-out cúbico)
local function EaseInOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    else
        return 1 - math.pow(-2 * t + 2, 3) / 2
    end
end

-- Função genérica de flip com suavização
function DoFlip(vehicle, axis, angle)
    local startRot = GetEntityRotation(vehicle, 2)
    local startTime = GetGameTimer()

    Citizen.CreateThread(function()
        while GetGameTimer() - startTime < rotationTime do
            local elapsed = GetGameTimer() - startTime
            local progress = elapsed / rotationTime
            if progress > 1.0 then progress = 1.0 end

            local eased = EaseInOutCubic(progress)

            local newX = startRot.x
            local newY = startRot.y
            local newZ = startRot.z

            if axis == "roll" then
                newY = startRot.y + angle * eased -- lateral
            elseif axis == "pitch" then
                newX = startRot.x + angle * eased -- frontal
            end

            SetEntityRotation(vehicle, newX, newY, newZ, 2, true)
            Citizen.Wait(0)
        end

        -- garante que termine exatamente no final do giro
        if axis == "roll" then
            SetEntityRotation(vehicle, startRot.x, startRot.y + angle, startRot.z, 2, true)
        elseif axis == "pitch" then
            SetEntityRotation(vehicle, startRot.x + angle, startRot.y, startRot.z, 2, true)
        end
    end)
end

-- Função genérica de comando
function RegisterFlipCommand(cmd, axis, angle)
    RegisterCommand(cmd, function(source, args, rawCommand)
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        if not isJumpStarted then
            return
        end
        if vehicle and vehicle ~= 0 then
            -- aplica pulo mais alto e suave
            ApplyForceToEntity(vehicle, 1, 0.0, 0.0, jumpForce, 0.0, 0.0, 0.0, true, true, true, true, false, true)
            Citizen.Wait(10) -- espera mais antes de girar
            DoFlip(vehicle, axis, angle)
        else
            TriggerEvent('chat:addMessage', { args = {"Você precisa estar dentro de um veículo!"} })
        end
    end, false)
end

-- Registrando comandos
RegisterFlipCommand("esquerda", "roll", -360)   -- lateral esquerda
RegisterFlipCommand("direita", "roll", 360)   -- lateral direita
RegisterFlipCommand("frente", "pitch", -360)    -- flip frontal
RegisterFlipCommand("tras", "pitch", 360)     -- flip traseiro


--- @param forceValue number
RegisterNetEvent("jump:skp", function( forceValue )
    if isJumpStarted then
        isJumpStarted = false
    else
        isJumpStarted = true
        CreateThread(function()
            while isJumpStarted do
                Wait(1)
        
                local playerPed = PlayerPedId()
        
        
                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                        if IsControlJustPressed(0, 110) then
                            ApplyForceToEntity(vehicle, 1, 0.0, 0.0, forceValue, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                        end
                    end
                end
            end
        end)
    end
end)

