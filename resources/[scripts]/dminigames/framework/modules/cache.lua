---@class CacheManager
---@field cache table<string, table>
CacheManager = class()

---inicializa o CacheManager
function CacheManager:__init()
    self.cache = {}
end

---cria um novo cache vazio
---@param name string Nome do cache a ser criado
function CacheManager:create(name)
    self.cache[name] = {}
end

---define um valor em um cache
---@param name string Nome do cache
---@param key string|number Chave do valor
---@param value any Valor a ser armazenado
function CacheManager:set(name, key, value)
    self.cache[name] = self.cache[name] or {}
    self.cache[name][key] = value
end

---adiciona um valor ao final de um cache (array)
---@param name string Nome do cache
---@param value any Valor a ser adicionado
function CacheManager:push(name, value)
    self.cache[name] = self.cache[name] or {}
    table.insert(self.cache[name], value)
end

---obtém um valor de um cache
---@param name string Nome do cache
---@param key string|number Chave do valor
---@return any|nil Valor armazenado ou nil se não existir
function CacheManager:get(name, key)
    if not self.cache[name] then
        return nil
    end
    return self.cache[name][key]
end

---remove um valor de um cache
---@param name string Nome do cache
---@param key string|number Chave do valor a ser removido
function CacheManager:remove(name, key)
    if not self.cache[name] then
        return
    end
    self.cache[name][key] = nil
end

---limpa todos os valores de um cache (mantém o cache existente)
---@param name string Nome do cache
function CacheManager:clear(name)
    if not self.cache[name] then
        return
    end
    self.cache[name] = {}
end

---verifica se um cache existe
---@param name string Nome do cache
---@return boolean true se o cache existe, false caso contrário
function CacheManager:existsCache(name)
    return self.cache[name] ~= nil
end

---verifica se uma chave existe em um cache
---@param name string Nome do cache
---@param key string|number Chave a ser verificada
---@return boolean true se a chave existe, false caso contrário
function CacheManager:hasKey(name, key)
    return self.cache[name] ~= nil and self.cache[name][key] ~= nil
end

---verifica se um cache existe (alias para existsCache)
---@param name string Nome do cache
---@return boolean true se o cache existe, false caso contrário
function CacheManager:exists(name)
    return self:existsCache(name)
end

---verifica se uma chave existe (alias para hasKey)
---@param name string Nome do cache
---@param key string|number Chave a ser verificada
---@return boolean true se a chave existe, false caso contrário
function CacheManager:has(name, key)
    return self:hasKey(name, key)
end

---retorna o tamanho de um cache (número de chaves)
---@param name string Nome do cache
---@return number Número de chaves no cache (0 se o cache não existir)
function CacheManager:size(name)
    if not self.cache[name] then
        return 0
    end
    local count = 0
    for _ in pairs(self.cache[name]) do
        count = count + 1
    end
    return count
end

---retorna o tamanho de um cache (alias para size)
---@param name string Nome do cache
---@return number Número de chaves no cache (0 se o cache não existir)
function CacheManager:count(name)
    return self:size(name)
end

---verifica se um cache está vazio
---@param name string Nome do cache
---@return boolean true se o cache estiver vazio ou não existir, false caso contrário
function CacheManager:isEmpty(name)
    return self:size(name) == 0
end

---retorna todas as chaves de um cache
---@param name string Nome do cache
---@return table<string|number> Array com todas as chaves do cache
function CacheManager:keys(name)
    if not self.cache[name] then
        return {}
    end
    local keys = {}
    for key in pairs(self.cache[name]) do
        table.insert(keys, key)
    end
    return keys
end

---retorna todos os valores de um cache
---@param name string Nome do cache
---@return table<any> Array com todos os valores do cache
function CacheManager:values(name)
    if not self.cache[name] then
        return {}
    end
    local values = {}
    for _, value in pairs(self.cache[name]) do
        table.insert(values, value)
    end
    return values
end

---retorna todo o conteúdo de um cache
---@param name string Nome do cache
---@return table Tabela completa do cache (tabela vazia se não existir)
function CacheManager:getAll(name)
    if not self.cache[name] then
        return {}
    end
    return self.cache[name]
end

---remove e retorna um valor de um cache (pop)
---@param name string Nome do cache
---@param key string|number Chave do valor a ser removido
---@return any|nil Valor removido ou nil se não existir
function CacheManager:pop(name, key)
    if not self.cache[name] then
        return nil
    end
    local value = self.cache[name][key]
    self.cache[name][key] = nil
    return value
end

---incrementa um valor numérico em um cache
---@param name string Nome do cache
---@param key string|number Chave do valor
---@param amount? number Quantidade a incrementar (padrão: 1)
---@return number Novo valor após incremento
function CacheManager:increment(name, key, amount)
    amount = amount or 1
    self.cache[name] = self.cache[name] or {}
    self.cache[name][key] = (self.cache[name][key] or 0) + amount
    return self.cache[name][key]
end

---decrementa um valor numérico em um cache
---@param name string Nome do cache
---@param key string|number Chave do valor
---@param amount? number Quantidade a decrementar (padrão: 1)
---@return number Novo valor após decremento
function CacheManager:decrement(name, key, amount)
    amount = amount or 1
    return self:increment(name, key, -amount)
end

---faz merge de dados em um cache (sobrescreve valores existentes)
---@param name string Nome do cache
---@param data table<string|number, any> Tabela com dados a serem mesclados
function CacheManager:merge(name, data)
    self.cache[name] = self.cache[name] or {}
    for key, value in pairs(data) do
        self.cache[name][key] = value
    end
end

---deleta completamente um cache
---@param name string Nome do cache a ser deletado
function CacheManager:delete(name)
    self.cache[name] = nil
end

---limpa todo o cache (remove todos os caches)
function CacheManager:clearAll()
    self.cache = {}
end

---retorna o valor de um cache ou um valor padrão se não existir
---@param name string Nome do cache
---@param key string|number Chave do valor
---@param defaultValue any Valor padrão a ser retornado se a chave não existir
---@return any Valor do cache ou valor padrão
function CacheManager:getOrDefault(name, key, defaultValue)
    if self:hasKey(name, key) then
        return self:get(name, key)
    end
    return defaultValue
end

---retorna o valor de um cache ou cria com um valor padrão se não existir
---@param name string Nome do cache
---@param key string|number Chave do valor
---@param defaultValue any Valor padrão a ser definido se a chave não existir
---@return any Valor do cache ou valor padrão definido
function CacheManager:getOrSet(name, key, defaultValue)
    if self:hasKey(name, key) then
        return self:get(name, key)
    end
    self:set(name, key, defaultValue)
    return defaultValue
end

CacheManager = CacheManager()
