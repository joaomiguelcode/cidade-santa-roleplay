---@class QueueJoinData
---@field playersNeeded number Quantidade de jogadores que faltam para iniciar
---@field queueId number ID único da fila
---@field currentCount number Quantidade atual de jogadores na fila
---@field maxPlayers number Máximo de jogadores na fila
---@field queueState string Estado da fila: 'waiting', 'full'

---@class QueueLeaveData
---@field queueId number ID único da fila
---@field reason string Motivo da saída: 'voluntary', 'timeout', 'disconnect'

---@class QueueTimeoutData
---@field queueId number ID único da fila
---@field timeInQueue number Tempo que o jogador ficou na fila em ms

---@class QueueUpdateData
---@field playersNeeded number Quantidade de jogadores que faltam para iniciar
---@field queueId number ID único da fila
---@field currentCount number Quantidade atual de jogadores na fila

---@class QueueDisconnectData
---@field userId number ID do usuário que desconectou
---@field queueId number ID único da fila
---@field currentCount number Quantidade restante de jogadores na fila
---@field playersNeeded number Quantidade de jogadores que faltam para iniciar

---@class CameraManager
---@field active boolean
---@field camera number|nil
---@field spline number|nil
---@field transitionThread thread|nil
---@field looped boolean
---@field splines table|nil
---@field nextSplineStartTime number|nil

---@alias QueueClientState "idle"|"in_queue"|"match_started"
--- Estados possíveis:
--- - "idle": Não está na fila e não está em partida
--- - "in_queue": Está aguardando na fila
--- - "match_started": A partida já iniciou (transição automática de in_queue)

---@class QueueConfig
---@field name string Nome do minigame (obrigatório)
---@field camera? CameraManager Gerenciador de câmera (opcional, será criado se não fornecido)
---@field cameras? table Array de configurações de câmera para transições
---@field onJoin? fun(data: QueueJoinData): nil Callback quando entra na fila
---@field onLeave? fun(data: QueueLeaveData): nil Callback quando sai da fila
---@field onTimeout? fun(data: QueueTimeoutData): nil Callback quando timeout da fila
---@field onPlayerDisconnect? fun(data: QueueDisconnectData): nil Callback quando outro jogador desconecta da fila

---@class QueueManager
---@field name string Nome do minigame
---@field state QueueClientState Estado atual do cliente na fila
---@field controlThread? thread Thread que gerencia os controles da fila
---@field camera CameraManager Gerenciador de câmera
---@field onJoin? fun(data: QueueJoinData): nil
---@field onLeave? fun(data: QueueLeaveData): nil
---@field onTimeout? fun(data: QueueTimeoutData): nil
---@field onPlayerDisconnect? fun(data: QueueDisconnectData): nil
---@field cameras? table
QueueManager = class()

---Inicializa o QueueManager
---@param data QueueConfig Dados da fila
---@return QueueManager
function QueueManager:__init(data)
    data = data or {}

    self.name = data.name or nil

    if (not self.name) then
        error('Queue name is required')
    end

    -- Estado inicial: idle (não está na fila)
    self.state = 'idle'
    self.controlThread = nil
    self.camera = data.camera or CameraManager()

    -- Armazena callbacks e configurações
    self.onJoin = data.onJoin
    self.onLeave = data.onLeave
    self.onTimeout = data.onTimeout
    self.onPlayerDisconnect = data.onPlayerDisconnect
    self.cameras = data.cameras

    -- Registra eventos de rede
    self:_registerNetworkEvents()
end

