---@type Source?
local currentSpectatingTarget = nil

---@type gamemaster.SpectatorData?
local currentSpectatorData = nil

---@type boolean?
gCurrentSpectatorVisibleMenu = nil

---@type function?
gamemaster.client.spectator.tickAbortSignal = nil

---@return Source?
function gamemaster.client.state.GetCurrentSpectatingTarget()

    return currentSpectatingTarget
end

---@param target Source?
function gamemaster.client.state.SetCurrentSpectatingTarget( target )

    currentSpectatingTarget = target
end

--[[

    SpectatorData is not used in this script
    but it is a good idea to keep it here 
    for future reference.

    ---@return gamemaster.SpectatorData?
    function gamemaster.client.state.GetCurrentSpectatorData()

        return currentSpectatorData
    end

    ---@param data gamemaster.SpectatorData?
    function gamemaster.client.state.SetCurrentSpectatorData( data )

        currentSpectatorData = data
    end

    - @TkzDev
]]