RESOURCE_NAME = GetCurrentResourceName()
utils = {}

---@enum eDEFINE_GETTERS_ENTERPRISE_INFOS
DEFINE_GETTERS_ENTERPRISE_INFOS = {
    BASIC_INFORMATIONS = 1 << 1, -- nome, id, tipo, upgrade, position, photo
    METAS = 1 << 2, -- metas
    PAYROLL = 1 << 3, -- payroll
    WORKSTATIONS = 1 << 4, -- workstations
    STOCK_VIPS = 1 << 5, -- stock_vips
    PASSIVE_INCOME = 1 << 6, -- passive_income
    CHEST = 1 << 7, -- chest
    WORKFLOW_EXPIRES_IN = 1 << 8, -- workflowExpiresIn    
}

if IsDuplicityVersion() then
    ---@param origin string
    require = function(origin)
        local PATHS_BASED_SPLIT = utils.split(origin, '.')
        local RESOURCE_NAME = GetCurrentResourceName()
    
        local path = ''
        for key, value in pairs(PATHS_BASED_SPLIT) do
            if #PATHS_BASED_SPLIT ~= key then
                path = path .. ('%s/'):format(value)
            end
        end
    
        local content = LoadResourceFile(RESOURCE_NAME, path .. PATHS_BASED_SPLIT[#PATHS_BASED_SPLIT] .. '.lua')
        assert(type(content) == 'string', 'content not found')
    
        local success, field = pcall(function()
            return load(content)()
        end)
    
        assert(success, 'failed to load content')
        return field
    end
end

---@param vector vector
---@return string
function utils.transformVecToString(vector)
    local fields = {}

    for index, value in pairs(vector) do
        table.insert(fields, value)
    end

    return table.concat(fields, ',')
end

---@param inputstr string
---@param sep string
---@return table<number, string>
function utils.split(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t = {}

    for field in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        table.insert(t, field)
    end
    return t
end

---@generic T: function | string
---@param path string
---@param name string
---@return T
function utils.loadFile(path, name)
    local content = LoadResourceFile(RESOURCE_NAME, ('%s/%s'):format(path, name))
    
    assert(type(content) == 'string', ('Arquivo %s não encontrado'):format(name))

    local success, field = pcall(function()
        return load(content)()
    end)

    assert(success, 'Arquivo ' .. name .. ' não encontrado')
    return field
end

---@param condition boolean
---@param message string
assert = function(condition, message)
    if condition then
        return
    end
    error( setmetatable({ message = message }, { __tostring = function(self) return self.message end }) )
end


utils.reduceVectorToString = function(position)
    return ('%0.2f,%0.2f,%0.2f'):format(position.x, position.y, position.z)
end

---@param text string
utils.tonumber = function(text)
    return tonumber(text)
end

function table.find(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k -- retorna a chave (índice) onde o valor foi encontrado
        end
    end
    return nil -- se não encontrou
end

---@param data ISystem.PropsNotifyError
function utils.notifyByStatus(data)
    local fields = data.status and data.success or data.error
    
    ---@diagnostic disable-next-line: inject-field
    fields.duration = (data.duration or 5) * 1000

    -- Mapear o tipo para o CSS correspondente
    local css = "Warning" -- padrão para erro
    if fields.type == "success" then
        css = "Confirmed"
    elseif fields.type == "warning" then
        css = "Warning"
    elseif fields.type == "error" then
        css = "Warning"
    end

    utils.notify(data.source, css, fields.description, fields.duration, fields.title)
end

--- Função para enviar notificações usando TriggerClientEvent/TriggerEvent
---@param source number|nil Source do player (obrigatório no servidor)
---@param css string Tipo da notificação: "Confirmed", "Warning"
---@param description string Descrição da notificação
---@param timer number Timer em milissegundos
---@param title string Título da notificação
function utils.notify(source, css, description, timer, title)
    if IsDuplicityVersion() then
        if not source then
            return print("Source é obrigatório no servidor")
        end
        TriggerClientEvent("Notify", source, css, description, timer, title)
    else
        TriggerEvent("Notify", css, description, timer, title)
    end
end

-- Função para garantir que tabelas vazias sejam sempre objetos no JSON
---@param data table|nil
---@return string
function utils.safeJsonEncode(data)
    if type(data) ~= 'table' or not next(data) then
        return '{}'
    end

    return json.encode(data)
end

---@param x number
---@param min number
---@param max number
---@return number
function math.clamp(x, min, max)
    -- Se x for NaN ou infinito, retorna min
    if x ~= x or x == math.huge or x == -math.huge then
        return min
    end
    return math.max(math.min(x, max), min)
end


if not IsDuplicityVersion() then
    ---@type ContextMenuItem[]
    STAFF_CONTEXT_FORMS_CONFIGURATOR = {}
    
    ---@param form ContextMenuItem
    function DEFINE_CONTEXT_FORM(form)
        STAFF_CONTEXT_FORMS_CONFIGURATOR[#STAFF_CONTEXT_FORMS_CONFIGURATOR + 1] = form
    end
end


---@param point vector3
---@param polyzonePoints vector3[]
---@return boolean
IsPointInPolyzone = function(point, polyzonePoints)
    if #polyzonePoints < 3 then
        return false
    end

    local x, y, z = point.x, point.y, point.z
    local inside = false

    local j = #polyzonePoints
    for i = 1, #polyzonePoints do
        local xi, yi = polyzonePoints[i].x, polyzonePoints[i].y
        local xj, yj = polyzonePoints[j].x, polyzonePoints[j].y

        if ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi) then
            inside = not inside
        end
        j = i
    end

    return inside
end

--- Calcula o centro geométrico e o raio de uma polyzone
---@param polyzonePoints vector3[] Array de pontos que formam a polyzone
---@return vector3 center Centro geométrico da polyzone
---@return number radius Raio máximo da polyzone (distância do centro ao ponto mais distante)
function utils.calculatePolyzoneCenterAndRadius(polyzonePoints)
    if not polyzonePoints or #polyzonePoints == 0 then
        return vector3(0, 0, 0), 0
    end

    -- Calcular o centro da polyzone
    local centerX, centerY, centerZ = 0, 0, 0
    local pointCount = #polyzonePoints
    
    -- Somar todas as coordenadas
    for i = 1, pointCount do
        local position = polyzonePoints[i]
        centerX = centerX + position.x
        centerY = centerY + position.y
        centerZ = centerZ + position.z
    end
    
    -- Calcular a média (centro)
    centerX = centerX / pointCount
    centerY = centerY / pointCount
    centerZ = centerZ / pointCount
    
    local center = vector3(centerX, centerY, centerZ)
    
    -- Calcular o raio (distância máxima do centro)
    local maxDistance = 0
    for i = 1, pointCount do
        local position = polyzonePoints[i]
        local distance = math.sqrt(
            (position.x - centerX)^2 + 
            (position.y - centerY)^2 + 
            (position.z - centerZ)^2
        )
        if distance > maxDistance then
            maxDistance = distance
        end
    end
    
    return center, maxDistance
end