---Registra todos os eventos de rede
---@private
---@return nil
function QueueManager:_registerNetworkEvents()
    RegisterNetEvent(('%s.client:onJoinQueue'):format(self.name))
    AddEventHandler(('%s.client:onJoinQueue'):format(self.name), function(data)
        self:_handleJoinQueue(data)
    end)

    RegisterNetEvent(('%s.client:onLeaveQueue'):format(self.name))
    AddEventHandler(('%s.client:onLeaveQueue'):format(self.name), function(data)
        self:_handleLeaveQueue(data)
    end)

    RegisterNetEvent(('%s.client:onQueueUpdate'):format(self.name))
    AddEventHandler(('%s.client:onQueueUpdate'):format(self.name), function(data)
        self:_handleQueueUpdate(data)
    end)

    RegisterNetEvent(('%s.client:onQueueTimeout'):format(self.name))
    AddEventHandler(('%s.client:onQueueTimeout'):format(self.name), function(data)
        self:_handleQueueTimeout(data)
    end)

    RegisterNetEvent(('%s.client:onQueuePlayerDisconnect'):format(self.name))
    AddEventHandler(('%s.client:onQueuePlayerDisconnect'):format(self.name), function(data)
        self:_handlePlayerDisconnect(data)
    end)
end

---Valida se uma transição de estado é permitida
---@private
---@param fromState QueueClientState Estado atual
---@param toState QueueClientState Estado desejado
---@return boolean
function QueueManager:_isValidTransition(fromState, toState)
    local validTransitions = {
        idle = { 'in_queue' },
        in_queue = { 'idle', 'match_started' },
        match_started = { 'idle' }
    }

    local allowed = validTransitions[fromState]
    if not allowed then
        return false
    end

    for _, state in ipairs(allowed) do
        if state == toState then
            return true
        end
    end

    return false
end

---Muda o estado do QueueManager com validação
---@private
---@param newState QueueClientState Novo estado
---@return boolean success Se a transição foi bem-sucedida
function QueueManager:_transitionTo(newState)
    if not self:_isValidTransition(self.state, newState) then
        return false
    end

    self.state = newState
    return true
end

