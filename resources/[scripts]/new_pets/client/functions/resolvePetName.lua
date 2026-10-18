---@param savedName unknown
---@param model unknown
---@return string name
ResolvePetName = function(savedName, model)

    local normalizedName = type(savedName) == 'string' and savedName:match('^%s*(.-)%s*$') or nil

    if normalizedName and normalizedName ~= '' then
        return normalizedName
    end

    local modelSettings = type(model) == 'string' and config.modelSettings[model] or nil
    local translatedModel = type(model) == 'string' and _t(model) or nil

    return translatedModel or (modelSettings and modelSettings.name) or tostring(model or 'Pet')
end
