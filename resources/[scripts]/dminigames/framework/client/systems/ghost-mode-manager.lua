---@class GhostModeManager
---Sistema de gerenciamento de Ghost Mode para minigames
---Responsável por controlar visibilidade, invencibilidade e comportamento de jogadores mortos/aguardando
GhostModeManager = class()

---Inicializa o GhostModeManager
---@param minigameName string Nome do minigame
---@param matchConfig table Configuração da partida
---@return GhostModeManager
function GhostModeManager:__init(minigameName, matchConfig)
    self.minigameName = minigameName
    self.matchConfig = matchConfig
    self.isActive = false
    self.isWaitingMode = false
    self.visibilityThread = nil
    self._shouldStopVisibility = false -- Flag para parar o loop imediatamente

    -- Listas de jogadores (referências das listas do MinigameClient)
    self.alivePlayers = {}
    self.deadPlayers = {}
    self.ghostPlayers = {}
end

---Atualiza as listas de jogadores
---@param alivePlayers table<number, number> Jogadores vivos
---@param deadPlayers table<number, number> Jogadores mortos
---@param ghostPlayers table<number, number> Jogadores aguardando
---@return nil
function GhostModeManager:updatePlayerLists(alivePlayers, deadPlayers, ghostPlayers)
    self.alivePlayers = alivePlayers
    self.deadPlayers = deadPlayers
    self.ghostPlayers = ghostPlayers
end

---Ativa o Modo Ghost (jogador morto não é visto/ouvido pelos vivos)
---@param isWaitingMode? boolean Se true, é um late join esperando (não usa SetLocalPlayerAsGhost)
---@return nil
function GhostModeManager:enable(isWaitingMode)
    isWaitingMode = isWaitingMode or false
    if self.isActive then
        return
    end

    self.isActive = true
    self.isWaitingMode = isWaitingMode

    -- Exibe notificação de ghost mode
    TriggerEvent("Notify:Text", FrameworkTranslations.get('ghost_mode_active'))

    local playerPed = PlayerPedId()
    local respawnOnDeath = self.matchConfig and self.matchConfig.respawnOnDeath == true

    -- 1. Fade-out/fade-in na tela
    local TRANSITION_TIME = 500
    DoScreenFadeOut(TRANSITION_TIME)
    Wait(TRANSITION_TIME)

    -- 2. Respawna o jogador apenas se respawnOnDeath estiver habilitado
    if respawnOnDeath then
        Wait(100)
        playerPed = PlayerPedId()
    else
        -- Se não respawnar, apenas ressurge no mesmo local
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)

        SetPedMaxHealth(playerPed, 400)
        SetEntityHealth(playerPed, 400)
        Wait(100)
        playerPed = PlayerPedId()
    end
    DoScreenFadeIn(TRANSITION_TIME)

    -- Para late join (waiting mode), NÃO usa SetLocalPlayerAsGhost
    -- Isso permite que o jogador veja todos os outros normalmente
    if not isWaitingMode then
        SetLocalPlayerAsGhost(true)
    end

    -- 3. Usa PlayerStateManager para gerenciar invencibilidade
    local stateManager = PlayerStateManager:getInstance()
    local owner = ('minigame_%s_ghost'):format(self.minigameName)
    stateManager:setInvincibility(true, owner, 90)

    -- 4. Aplica alpha semi-transparente apenas ao jogador local
    SetEntityAlpha(playerPed, 150, false)

    ClearPedTasksImmediately(playerPed)

    -- 5. Aguarda fade-in completar
    Wait(TRANSITION_TIME)

    -- 6. Atualiza visibilidade imediatamente
    self:updatePlayersVisibility()

    ClearPedTasksImmediately(playerPed)
end

