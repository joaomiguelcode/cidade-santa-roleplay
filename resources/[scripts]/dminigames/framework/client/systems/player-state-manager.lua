---@class PlayerStateOperation
---@field id string ID único da operação
---@field owner string Owner da operação (ex: "camera", "minigame")
---@field type string Tipo da operação (ex: "invincibility", "freeze")
---@field timeoutId? number ID do timeout (se houver)
---@field callback? function Callback para cancelar
---@field priority number Prioridade (maior = mais importante)

---@class PlayerStateManager
---@field invincibilityOwner? string Owner atual da invencibilidade
---@field invincibilityPriority number Prioridade do owner atual
---@field freezeOwner? string Owner atual do freeze
---@field freezePriority number Prioridade do owner atual
---@field ghostModeOwner? string Owner atual do ghost mode
---@field ghostModePriority number Prioridade do owner atual
---@field pendingOperations table<string, PlayerStateOperation> Operações pendentes
---@field operationCounter number Contador para IDs únicos
PlayerStateManager = class()

-- Instância singleton
local PlayerStateManagerInstance = nil

---Obtém a instância singleton do PlayerStateManager
---@return PlayerStateManager
function PlayerStateManager:getInstance()
    if not PlayerStateManagerInstance then
        PlayerStateManagerInstance = PlayerStateManager()
    end
    return PlayerStateManagerInstance
end

function PlayerStateManager:__init()
    self.invincibilityOwner = nil
    self.invincibilityPriority = 0
    self.invincibilityTransparent = false -- Se invencibilidade aplica transparência
    self.freezeOwner = nil
    self.freezePriority = 0
    self.ghostModeOwner = nil
    self.ghostModePriority = 0
    self.pendingOperations = {}
    self.operationCounter = 0
end

---Define invencibilidade com sistema de ownership
---@param invincible boolean Se o jogador deve ser invulnerável
---@param owner string Owner da operação (ex: "camera", "minigame")
---@param priority number Prioridade (padrão: 50)
---@param duration? number Duração em ms (opcional, se não fornecido é permanente até remover)
---@param makeTransparent? boolean Se deve aplicar transparência visual (alpha 150) durante invencibilidade (padrão: false)
---@return string? operationId ID da operação criada (se houver timeout)
function PlayerStateManager:setInvincibility(invincible, owner, priority, duration, makeTransparent)
    priority = priority or 50
    local playerPed = PlayerPedId()
    
    if not DoesEntityExist(playerPed) then
        return nil
    end
    
    -- Se está tentando definir invencibilidade
    if invincible then
        -- Verifica se já há um owner com prioridade maior
        if self.invincibilityOwner and self.invincibilityPriority > priority then
            return nil
        end
        
        -- Cancela operações do owner anterior se houver mudança
        if self.invincibilityOwner and self.invincibilityOwner ~= owner then
            self:_cancelOwnerOperations(self.invincibilityOwner, 'invincibility')
        end
        
        -- Define novo owner
        self.invincibilityOwner = owner
        self.invincibilityPriority = priority
        self.invincibilityTransparent = makeTransparent == true
        
        SetEntityInvincible(playerPed, true)
        LocalPlayer["state"]["Invincible"] = true
        
        -- Aplica transparência se solicitado
        if makeTransparent then
            SetEntityAlpha(playerPed, 150, false)
        end
        
        -- Se houver duração, cria operação para remover
        if duration and duration > 0 then
            local operationId = self:_createOperation({
                owner = owner,
                type = 'invincibility',
                priority = priority,
                callback = function()
                    self:removeInvincibility(owner)
                end
            }, duration)
            
            return operationId
        end
        
        return nil
    else
        -- Se está tentando remover invencibilidade
        -- Só remove se for o owner atual ou se tiver prioridade maior
        if self.invincibilityOwner == owner or priority > self.invincibilityPriority then
            -- Cancela operações pendentes deste owner
            self:_cancelOwnerOperations(owner, 'invincibility')
            
            -- Remove invencibilidade
            SetEntityInvincible(playerPed, false)
            LocalPlayer["state"]["Invincible"] = false
            
            -- Remove transparência se estava aplicada
            if self.invincibilityTransparent then
                SetEntityAlpha(playerPed, 255, false)
                ResetEntityAlpha(playerPed)
            end
            
            -- Limpa owner se for o atual
            if self.invincibilityOwner == owner then
                self.invincibilityOwner = nil
                self.invincibilityPriority = 0
                self.invincibilityTransparent = false
            end
        end
    end
