---@class IUiCallback.MembersBanned
---@field pagination PaginatedOutput<aDefinitionPaginationMembersOutput>
---@field members IEnterPrise.Members.Banned[]

--[[
    cb: {
    data: Array<{
        id: number; //ID
        name: string; //Nome
        bannedBy: string; //Banido por
        reason: string; //Motivo
        bannedAt: string; //timestamp
    }>;
    page: number;
    perPage: number;
    total: number;
    }
]]

---@param data IUiCallback.MembersBanned
local function OnFormatCallback(data)
    local members = {}

    for _, member in pairs(data.members) do

        table.insert(members, {
            id = member.user_id,
            name = member.username,
            bannedBy = member.author_username,
            reason = member.reason,
            bannedAt = member.createAt * 1000
        })
    end

    return {
        data = members,
        perPage = data.pagination.perPage,
        total = data.pagination.total
    }
end

RegisterNUICallback('banned:list', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-ban-list', false, EnterPriseClass.activeEnterprise, data.page, data.searchTerm)

    callback(OnFormatCallback(response))
end)

RegisterNUICallback('employees:unban', function(data, callback)
    local response = lib.callback.await('enterprise/ui/unban-member', false, EnterPriseClass.activeEnterprise, data.id, data.reason)
    callback(response)
end)