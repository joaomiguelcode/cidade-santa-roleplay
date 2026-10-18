---Dispatch a nui message
---@param action string
---@param data any
function DispatchNuiMessage(action, data)
    SendNuiMessage(json.encode({
        action = action,
        data = data
    }))
end

---@param alias string
function GetGroupByAlias(alias)
    local Table = GlobalState["AliasGroup"]
    for Group,Alias in pairs(Table) do
        if Alias == alias then
            return Group
        end
    end
    return alias
end

---@param group string
function GetAliasByGroup(group)
    local Table = GlobalState["AliasGroup"]
    if Table[Group] then
        return Table[Group]
    end
    return group
end