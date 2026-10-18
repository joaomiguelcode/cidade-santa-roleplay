---Utils compartilhados (client e server).
---SetTimeoutEx, ClearTimeoutEx, PrintJSON, utils table base.

utils = utils or {}

-- Implementação customizada de SetTimeout com suporte a cancelamento
local timeouts = {}
local nextTimeoutId = 0

---Cria um timeout que pode ser cancelado
---@param delay number Tempo em milissegundos
---@param callback fun(): nil Função a ser executada
---@return number ID do timeout criado
function SetTimeoutEx(delay, callback)
    local id = nextTimeoutId
    nextTimeoutId = nextTimeoutId + 1

    timeouts[id] = { cancelled = false }

    Citizen.CreateThread(function()
        Citizen.Wait(delay)

        local timeout = timeouts[id]
        if timeout and not timeout.cancelled then
            callback()
        end

        timeouts[id] = nil
    end)

    return id
end

---Cancela um timeout criado com SetTimeoutEx
---@param id number ID do timeout a ser cancelado
function ClearTimeoutEx(id)
    local timeout = timeouts[id]
    if timeout then
        timeout.cancelled = true
    end
end

---Serializa uma tabela substituindo funções por strings
---@param data any Dados a serem serializados
---@param seen? table Tabela para rastrear referências circulares
---@return any Dados serializados
local function serializeForJSON(data, seen)
    seen = seen or {}

    local dataType = type(data)

    if dataType == 'function' then
        return '[Function]'
    elseif dataType == 'table' then
        if seen[data] then
            return '[Circular Reference]'
        end
        seen[data] = true

        local result = {}
        for key, value in pairs(data) do
            local serializedKey = serializeForJSON(key, seen)
            local serializedValue = serializeForJSON(value, seen)
            result[serializedKey] = serializedValue
        end
        seen[data] = nil
        return result
    else
        return data
    end
end

---Imprime dados em formato JSON, substituindo funções por strings
---@param data any Dados a serem impressos
---@param options? table Opções para json.encode (ex: { indent = true })
---@return nil
function PrintJSON(data, options)
    options = options or {}
    local serialized = serializeForJSON(data)
    -- print(json.encode(serialized, options))
end
