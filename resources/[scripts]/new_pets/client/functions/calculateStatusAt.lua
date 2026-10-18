---@param num number
---@return number
---@diagnostic disable-next-line: lowercase-global
round = function(num)
    return math.floor(num + 0.5)
end

---@param spawnedAt number
---@param hunger number
---@param thirst number
---@return number, number, number
---@diagnostic disable-next-line: lowercase-global
calculateStatusAt = function(spawnedAt, hunger, thirst)
    local elapsedMinutes = (GetNetworkTime() - spawnedAt) / (1000 * 60)
    local hungerLost = elapsedMinutes * config.HUNGER_RATE
    local thirstGained = elapsedMinutes * config.THIRST_RATE
    local newHunger = math.max(0, round((hunger or 100) - hungerLost))
    local newThirst = math.max(0, round((thirst or 100) - thirstGained))

    return newHunger, newThirst, elapsedMinutes
end