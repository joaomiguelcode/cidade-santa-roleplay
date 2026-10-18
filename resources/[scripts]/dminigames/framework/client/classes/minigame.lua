---@class MinigameKillfeedEntry
---@field id? number
---@field matchId? number
---@field killer string
---@field victim string
---@field weapon? string|number
---@field isHeadshot? boolean
---@field isKillStreak? boolean
---@field killerSource? number
---@field killerPassport? number Passaporte do autor do abate
---@field victimSource? number
---@field victimPassport? number Passaporte da vitima do abate
---@field killerKills? number
---@field killerTeamStr? string
---@field victimTeamStr? string

---@class MatchStartData
---@field players table<number, number> Tabela com todos os jogadores da partida [source] = userId
---@field matchId number ID único da partida
---@field teams? table<string, table<number, number>> Times organizados por role (se houver)
---@field playerRole? string Role do jogador (se houver times)
---@field queueId? number ID da fila que originou a partida

---@class MatchEndData
---@field source number ID do servidor do jogador
---@field userId number ID do usuário no sistema (vRP)
---@field players table<number, number> Tabela com todos os jogadores que estavam na partida [source] = userId
---@field matchId number ID único da partida
---@field matchDuration number Duração da partida em ms
---@field teams? table<string, table<number, number>> Times finais (se houver)
---@field playerRole? string Role do jogador (se houver times)
---@field returnCoords? vector4 Coordenada de retorno configurada no role do jogador
---@field queueId? number ID da fila que originou a partida

---@class MatchLateJoinData
---@field userId number ID do usuário que entrou
---@field matchId number ID único da partida
---@field players table<number, number> Jogadores atuais da partida
---@field teams? table<string, table<number, number>> Times (se houver)
---@field matchDuration number Tempo decorrido desde o início em ms
---@field playerRole? string Role atribuído (se houver times)
---@field queueId? number ID da fila que originou a partida

---@class MatchDisconnectData
---@field userId number ID do usuário que desconectou
---@field matchId number ID único da partida
---@field remainingPlayers table<number, number> Jogadores restantes na partida
---@field teams? table<string, table<number, number>> Times atualizados (se houver)
---@field matchDuration number Tempo decorrido desde o início em ms
---@field queueId? number ID da fila que originou a partida

---@class MatchPlayerDeathData
---@field source number ID do servidor do jogador que morreu
---@field userId number ID do usuário que morreu
---@field matchId number ID único da partida
---@field attacker? number ID da entidade que causou a morte (opcional)
---@field weapon? string Hash da arma usada (opcional)
---@field playerRole? string Role do jogador que morreu (se houver times)

---@class MatchAddData
---@field source number ID do servidor do jogador que foi adicionado
---@field userId number ID do usuário que foi adicionado
---@field matchId number ID único da partida
---@field players table<number, number> Jogadores atuais da partida (após adicionar)
---@field teams? table<string, table<number, number>> Times (se houver)
---@field playerRole? string Role atribuído ao jogador (se houver times)
---@field matchDuration number Tempo decorrido desde o início em ms
---@field queueId? number ID da fila que originou a partida

---@class MatchRemoveData
---@field source number ID do servidor do jogador que foi removido
---@field userId number ID do usuário que foi removido
---@field matchId number ID único da partida
---@field remainingPlayers table<number, number> Jogadores restantes na partida (após remover)
---@field teams? table<string, table<number, number>> Times atualizados (se houver)
---@field playerRole? string Role do jogador removido (se houver times)
---@field returnCoords? vector4 Coordenada de retorno configurada no role do jogador
---@field matchDuration number Tempo decorrido desde o início em ms
---@field queueId? number ID da fila que originou a partida
---@field reason? string Motivo da remoção: 'voluntary', 'disconnect' (opcional)

---@class RoundStartData
---@field roundNumber number Número da rodada atual
---@field players table<number, number> Tabela com todos os jogadores da rodada [source] = userId
---@field matchId number ID único da partida
---@field teams? table<string, table<number, number>> Times organizados por role (se houver)
---@field playerRole? string Role do jogador (se houver times)
---@field queueId? number ID da fila que originou a partida

---@class RoundEndData
---@field roundNumber number Número da rodada que terminou
---@field matchId number ID único da partida
---@field winnerTeam? string Nome do time vencedor (se houver times) ou nil se empate/tempo
---@field players table<number, number> Tabela com todos os jogadores da rodada [source] = userId
---@field teams? table<string, table<number, number>> Times finais (se houver)
---@field roundDuration number Duração da rodada em ms
---@field reason string Motivo do fim: 'team_elimination', 'time_limit'
---@field queueId? number ID da fila que originou a partida

---@class PlayerWaitingNextRoundData
---@field userId number ID do usuário no sistema (vRP)
---@field matchId number ID único da partida
---@field queueId? number ID da fila que originou a partida

---@class MatchDownedStateConfig
---@field animationDict? string Dicionario da animacao usada enquanto abatido
---@field animationName? string Nome da animacao usada enquanto abatido
---@field invincibilityPriority? integer Prioridade no PlayerStateManager
---@field collision? boolean Mantem a colisao do jogador enquanto abatido (padrao: true)

---@class MatchClientConfig
---@field enableKillfeed? boolean Exibe o killfeed compartilhado (padrao: false)
---@field onKillfeed? fun(data: MinigameKillfeedEntry) Efeitos locais adicionais, sem reenviar a linha do feed
---@field respawnOnDeath? boolean Se deve respawnar automaticamente quando o jogador morre (padrão: false)
---@field downedState? boolean|MatchDownedStateConfig Mantem o jogador abatido com camera livre ate o modo reviver ou iniciar outra rodada
---@field reportDamage? boolean Se deve enviar eventos de dano ao server para stats/assistencias
---@field introGracePeriod? number Tempo de folga em ms para intro do cliente (padrão: 0)
---@field onStart? fun(data: MatchStartData): nil Callback quando a partida inicia
---@field onEnd? fun(data: MatchEndData): nil Callback quando a partida termina (chamado para cada jogador)
---@field onLateJoin? fun(data: MatchLateJoinData): nil Callback quando um jogador entra tardiamente (chamado no jogador que entrou)
---@field onPlayerDisconnect? fun(data: MatchDisconnectData): nil Callback quando um jogador desconecta (chamado nos outros jogadores)
---@field onPlayerDeath? fun(data: MatchPlayerDeathData): nil Callback quando o jogador morre (chamado no jogador que morreu)
---@field onAdd? fun(data: MatchAddData): nil Callback quando um jogador é adicionado à partida
---@field onRemove? fun(data: MatchRemoveData): nil Callback quando um jogador é removido da partida
---@field onRoundStart? fun(data: RoundStartData): nil Callback quando uma rodada inicia
---@field onRoundEnd? fun(data: RoundEndData): nil Callback quando uma rodada termina
---@field onPlayerWaitingNextRound? fun(data: PlayerWaitingNextRoundData): nil Callback quando um jogador entra em modo fantasma de espera
---@field onLocalPlayerEnteredVehicle? fun(vehicle: number, ped: number): nil Callback quando o jogador local entra em um veiculo durante o modo

---@class MinigameClientData
---@field name string Nome do minigame
---@field conversation? ConversationData Configuração da conversa (opcional)
---@field queue? QueueConfig Configuração da fila (opcional)
---@field match? MatchClientConfig Configuração da partida (opcional)

---@class MinigameClient
---@field name string Nome do minigame
---@field conversation ConversationManager Gerenciador de conversas
---@field queue QueueManager Gerenciador de fila
---@field camera CameraManager Gerenciador de câmera
---@field matchConfig? MatchClientConfig Configuração da partida
---@field ghostMode boolean Se o jogador está em modo ghost
---@field visibilityThread? thread Thread do loop de gerenciamento de visibilidade
---@field matchBindsThread? thread Thread dos controles durante a partida
---@field alivePlayers table<number, number> Tabela de jogadores vivos [serverId] = userId
---@field deadPlayers table<number, number> Tabela de jogadores mortos [serverId] = userId
---@field ghostPlayers table<number, number> Tabela de jogadores em ghost mode/late join [serverId] = userId
---@field downedPlayerManager? DownedPlayerManager
---@field currentState string Estado atual do cliente (GameState)
---@field pendingTimeouts table<number> Lista de IDs de timeouts pendentes
---@field shouldStopThreads boolean Flag para parar threads em execução

