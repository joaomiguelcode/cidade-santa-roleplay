eMissionFlags = {
    NONE = 0,
    
    -- Block all interactions until mission is completed
    BLOCK_ALL_INTERACTIONS = 1,
    
    -- Must be first mission in the group to be started
    MUST_BE_FIRST = 2,
    
    -- Must be last mission in the group to be started  
    MUST_BE_LAST = 4,
    
    -- Opens a modal NUI when available
    OPENS_MODAL = 8,
    
    -- Can be skipped if condition met (e.g., discord covers sms)
    CAN_BE_SKIPPED = 16,
    
    -- Requires group membership to be active
    REQUIRES_FAC = 32,
    
    -- Requires citizenship (checkpoint 2) to be active
    REQUIRES_CITIZENSHIP = 64,

    -- Block inventory interactions
    BLOCK_INVENTORY_INTERACTION = 128,

    -- Block vehicle interactions
    BLOCK_VEHICLE_INTERACTION = 256,
}

---@param flags number
---@param flag number
---@return boolean
function HasMissionFlag(flags, flag)
    return (flags or 0) & flag ~= 0
end

---@vararg number
---@return number combined flags
function CombineMissionFlags(...)
    local result = 0
    for _, flag in ipairs({...}) do
        result = result | flag
    end
    return result
end