---Desativa o Modo Ghost
---@return nil
function GhostModeManager:disable()
    if not self.isActive then
        return
    end

    self.isActive = false
    self.isWaitingMode = false

    -- Remove notificação
    TriggerEvent("Notify:Text", "")

    local playerPed = PlayerPedId()

    if not DoesEntityExist(playerPed) then
        return
    end

    -- Restaura alpha normal
    SetEntityAlpha(playerPed, 255, false)
    ResetEntityAlpha(playerPed)

    -- Restaura colisão do jogador local
    SetEntityVisible(playerPed, true, false)
    SetEntityCollision(playerPed, true, true)

    -- Desativa ghost mode
    SetLocalPlayerAsGhost(false)

    -- Remove invencibilidade
    local stateManager = PlayerStateManager:getInstance()
    local owner = ('minigame_%s_ghost'):format(self.minigameName)
    stateManager:removeInvincibility(owner)

    -- Restaura visibilidade de todos os jogadores
    self:restoreAllPlayersVisibility()
end

---Verifica se o ghost mode está ativo
---@return boolean
function GhostModeManager:isEnabled()
    return self.isActive
end

---Atualiza a visibilidade dos jogadores baseado no estado (vivo/morto/ghost)
---@return nil
function GhostModeManager:updatePlayersVisibility()
    local allPlayers = GetActivePlayers()
    local localPlayerId = PlayerId()
    local localServerId = GetPlayerServerId(localPlayerId)
    local isLocalPlayerDead = self.deadPlayers[localServerId] ~= nil
    local isLocalPlayerInWaiting = self.ghostPlayers[localServerId] ~= nil
    -- Jogadores em ghost mode podem ver todos (mortos por morte ou esperando próxima rodada)
    local isLocalPlayerGhost = self.isActive or isLocalPlayerDead or isLocalPlayerInWaiting

    for _, player in ipairs(allPlayers) do
        local playerServerId = GetPlayerServerId(player)
        local playerPed = GetPlayerPed(player)

        -- Se não é o próprio jogador
        if player ~= localPlayerId then
            local isPlayerAlive = self.alivePlayers[playerServerId] ~= nil
            local isPlayerDead = self.deadPlayers[playerServerId] ~= nil
            local isPlayerGhost = self.ghostPlayers[playerServerId] ~= nil

            -- Só gerencia visibilidade de jogadores que estão na partida (incluindo ghosts)
            if isPlayerAlive or isPlayerDead or isPlayerGhost then
                if isLocalPlayerGhost then
                    -- Jogador local está em ghost mode: pode ver todos (vivos, mortos e outros ghosts)
                    NetworkConcealPlayer(player, false, false)

                    -- Força a renderização do ped (necessário quando SetLocalPlayerAsGhost está ativo)
                    SetEntityVisible(playerPed, true, false)
                    SetEntityCollision(playerPed, true, true)

                    -- Aplica alpha diferenciado
                    -- Jogadores VIVOS aparecem NORMAIS (alpha 255)
                    -- Jogadores MORTOS/GHOST aparecem TRANSPARENTES (alpha 150)
                    
                    -- ✅ FIX BUG TRANSPARÊNCIA (ROBUSTEZ): 
                    -- Se jogador não estiver explicitamente marcado como morto/ghost, assume VIVO.
                    -- Isso previne transparência acidental caso a lista 'alivePlayers' desincronize.
                    local isKnownDeadOrGhost = isPlayerDead or isPlayerGhost
                    
                    if isKnownDeadOrGhost then
                         -- Apenas aplica transparência se CONFIRMADO que está morto/ghost
                        SetEntityAlpha(playerPed, 150, false)
                    else
                        -- Jogador VIVO ou DESCONHECIDO = assume VIVO (opaco)
                        SetEntityAlpha(playerPed, 255, false)
                        ResetEntityAlpha(playerPed)
                    end

                    -- Se estiver em um veículo, tornar o veículo visível também
                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if DoesEntityExist(vehicle) then
                            NetworkConcealEntity(vehicle, false)
                            SetEntityVisible(vehicle, true, false)
                            -- Aplica o mesmo alpha do jogador ao veículo
                            if isPlayerAlive then
                                SetEntityAlpha(vehicle, 255, false)
                                ResetEntityAlpha(vehicle)
                            else
                                SetEntityAlpha(vehicle, 150, false)
                            end
                        end
                    end
                else
                    -- Jogador local está vivo
                    if isPlayerAlive then
                        -- Jogador está vivo: tornar visível
                        NetworkConcealPlayer(player, false, false)

                        -- Se estiver em um veículo, tornar o veículo visível também
                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            if DoesEntityExist(vehicle) then
                                NetworkConcealEntity(vehicle, false)
                            end
                        end
                    elseif isPlayerDead then
                        -- Jogador está morto: ocultar
                        NetworkConcealPlayer(player, true, false)

                        -- Se estiver em um veículo, ocultar o veículo também
                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            if DoesEntityExist(vehicle) then
                                NetworkConcealEntity(vehicle, true)
                            end
                        end
                    elseif isPlayerGhost then
                        -- Jogador está aguardando próxima rodada: ocultar
                        NetworkConcealPlayer(player, true, false)

                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            if DoesEntityExist(vehicle) then
                                NetworkConcealEntity(vehicle, true)
                            end
                        end
                    end
                end
            end
        end
    end