-- Tabela global para armazenar todas as instâncias de minigames
MinigameInstances = {}
MinigameDamageReportEnabled = MinigameDamageReportEnabled or {}

local MINIGAME_PED_MAX_HEALTH = 400
local MINIGAME_PED_BASE_HEALTH = 100

local function setMinigamePedFullHealth(ped)
    if not DoesEntityExist(ped) then return end

    SetPedMaxHealth(ped, MINIGAME_PED_MAX_HEALTH)
    SetEntityHealth(ped, MINIGAME_PED_MAX_HEALTH)
end

local function isMinigamePedDeadOrDying(ped)
    return DoesEntityExist(ped) and (
        IsEntityDead(ped) or
        IsPedDeadOrDying(ped, true) or
        GetEntityHealth(ped) <= MINIGAME_PED_BASE_HEALTH
    )
end

---Força refresh do interior na posição do jogador (evita tela preta)
---@param delayMs number? Delay em ms antes de executar (para aguardar spawn)
local function refreshInteriorAtPlayer(delayMs)
    CreateThread(function()
        Wait(delayMs or 0)
        local ped = PlayerPedId()
        if not DoesEntityExist(ped) then return end
        local coords = GetEntityCoords(ped)
        local interiorID = GetInteriorAtCoords(coords.x, coords.y, coords.z)
        if interiorID ~= 0 then
            RefreshInterior(interiorID)
            PinInteriorInMemory(interiorID)
        end
    end)
end

local function setTeamVoiceRadioChannel(channel)
    if GetResourceState('pma-voice') ~= 'started' then return end

    channel = tonumber(channel) or 0

    if channel > 0 then
        exports['pma-voice']:setRadioChannel(channel)
    else
        exports['pma-voice']:removePlayerFromRadio()
    end
end

RegisterNetEvent('dminigames:teamVoice:setRadioChannel', setTeamVoiceRadioChannel)

MinigameClient = class()

local gKillfeedWeaponNamesByHash = nil

---@param data MinigameKillfeedEntry
function MinigameClient:AddKillfeedItem( data )
    if not self.matchConfig or not self.matchConfig.enableKillfeed or type( data ) ~= 'table' then
        return
    end

    local weapon = data.weapon
    local weaponHash = math.tointeger( tonumber( weapon ) )

    if weaponHash then
        if not gKillfeedWeaponNamesByHash then
            gKillfeedWeaponNamesByHash = {}

            for weaponName in pairs( itemList() ) do
                if weaponName:sub( 1, 7 ) == 'WEAPON_' then
                    gKillfeedWeaponNamesByHash[ joaat( weaponName ) & 0xFFFFFFFF ] = weaponName
                end
            end
        end

        weapon = gKillfeedWeaponNamesByHash[ weaponHash & 0xFFFFFFFF ]
    end

    TriggerEvent( 'pvp.hud:addKillFeedItem', {
        id = data.id,
        killer = data.killerPassport and ( '%s #%s' ):format( data.killer, data.killerPassport ) or data.killer,
        victim = data.victimPassport and ( '%s #%s' ):format( data.victim, data.victimPassport ) or data.victim,
        weapon = type( weapon ) == 'string' and weapon or 'rifle',
        isHeadshot = data.isHeadshot == true,
        isKillStreak = data.isKillStreak == true,
        killerTeamStr = data.killerTeamStr,
        victimTeamStr = data.victimTeamStr,
    } )
end

-- ============================================
-- SISTEMA DE ESTADOS
-- ============================================
---Estados possíveis do cliente durante o ciclo de vida do minigame
MinigameClient.GameState = {
    NONE = 'none',                        -- Estado inicial/sem atividade
    QUEUE = 'queue',                      -- Na fila de matchmaking
    MATCH_INTRO = 'match_intro',          -- Durante a introdução/grace period
    MATCH_GAMEPLAY = 'match_gameplay',    -- Durante o gameplay ativo
    MATCH_SPECTATOR = 'match_spectator',  -- Morto/espectando
    MATCH_ENDED = 'match_ended'           -- Partida terminou
}

