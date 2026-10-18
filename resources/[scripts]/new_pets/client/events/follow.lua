--[[
Tive que fazer isso por que a forma como FiveM lida com as tasks do GTA 5 é muito ruim.
Tentei varias abordagens, mas nenhuma funcionou.
A cada vez que o jogador se move, em vez de manter a task ativa, ela é reiniciada.
Isso é muito ruim para o desempenho e a experiência do jogador.
Então, eu registrei todos os game events do GTA 5 disponibilizados pelo FiveM.
(https://docs.fivem.net/docs/game-references/game-events)
Para descobrir algum evento que me ajudasse a resolver o problema.
Agora quando o jogador se move(CEventFootStepHeard), eu verifico se a task está ativa.
Se não estiver, eu reinicio a task.
Se estiver, eu não faço nada.
Isso é muito melhor para o desempenho e a experiência do jogador.
Talvez tenha uma forma melhor de fazer isso, mas é o melhor que eu consegui pensar.

SetPedKeepTask:
Deveria manter a task ativa
Pelo menos enquanto a entidade não migrou
Mas não funciona
Vou manter aqui por desencargo de consciencia.
]]

PED_BEING_FOLLOWED = nil
PED_FOLLOWING      = nil
COOLDOWN           = 10000
NEXT_CHECK         = GetGameTimer() + COOLDOWN

---@param pet number
---@param owner number
---@param active boolean
---@return boolean, string
---@diagnostic disable-next-line: lowercase-global
setPedFollowingPed = function(pet, owner, active)
    local state = Entity(pet).state.pet_task
    
    if (state and tasks[state].action ~= 'follow') then
        return false, 'Ped is not following'
    end

    if (not active) then
        SetPedKeepTask(pet, false)
        PED_BEING_FOLLOWED = nil
        PED_FOLLOWING = nil
        return true, 'Ped following stopped'
    end

    TaskSetBlockingOfNonTemporaryEvents(pet, true)
    TaskFollowToOffsetOfEntity(
        pet, 
        owner, 
        0.0, 
        0.0, 
        0.0, 
        5.0, 
        -1, 
        10.0,
        true
    )
    TaskGoToEntityWhileAimingAtEntity(pet, owner, owner, 10.0, false, 1.0, -1, false)

    SetPedKeepTask(pet, true) 

    PED_BEING_FOLLOWED = owner
    PED_FOLLOWING = pet

    return true, 'Ped following started'
end

---@return boolean, string
local taskReset = function()
    if (GetGameTimer() < NEXT_CHECK) then
        return true, ('next check in %s ms'):format(NEXT_CHECK - GetGameTimer())
    end

    if (not PED_BEING_FOLLOWED) then
        return false, 'No pet being followed'
    end

    if (not PED_FOLLOWING) then
        return false, 'No ped following'
    end

    if (not DoesEntityExist(PED_BEING_FOLLOWED)) then
        return false, 'Pet not found'
    end

    if (not DoesEntityExist(PED_FOLLOWING)) then
        return false, 'Ped not found'
    end

    if (not IsEntityAPed(PED_BEING_FOLLOWED)) then
        return false, 'Pet is not a ped'
    end

    if (not IsEntityAPed(PED_FOLLOWING)) then
        return false, 'Ped is not a ped'
    end

    if (not IsPedAPlayer(PED_BEING_FOLLOWED)) then
        return false, 'Ped being followed is not a player'
    end

    local taskStatus = GetScriptTaskStatus(PED_FOLLOWING, 0x3EF867F4)

    if taskStatus ~= 7 then
        return false, 'Task is active'
    end

    TaskFollowToOffsetOfEntity(
        PED_FOLLOWING, 
        PED_BEING_FOLLOWED, 
        0.0, 
        0.0, 
        0.0, 
        20.0, 
        -1, 
        10.0,
        true
    )
    TaskGoToEntityWhileAimingAtEntity(PED_FOLLOWING, PED_BEING_FOLLOWED, PED_BEING_FOLLOWED, 10.0, false, 1.0, -1, false)
    SetPedKeepTask(PED_FOLLOWING, true)

    local dist = #(GetEntityCoords(PED_FOLLOWING) - GetEntityCoords(PED_BEING_FOLLOWED))

    if ( dist > config.warpDistance ) then
        TriggerServerEvent('pets.server:warp', NetworkGetNetworkIdFromEntity(PED_FOLLOWING))
    end

    NEXT_CHECK = GetGameTimer() + COOLDOWN

    return true, 'Task reset'
end

---@param entity number
---@return boolean, string
---@diagnostic disable-next-line: lowercase-global
taskFollow = function(entity)
    if (not PED_BEING_FOLLOWED) then return false, 'No pet being followed' end
    if (not PED_FOLLOWING) then return false, 'No ped following' end
    -- Se a entidade que fez o passo é o jogador sendo seguido
    -- Apenas o client sendo seguido precisa setar a task
    if (entity ~= PED_BEING_FOLLOWED) then return false, 'Entity is not the pet being followed' end
    if (PED_BEING_FOLLOWED ~= PlayerPedId()) then return false, 'Player is not the pet being followed' end

    local success, err = taskReset()

    return true, 'Task follow'
end


RegisterNetEvent('CEventFootStepHeard', function(p1, entity, p3, p4, p5, p6, p7)
    taskFollow(entity)
end)

RegisterNetEvent('pets.client:whistle', function() 
    local success, err = taskFollow(PlayerPedId())

    if (not success) then
        return
    end


    TriggerEvent('Notify', 'Pets', _t('whistle_pet'), 5000)
end)