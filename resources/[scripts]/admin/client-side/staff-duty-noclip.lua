-- Toggle /staff (ENG-3734): em serviço (não isento) o NC não cai.
--
-- NC desligado (bag `psnc` false) o server religa sozinho, no handler da bag no `core.lua`.
-- O que sobra pro client é o caso em que o NC continua "ligado" mas o ped foi sentado num
-- veículo (`/car`, `/vehedit`, tp com carro): o garages usa `SetPedIntoVehicle` e o movimento
-- do NC para. Aqui o ped sai do banco na hora e o estado do NC é reaplicado.

local gLockNoclip = false

RegisterNetEvent( "admin:staffDuty:sync", function( _, lockNoclip )
    gLockNoclip = lockNoclip == true
end )

CreateThread( function()
    while true do
        if gLockNoclip and LocalPlayer.state.psnc then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn( ped, false )

            if vehicle ~= 0 then
                TaskLeaveVehicle( ped, vehicle, 16 ) -- 16: sai teleportado, sem animação
                Wait( 100 )
                vRP.ReapplyNoClip()
            end
        end

        Wait( 250 )
    end
end )
