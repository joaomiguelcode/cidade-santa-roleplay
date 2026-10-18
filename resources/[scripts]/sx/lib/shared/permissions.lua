sx.groupPermissions = {
    ["Afiliado"] = {
        [1] = {
            "CRM:open",
        },
        [2] = {
            "CRM:open",
        },
        [3] = {
            "CRM:open",
        },
        [4] = {
            "CRM:open",
        },
        [5] = {
            "CRM:open",
        },
    },
    ["Admin"] = {
        [1] = {
            "CRM:open",
        },
        [2] = {
            "CRM:open",
        },
    },
}

---@param groups string[]
---@return table
function sx.getPlayerPermissions(groups)
    local permissions = { }
    for group, level in pairs(groups) do
        if sx.groupPermissions[group] and sx.groupPermissions[group][level] then
            for _, permission in pairs(sx.groupPermissions[group][level]) do
                table.insert(permissions, permission)
            end
        end
    end
    return permissions
end