---Inicializa o MinigameClient
---@param data MinigameClientData Dados do minigame
---@return MinigameClient
function MinigameClient:__init(data)
    data = data or {}

    self.name = data.name or nil

    if (not self.name) then
        error('Minigame name is required')
    end

    -- Inicializa ConversationManager
    self.conversation = ConversationManager()

    -- Cria a conversa se configurada
    if data.conversation then
        self.conversation:addConversation(data.conversation)
    end

    -- Inicializa CameraManager
    self.camera = CameraManager()

    -- Inicializa estado do ghost mode
    self.ghostMode = false
    self.visibilityThread = nil
    self.matchBindsThread = nil
    self.alivePlayers = {}
    self.deadPlayers = {}
    self.ghostPlayers = {}

    -- ✅ Inicializa sistema de estados e gerenciamento de operações assíncronas
    self.currentState = MinigameClient.GameState.NONE
    self.pendingTimeouts = {}
    self.shouldStopThreads = false
    
    -- ✅ FIX BUG #2: Estado para prevenir múltiplos leaves
    self.isLeaving = false
    
    -- ✅ FIX BUG INVENCIBILIDADE: Rastreia número da rodada atual
    -- Usado para validar se callbacks de timeout ainda são válidos
    self.currentMatchId = nil
    self.currentRoundNumber = 0
    self.reportDamage = (data.match and data.match.reportDamage == true) or data.reportDamage == true
    MinigameDamageReportEnabled[self.name] = self.reportDamage
    
    -- ✅ NOVO: GhostModeManager (opcional - só instancia se necessário)
    self.ghostModeManager = nil
    if data.match and data.match.enableGhostModeOnDeath then
        self.ghostModeManager = GhostModeManager(self.name, data.match)
    end

    self.downedPlayerManager = nil
    local downedStateConfig = data.match and data.match.downedState or nil

    if downedStateConfig == true or type( downedStateConfig ) == 'table' then
        self.downedPlayerManager = DownedPlayerManager(
            self.name,
            type( downedStateConfig ) == 'table' and downedStateConfig or nil
        )
    end
    
    -- ✅ FIX BUG #5: Integração do ControlsManager
    -- ✅ DEBUG: Verifica se ControlsManager está disponível
    if not ControlsManager then
        error(('[MinigameClient] ERRO CRÍTICO: ControlsManager não está disponível! (minigame: %s)'):format(data.name or 'unknown'))
    end
    self.controlsManager = ControlsManager(data.name or 'Minigame')
 
    -- Inicializa QueueManager com configuração
    local queueConfig = data.queue or {}
    queueConfig.name = self.name     -- Garante que o nome está presente
    queueConfig.camera = self.camera -- Passa a referência da câmera

    self.queue = QueueManager(queueConfig)

    self.gunpopup = GunPickup()

    -- Armazena configuração da partida
    if data.match then
        self.matchConfig = {
            enableKillfeed = data.match.enableKillfeed == true,
            onKillfeed = data.match.onKillfeed,
            reportDamage = data.match.reportDamage,
            introGracePeriod = data.match.introGracePeriod,
            respawnOnDeath = data.match.respawnOnDeath,
            downedState = data.match.downedState,
            clearWeaponsOnRoundReset = data.match.clearWeaponsOnRoundReset,
            onStart = data.match.onStart,
            onEnd = data.match.onEnd,
            onLateJoin = data.match.onLateJoin,
            onPlayerDisconnect = data.match.onPlayerDisconnect,
            onPlayerDeath = data.match.onPlayerDeath,
            onMatchPlayerDeath = data.match.onMatchPlayerDeath,  -- ✅ FIX: Callback para atualizar HUD quando QUALQUER jogador morre
            onAdd = data.match.onAdd,
            onRemove = data.match.onRemove,
            onLeave = data.match.onLeave,  -- ✅ FIX BUG CRÍTICO: Callback onLeave estava faltando!
            confirmLeave = data.match.confirmLeave,
            onRoundStart = data.match.onRoundStart,
            onRoundEnd = data.match.onRoundEnd,
            onPlayerWaitingNextRound = data.match.onPlayerWaitingNextRound,
            onWeaponPickup = data.match.onWeaponPickup,  -- ✅ FIX: Callback quando pega arma do chão
            onPlayersStateUpdated = data.match.onPlayersStateUpdated,  -- ✅ FIX: Callback para atualizar contador de sobreviventes
            onLocalPlayerEnteredVehicle = data.match.onLocalPlayerEnteredVehicle,
        }
    end

    -- Registra eventos de rede
    RegisterNetEvent(('%s.client:onMatchStart'):format(self.name), function(data)
        -- ✅ FIX RACE CONDITION: Define minigame:active com NOME do minigame IMEDIATAMENTE
        -- Previne race condition onde player morre antes do state do servidor chegar
        -- Usa self.name (string) ao invés de true (boolean) para manter consistência
        LocalPlayer["state"]["minigame:active"] = self.name
        self:setDownedState( false )
        self.currentMatchId = data.matchId or self.currentMatchId
        self.currentRoundNumber = data.roundNumber or 0

        TriggerEvent("radio:RadioClean")

        -- ✅ FIX REPORTE: Registra controle ESC ANTES de qualquer outra coisa
        -- Isso garante que o jogador possa sair mesmo durante a intro
        self:handleMatchBinds()
        
        -- ✅ Transita para estado MATCH_INTRO
        self:transitionToState(MinigameClient.GameState.MATCH_INTRO, 'match started')
        
        -- Inicializa listas de jogadores (todos vivos no início)
        self.alivePlayers = data.players or {}
        self.deadPlayers = {}
        self.ghostPlayers = {}

        -- Notifica o queue que a partida iniciou (desabilita controles e transiciona estado)
        if self.queue then
            self.queue:notifyMatchStarted()
        end

        self.gunpopup:worker(true)

        -- Inicia loop de visibilidade (gerencia visibilidade de todos os jogadores)
        self:startVisibilityLoop()

        -- ✅ Callback onStart com proteção
        if self.matchConfig and self.matchConfig.onStart then
            local success, err = pcall(function()
                self.matchConfig.onStart(data)
            end)
        end

        -- ✅ FIX INTERIOR PRETO: Após spawn, força refresh do interior na posição do jogador
        local gracePeriod = (self.matchConfig and self.matchConfig.introGracePeriod) or 0
        refreshInteriorAtPlayer(gracePeriod + 300)
    end)

    RegisterNetEvent(('%s.client:onMatchEnd'):format(self.name), function(data)
        -- ✅ FIX BUG CRÍTICO: Reset isLeaving quando partida termina
        if self.isLeaving then
            self.isLeaving = false
        end
        
        self:setDownedState( false )

        -- ✅ FIX SURVIVAL: Remove minigame:active=false IMEDIATAMENTE no cliente
        LocalPlayer["state"]["minigame:active"] = false
        self.currentMatchId = nil
        self.currentRoundNumber = 0
        
        -- ✅ Transita para MATCH_ENDED (cancela operações pendentes)
        self:transitionToState(MinigameClient.GameState.MATCH_ENDED, 'match ended')
        
        -- ✅ Destrói câmera se estiver ativa
        if self.camera then
            self.camera:destroyCamera()
        end
        
        -- ✅ REFATORADO: Usa PlayerStateManager para garantir limpeza completa
        local stateManager = PlayerStateManager:getInstance()
        stateManager:cancelAllOperations()
        
        -- ✅ Garante que o jogador não está freezado (caso saia durante intro)
        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) then
            FreezeEntityPosition(playerPed, false)
            RemoveAllPedWeapons(playerPed, true)
        end
        
        -- Finaliza sessão de tutorial
        NetworkEndTutorialSession()
        
        -- ✅ FIX PISCAR ALPHA: Para loop e limpa listas do GhostModeManager antes de disable
        self:stopVisibilityLoop()
        if self.ghostModeManager then
            self.ghostModeManager:updatePlayerLists({}, {}, {})
        end

        -- Desativa ghost mode quando a partida termina
        self:disableGhostMode()

        -- Limpa listas de jogadores (em lugar para referências compartilhadas)
        for k in pairs(self.alivePlayers) do self.alivePlayers[k] = nil end
        for k in pairs(self.deadPlayers) do self.deadPlayers[k] = nil end
        for k in pairs(self.ghostPlayers) do self.ghostPlayers[k] = nil end

        -- Para controles
        self:stopMatchBinds()

        self.gunpopup:worker(false)

        -- Notifica o queue que a partida terminou (reseta estado para idle)
        if self.queue then
            self.queue:notifyMatchEnded()
        end

        -- ✅ Callback onEnd com proteção
        if self.matchConfig and self.matchConfig.onEnd then
            local success, err = pcall(function()
                self.matchConfig.onEnd(data)
            end)
        end
        
        -- ✅ Transita para NONE após callbacks terminarem
        self:transitionToState(MinigameClient.GameState.NONE, 'cleanup completed')
    end)

    RegisterNetEvent(('%s.client:onMatchLateJoin'):format(self.name), function(data)
        data = data or {}
        self.currentMatchId = data.matchId or self.currentMatchId
        self.currentRoundNumber = data.roundNumber or self.currentRoundNumber or 0

        TriggerEvent("radio:RadioClean")

        -- Notifica o queue que a partida iniciou (mesmo que tenha entrado tardiamente)
        -- Isso muda o estado de 'in_queue' para 'match_started' e para os controles da fila
        if self.queue then
            self.queue:notifyMatchStarted()
        end

        -- ✅ FIX BUG #3: Para threads antigas ANTES de iniciar novas (late join)
        self:stopVisibilityLoop()
        self:stopMatchBinds()
        
        -- Pequeno delay para garantir que threads antigas finalizaram
        Wait(50)

        -- Inicia loop de visibilidade e controles da partida
        self:startVisibilityLoop()
        self:handleMatchBinds()

        if self.matchConfig and self.matchConfig.onLateJoin then
            self.matchConfig.onLateJoin(data)
        end

        -- ✅ FIX INTERIOR PRETO: Late join spawna em interior; força refresh após spawn
        refreshInteriorAtPlayer(500)
    end)

    RegisterNetEvent(('%s.client:onMatchPlayerDisconnect'):format(self.name), function(data)
        -- Remove jogador das listas (pode estar em alivePlayers, deadPlayers ou ghostPlayers)
        -- CRÍTICO: Usar data.source como chave, não userId!
        self.alivePlayers[data.source] = nil
        self.deadPlayers[data.source] = nil
        self.ghostPlayers[data.source] = nil

        -- Atualiza visibilidade imediatamente
        self:updatePlayersVisibility()

        if self.matchConfig and self.matchConfig.onPlayerDisconnect then
            self.matchConfig.onPlayerDisconnect(data)
        end
    end)

    RegisterNetEvent(('%s.client:onKillfeed'):format(self.name), function(data)
        if type( data ) ~= 'table' or not self.currentMatchId or data.matchId ~= self.currentMatchId
            or not self.matchConfig or not self.matchConfig.enableKillfeed
        then
            return
        end

        self:AddKillfeedItem( data )

        if self.matchConfig.onKillfeed then
            self.matchConfig.onKillfeed( data )
        end
    end)

    RegisterNetEvent(('%s.client:onMatchPlayerDeath'):format(self.name), function(data)
        local localServerId = GetPlayerServerId(PlayerId())

        -- Atualiza listas localmente: move jogador de alivePlayers para deadPlayers
        if self.alivePlayers[data.source] then
            self.alivePlayers[data.source] = nil
            self.deadPlayers[data.source] = data.userId
        end

        -- ✅ Se é o jogador local que morreu, transita para SPECTATOR
        if data.source == localServerId then
            self:transitionToState(MinigameClient.GameState.MATCH_SPECTATOR, 'player died')
            self:setDownedState( true )
        end

        -- ✅ CORRIGIDO: Sempre atualiza visibilidade (simplificado)
        self:updatePlayersVisibility()

        -- ✅ Callback onPlayerDeath com proteção (crítico - define ghost mode, armas, etc)
        -- Este callback é chamado APENAS no cliente que morreu
        if data.source == localServerId and self.matchConfig and self.matchConfig.onPlayerDeath then
            local success, err = pcall(function()
                self.matchConfig.onPlayerDeath(data)
            end)
        end
        
        -- ✅ NOVO: Callback onMatchPlayerDeath com proteção (chamado para TODOS os clientes)
        -- Útil para atualizar UI (contadores, HUD) em todos os jogadores quando alguém morre
        if self.matchConfig and self.matchConfig.onMatchPlayerDeath then
            local success, err = pcall(function()
                self.matchConfig.onMatchPlayerDeath(data)
            end)
        end
    end)

    RegisterNetEvent(('%s.client:onMatchAdd'):format(self.name), function(data)
        -- Atualiza listas localmente: adiciona jogador aos vivos
        self.alivePlayers[data.source] = data.userId
        self.deadPlayers[data.source] = nil

        -- ✅ CORRIGIDO: Sempre atualiza visibilidade (simplificado)
        self:updatePlayersVisibility()

        -- Chama callback se configurado
        if self.matchConfig and self.matchConfig.onAdd then
            self.matchConfig.onAdd(data)
        end
    end)

    RegisterNetEvent(('%s.client:onMatchRemove'):format(self.name), function(data)
        -- Remove jogador das listas (pode estar em alivePlayers, deadPlayers ou ghostPlayers)
        self.alivePlayers[data.source] = nil
        self.deadPlayers[data.source] = nil
        self.ghostPlayers[data.source] = nil

        -- Atualiza visibilidade imediatamente
        self:updatePlayersVisibility()

        -- Chama callback se configurado
        if self.matchConfig and self.matchConfig.onRemove then
            self.matchConfig.onRemove(data)
        end
    end)
    
    -- Evento para quando o jogador local sai da partida (voluntariamente ou não)
    RegisterNetEvent(('%s.client:onPlayerLeave'):format(self.name), function(data)
        -- ⚠️ NÃO RESETAR isLeaving AQUI - será resetado apenas NO FINAL após tudo processar
        -- Isso garante que se houver erro no meio do processamento, isLeaving permanece true
        
        self:setDownedState( false )

        -- ✅ FIX SURVIVAL: Remove minigame:active=false IMEDIATAMENTE no cliente
        LocalPlayer["state"]["minigame:active"] = false
        self.currentMatchId = nil
        self.currentRoundNumber = 0
        
        -- ✅ Transita para NONE (cancela todas operações pendentes automaticamente)
        self:transitionToState(MinigameClient.GameState.NONE, 'player left')
        
        -- ✅ Destrói câmera se estiver ativa
        if self.camera then
            self.camera:destroyCamera()
        end
        
        -- ✅ REFATORADO: Usa PlayerStateManager para garantir limpeza completa
        local stateManager = PlayerStateManager:getInstance()
        stateManager:cancelAllOperations()
        
        -- ✅ Garante que o jogador não está freezado (caso saia durante intro)
        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) then
            FreezeEntityPosition(playerPed, false)
            RemoveAllPedWeapons(playerPed, true)
        end
        
        -- Finaliza sessão de tutorial
        NetworkEndTutorialSession()
        
        -- ✅ FIX PISCAR ALPHA: Para o loop de visibilidade ANTES de desativar ghost mode
        -- e limpa listas do GhostModeManager (ele mantém referências; sem isso o loop continua)
        self:stopVisibilityLoop()
        if self.ghostModeManager then
            self.ghostModeManager:updatePlayerLists({}, {}, {})
        end

        -- Desativa ghost mode se estiver ativo
        self:disableGhostMode()
        
        -- Limpa listas de jogadores (em lugar para que referências compartilhadas fiquem vazias)
        for k in pairs(self.alivePlayers) do self.alivePlayers[k] = nil end
        for k in pairs(self.deadPlayers) do self.deadPlayers[k] = nil end
        for k in pairs(self.ghostPlayers) do self.ghostPlayers[k] = nil end
        
        -- ✅ Para threads e gunpopup
        -- Controles serão parados por transitionToState(NONE) abaixo
        self.gunpopup:worker(false)
        
        -- Notifica o queue que a partida terminou para este jogador
        if self.queue then
            self.queue:notifyMatchEnded()
        end
        
        -- ✅ FIX: Chama onRemove com proteção contra erros (pcall)
        -- onRemove é chamado DEPOIS de onLeave para manter a ordem correta
        if self.matchConfig and self.matchConfig.onRemove then
            pcall(function()
                self.matchConfig.onRemove(data)
            end)
        end
        
        -- Chama callback onLeave se configurado (para lógica adicional)
        if self.matchConfig and self.matchConfig.onLeave then
            pcall(function()
                self.matchConfig.onLeave(data)
            end)
        end
        
        -- ✅ FIX PISCAR ALPHA: Garante alpha normal ao sair (safety net final)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) then
            SetEntityAlpha(ped, 255, false)
            ResetEntityAlpha(ped)
        end

        -- ✅ FIX BUG CRÍTICO: Reset isLeaving APENAS NO FINAL (após todo processamento)
        -- Isso garante que isLeaving só é resetado após TUDO executar com sucesso
        if self.isLeaving then
            self.isLeaving = false
        end
    end)

    -- Evento de sincronização de estado dos jogadores
    -- Separado de visibilidade para permitir minigames customizados
    RegisterNetEvent(('%s.client:syncPlayersState'):format(self.name), function(data)
        self.alivePlayers = data.alivePlayers or {}
        self.deadPlayers = data.deadPlayers or {}
        self.ghostPlayers = data.ghostPlayers or {}
        
        -- Conta jogadores de cada categoria
        local aliveCount = 0
        local deadCount = 0
        local ghostCount = 0
        for _ in pairs(self.alivePlayers) do aliveCount = aliveCount + 1 end
        for _ in pairs(self.deadPlayers) do deadCount = deadCount + 1 end
        for _ in pairs(self.ghostPlayers) do ghostCount = ghostCount + 1 end
        
        local localServerId = GetPlayerServerId(PlayerId())
        
        -- Atualiza GhostModeManager se existir
        if self.ghostModeManager then
            self.ghostModeManager:updatePlayerLists(self.alivePlayers, self.deadPlayers, self.ghostPlayers)
            
            -- Atualiza visibilidade apenas se shouldUpdateVisibility=true
            if data.shouldUpdateVisibility then
                self.ghostModeManager:updatePlayersVisibility()
            end
        end
        
        -- Callback para minigames reagirem a mudanças de estado
        -- Permite que minigames sem ghost mode usem as listas sem overhead de visibilidade
        
        -- 🔍 DEBUG TEMPORÁRIO: Verifica se evento chegou no cliente
        -- print(('[CLIENT DEBUG] 📡 syncPlayersState recebido - alive:%d dead:%d ghost:%d'):format(aliveCount, deadCount, ghostCount))
        
        if self.matchConfig and self.matchConfig.onPlayersStateUpdated then
            -- print('[CLIENT DEBUG] ✅ Chamando callback onPlayersStateUpdated')
            self.matchConfig.onPlayersStateUpdated({
                alivePlayers = self.alivePlayers,
                deadPlayers = self.deadPlayers,
                ghostPlayers = self.ghostPlayers,
                aliveCount = aliveCount,
                deadCount = deadCount,
                ghostCount = ghostCount
            })
        else
            -- print('[CLIENT DEBUG] ⚠️ matchConfig.onPlayersStateUpdated NÃO EXISTE!')
        end
    end)

    -- Evento para resetar rodada (remove ghost mode e armas)
    RegisterNetEvent(('%s.client:onRoundReset'):format(self.name), function(data)
        self:setDownedState( false )

        local playerPed = PlayerPedId()
        
        -- ✅ REFATORADO: Cancela TODAS as operações do PlayerStateManager
        -- Isso garante que invencibilidade de qualquer sistema seja limpa
        local stateManager = PlayerStateManager:getInstance()
        stateManager:cancelAllOperations()
        
        -- ✅ FIX BUG INVENCIBILIDADE EXTRA: Força remoção de invencibilidade NOVAMENTE
        -- Proteção dupla para garantir que invencibilidade seja removida
        SetEntityInvincible(playerPed, false)
        LocalPlayer["state"]["Invincible"] = false
        
        -- ✅ FIX BUG COLISÃO: Força restauração de colisão do jogador local
        -- Isso garante que o próprio jogador tenha colisão após reset
        SetEntityVisible(playerPed, true, false)
        ResetEntityAlpha(playerPed)
        SetEntityCollision(playerPed, true, true)
        
        -- ✅ FIX BUG INVENCIBILIDADE: Cancela TODOS os timeouts pendentes (incluindo invencibilidade)
        -- Isso previne que timeouts de invencibilidade da rodada anterior executem na nova rodada
        self:cancelPendingOperations()
        
        -- Remove ghost mode
        self:disableGhostMode()

        -- Safety net para modos que escondem/congelam o ped sem GhostModeManager.
        SetLocalPlayerAsGhost(false)
        FreezeEntityPosition(playerPed, false)
        SetEntityInvincible(playerPed, false)
        LocalPlayer["state"]["Invincible"] = false
        SetEntityVisible(playerPed, true, false)
        ResetEntityAlpha(playerPed)
        SetEntityCollision(playerPed, true, true)

        -- ✅ FIX BUG #3: Limpa todas as listas locais (jogadores mortos voltam a vivos)
        self.alivePlayers = {}
        self.deadPlayers = {}
        self.ghostPlayers = {}

        -- ✅ FIX BUG TRANSPARENCIA: Limpa listas do GhostModeManager também
        -- Se não limpar, ele acha que o player ainda está morto e reaplica transparência em updatePlayersVisibility
        if self.ghostModeManager then
            self.ghostModeManager:updatePlayerLists({}, {}, {})
        end
        
        -- Atualiza visibilidade para resetar estados
        self:updatePlayersVisibility()

        -- ✅ FIX CÂMERA: Destrói câmera ao resetar rodada (previne travar em intro/morte)
        if self.camera then
            self.camera:destroyCamera()
        end
        
        -- ✅ FIX SCENE/FOCUS: Safety clean
        NewLoadSceneStop()
        ClearFocus()

        local shouldRemoveWeapons = not self.matchConfig or self.matchConfig.clearWeaponsOnRoundReset ~= false
        if shouldRemoveWeapons then
            RemoveAllPedWeapons(playerPed, true)
        end
    end)

    -- Evento para quando jogador entra em modo fantasma de espera
    RegisterNetEvent(('%s.client:onPlayerWaitingNextRound'):format(self.name), function(data)
        -- ✅ FIX RACE CONDITION: Define minigame:active IMEDIATAMENTE para late joiners
        -- Usa self.name (string) ao invés de true (boolean) para manter consistência
        LocalPlayer["state"]["minigame:active"] = self.name

        TriggerEvent("radio:RadioClean")
        
        -- Notifica o queue que a partida iniciou (mesmo que tenha entrado tardiamente)
        -- Isso muda o estado de 'in_queue' para 'match_started' e para os controles da fila
        if self.queue then
            self.queue:notifyMatchStarted()
        end

        -- ✅ FIX BUG CRÍTICO: Registra controle ESC para late joiners
        -- Late joiners precisam poder sair (tecla ESC) enquanto aguardam próxima rodada
        self:handleMatchBinds()

        -- ✅ Atualiza visibilidade (controles já estão rodando da rodada anterior)
        self:startVisibilityLoop()

        -- Aguarda processamento do sync de estado antes de ativar ghost mode
        -- O servidor envia syncPlayersState ANTES deste evento
        Wait(200) -- Delay para garantir que sync foi recebido e processado
        
        -- Ativa ghost mode em WAITING MODE (late join: vê todos, mas não é visto)
        self:enableGhostMode(true)
        
        -- Força atualização de visibilidade após ativar ghost mode
        -- Garante que as listas recebidas via syncPlayersVisibility sejam processadas
        Wait(100) -- Pequeno delay para garantir que ghost mode foi ativado
        self:updatePlayersVisibility()

        -- Chama callback se configurado
        if self.matchConfig and self.matchConfig.onPlayerWaitingNextRound then
            self.matchConfig.onPlayerWaitingNextRound(data)
        end
    end)

    -- Evento para ativar ghost mode (chamado pelo servidor)
    RegisterNetEvent(('%s.client:enableGhostMode'):format(self.name), function(data)
        local isWaitingMode = data and data.isWaitingMode or false
        self:enableGhostMode(isWaitingMode)
    end)

    -- Evento para início de rodada (chamado a cada rodada quando roundBased = true)
    RegisterNetEvent(('%s.client:onRoundStart'):format(self.name), function(data)
        local playerCount = 0
        if data.players then
            for _ in pairs(data.players) do
                playerCount = playerCount + 1
            end
        end
        
        -- ✅ FIX RACE CONDITION: Define minigame:active IMEDIATAMENTE no cliente (nova rodada)
        -- Usa self.name (string) ao invés de true (boolean) para manter consistência
        LocalPlayer["state"]["minigame:active"] = self.name
        
        -- ✅ FIX BUG INVENCIBILIDADE CRÍTICO: Remove invencibilidade ANTES de começar
        -- O player pode vir com invencibilidade do jogo base/fila/sistema externo
        local playerPed = PlayerPedId()
        local stateManager = PlayerStateManager:getInstance()
        
        -- ✅ FIX: cancelAllOperations já remove invencibilidade E reseta owners
        stateManager:cancelAllOperations()
        
        -- ✅ FIX EXTRA: Força remoção NOVAMENTE como proteção dupla
        SetEntityInvincible(playerPed, false)
        LocalPlayer["state"]["Invincible"] = false
        SetLocalPlayerAsGhost(false)
        
        -- ✅ FIX BUG COLISÃO: Força restauração de colisão do jogador local
        SetEntityVisible(playerPed, true, false)
        ResetEntityAlpha(playerPed)
        SetEntityCollision(playerPed, true, true)
        
        -- ✅ Cancela TAMBÉM os timeouts do minigame (proteção tripla!)
        self:cancelPendingOperations()
        
        -- ✅ FIX BUG INVENCIBILIDADE: Atualiza número da rodada ANTES de tudo
        -- Isso permite que callbacks de timeout validem se ainda são da rodada atual
        self.currentMatchId = data.matchId or self.currentMatchId
        self.currentRoundNumber = data.roundNumber or 0
        
        -- ✅ Transita para MATCH_INTRO (início da rodada com grace period)
        self:transitionToState(MinigameClient.GameState.MATCH_INTRO, 'round started')
        
        -- Reseta listas de jogadores (todos voltam a vivos na nova rodada)
        self.alivePlayers = data.players or {}
        self.deadPlayers = {}
        self.ghostPlayers = {}

        -- Se ainda está na fila (primeira rodada), notifica que a partida iniciou
        if self.queue and self.queue:isInQueue() then
            self.queue:notifyMatchStarted()
            
            -- ✅ FIX BUG #3: Para threads antigas ANTES de iniciar novas (primeira rodada)
            self:stopVisibilityLoop()
            self:stopMatchBinds()
            Wait(50)
            
            -- Inicia loop de visibilidade e controles da partida
            self:startVisibilityLoop()
            self:handleMatchBinds()
        end

        -- Atualiza visibilidade imediatamente
        if self.ghostMode then
            self:updatePlayersVisibility()
        end

        -- ✅ Callback onRoundStart com proteção (crítico - define roles, armas, etc)
        if self.matchConfig and self.matchConfig.onRoundStart then
            pcall(function()
                self.matchConfig.onRoundStart(data)
            end)
        end

        -- ✅ FIX INTERIOR PRETO: Após spawn da rodada, força refresh do interior
        local gracePeriod = (self.matchConfig and self.matchConfig.introGracePeriod) or 0
        refreshInteriorAtPlayer(gracePeriod + 300)
    end)

    -- Evento para fim de rodada (chamado quando uma rodada termina)
    RegisterNetEvent(('%s.client:onRoundEnd'):format(self.name), function(data)
        -- ✅ Callback onRoundEnd com proteção
        if self.matchConfig and self.matchConfig.onRoundEnd then
            pcall(function()
                self.matchConfig.onRoundEnd(data)
            end)
        end
    end)

    -- Registra eventos de rede para pickups de armas
    RegisterNetEvent(('%s.client:onWeaponPickupCreated'):format(self.name), function(data)
        -- Cria o pickup localmente quando recebe notificação do servidor
        if self.gunpopup and data.weapon and data.coords then
            self.gunpopup:createPickupLocal(data.weapon, data.coords, data.pickupId)
        end
    end)

    RegisterNetEvent(('%s.client:onWeaponPickupRemoved'):format(self.name), function(data)
        -- Remove o pickup quando alguém pega
        if self.gunpopup and data.pickupId then
            -- ✅ Usa pcall para evitar crash se o pickup não existir
            pcall(function()
                return GunPickup.removePickupById(data.pickupId)
            end)
            
            -- Se foi este jogador que pegou, da a arma
            local localServerId = GetPlayerServerId(PlayerId())
            if data.pickedBySource == localServerId and data.weapon then
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.weapon)
                
                -- Define munição baseada no tipo de arma
                local ammo = 300
                if data.weapon == 'WEAPON_KARAMBIT' then
                    ammo = 100
                elseif data.weapon == 'WEAPON_REVOLVER' then
                    ammo = 300
                end
                
                GiveWeaponToPed(playerPed, weaponHash, ammo, false, true)
                
                -- ✅ Chama callback onWeaponPickup se configurado
                if self.matchConfig and self.matchConfig.onWeaponPickup then
                    pcall(function()
                        self.matchConfig.onWeaponPickup({
                            weapon = data.weapon,
                            pickupId = data.pickupId
                        })
                    end)
                end
            end
        end
    end)

    -- Registra a instância globalmente após toda inicialização estar completa
    MinigameInstances[self.name] = self