end

---Inicia o loop de gerenciamento de visibilidade
---@return nil
function GhostModeManager:startVisibilityLoop()
    -- Para qualquer thread anterior se existir
    self:stopVisibilityLoop()

    self._shouldStopVisibility = false
    local TIME_TO_CHECK_MS = 500

    self.visibilityThread = CreateThread(function()
        -- Primeira atualização imediata
        self:updatePlayersVisibility()

        -- Loop contínuo enquanto estiver na partida
        -- _shouldStopVisibility permite parar imediatamente ao sair (evita piscar alpha)
        while not self._shouldStopVisibility and (self.isActive or next(self.alivePlayers) ~= nil or next(self.deadPlayers) ~= nil) do
            Wait(TIME_TO_CHECK_MS)

            if self._shouldStopVisibility then break end

            -- Atualiza visibilidade periodicamente
            self:updatePlayersVisibility()
        end

        -- Thread terminou naturalmente
        self.visibilityThread = nil
    end)
end

---Para o loop de gerenciamento de visibilidade
---Sinaliza para a thread parar na próxima iteração (evita loop continuar após sair)
---@return nil
function GhostModeManager:stopVisibilityLoop()
    self._shouldStopVisibility = true
    self.visibilityThread = nil
end

---Restaura a visibilidade de todos os jogadores (remove NetworkConceal)
---@return nil
function GhostModeManager:restoreAllPlayersVisibility()
    local allPlayers = GetActivePlayers()
    local localPlayerId = PlayerId()

    -- Só restaura visibilidade de jogadores da PARTIDA, não de todos do servidor
    for _, player in ipairs(allPlayers) do
        if player ~= localPlayerId then
            local playerServerId = GetPlayerServerId(player)
            local isInMatch = self.alivePlayers[playerServerId] or
                self.deadPlayers[playerServerId] or
                self.ghostPlayers[playerServerId]

            if isInMatch then
                local playerPed = GetPlayerPed(player)

                NetworkConcealPlayer(player, false, false)

                -- Restaura visibilidade, alpha E colisão
                -- Sem isso, jogadores ficam "intangíveis" após ghost mode
                SetEntityVisible(playerPed, true, false)
                SetEntityAlpha(playerPed, 255, false)
                ResetEntityAlpha(playerPed)
                SetEntityCollision(playerPed, true, true)

                -- Se estiver em um veículo, restaurar o veículo também
                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if DoesEntityExist(vehicle) then
                        NetworkConcealEntity(vehicle, false)
                        SetEntityVisible(vehicle, true, false)
                        SetEntityAlpha(vehicle, 255, false)
                        ResetEntityAlpha(vehicle)
                    end
                end
            end
        end
    end
end

---Limpa todos os recursos do GhostModeManager
---@return nil
function GhostModeManager:cleanup()
    self:stopVisibilityLoop()
    self:disable()
    self.alivePlayers = {}
    self.deadPlayers = {}
    self.ghostPlayers = {}
end
