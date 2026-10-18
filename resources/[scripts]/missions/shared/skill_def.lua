gSkillDefinitions = {}
gSkillDefinitionsByName = {}

---@param skillId string
function DEFINE_SKILL(skillId)
    return function(def)
        def.id = skillId

        local index = #gSkillDefinitions + 1
        def.index = index
        gSkillDefinitions[index] = def
        gSkillDefinitionsByName[skillId] = def
    end
end

---@param skillId string
---@return table|nil skill definition
function GetSkillDefinition(skillId)
    return gSkillDefinitionsByName[skillId]
end

---@param skillId string
---@return boolean
function IsSkillValid(skillId)
    return gSkillDefinitionsByName[skillId] ~= nil
end

-- Skill XP curve. Index = level, value = cumulative XP required to REACH that level.
-- Nivel 1 = 0 XP. Max = 100.
-- Niveis 1–10 (inalterados): 1→2 e 2→3 = 100 XP; do 3→4 em diante o passo dobra.
-- Niveis 11–100: o XP de cada nivel sobe ~6% em relacao ao passo anterior (sempre mais dificil).
-- Referencia: nivel 10 = 25.600 | 11 ≈ 39.168 (+6% sobre 12.800) | 100 ≈ 40,2M XP total.
MAX_SKILL_LEVEL = 100
SKILL_XP_INITIAL = 100
SKILL_XP_GROWTH_NUM = 106
SKILL_XP_GROWTH_DEN = 100

SKILL_LEVEL_THRESHOLDS = {
    [1] = 0,
    [2] = SKILL_XP_INITIAL,
}

local xpToNextLevel = SKILL_XP_INITIAL

for level = 3, 10 do
    SKILL_LEVEL_THRESHOLDS[level] = SKILL_LEVEL_THRESHOLDS[level - 1] + xpToNextLevel
    if level < 10 then
        xpToNextLevel = xpToNextLevel * 2
    end
end

for level = 11, MAX_SKILL_LEVEL do
    xpToNextLevel = math.floor((xpToNextLevel * SKILL_XP_GROWTH_NUM) / SKILL_XP_GROWTH_DEN)
    SKILL_LEVEL_THRESHOLDS[level] = SKILL_LEVEL_THRESHOLDS[level - 1] + xpToNextLevel
end

---@param points number
---@return number current level (1-MAX_SKILL_LEVEL)
function GetSkillLevel(points)
    for level = MAX_SKILL_LEVEL, 1, -1 do
        if points >= SKILL_LEVEL_THRESHOLDS[level] then
            return level
        end
    end
    return 1
end

---@param points number
---@return number xp into current level
function GetSkillProgress(points)
    local level = GetSkillLevel(points)
    return points - SKILL_LEVEL_THRESHOLDS[level]
end

---@param points number
---@return number xp required to advance from current level to next (0 if maxed)
function GetSkillNeeded(points)
    local level = GetSkillLevel(points)
    if level >= MAX_SKILL_LEVEL then
        return 0
    end
    return SKILL_LEVEL_THRESHOLDS[level + 1] - SKILL_LEVEL_THRESHOLDS[level]
end

---@param points number
---@return number percentage (0-100) within current level
function GetSkillPercentage(points)
    local level = GetSkillLevel(points)
    if level >= MAX_SKILL_LEVEL then
        return 100
    end
    local needed = GetSkillNeeded(points)
    return math.floor((GetSkillProgress(points) / needed) * 100)
end

---@param points number
---@return string formatted "Nivel X (YY%)"
function FormatSkillProgress(points)
    local level = GetSkillLevel(points)
    if level >= MAX_SKILL_LEVEL then
        return string.format("Nivel %d (MAX)", level)
    end
    return string.format("Nivel %d (%d%%)", level, GetSkillPercentage(points))
end
