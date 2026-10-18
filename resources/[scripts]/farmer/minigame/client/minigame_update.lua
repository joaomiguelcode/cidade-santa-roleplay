local MAX_DURATION_TO_BE_INVINCIBLE = 1 * 60

---@param minigame Minigame
---@param diffSeconds number
local function UpdateDelayedMinigameProtection(minigame, diffSeconds)
    local hasReachedActivationDelay = diffSeconds >= minigame.def.protectionActivationDelay

    if not minigame.isProtectionActive and not hasReachedActivationDelay then
        return
    end

    minigame.isProtectionActive = true

    if minigame.def.flags & eMinigameDefFlags.MDF_FLAG_PLAYER_INVINCIBLE ~= 0 then
        if not LocalPlayer.state['Invincible'] then
            LocalPlayer.state['Invincible'] = true
            SetLocalPlayerAsGhost(true)
            SetEntityInvincible(PlayerPedId(), true)
        end
    end

    if minigame.def.flags & eMinigameDefFlags.MDF_FLAG_COLLISION_ENTITIES ~= 0 then
        OnToggleCollisionEntities(false)
    end
end

---@param enable boolean
function OnToggleCollisionEntities(enable)
    enable = not enable

    local player = PlayerPedId()
    
    for _, entity in pairs(GetGamePool('CPed')) do
        if entity ~= player then
            SetEntityNoCollisionEntity(entity, player, enable)
        end
    end
    
    for _, entity in pairs(GetGamePool('CVehicle')) do
        SetEntityNoCollisionEntity(entity, player, enable)
    end
end

---Update executado a cada frame enquando tiver um Minigame ativo!
---@param minigame Minigame
function OnUpdateMinigame( minigame )

    -- TODO: Cancelar o minigame caso o jogador não esteja executando a animação?

    if not minigame.isStarted then

        -- "E" foi pressionado nesse frame?
        --
        -- Quando a duração do minigame for <= 0, a gente permite que o minigame seja iniciado
        -- sem que o jogador pressione uma tecla.
        -- isso é utilizado atualmente para os minigames de rota
        if minigame.def.duration <= 0 or IsControlJustPressed( 0, 38 ) then

            if CanStartMinigameClient( minigame ) == eMinigameStartStatus.OK then

                RequestStartMinigame( minigame )
            end
        end

    elseif minigame.isStarted then
        if minigame.def.protectionActivationDelay then
            local diffSeconds = (GetServerTime() - minigame.startedAtMs) / 1000

            UpdateDelayedMinigameProtection(minigame, diffSeconds)
        elseif minigame.def.flags & eMinigameDefFlags.MDF_FLAG_PLAYER_INVINCIBLE ~= 0 then
            local diffSeconds = (GetServerTime() - minigame.enterAtMs) / 1000

            -- print('OnUpdateMinigame:: can complete duration invincible after duration', diffSeconds)

            if diffSeconds >= MAX_DURATION_TO_BE_INVINCIBLE then
                if not LocalPlayer.state['Invincible'] then
                    LocalPlayer.state['Invincible'] = true
                    SetLocalPlayerAsGhost(true)
                    SetEntityInvincible(PlayerPedId(), true)
                end
            end
        end

        if not minigame.def.protectionActivationDelay
            and minigame.def.flags & eMinigameDefFlags.MDF_FLAG_COLLISION_ENTITIES ~= 0
        then
            OnToggleCollisionEntities(false)
        end

        local status = CanCompleteMinigame( minigame )

        -- print('OnUpdateMinigame :: can complete status', status)

        if status == eMinigameCompleteStatus.OK then

            RequestCompleteMinigame( minigame )
        else

            if 
                status == eMinigameCompleteStatus.ERR_INVENTORY_FULL or
                status == eMinigameCompleteStatus.ERR_REQUIREMENTS_NOT_MET
            then

                local statusMessage = GetMinigameCompleteStatusMessage( status )

                assert( statusMessage )

                if statusMessage ~= '' then
                    TriggerEvent( 'Notify', 'vermelho', statusMessage, 5000, 'Minigames' )
                end

                -- Finalizar minigame para erros críticos
                RequestEndMinigame( minigame )
            end
        end
    end
end