---Trata o evento de entrar na fila
---@private
---@param data QueueJoinData Dados do evento
---@return nil
function QueueManager:_handleJoinQueue(data)
    -- Se já está em match_started, ignora (pode ser evento duplicado/atrasado)
    if self.state == 'match_started' then
        return
    end

    -- Se ainda não está na fila, inicializa (primeira vez entrando)
    if self.state == 'idle' then
        if not self:_transitionTo('in_queue') then
            return
        end
        
        -- ✅ FIX RACE CONDITION: Define minigame:active IMEDIATAMENTE no cliente (entrou na fila)
        -- Previne race condition onde player morre antes do state do servidor chegar
        -- Usa self.name (string) ao invés de true (boolean) para manter consistência
        LocalPlayer["state"]["minigame:active"] = self.name

        -- ✅ FIX DELAY: Inicia controles da fila IMEDIATAMENTE (antes de câmera e UI)
        -- Previne delay causado pelo carregamento da cena da câmera (pode levar 2-10s!)
        self:_startQueueControls()

        -- ✅ FIX PERFORMANCE: Inicializa UI ANTES da câmera (mais responsivo)
        if self.onJoin then
            self.onJoin(data)
        end

        -- ✅ GARANTIA: Cinemática NUNCA é ignorada - retry com timeout progressivo
        -- Tentativa 1: 3s (rápido), Tentativa 2: 8s (normal), Tentativa 3: 15s (lento)
        if self.cameras and self.camera then
            CreateThread(function()
                -- print('[CAMERA DEBUG] 🎬 Iniciando sistema de câmera da fila')
                if self.state ~= 'in_queue' then 
                    -- print('[CAMERA DEBUG] ⚠️ Estado não é in_queue, abortando')
                    return 
                end
                
                local firstSpline = self.cameras[1]
                if not firstSpline or not firstSpline.center then return end
                
                local stateChecker = function()
                    return self.state == 'in_queue'
                end
                
                local success = false
                local attempts = {
                    { timeout = nil, name = "rápida (3s)" },      -- Usa SCENE_LOAD_TIMEOUT_FAST
                    { timeout = 8000, name = "normal (8s)" },     -- SCENE_LOAD_TIMEOUT_NORMAL
                    { timeout = 15000, name = "lenta (15s)" }     -- SCENE_LOAD_TIMEOUT_SLOW
                }
                
                -- Tenta carregar com timeout progressivo
                for i, attempt in ipairs(attempts) do
                    if self.state ~= 'in_queue' then return end
                    
                    -- print(('[CAMERA] Tentativa %d/%d de carregamento (%s)'):format(i, #attempts, attempt.name))
                    success = self.camera:loadSceneOnce(firstSpline.center, stateChecker, attempt.timeout)
                    
                    if success then
                        -- print(('[CAMERA] ✅ Cena carregada com sucesso na tentativa %d'):format(i))
                        break
                    else
                        if self.state ~= 'in_queue' then
                            -- print('[CAMERA] ⚠️ Carregamento abortado (match iniciou)')
                            return
                        end
                        -- print(('[CAMERA] ⚠️ Tentativa %d falhou, tentando novamente...'):format(i))
                        Wait(500) -- Pequeno delay entre retries
                    end
                end
                
                -- ✅ FALLBACK: Se todas as tentativas falharam mas ainda está na fila,
                -- inicia câmera mesmo assim (melhor mostrar cinemática imperfeita do que não mostrar)
                if not success and self.state == 'in_queue' then
                    -- print('[CAMERA] ⚠️ Todas as tentativas falharam, iniciando câmera como fallback')
                    -- Garante que tela não está preta
                    DoScreenFadeIn(500)
                    Wait(500)
                end
                
                -- Inicia transição de câmera (sempre, mesmo se carregamento não foi perfeito)
                if self.state == 'in_queue' then
                    self.camera:setSplines(self.cameras)
                    self.camera:transitionCamera(true)
                end
            end)
        end
    else
        -- Já está na fila, apenas atualiza contagem (outro jogador entrou)
        if self.onJoin then
            self.onJoin(data)
        end
    end
end

---Trata o evento de sair da fila
---@private
---@param data QueueLeaveData Dados do evento
---@return nil
function QueueManager:_handleLeaveQueue(data)
    -- Só processa se não estiver em idle
    if self.state == 'idle' then
        return
    end
    
    -- ✅ Guarda estado anterior para decidir se remove minigame:active
    local wasInQueue = (self.state == 'in_queue')

    if self.onLeave then
        self.onLeave(data)
    end

    -- Limpa recursos
    self:_cleanupQueueResources()

    -- Muda estado para idle
    self:_transitionTo('idle')
    
    -- ✅ FIX SURVIVAL: Só remove minigame:active se estava na FILA (não em partida)
    -- Se estava em match_started, o framework já remove via onMatchEnd/onPlayerLeave
    if wasInQueue then
        LocalPlayer["state"]["minigame:active"] = false
    end
end

---Trata atualização da fila (outro jogador entrou/saiu)
---@private
---@param data QueueUpdateData Dados do evento
---@return nil
function QueueManager:_handleQueueUpdate(data)
    -- Só atualiza UI se estiver na fila
    if self.state ~= 'in_queue' then
        return
    end

    -- Usa onJoin para atualizar UI com os dados de atualização (compatível com QueueJoinData)
    if self.onJoin then
        -- Converte QueueUpdateData para formato compatível com QueueJoinData
        local joinData = {
            playersNeeded = data.playersNeeded,
            queueId = data.queueId,
            currentCount = data.currentCount,
            maxPlayers = 0, -- Não disponível em update, mas não é crítico
            queueState = 'waiting' -- Assumindo waiting já que está recebendo update
        }
        self.onJoin(joinData)
    end
end

---Trata timeout da fila
---@private
---@param data QueueTimeoutData Dados do evento
---@return nil
function QueueManager:_handleQueueTimeout(data)
    -- Só processa se não estiver em idle
    if self.state == 'idle' then
        return
    end

    if self.onTimeout then
        self.onTimeout(data)
    end
    
    -- ✅ FIX SURVIVAL: Remove minigame:active=false quando timeout da fila
    LocalPlayer["state"]["minigame:active"] = false

    -- Limpa recursos
    self:_cleanupQueueResources()

    -- Muda estado para idle
    self:_transitionTo('idle')
end

---Trata desconexão de outro jogador da fila
---@private
---@param data QueueDisconnectData Dados do evento
---@return nil
function QueueManager:_handlePlayerDisconnect(data)
    if self.onPlayerDisconnect then
        self.onPlayerDisconnect(data)
    end

    -- Atualiza contagem se estiver na fila
    if self.state == 'in_queue' and self.onJoin then
        -- Converte QueueDisconnectData para formato compatível com QueueJoinData
        local joinData = {
            playersNeeded = data.playersNeeded,
            queueId = data.queueId,
            currentCount = data.currentCount,
            maxPlayers = 0, -- Não disponível em disconnect, mas não é crítico
            queueState = 'waiting' -- Assumindo waiting já que está recebendo update
        }
        self.onJoin(joinData)
    end
end

---Limpa todos os recursos relacionados à fila
---@private
---@return nil
function QueueManager:_cleanupQueueResources()
    -- Para controles
    self:_stopQueueControls()

    -- Destrói câmera se houver
    if self.cameras and self.camera then
        self.camera:destroyCamera()
    end
end

---Inicia os controles da fila (tecla ESC para sair)
---@private
---@return nil
function QueueManager:_startQueueControls()
    -- ✅ FIX REPORTE: Permite iniciar controles mesmo se estado estiver inconsistente
    -- Isso previne casos onde o jogador está preso em estado incorreto
    -- Só bloqueia se realmente estiver idle (não está na fila nem em partida)
    if self.state == 'idle' then
        return
    end

    -- Se já existe uma thread rodando, não cria outra
    if self.controlThread then
        return
    end

    -- Cria thread de controles
    self.controlThread = CreateThread(function()
        local CONTROL_KEY = 322 -- ESC
        local currentState = self.state

        while currentState == 'in_queue' do
            -- Verifica se ainda está no estado correto a cada iteração
            currentState = self.state

            if currentState ~= 'in_queue' then
                break
            end

            if (IsControlJustPressed(0, CONTROL_KEY) or IsDisabledControlJustPressed(0, CONTROL_KEY))
                and not IsPauseMenuActive() and GetPauseMenuState() == 0 then
                -- Sai da fila
                TriggerServerEvent('dminigames.server:leaveQueue', self.name)
                NetworkEndTutorialSession()
                break
            end

            Wait(0)
        end

        -- print('[QUEUE] ⚠️ Thread de controle FINALIZADA - Minigame:', self.name)
        -- Thread terminou, limpa referência
        self.controlThread = nil
    end)
end

---Para os controles da fila
---@private
---@return nil
function QueueManager:_stopQueueControls()
    -- A thread vai terminar automaticamente quando o estado mudar
    -- Apenas limpa a referência
    self.controlThread = nil
end

---Notifica que a partida iniciou (chamado pelo MinigameClient)
---@return nil
function QueueManager:notifyMatchStarted()
    -- Se não está na fila e não está em idle (late join), não faz nada
    -- IMPORTANTE: Aceita 'idle' também para late joiners que nunca receberam onJoinQueue
    if self.state ~= 'in_queue' and self.state ~= 'idle' then
        return
    end
    
    -- Limpa recursos da fila (câmera, controles, etc)
    self:_cleanupQueueResources()

    -- Transiciona para match_started
    self:_transitionTo('match_started')
end

---Notifica que a partida terminou (chamado pelo MinigameClient)
---@return nil
function QueueManager:notifyMatchEnded()
    -- Se estava em match, volta para idle
    if self.state == 'match_started' then
        self:_transitionTo('idle')
    end
end

---Desabilita os controles da fila (método público para compatibilidade)
---@deprecated Use notifyMatchStarted() ao invés disso
---@return nil
function QueueManager:disableQueueControls()
    self:notifyMatchStarted()
end

---Verifica se está na fila
---@return boolean
function QueueManager:isInQueue()
    return self.state == 'in_queue'
end

---Verifica se a partida já iniciou
---@return boolean
function QueueManager:isMatchStarted()
    return self.state == 'match_started'
end

---Entra na fila de matchmaking
---@return nil
function QueueManager:joinQueue()
    -- Validação: não permite entrar se já estiver na fila ou em partida
    if self.state ~= 'idle' then
        return
    end

    TriggerServerEvent('dminigames.server:joinQueue', self.name)
end
