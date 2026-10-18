---@class IUiCallback.MembersOverview
---@field pagination PaginatedOutput<aDefinitionPaginationMembersOutput>
---@field members IEnterPrise.Members.Overview[]

--[[
    {
    data: Array<{
        id: number;
        name: string;
        role: string;
        status: "offline" | "online"
        joinedAt: string;
    }>;
    page: number;
    perPage: number;
    total: number;
    }
]]

---@param data IUiCallback.MembersOverview
local function OnFormatCallback(data)
    local members = {}

    for _, member in pairs(data.members) do
        table.insert(members, {
            id = member.user_id,
            name = member.name,
            role = member.role,
            status = member.status,
            joinedAt = member.enterAt * 1000
        })
    end

    return {
        data = members,
        perPage = data.pagination.perPage,
        total = data.pagination.total
    }
end

RegisterNuiCallback('employees:list', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-members-list',
        false,
        EnterPriseClass.activeEnterprise,
        data.page,
        data.searchTerm
    )

    callback(OnFormatCallback(response))
end)

RegisterNUICallback('employees:ban', function(data, callback)
    local response = lib.callback.await('enterprise/ui/ban-member',
        false,
        EnterPriseClass.activeEnterprise,
        data.id,
        data.reason
    )
    callback(response)
end)

RegisterNUICallback('employees:hire', function(data, callback)
    local response = lib.callback.await('enterprise/ui/hire-member',
        false,
        EnterPriseClass.activeEnterprise,
        data.id
    )
    callback(response)
end)

RegisterNUICallback('employees:kick', function(data, callback)
    local response = lib.callback.await('enterprise/ui/kick-member',
        false,
        EnterPriseClass.activeEnterprise,
        data.id
    )
    callback(response)
end)

RegisterNUICallback('employees:editRole', function(data, callback)
    local response = lib.callback.await('enterprise/ui/edit-role-member',
        false,
        EnterPriseClass.activeEnterprise,
        data.id,
        data.role
    )
    callback(response)
end)