gMissionDefinitions = {}
gMissionDefinitionsByName = {}
gMissionGroupDefinitionsByName = {}

---@param groupId string Unique identifier for the group (e.g. 'connect')
function DEFINE_GROUP(groupId)
    return function(def)
        assert(not gMissionGroupDefinitionsByName[groupId], "Duplicate group: " .. groupId)
        def.id = groupId
        def.missions = {}
        gMissionGroupDefinitionsByName[groupId] = def
    end
end

---@param groupId string
---@return table|nil group definition
function GetMissionGroupDefinition(groupId)
    return gMissionGroupDefinitionsByName[groupId]
end

---@param missionId string Unique identifier for the mission (e.g., 'validate-discord')
function DEFINE_MISSION(missionId)
    return function(def)
        if def.enabled == false then
            return
        end

        def.id = missionId
        assert(def.group, "Mission must belong to a group: " .. missionId)
        assert(gMissionGroupDefinitionsByName[def.group], "Group not found: " .. def.group)

        local index = #gMissionDefinitions + 1
        def.index = index
        gMissionDefinitions[index] = def
        gMissionDefinitionsByName[missionId] = def

        -- Add mission to its group's mission list
        local group = gMissionGroupDefinitionsByName[def.group]
        group.missions[#group.missions + 1] = def
    end
end

---@param missionId string
---@return table|nil mission definition
function GetMissionDefinition(missionId)
    return gMissionDefinitionsByName[missionId]
end

---@param missionId string
---@return boolean
function IsMissionValid(missionId)
    return gMissionDefinitionsByName[missionId] ~= nil
end

---@param groupId string
---@return table[] missions belonging to the group
function GetMissionsByGroup(groupId)
    local group = gMissionGroupDefinitionsByName[groupId]
    if group then
        return group.missions or {}
    end
    return {}
end
