cityName = GetConvar("cityName", "")
function CheckValidConfig(Config)
    Config = Config:upper()
    local Valid = false
    if ORGS_CONFIG[Config] then
        Valid = true
    end
    return Valid
end
exports("CheckValidConfig", CheckValidConfig)

local function GetCoordsCandidate(Data)
    if not Data then
        return nil
    end

    local DataType = type(Data)
    if DataType == "vector3" or DataType == "vector4" then
        return Data
    end

    if DataType ~= "table" then
        return nil
    end

    return Data["Coords"] or Data["coords"] or Data[1]
end

local function GetFirstListCoords(List)
    if type(List) ~= "table" then
        return nil
    end

    for _, Data in ipairs(List) do
        local Coords = GetCoordsCandidate(Data)
        if Coords then
            return Coords
        end
    end

    for _, Data in pairs(List) do
        local Coords = GetCoordsCandidate(Data)
        if Coords then
            return Coords
        end
    end

    return nil
end

local function GetFirstGarageCoords(Garages)
    if type(Garages) ~= "table" then
        return nil
    end

    for _, Garage in ipairs(Garages) do
        if type(Garage) == "table" and type(Garage["Spawns"]) == "table" and Garage["Spawns"]["Open"] then
            return Garage["Spawns"]["Open"]
        end
    end

    for _, Garage in pairs(Garages) do
        if type(Garage) == "table" and type(Garage["Spawns"]) == "table" and Garage["Spawns"]["Open"] then
            return Garage["Spawns"]["Open"]
        end
    end

    return nil
end

function GetConfigReferenceCoords(Config)
    if type(Config) ~= "string" then
        return nil
    end

    Config = Config:upper()
    local Data = ORGS_CONFIG[Config]
    if not Data then
        return nil
    end

    if type(Data["SURVIVAL"]) == "table" and Data["SURVIVAL"][Config] then
        return Data["SURVIVAL"][Config]
    end

    return GetFirstListCoords(Data["RISK_ZONES"])
        or GetFirstListCoords(Data["CHESTS"])
        or GetFirstListCoords(Data["DOORS"])
        or GetFirstGarageCoords(Data["GARAGES"])
end
exports("GetConfigReferenceCoords", GetConfigReferenceCoords)

function GetAllOfConfig(SelectedConfig)
    local Configs = {}
    local CachedConfig = {}
    for Org, Data in pairs(ORGS_CONFIG) do
        if Data["ACTIVE"][cityName] then
            if Data[SelectedConfig] then
                table.insert(CachedConfig, { name = Org, info = Data[SelectedConfig] })
            end
        end
    end
    table.sort(CachedConfig, function(a, b) return a.name < b.name end)
    for i = 1, #CachedConfig do
        table.insert(Configs, CachedConfig[i].info)
    end
    return Configs
end
exports("GetAllOfConfig", GetAllOfConfig)
