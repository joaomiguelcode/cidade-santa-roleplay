--[[
    Notes: Ainda não foi testado com o chamado do smartphone.
]]

local qruStarted = false

---@param location vector3 | { x: number, y: number, z: number }
RegisterNetEvent("missions:client:policeQruStarted", function(location)
    if not MissionInProgress("ramo_primeira_patrulha") then return end
    
    if qruStarted then
        qruStarted = false
        Wait(1000)
    end

    qruStarted = true

    CreateThread(function()
        while qruStarted do
            local coords = GetEntityCoords(cache.ped)
            local distance = #(coords - vec3(location.x, location.y, location.z))
            if distance < 10.0 then
                TriggerServerEvent("missions:server:policeQruCompleted")
                qruStarted = false
                break
            end

            Wait(1000)
        end
    end)
end)