end

---Remove invencibilidade de um owner específico
---@param owner string Owner que está removendo
function PlayerStateManager:removeInvincibility(owner)
    self:setInvincibility(false, owner, 100) -- Prioridade alta para forçar remoção
end

---Cancela todas as operações de um owner
---@param owner string Owner cujas operações devem ser canceladas
---@param type? string Tipo específico de operação (opcional)
function PlayerStateManager:cancelOwnerOperations(owner, type)
    self:_cancelOwnerOperations(owner, type)
end

---Cancela TODAS as operações pendentes e reseta todos os estados
function PlayerStateManager:cancelAllOperations()
    local playerPed = PlayerPedId()
    
    for operationId, operation in pairs(self.pendingOperations) do
        self:_cancelOperation(operationId)
    end
    
    -- Reseta todos os estados
    if DoesEntityExist(playerPed) then
        SetEntityInvincible(playerPed, false)
        LocalPlayer["state"]["Invincible"] = false
        FreezeEntityPosition(playerPed, false)
        -- ✅ FIX BUG TRANSPARÊNCIA (CAUSA RAIZ): Reseta flag APENAS quando reseta alpha
        -- Isso previne race condition onde cancelAllOperations reseta a flag
        -- mas o timeout de invencibilidade ainda não executou
        if self.invincibilityTransparent then
            SetEntityAlpha(playerPed, 255, false)
            ResetEntityAlpha(playerPed)
            self.invincibilityTransparent = false  -- ✅ Movido para dentro do if!
        end
    end
    
    self.invincibilityOwner = nil
    self.invincibilityPriority = 0
    -- self.invincibilityTransparent = false  ← REMOVIDO (agora está dentro do if acima)
    self.freezeOwner = nil
    self.freezePriority = 0
    self.ghostModeOwner = nil
    self.ghostModePriority = 0
end

-- Métodos privados

function PlayerStateManager:_createOperation(operation, duration)
    self.operationCounter = self.operationCounter + 1
    local operationId = ('%s_%s_%d'):format(operation.owner, operation.type, self.operationCounter)
    
    operation.id = operationId
    operation.timeoutId = SetTimeoutEx(duration, function()
        if self.pendingOperations[operationId] then
            operation.callback()
            self.pendingOperations[operationId] = nil
        end
    end)
    
    self.pendingOperations[operationId] = operation
    
    return operationId
end

function PlayerStateManager:_cancelOperation(operationId)
    local operation = self.pendingOperations[operationId]
    if not operation then
        return
    end
    
    if operation.timeoutId then
        ClearTimeoutEx(operation.timeoutId)
    end
    
    self.pendingOperations[operationId] = nil
end

function PlayerStateManager:_cancelOwnerOperations(owner, type)
    local toCancel = {}
    
    for operationId, operation in pairs(self.pendingOperations) do
        if operation.owner == owner and (not type or operation.type == type) then
            table.insert(toCancel, operationId)
        end
    end
    
    for _, operationId in ipairs(toCancel) do
        self:_cancelOperation(operationId)
    end
    
    -- ✅ FIX BUG INVENCIBILIDADE CRÍTICO: Remove invencibilidade ativa se o owner corresponder
    -- Isso garante que cancelar operações REALMENTE remove a invencibilidade
    if (not type or type == 'invincibility') and self.invincibilityOwner == owner then
        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) then
            SetEntityInvincible(playerPed, false)
            LocalPlayer["state"]["Invincible"] = false
            
            -- Remove transparência se estava aplicada
            if self.invincibilityTransparent then
                SetEntityAlpha(playerPed, 255, false)
                ResetEntityAlpha(playerPed)
            end
        end
        self.invincibilityOwner = nil
        self.invincibilityPriority = 0
        self.invincibilityTransparent = false
    end
end

function PlayerStateManager:_countOperations()
    local count = 0
    for _ in pairs(self.pendingOperations) do
        count = count + 1
    end
    return count
end
