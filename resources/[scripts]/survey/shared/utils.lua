Utils = {
    clock = {}
}

Utils.clock.DAYS_IN_SECONDS = 86400
Utils.clock.HOURS_IN_SECONDS = 3600
Utils.clock.MINUTES_IN_SECONDS = 60
Utils.clock.MULTIPLIERS = {
    s = 1, sec = 1,
    m = 60, min = 60,
    h = 3600, hour = 3600,
    d = 86400, day = 86400,
    w = 604800, week = 604800
}

---@param inputstr string
---@param sep string
---@return table<number, string>
function Utils.split(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t = {}

    for field in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        table.insert(t, field)
    end
    return t
end

---Converte timestamp Unix para formato DATETIME do MySQL
---@param timestamp number? timestamp Unix (os.time())
---@return string|nil DATETIME string ou nil
function ToMySQLDateTime(timestamp)
    if not timestamp then
        return nil
    end
    return os.date('%Y-%m-%d %H:%M:%S', timestamp)
end

---@class utils.ReturnStatusUI.error
---@field key? string
---@field params? string[] | number[]

---@param status boolean
---@param error utils.ReturnStatusUI.error?
function Utils.ReturnStatusUI(status, error)
    return {
        status = status,
        error = error
    }
end

---Converte string de tempo para segundos
---@param timeStr string
---@return number
function Utils.parseTime(timeStr)
    assert(type(timeStr) == 'string', 'timeStr is required')
    
    local value = tonumber(timeStr:match("%d+"))
    local unit = timeStr:match("%a+")
    
    return value * (Utils.clock.MULTIPLIERS[unit] or 0)
end

---Formata segundos para string legível e gameficada
---@param seconds number Tempo em segundos
---@param maxUnits number? Máximo de unidades a exibir (padrão: 2)
---@return string Tempo formatado (ex: "5m 30s", "2h 15m", "3d 5h")
function Utils.formatTime(seconds, maxUnits)
    maxUnits = maxUnits or 2
    
    if seconds <= 0 then
        return "0s"
    end
    
    local parts = {}
    local remaining = math.floor(seconds)
    
    -- Dias
    if remaining >= Utils.clock.DAYS_IN_SECONDS then
        local days = math.floor(remaining / Utils.clock.DAYS_IN_SECONDS)
        table.insert(parts, days .. "d")
        remaining = remaining % Utils.clock.DAYS_IN_SECONDS
    end
    
    -- Horas
    if remaining >= Utils.clock.HOURS_IN_SECONDS and #parts < maxUnits then
        local hours = math.floor(remaining / Utils.clock.HOURS_IN_SECONDS)
        table.insert(parts, hours .. "h")
        remaining = remaining % Utils.clock.HOURS_IN_SECONDS
    end
    
    -- Minutos
    if remaining >= Utils.clock.MINUTES_IN_SECONDS and #parts < maxUnits then
        local minutes = math.floor(remaining / Utils.clock.MINUTES_IN_SECONDS)
        table.insert(parts, minutes .. "m")
        remaining = remaining % Utils.clock.MINUTES_IN_SECONDS
    end
    
    -- Segundos (só mostra se ainda não atingiu o limite de unidades ou se não tem nada)
    if #parts < maxUnits and (#parts == 0 or remaining > 0) then
        table.insert(parts, remaining .. "s")
    end
    
    return table.concat(parts, " ")
end

if IsDuplicityVersion() then
    ---@param origin string
    require = function(origin)
        local PATHS_BASED_SPLIT = Utils.split(origin, '.')
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

---@param condition boolean
---@param message string
assert = function(condition, message)
    if condition then
        return
    end
    error( setmetatable({ message = message }, { __tostring = function(self) return self.message end }) )
end