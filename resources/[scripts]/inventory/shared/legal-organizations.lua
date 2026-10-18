if not IsDuplicityVersion() then
    return
end

local gPoliceOrganizations = nil
local gLegalOrganizations = nil

---@return table<string, boolean>, table<string, boolean>
local function LoadLegalOrganizations()

    if gPoliceOrganizations then
        return gPoliceOrganizations, gLegalOrganizations
    end

    local groups = vRP.Groups() or {}
    local roots = { "Policia", "Paramedic", "Bombeiros", "Juridico" }
    gPoliceOrganizations = { Policia = true }
    gLegalOrganizations = {}

    for _, root in ipairs(roots) do
        gLegalOrganizations[root] = true
        local parent = groups[root] and groups[root].Parent or {}

        for group, config in pairs(groups) do
            local groupParent = config.Parent or {}

            if config.Type == "Job" and (parent[group] or groupParent[root]) then
                gLegalOrganizations[group] = true

                if root == "Policia" then
                    gPoliceOrganizations[group] = true
                end
            end
        end
    end

    return gPoliceOrganizations, gLegalOrganizations
end

---@param group string?
---@return boolean
function IsPoliceOrganization(group)

    local police = LoadLegalOrganizations()

    return police[group] == true
end

---@param group string?
---@return boolean
local function IsLegalOrganization(group)

    local _, legal = LoadLegalOrganizations()

    return legal[group] == true
end

exports("IsLegalOrganization", IsLegalOrganization)

---@return table<string, boolean>
function GetPoliceOrganizations()

    local police = LoadLegalOrganizations()

    return police
end

---@param passport number
---@return string? job, number? rank
function GetPoliceJob(passport)

    local job, rank = vRP.UserGroupByType(passport, "Job")

    if IsPoliceOrganization(job) and vRP.HasPermission(passport, job) then
        return job, rank
    end

    return nil
end

---@param passport number
---@return boolean
function IsPolicePrimaryLeader(passport)

    local job = GetPoliceJob(passport)

    if not job then
        return false
    end

    local leader = exports.painel:GetGroupLeaderPassport(job)

    return leader and parseInt(leader) == parseInt(passport) or false
end

---@param name string?
---@return string? group
function GetPoliceChestGroup(name)

    if type(name) ~= "string" or name:find("-", 1, true) then
        return nil
    end

    if not IsPoliceOrganization(name) then
        return nil
    end

    for _, chest in pairs(Chests or {}) do

        if chest.Name == name and (chest.Mode == "1" or chest.Mode == "2") then
            return name
        end
    end

    return nil
end

---@param job string
---@return string? name
function GetPoliceArsenalChest(job)

    if not IsPoliceOrganization(job) then
        return nil
    end

    -- Cidades sem baú próprio da divisão usam somente o baú geral raiz.
    return GetPoliceChestGroup(job) or GetPoliceChestGroup("Policia")
end
