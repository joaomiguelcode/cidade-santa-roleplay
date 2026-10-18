---@class PropData
---@field id string ID único do prop
---@field model string|number Hash do modelo
---@field entity number Entidade do prop criado
---@field coords vector3 Coordenadas do prop
---@field heading number Heading do prop
---@field createdAt number Timestamp de criação

---Sistema de gerenciamento de props 3D
---@class PropHandler
---@field props table<string, PropData> Tabela de props ativos [id] = PropData
---@field nextId number Contador para IDs únicos
PropHandler = class()

function PropHandler:__init()
    self.props = {}
    self.nextId = 0
end

---Carrega um modelo de prop
---@param model string|number Hash ou nome do modelo
---@param timeout? number Timeout em ms (padrão: 10000)
---@return boolean success Se o modelo foi carregado
---@return string? message Mensagem de erro ou sucesso
function PropHandler:loadModel(model, timeout)
    timeout = timeout or 10000
    
    local modelHash = type(model) == 'string' and GetHashKey(model) or model
    
    if HasModelLoaded(modelHash) then
        return true, 'Model already loaded'
    end
    
    RequestModel(modelHash)
    
    local startTime = GetGameTimer()
    local timeoutTime = startTime + timeout

    repeat
        Wait(1)

        if GetGameTimer() > timeoutTime then
            return false, 'Timeout loading model'
        end

        if HasModelLoaded(modelHash) then
            return true, 'Model loaded'
        end
    until HasModelLoaded(modelHash)

    return false, 'Model not loaded'
end

---Define mapeamento de armas para modelos de props
---Permite que cada minigame configure seus próprios mapeamentos
---@param weaponName string Nome da arma (ex: 'WEAPON_REVOLVER')
---@param propModel string|number Hash ou nome do modelo do prop
---@return nil
function PropHandler:setWeaponPropMapping(weaponName, propModel)
    if not self.weaponMappings then
        self.weaponMappings = {}
    end
    self.weaponMappings[weaponName] = propModel
end

---Define múltiplos mapeamentos de uma vez
---@param mappings table<string, string|number> Tabela de mapeamentos [weaponName] = propModel
---@return nil
function PropHandler:setWeaponPropMappings(mappings)
    if not self.weaponMappings then
        self.weaponMappings = {}
    end
    for weaponName, propModel in pairs(mappings) do
        self.weaponMappings[weaponName] = propModel
    end
end

---Obtém o modelo de prop baseado no nome da arma (se configurado)
---@param weaponName string Nome da arma (ex: 'WEAPON_REVOLVER')
---@return string|number? model Hash ou nome do modelo do prop ou nil se não encontrado
function PropHandler:getWeaponPropModel(weaponName)
    if not self.weaponMappings then
        return nil
    end
    return self.weaponMappings[weaponName]
end

---Cria um prop 3D no mundo
---@param model string|number Hash ou nome do modelo
---@param coords vector3 Coordenadas onde criar o prop
---@param heading? number Heading do prop (padrão: 0.0)
---@param propId? string ID único do prop (opcional, será gerado se não fornecido)
---@param options? table Opções adicionais: { frozen = boolean, collision = boolean, visible = boolean }
---@return string? propId ID do prop criado ou nil se falhou
---@return string? error Mensagem de erro se falhou
function PropHandler:create(model, coords, heading, propId, options)
    if not model or not coords then
        return nil, 'Model and coords are required'
    end
    
    options = options or {}
    heading = heading or 0.0
    
    -- Gera ID único se não fornecido
    if not propId then
        self.nextId = self.nextId + 1
        propId = ('prop_%d_%d'):format(GetGameTimer(), self.nextId)
    end
    
    -- Verifica se já existe prop com este ID
    if self.props[propId] then
        return nil, 'Prop with this ID already exists'
    end
    
    -- Carrega o modelo
    local success, message = self:loadModel(model)
    if not success then
        return nil, message or 'Failed to load model'
    end
    
    local modelHash = type(model) == 'string' and GetHashKey(model) or model
    
    -- Cria o prop
    local prop = CreateObject(modelHash, coords.x, coords.y, coords.z, false, false, false)
    
    if not prop or prop == 0 then
        return nil, 'Failed to create prop entity'
    end
    
    -- Configura propriedades do prop
    SetEntityHeading(prop, heading)
    SetEntityAsMissionEntity(prop, true, true)
    
    -- Opções adicionais
    if options.frozen ~= false then
        FreezeEntityPosition(prop, true)
    end
    
    if options.collision == false then
        SetEntityCollision(prop, false, false)
    end
    
    if options.visible == false then
        SetEntityVisible(prop, false, false)
    end
    
    -- Armazena dados do prop
    self.props[propId] = {
        id = propId,
        model = modelHash,
        entity = prop,
        coords = coords,
        heading = heading,
        createdAt = GetGameTimer()
    }
    
    return propId, nil
