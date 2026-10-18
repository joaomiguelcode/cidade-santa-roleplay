---Sistema centralizado de gerenciamento de controles
---Gerencia múltiplas teclas e previne conflitos entre threads
---@class ControlsManager

-- ✅ DEBUG: Verifica se class() está disponível
if not class then
    error('[ControlsManager] ERRO CRÍTICO: função class() não está disponível!')
end

ControlsManager = class()

---Inicializa o gerenciador de controles
---@param minigameName string Nome do minigame (para logs)
function ControlsManager:__init(minigameName)
    self.minigameName = minigameName
    self.controls = {}
    self.mainThread = nil
    self.active = false
end

---Registra um controle
---@param key number Código da tecla (ex: 47 para G)
---@param callback function Callback a executar quando pressionar
---@param options? table Opções: { once: boolean, enabled: boolean, description: string }
---@return string controlId ID do controle registrado
function ControlsManager:register(key, callback, options)
    options = options or {}

    local controlId = tostring(key) .. '_' .. math.random(100000, 999999)

    self.controls[controlId] = {
        id = controlId,
        key = key,
        callback = callback,
        enabled = options.enabled ~= false, -- true por padrão
        once = options.once or false,
        description = options.description or 'Control ' .. key,
        hasProcessed = false,
        lastProcessed = 0
    }

    -- Inicia thread principal se ainda não estiver rodando
    if not self.mainThread then
        self:startMainThread()
    end

    return controlId
end

---Inicia a thread principal que gerencia todos os controles
function ControlsManager:startMainThread()
    if self.mainThread then
        return
    end

    self.active = true

    self.mainThread = CreateThread(function()

        while self.active and next(self.controls) do
            for controlId, control in pairs(self.controls) do
                -- Verifica se está habilitado
                if control.enabled then
                    -- Detecta pressionar da tecla
                    if IsControlJustPressed(0, control.key) or IsDisabledControlJustPressed(0, control.key) then
                        local now = GetGameTimer()

                        -- Cooldown de 100ms para evitar múltiplos triggers
                        if not control.hasProcessed or (now - control.lastProcessed) > 100 then
                            control.hasProcessed = true
                            control.lastProcessed = now

                            -- ✅ FIX CRÍTICO: Executa callback com pcall para evitar quebrar thread
                            pcall(function()
                                control.callback()
                            end)

                            -- Remove se for once
                            if control.once then
                                self.controls[controlId] = nil
                            else
                                -- Reset hasProcessed após cooldown
                                SetTimeout(150, function()
                                    if control then
                                        control.hasProcessed = false
                                    end
                                end)
                            end
                        end
                    end
                end
            end

            Wait(0)
        end

        self.mainThread = nil
    end)
end

---Remove um controle específico
---@param controlId string ID do controle
---@return boolean success
function ControlsManager:unregister(controlId)
    if self.controls[controlId] then
        self.controls[controlId] = nil
        return true
    end
    return false
end

---Remove todos os controles de uma tecla específica
---@param key number Código da tecla
---@return number count Quantidade de controles removidos
function ControlsManager:unregisterByKey(key)
    local count = 0
    for controlId, control in pairs(self.controls) do
        if control.key == key then
            self.controls[controlId] = nil
            count = count + 1
        end
    end

    return count
end

---Habilita/desabilita um controle
---@param controlId string ID do controle
---@param enabled boolean Estado desejado
---@return boolean success
function ControlsManager:setEnabled(controlId, enabled)
    if self.controls[controlId] then
        self.controls[controlId].enabled = enabled
        return true
    end
    return false
end

---Habilita/desabilita todos os controles
---@param enabled boolean Estado desejado
function ControlsManager:setAllEnabled(enabled)
    for _, control in pairs(self.controls) do
        control.enabled = enabled
    end
end

---Para todos os controles e a thread principal
function ControlsManager:stopAll()
    self.controls = {}
    self.active = false
    self.mainThread = nil
end

---Retorna informações sobre os controles ativos
---@return table stats Estatísticas dos controles
function ControlsManager:getStats()
    local total = 0
    local enabled = 0
    local disabled = 0

    for _, control in pairs(self.controls) do
        total = total + 1
        if control.enabled then
            enabled = enabled + 1
        else
            disabled = disabled + 1
        end
    end

    return {
        total = total,
        enabled = enabled,
        disabled = disabled,
        isRunning = self.mainThread ~= nil
    }
end

---Verifica se um controle existe
---@param controlId string ID do controle
---@return boolean exists
function ControlsManager:exists(controlId)
    return self.controls[controlId] ~= nil
end