end

-- ============================================
-- GERENCIAMENTO DE ESTADOS E OPERAÇÕES ASSÍNCRONAS
-- ============================================

---Registra um timeout que será automaticamente rastreado e validado
---@param callback function Função a ser executada após o delay
---@param delay number Tempo em milissegundos
---@return number timerId ID do timeout criado
function MinigameClient:registerTimeout(callback, delay)
    local timerId = SetTimeoutEx(delay, function()
        -- ✅ VALIDAÇÃO AUTOMÁTICA: Só executa se ainda estiver na partida
        if not self:isInMatch() then
            return
        end
        
        -- ✅ Executa callback
        callback()
    end)
    
    -- ✅ Rastreia o timeout
    table.insert(self.pendingTimeouts, timerId)
    
    return timerId
end

---Cancela TODAS as operações pendentes (timeouts, threads, etc)
---Deve ser chamado quando o jogador sair da partida
function MinigameClient:cancelPendingOperations()
    -- ✅ REFATORADO: Cancela operações do PlayerStateManager deste minigame
    local stateManager = PlayerStateManager:getInstance()
    local owner = ('minigame_%s'):format(self.name)
    stateManager:cancelOwnerOperations(owner)
    
    -- Cancela também operações de ghost mode
    local ghostOwner = ('minigame_%s_ghost'):format(self.name)
    stateManager:cancelOwnerOperations(ghostOwner)
    
    -- ✅ Cancela todos os timeouts rastreados
    for i, timerId in ipairs(self.pendingTimeouts) do
        ClearTimeoutEx(timerId)
    end
    self.pendingTimeouts = {}
    
    -- ✅ Sinaliza para threads pararem
    self.shouldStopThreads = true
