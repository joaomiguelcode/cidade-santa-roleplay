---@class IUiCallback.MembersRankingOverview
---@field pagination PaginatedOutput<aDefinitionPaginationMembersOutput>
---@field members IEnterPrise.Members.Ranking[]

--[[
    cb: {
  data: Array<{
    position: number;
    id: number;
    name: string;
    role: number;
    deliveredGoals: number;
    productivity: number;
  }>;
  page: number;
  perPage: number;
  total: number;
}
]]

---@param data IUiCallback.MembersRankingOverview
local function OnFormatCallback(data)
    local members = {}

    for index, member in pairs(data.members) do
        table.insert(members, {
            id = member.user_id,
            name = member.name,
            role = member.role,
            deliveredGoals = member.goals,
            productivity = member.productivity,
            position = member.position,
        })
    end

    return {
        data = members,
        perPage = data.pagination.perPage,
        total = data.pagination.total
    }
end

RegisterNUICallback('ranking:list', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-members-ranking-list',
        false,
        EnterPriseClass.activeEnterprise,
        data.page,
        data.searchTerm
    )

    callback(OnFormatCallback(response))
end)

RegisterNUICallback('ranking:summary', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-ranking-summary',
        false,
        EnterPriseClass.activeEnterprise
    )
    callback(response)
end)