end

---Cria um prop de arma baseado no nome da arma (usa mapeamento configurado)
---@param weaponName string Nome da arma (ex: 'WEAPON_REVOLVER')
---@param coords vector3 Coordenadas onde criar o prop
---@param heading? number Heading do prop (padrão: 0.0)
---@param propId? string ID único do prop (opcional)
---@param options? table Opções adicionais
---@return string? propId ID do prop criado ou nil se falhou
---@return string? error Mensagem de erro se falhou
function PropHandler:createWeaponProp(weaponName, coords, heading, propId, options)
    local model = self:getWeaponPropModel(weaponName)
    
    if not model then
        return nil, ('No prop model mapping found for weapon: %s. Use setWeaponPropMapping() or setWeaponPropMappings() to configure.'):format(weaponName)
    end
    
    return self:create(model, coords, heading, propId, options)
end

---Deleta um prop específico por ID
---@param propId string ID do prop a ser deletado
---@return boolean success Se o prop foi deletado
---@return string? error Mensagem de erro se falhou
function PropHandler:delete(propId)
    if not propId then
        return false, 'Prop ID is required'
    end
    
    local propData = self.props[propId]
    if not propData then
        return false, 'Prop not found'
    end
    
    local entity = propData.entity
    
    -- Verifica se a entidade ainda existe
    if DoesEntityExist(entity) then
        -- Remove como mission entity antes de deletar
        SetEntityAsMissionEntity(entity, false, true)
        DeleteEntity(entity)
    end
    
    -- Remove da tabela
    self.props[propId] = nil
    
    return true, nil
end

---Deleta todos os props ativos
---@return number count Número de props deletados
function PropHandler:deleteAll()
    local count = 0
    
    for propId, propData in pairs(self.props) do
        local entity = propData.entity
        
        if DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, false, true)
            DeleteEntity(entity)
        end
        
        count = count + 1
    end
    
    self.props = {}
    
    return count
end

---Verifica se um prop existe
---@param propId string ID do prop
---@return boolean exists Se o prop existe
function PropHandler:exists(propId)
    if not propId then
        return false
    end
    
    local propData = self.props[propId]
    if not propData then
        return false
    end
    
    -- Verifica se a entidade ainda existe no mundo
    return DoesEntityExist(propData.entity)
end

---Obtém dados de um prop
---@param propId string ID do prop
---@return PropData? propData Dados do prop ou nil se não encontrado
function PropHandler:get(propId)
    return self.props[propId]
end

---Obtém a entidade de um prop
---@param propId string ID do prop
---@return number? entity Entidade do prop ou nil se não encontrado
function PropHandler:getEntity(propId)
    local propData = self.props[propId]
    if propData and DoesEntityExist(propData.entity) then
        return propData.entity
    end
    return nil
end

---Obtém todos os props ativos
---@return table<string, PropData> props Tabela de props ativos
function PropHandler:getAll()
    return self.props
end

---Obtém o número de props ativos
---@return number count Número de props
function PropHandler:count()
    local count = 0
    for _ in pairs(self.props) do
        count = count + 1
    end
    return count
end

---Limpa props que não existem mais no mundo (limpeza de referências órfãs)
---@return number count Número de props limpos
function PropHandler:cleanup()
    local count = 0
    local toRemove = {}
    
    for propId, propData in pairs(self.props) do
        if not DoesEntityExist(propData.entity) then
            table.insert(toRemove, propId)
        end
    end
    
    for _, propId in ipairs(toRemove) do
        self.props[propId] = nil
        count = count + 1
    end
    
    return count
end