end

---Ativa ou encerra a apresentacao local reutilizavel de jogador abatido.
---@param enabled boolean
---@return boolean supported
function MinigameClient:setDownedState( enabled )
    if not self.downedPlayerManager then
        return false
    end

    if enabled then
        self.downedPlayerManager:enter()
    else
        self.downedPlayerManager:exit()
    end

    return true
end

---UI aberta durante o abatido so segura o foco depois da pose, que solta o foco da NUI.
---@return boolean ready true tambem quando o modo nao usa estado abatido
function MinigameClient:isDownedPresentationReady()
    return not self.downedPlayerManager or self.downedPlayerManager:isPresented()
end

---Faz transição para um novo estado do jogo
---@param newState string Novo estado (GameState)
---@param reason? string Razão da transição (opcional, para debug)
function MinigameClient:transitionToState(newState, reason)
    local oldState = self.currentState
    
    -- Não faz nada se já estiver no estado
    if oldState == newState then
        return
    end
    
    -- ✅ Cancela operações quando sair de qualquer estado de match
    -- Verifica se está SAINDO de um estado de match (não apenas entrando em NONE)
    local wasInMatch = oldState == MinigameClient.GameState.MATCH_INTRO or
                       oldState == MinigameClient.GameState.MATCH_GAMEPLAY or
                       oldState == MinigameClient.GameState.MATCH_SPECTATOR or
                       oldState == MinigameClient.GameState.MATCH_ENDED
    
    local isLeavingMatch = wasInMatch and (
        newState == MinigameClient.GameState.NONE or
        newState == MinigameClient.GameState.QUEUE or
        newState == MinigameClient.GameState.MATCH_ENDED  -- Cancela também ao ir para MATCH_ENDED
    )
    
    if isLeavingMatch then
        self:cancelPendingOperations()
        
        -- ✅ Para threads e controles quando sai de match
        self:stopVisibilityLoop()
        self:stopMatchBinds()
    end
    
    self.currentState = newState
    
    -- Reset da flag de threads ao entrar em novo estado
    if newState == MinigameClient.GameState.MATCH_INTRO or 
       newState == MinigameClient.GameState.MATCH_GAMEPLAY then
        self.shouldStopThreads = false
    end
