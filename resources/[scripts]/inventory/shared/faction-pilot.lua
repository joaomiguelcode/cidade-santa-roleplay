local gFactionPilotCities = {
    Maresia = true,
    Grande = true,
    Santa = true,
    Malta = true,
    Kingdom = true,
    CidadeNobre = true
}

local gBankWithdrawPilotCities = {
    Maresia = true,
    Grande = true,
    Santa = true,
    Malta = true,
    Kingdom = true,
    CidadeNobre = true
}

local gCityBlipColor = {
    Santa = 1,
    Grande = 5,
    CidadeNobre = 27,
    Kingdom = 46,
    Krown = 46,
    Liberty99 = 3,
    District99 = 40,
    Orizon = 26,
    Maresia = 32,
    Fronteira = 47,
    Boomerang = 47,
    Malta = 46,
    Royal = 46,
    Real = 5,
    Prime = 5,
    Universo = 8,
}

function IsFactionPilotCity()
    return gFactionPilotCities[GetConvar("cityName", "")] == true
end

---@param chestName any
---@return boolean
function IsManagedLeaderChest(chestName)

    return type(chestName) == "string"
        and (chestName == "Paramedic-2" or chestName:match("^QG_.-%-2$") ~= nil)
end

function IsBankWithdrawPilotCity()
    return gBankWithdrawPilotCities[GetConvar("cityName", "")] == true
end

function GetFactionPilotBlipColor()
    return gCityBlipColor[GetConvar("cityName", "")] or 4
end

exports("IsFactionPilotCity", IsFactionPilotCity)
exports("IsBankWithdrawPilotCity", IsBankWithdrawPilotCity)

---@param api table
---@param skip table|nil
function WrapFactionPilotApi(api, skip)
    skip = skip or {}
    local names = {}

    for name, fn in pairs(api) do
        if type(fn) == "function" and not skip[name] then
            names[#names + 1] = name
        end
    end

    for i = 1, #names do
        local name = names[i]
        local fn = api[name]
        api[name] = function(...)
            if not IsFactionPilotCity() then
                return { ok = false }
            end
            return fn(...)
        end
    end
end
