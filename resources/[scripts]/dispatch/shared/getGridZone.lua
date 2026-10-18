-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local GridSize = 256

---@param x number
---@return number
function gridChunk(x)
    return math.floor((x + 8192) / GridSize)
end

---@param v table
---@return number
function toChannel(v)
    return (v["x"] << 8) | v["y"]
end

---@param x number | string
---@param y number | nil
---@return number
function getGridzone(x,y)
    if not x or not y or type(x) ~= "number" or type(y) ~= "number" then
        print("^1ERRO: getGridzone recebeu valores inválidos. x:", x, "y:", y, "^7")
        return 0
    end
    
    local gridChunk = vector2(gridChunk(x),gridChunk(y))
    return toChannel(gridChunk)
end