end

---Verifica se o jogador está em algum estado de partida ativa
---@return boolean
function MinigameClient:isInMatchState()
    return self.currentState == MinigameClient.GameState.MATCH_INTRO or
           self.currentState == MinigameClient.GameState.MATCH_GAMEPLAY or
           self.currentState == MinigameClient.GameState.MATCH_SPECTATOR
end

---Verifica se o jogador está em uma partida e retorna o nome do minigame
---@return string? Nome do minigame se estiver em uma partida, nil caso contrário
---@diagnostic disable-next-line: lowercase-global
function getActiveMinigameName()
    -- ✅ FIX RACE CONDITION: Usa Player State setado pelo SERVIDOR
    -- minigame:active agora é string (nome do minigame) ou nil
    -- Isso evita race conditions durante transições de currentState (morte, respawn, etc)
    return LocalPlayer["state"]["minigame:active"]
end

AddEventHandler( 'gameEventTriggered', function( eventName, args )

    if eventName ~= 'CEventNetworkPlayerEnteredVehicle'
        or type( args ) ~= 'table' or tonumber( args[ 1 ] ) ~= PlayerId() then return end

    local minigameName = getActiveMinigameName()
    local instance = minigameName and MinigameInstances[ minigameName ] or nil
    local callback = instance and instance.matchConfig and instance.matchConfig.onLocalPlayerEnteredVehicle

    if not callback then return end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then return end

    SetTimeout( 250, function()

        if getActiveMinigameName() ~= minigameName
            or MinigameInstances[ minigameName ] ~= instance
            or PlayerPedId() ~= ped or not DoesEntityExist( ped ) then return end

        local vehicle = GetVehiclePedIsIn( ped, false )

        if vehicle == 0 or not DoesEntityExist( vehicle ) then return end

        local success, err = pcall( callback, vehicle, ped )

        if not success then
            sx.logger:error( ( 'Minigame %s: falha em onLocalPlayerEnteredVehicle: %s' ):format( minigameName, err ) )
        end
    end )
end )

local function shouldReportDamageForMinigame(minigameName)
    return minigameName and MinigameDamageReportEnabled[minigameName] == true
end

local function isCompetitiveMinigameName(minigameName)
    if PvpIsCompetitiveMinigameName then
        return PvpIsCompetitiveMinigameName(minigameName)
    end

    return minigameName == 'Competitivo 5v5'
end

---@param minigameName string?
---@return boolean
local function ShouldUseDownedState( minigameName )
    local instance = minigameName and MinigameInstances[ minigameName ] or nil

    return instance and instance.downedPlayerManager ~= nil or false
end

local function isCompetitivePauseActive()
    local state = _G.dminigames_competitive
    return type(state) == 'table' and state.pauseActive == true
end

local function getDeathReportContext(minigameName)
    local instance = minigameName and MinigameInstances[minigameName] or nil

    return {
        matchId = instance and instance.currentMatchId or nil,
        roundNumber = instance and instance.currentRoundNumber or nil,
    }
end

local function debugCompetitiveDamageEvent(stage, minigameName, args, attackerServerId, victimDied, eventSaysFatal)
    if not isCompetitiveMinigameName(minigameName) then return end

    local ped = PlayerPedId()
    local pedExists = DoesEntityExist(ped)
    TriggerEvent('pvp.competitive:damageDebug', {
        stage = stage,
        extra = ('fatal=%s victimDied=%s health=%d dead=%s dying=%s attackerPed=%s attackerSrc=%s weapon=%s arg6=%s arg10=%s'):format(
            tostring(eventSaysFatal),
            tostring(victimDied),
            pedExists and GetEntityHealth(ped) or 0,
            tostring(pedExists and IsEntityDead(ped) or false),
            tostring(pedExists and IsPedDeadOrDying(ped, true) or false),
            tostring(args and args[2]),
            tostring(attackerServerId),
            tostring(args and args[7]),
            tostring(args and args[6]),
            tostring(args and args[10])
        )
    })
