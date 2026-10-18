Config = Config or {}
Config.Functions = Config.Functions or {}

Config.Labels = {
    ACTIVATED_WALL = _t("wall_activated"),
    DISABLED_WALL  = _t("wall_disabled"),
    NO_PERMISSION  = _t("no_permission"),
}

-- [key] = Tipo Padrão usado pelo AntiCheat
-- [value]: Tipo de notificação que será usado no lugar do padrão.
local VALID_TYPES = {
    ['sucesso']    = 'sucesso',
    ['negado']     = 'negado',
    ['importante'] = 'importante',
}

---@param notify_type string
---@param src number | false
---@param message string
Config.Functions.Notify = function(src, notify_type, message)
    if not VALID_TYPES[notify_type] then
        print(('[likizao_ac] invalid notify type "%s", falling back to sucesso'):format(notify_type))
    end
    if IsDuplicityVersion() then
        TriggerClientEvent("Notify", src, VALID_TYPES[notify_type], message)
    else
        TriggerEvent("Notify", VALID_TYPES[notify_type], message)
    end
end


---@param user_id number
---@param permission string Permissões configuradas em cada um dos módulos.
---@return boolean
Config.Functions.hasPermission = function(user_id, permission)
    local hasGroup = false
    if type(permission) == 'table' then
        hasGroup = vRP.HasAnyGroupIn(user_id, permission)
    elseif type(permission) == 'string' then
        hasGroup = vRP.HasGroup(user_id, permission)
    end
    return hasGroup
end

---@alias Identity { name: string, firstname: string } | { name: string, name2: string } | {nome: string, sobrenome: string }
---@param user_id number
---@return Identity | nil
Config.Functions.getIdentity = function(user_id)
    local identity = vRP.Identity(user_id)
    if not identity then
        return {
            name = 'Individuo',
            name2 = 'Indigente'
        }
    end
    return {
        name = identity.Name,
        name2 = identity.Lastname
    }
    -- return vRP.getUserIdentity(user_id)
end

---@param user_id number
---@param type 'job'
---@return string | nil | false
Config.Functions.getUserGroupByType = function(user_id, type)
    return ''
end

---@alias user_id number
---@param permission string
---@return table<number, user_id>
--- Config.NotifyAdmins (@config/sv_report_handler.lua)
Config.Functions.getUsersByPermission = function(permission)
    -- return vRP.getUsersByPermission(permission)
    -- return vRP.NumPermission(permission)
end


---@param user_id number
---@return number | nil
Config.Functions.getUserSource = function(user_id)
    return vRP.Source(user_id)
    -- return vRP.getUserSource(user_id)
end


---@param source number
---@return number | nil
Config.Functions.getUserId = function(source)
    return vRP.Passport(source)
    -- return vRP.getUserId(source)
end
