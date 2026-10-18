sx.vipsystem = { }

---@param commandName string
---@return table | nil
function sx.vipsystem.GetVipsCommandPermissions(commandName)
    local commandPermissions = VipSystem.commands[commandName]
    if commandPermissions then
        return commandPermissions or {}
    end
    return {}
end

---@param scriptName string
---@param functionName string
---@return table
function sx.vipsystem.GetVipsScriptsConfig(scriptName,functionName)
    local scriptsConfig = VipSystem.scripts_config[scriptName]
    if scriptsConfig then
        return scriptsConfig[functionName] or {}
    end
    return {}
end

---@param scriptName string
---@param functionName string
---@return table
function sx.vipsystem.GetVipsScriptsPermissions(scriptName,functionName)
    local scriptsPermissions = VipSystem.scripts_permissions[scriptName]
    if scriptsPermissions then
        return scriptsPermissions[functionName] or {}
    end
    return {}
end