end

local lastDamageVitals = nil

local function getPedCombatVitals(ped)
    return {
        health = math.max(0, GetEntityHealth(ped) - MINIGAME_PED_BASE_HEALTH),
        armor = GetPedArmour(ped),
    }
end

local HEAD_DAMAGE_BONES = {
    [31086] = true, -- SKEL_Head
    [12844] = true, -- IK_Head
}

local function wasHeadshot(ped)
    local hit, bone = GetPedLastDamageBone(ped)
    return hit and HEAD_DAMAGE_BONES[bone] == true
end

local function eventHasHeadshotFlag(args)
    return tonumber(args and args[10]) == 1
end

CreateThread(function()
    while true do
        local minigameName = getActiveMinigameName()

        if shouldReportDamageForMinigame(minigameName) then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                lastDamageVitals = getPedCombatVitals(ped)
            end
            Wait(150)
        else
            lastDamageVitals = nil
            Wait(1000)
        end
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    if name ~= "CEventNetworkEntityDamage" then
        return
    end

    local Victim = PlayerPedId()

    if args[1] ~= Victim then
        return
    end

    -- Verifica se está em uma partida e obtém o nome do minigame
    local minigameName = getActiveMinigameName()
    if not minigameName then
        return
    end
    local reportDamage = shouldReportDamageForMinigame(minigameName)

    if isCompetitiveMinigameName(minigameName) and isCompetitivePauseActive() then
        lastDamageVitals = getPedCombatVitals(Victim)
        return
    end

    local AttackerPed = tonumber(args[2])  -- Entity/Ped ID do atacante
    local eventSaysFatal = args[6] == true or tonumber(args[6]) == 1
    local VictimDied = eventSaysFatal or GetEntityHealth(Victim) <= MINIGAME_PED_BASE_HEALTH
    local Weapon     = tostring(args[7])
    local eventHeadshot = eventHasHeadshotFlag(args)

    -- ✅ FIX: Converte Ped ID para Server ID
    local AttackerServerId = nil
    if AttackerPed and AttackerPed ~= 0 then
        -- Verifica se o atacante é um ped de jogador
        if IsPedAPlayer(AttackerPed) then
            -- Converte Ped para Player Index
            local attackerPlayerIndex = NetworkGetPlayerIndexFromPed(AttackerPed)
            if attackerPlayerIndex ~= -1 then
                -- Converte Player Index para Server ID
                AttackerServerId = GetPlayerServerId(attackerPlayerIndex)
            end
        end
    end

    if reportDamage then
        local currentVitals = getPedCombatVitals(Victim)
        if lastDamageVitals and AttackerServerId then
            local previousTotal = (lastDamageVitals.health or 0) + (lastDamageVitals.armor or 0)
            local currentTotal = (currentVitals.health or 0) + (currentVitals.armor or 0)
            local damage = math.floor(previousTotal - currentTotal)

            if damage > 0 then
                TriggerServerEvent(('%s.server:onPlayerDamage'):format(minigameName), {
                    attacker = AttackerServerId,
                    weapon = Weapon,
                    damage = damage,
                })
            end
        end

        lastDamageVitals = currentVitals
    end

    if VictimDied then
        debugCompetitiveDamageEvent('damage:fatal-candidate', minigameName, args, AttackerServerId, VictimDied, eventSaysFatal)
    end

    if ShouldUseDownedState( minigameName )
        and VictimDied
        and not isMinigamePedDeadOrDying( Victim )
    then
        Wait(0)
        if minigameName ~= getActiveMinigameName() or not DoesEntityExist(Victim) then
            return
        end

        VictimDied = isMinigamePedDeadOrDying(Victim)

        if not VictimDied then
            Wait(50)
            if minigameName ~= getActiveMinigameName() or not DoesEntityExist(Victim) then
                return
            end

            VictimDied = isMinigamePedDeadOrDying(Victim)
        end

        if not VictimDied then
            debugCompetitiveDamageEvent('damage:fatal-cancelled', minigameName, args, AttackerServerId, VictimDied, eventSaysFatal)
        end
    end

    if not VictimDied then
        return
    end

    local coords = GetEntityCoords(Victim)
    local heading = GetEntityHeading(Victim)
    local isHeadshot = eventHeadshot or wasHeadshot(Victim)

    -- O DownedPlayerManager apresenta o estado abatido somente depois que o
    -- servidor confirmar a morte. Ate la, o corpo permanece no local.
    if ShouldUseDownedState( minigameName ) then
        debugCompetitiveDamageEvent('damage:report-death', minigameName, args, AttackerServerId, VictimDied, eventSaysFatal)
        local deathContext = getDeathReportContext(minigameName)
        TriggerServerEvent(('%s.server:onPlayerDeath'):format(minigameName), {
            matchId = deathContext.matchId,
            roundNumber = deathContext.roundNumber,
            attacker = AttackerServerId,
            weapon = Weapon,
            isHeadshot = isHeadshot,
            health = GetEntityHealth(Victim),
        })

        SetEntityCollision(Victim, true, true)
        SetEntityVisible(Victim, true, false)
        ResetEntityAlpha(Victim)
        SetPedCanRagdoll(Victim, true)
        SetPedCanRagdollFromPlayerImpact(Victim, true)
        FreezeEntityPosition(Victim, false)
        return
    else
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading)
    end

    Wait(1)

    -- Notifica o servidor sobre a morte
    local deathContext = getDeathReportContext(minigameName)
    TriggerServerEvent(('%s.server:onPlayerDeath'):format(minigameName), {
        matchId = deathContext.matchId,
        roundNumber = deathContext.roundNumber,
        attacker = AttackerServerId,
        weapon = Weapon,
        isHeadshot = isHeadshot,
        health = GetEntityHealth(Victim),
    })
end)

---Ativa o Modo Ghost (jogador morto não é visto/ouvido pelos vivos)
---Wrapper para GhostModeManager (mantido para compatibilidade)
---@param isWaitingMode? boolean Se true, é um late join esperando (não usa SetLocalPlayerAsGhost)
---@return nil
function MinigameClient:enableGhostMode(isWaitingMode)
    if self.ghostModeManager then
        self.ghostModeManager:enable(isWaitingMode)
        -- Sincroniza estado local com o manager
        self.ghostMode = self.ghostModeManager:isEnabled()
    end
end

---Desativa o Modo Ghost
---Wrapper para GhostModeManager (mantido para compatibilidade)
---@return nil
function MinigameClient:disableGhostMode()
    if self.ghostModeManager then
        self.ghostModeManager:disable()
        -- Sincroniza estado local com o manager
        self.ghostMode = self.ghostModeManager:isEnabled()
    else
        -- Fallback: Ghost mode não configurado
        self.ghostMode = false
    end
end

---Define a invulnerabilidade do jogador
---@param invincible boolean Se o jogador deve ser invulnerável
---@param time? number Tempo em ms para desativar a invulnerabilidade (opcional)
---@param makeTransparent? boolean Se deve aplicar transparência visual durante invencibilidade (padrão: false)
---@return nil
function MinigameClient:setInvincibility(invincible, time, makeTransparent)
    local stateManager = PlayerStateManager:getInstance()
    local owner = ('minigame_%s'):format(self.name)
    
    -- ✅ REFATORADO: Usa PlayerStateManager para gerenciar invencibilidade
    -- Prioridade alta (80) - minigame tem controle principal sobre invencibilidade
    stateManager:setInvincibility(invincible, owner, 80, time, makeTransparent)
end

---Verifica se o jogador está em modo ghost
---@return boolean
function MinigameClient:isGhostMode()
    return self.ghostMode
end

---Verifica se o jogador está em uma partida ativa
---@return boolean
function MinigameClient:isInMatch()
    -- ✅ CORRIGIDO: Usa sistema de estados ao invés de listas (evita race conditions)
    -- Uma partida está ativa se estiver em qualquer estado de match
    return self:isInMatchState()
end

---Inicia o loop de gerenciamento de visibilidade
---Wrapper para GhostModeManager (mantido para compatibilidade)
---@return nil
function MinigameClient:startVisibilityLoop()
    if self.ghostModeManager then
        self.ghostModeManager:startVisibilityLoop()
    end
