interiors = class()

colors = {
    default = 0,
    white = 1,
    red = 2,
    blue = 3,
    orange = 4,
    yellow = 5,
    green = 6,
    pink = 7,
    turquoise = 8,
    gray = 9,
    black = 10
}


---@param id number
---@param tier number
---@return boolean, string
function interiors:__init(id, tier)
    self.id           = id or 1
    self.tier         = tier or 1
    self.name         = config.interiors[self.id].title
    self.ymaps        = config.interiors[self.id].tiers[self.tier].ymaps
    self.mlo_entities = config.interiors[self.id].tiers[self.tier].mlo_entities

    if not config.interiors[self.id] then
        return false, "^1[ERRO]^0 Interior não encontrado."
    end

    return true, "^2[INFO]^0 Interior carregado com sucesso."
end

---@return boolean, string
function interiors:load()
    for name, active in pairs(self.ymaps) do
        if active then
            RequestIpl(name)
        else
            RemoveIpl(name)
        end
    end

    for name, data in pairs(self.mlo_entities) do
        local coords     = data.coords
        local sets       = data.sets
        local interiorId = GetInteriorAtCoords(coords.x, coords.y, coords.z)

        if interiorId and IsValidInterior(interiorId) then
            for set, active in pairs(sets) do
                if active then
                    ActivateInteriorEntitySet(interiorId, set)
                else
                    DeactivateInteriorEntitySet(interiorId, set)
                end
                RefreshInterior(interiorId)
            end
        end
    end

    return self, "^2[INFO]^0 Interior carregado com sucesso."
end

---@return void
function interiors:unload()
    for name, active in pairs(self.ymaps) do
        RemoveIpl(name)
    end

    for name, data in pairs(self.mlo_entities) do
        local coords     = data.coords
        local sets       = data.sets
        local interiorId = GetInteriorAtCoords(coords.x, coords.y, coords.z)

        if interiorId and IsValidInterior(interiorId) then
            for set, active in pairs(sets) do
                DeactivateInteriorEntitySet(interiorId, set)
                RefreshInterior(interiorId)
            end
        end
    end
end

---@param tier number
---@return void
function interiors:setTier(tier)
    self.tier = tier

    self:load()
end

local function resolveColorIndex(value)
    if type(value) == 'string' then
        return colors[value] or colors.default
    elseif type(value) == 'number' then
        return value
    elseif type(value) == 'table' and value.name then
        return colors[value.name] or colors.default
    end
    return colors.default
end

local function getWallpaperConfig(wallpaperId)
    if not config.wallpapers then return nil end

    for _, data in ipairs(config.wallpapers) do
        if data.id == wallpaperId then
            return data
        end
    end

    return nil
end

---@param wallpaperId number|string
---@return boolean, string
function interiors:setColor(wallpaperId)
    if not self.mlo_entities then
        return false, '^1[ERRO]^0 Nenhum MLO configurado para este interior.'
    end

    local wallpaper = getWallpaperConfig(wallpaperId)

    local colorValue

    if wallpaper then
        colorValue = wallpaper.color or wallpaper.colorIndex or wallpaperId
    else
        if type(wallpaperId) == 'number' or type(wallpaperId) == 'string' then
            colorValue = wallpaperId
        else
            return false, ('^1[ERRO]^0 Wallpaper com id "%s" não encontrado.'):format(tostring(wallpaperId))
        end
    end
    local colorIndex = resolveColorIndex(colorValue)

    local applied = false
    local errors = {}

    for entityName, entityData in pairs(self.mlo_entities) do
        local coords = entityData.coords
        if not coords then
            errors[#errors + 1] = ('Coordenadas ausentes para "%s"'):format(entityName)
        else
            local interiorId = GetInteriorAtCoords(coords.x, coords.y, coords.z)
            if not interiorId or not IsValidInterior(interiorId) then
                errors[#errors + 1] = ('Interior inválido para "%s"'):format(entityName)
            else
                local sets = entityData.sets or {}
                local refreshed = false

                for setName, _ in pairs(sets) do
                    SetInteriorEntitySetColor(interiorId, setName, colorIndex)
                    applied = true
                    refreshed = true
                end

                if refreshed then
                    RefreshInterior(interiorId)
                end
            end
        end
    end

    if not applied then
        local reason = #errors > 0 and table.concat(errors, ' | ') or 'Nenhum entity set elegível encontrado.'
        return false, ('^1[ERRO]^0 Falha ao aplicar cor: %s'):format(reason)
    end

    return true, '^2[INFO]^0 Cor aplicada com sucesso.'
end

local unloadInteriors = function()
    for id, v in pairs(config.buildings) do
        local interior = interiors(id, 1)
        interior:unload()
    end
end

unloadInteriors()