end

---Para o loop de visibilidade
---@return nil
function MinigameClient:stopVisibilityLoop()
    if self.ghostModeManager then
        self.ghostModeManager:stopVisibilityLoop()
    end
    -- Limpa thread local também (se houver)
    self.visibilityThread = nil
end

---Gerencia os controles durante a partida
---@return nil
function MinigameClient:handleMatchBinds()
    -- ✅ FIX BUG #5: Usa ControlsManager ao invés de thread manual
    -- ✅ FIX BUG #2: Adiciona verificação de isLeaving para prevenir múltiplos envios
    -- ✅ FIX BUG #1: Verificação adicional para prevenir race condition
    
    -- Previne múltiplas chamadas simultâneas
    if self.leaveControlId then
        return
    end
    
    -- Para qualquer controle anterior (cleanup preventivo)
    self:stopMatchBinds()
    
    -- Registra controle ESC usando ControlsManager
    self.leaveControlId = self.controlsManager:register(322, function()
        -- ✅ FIX BUG #2: Verifica estado isLeaving
        if self.isLeaving or IsPauseMenuActive() or GetPauseMenuState() ~= 0 then
            return
        end

        local function leaveMatch()
            if self.isLeaving then
                return
            end

            -- ✅ FIX REPORTE: Removida verificação isInMatch() - permite sair em QUALQUER estado
            -- O servidor já valida se o jogador está na partida antes de processar
            -- Isso permite sair durante intro, quando morto, ou em qualquer estado inconsistente

            -- Marca como leaving
            self.isLeaving = true

            -- Tenta sair da partida primeiro
            TriggerServerEvent('dminigames.server:leaveMatch', self.name)

            -- ✅ FIX BUG CRÍTICO: NÃO remove o controle após primeiro uso!
            -- A flag isLeaving já previne múltiplos envios
            -- O controle só deve ser removido quando o servidor confirmar a saída ou a partida terminar
            -- Isso permite que o jogador tente sair novamente se o servidor não processar
            -- REMOVIDO: self:stopMatchBinds()

            -- ✅ FIX RACE CONDITION: Fallback aumentado de 1s para 3s
            -- Servidor pode demorar > 1s para processar (muitos jogadores, servidor lento)
            -- 3s é suficiente para processar sem causar dupla remoção desnecessária
            SetTimeout(3000, function()
                if self.isLeaving then
                    -- Ainda está preso após 3s, tenta sair da fila como último recurso
                    if self.queue and (self:isInMatch() or self.queue:isInQueue()) then
                        TriggerServerEvent('dminigames.server:leaveQueue', self.name)
                    end
                end
            end)

            -- ⚠️ Monitor de timeout para debugging (detecta callbacks com erro)
            -- Se isLeaving ainda está true após 5s, significa que onPlayerLeave teve erro no callback
            SetTimeout(5000, function()
                if self.isLeaving then
                    -- Reset isLeaving como último recurso (emergency fallback)
                    self.isLeaving = false
                end
            end)
        end

        if self.matchConfig and self.matchConfig.confirmLeave then
            if self.isLeaveConfirmOpen then
                return
            end

            self.isLeaveConfirmOpen = true
            self.matchConfig.confirmLeave(function(confirmed)
                self.isLeaveConfirmOpen = false
                if confirmed then
                    leaveMatch()
                end
            end)
            return
        end

        leaveMatch()
    end, {
        description = 'Leave Match (ESC)',
        enabled = true
    })
end

---Para os controles da partida
---@return nil
function MinigameClient:stopMatchBinds()
    -- ✅ FIX BUG #5: Para controles usando ControlsManager
    if self.leaveControlId then
        self.controlsManager:unregister(self.leaveControlId)
        self.leaveControlId = nil
    end

    self.isLeaveConfirmOpen = false
    
    -- ❌ REMOVIDO: NÃO resetar isLeaving aqui (causa race condition)
    -- isLeaving deve ser resetado APENAS no final de onPlayerLeave
    -- stopMatchBinds() pode ser chamado a qualquer momento (onMatchEnd, onRoundStart, etc)
    -- Resetar aqui causava reset prematuro antes de onPlayerLeave terminar
end

---Atualiza a visibilidade dos jogadores baseado no estado (vivo/morto/ghost)
---Wrapper para GhostModeManager (mantido para compatibilidade)
---@return nil
function MinigameClient:updatePlayersVisibility()
    if self.ghostModeManager then
        self.ghostModeManager:updatePlayersVisibility()
    end
end

---Restaura a visibilidade de todos os jogadores
---Wrapper para GhostModeManager (mantido para compatibilidade)
---@return nil
function MinigameClient:restoreAllPlayersVisibility()
    if self.ghostModeManager then
        self.ghostModeManager:restoreAllPlayersVisibility()
        return
    end
    
    -- Fallback: Implementação direta se não houver GhostModeManager
    local allPlayers = GetActivePlayers()
    local localPlayerId = PlayerId()

    -- Só restaura visibilidade de jogadores da PARTIDA, não de todos do servidor
    for _, player in ipairs(allPlayers) do
        if player ~= localPlayerId then
            local playerServerId = GetPlayerServerId(player)
            
            -- Só processa se o jogador estava nas listas da partida
            local isInMatch = self.alivePlayers[playerServerId] or 
                             self.deadPlayers[playerServerId] or 
                             self.ghostPlayers[playerServerId]
            
            if isInMatch then
                NetworkConcealPlayer(player, false, false)

                local playerPed = GetPlayerPed(player)
                
                -- ✅ FIX BUG COLISÃO CRÍTICO: Restaura visibilidade, alpha E colisão
                -- Sem isso, jogadores ficam "intangíveis" após ghost mode
                SetEntityVisible(playerPed, true, false)
                ResetEntityAlpha(playerPed)
                SetEntityCollision(playerPed, true, true)
                
                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if DoesEntityExist(vehicle) then
                        NetworkConcealEntity(vehicle, false)
                        SetEntityVisible(vehicle, true, false)
                        ResetEntityAlpha(vehicle)
                    end
                end
            end
        end
    end
end

---Retorna a configuração atual da partida
---@return MatchClientConfig? Configuração da partida ou nil se não houver
function MinigameClient:getCurrentMatchConfig()
    return self.matchConfig
end

---Conta jogadores vivos de roles específicos baseado nos times e jogadores vivos
---@param teams? table<string, table<number, number>> Times organizados por role [roleName] = {[source] = userId}
---@param alivePlayers? table<number, number> Tabela de jogadores vivos [source] = userId (opcional, usa self.alivePlayers se não fornecido)
---@param rolesToCount? table<string, boolean> Roles que devem ser contados [roleName] = true (opcional, se não fornecido conta todos os jogadores vivos)
---@return number Número de jogadores vivos dos roles especificados (ou todos se rolesToCount não fornecido)
function MinigameClient:countAlivePlayers(teams, alivePlayers, rolesToCount)
    alivePlayers = alivePlayers or self.alivePlayers or {}

    -- Se não fornecer teams, conta todos os jogadores vivos
    if not teams then
        local count = 0
        for _ in pairs(alivePlayers) do
            count = count + 1
        end
        return count
    end

    -- Se não fornecer rolesToCount, conta todos os jogadores vivos de todos os times
    if not rolesToCount then
        local count = 0
        for _, teamPlayers in pairs(teams) do
            for source, _ in pairs(teamPlayers) do
                if alivePlayers[source] then
                    count = count + 1
                end
            end
        end
        return count
    end

    -- Conta apenas os roles especificados
    local count = 0
    for roleName, _ in pairs(rolesToCount) do
        if teams[roleName] then
            for source, _ in pairs(teams[roleName]) do
                if alivePlayers[source] then
                    count = count + 1
                end
            end
        end
    end
    return count
end


RegisterNUICallback('closeNui', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('getRanking', function(data, cb)
    local gameMode = data.gameMode or 'murder'
    local page = data.page or 1
    local result = vSERVER.getRankingData(gameMode, page)
    if result and result.scoreboardData then
        SendNUIMessage({
            type = 'showScoreboard',
            data = {
                show = true,
                gameMode = result.gameMode or 'murder',
                scoreboardData = result.scoreboardData
            }
        })
    end
    cb(result and result.scoreboardData or {})
end)
