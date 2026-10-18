---@class IUiCallback.ProfitHistory
---@field pagination PaginatedOutput<aDefinitionPaginationMembersOutput>
---@field history IEnterprise.ProfitHistory[]

--[[
    {
    data: Array<{
        id: number;
        username: string;
        method: string;
        amount: number;
        date: number;
    }>;
    page: number;
    perPage: number;
    total: number;
    }
]]

---@param data IUiCallback.ProfitHistory
local function OnFormatCallback(data)
    local history = {}

    for _, record in pairs(data.history) do
        table.insert(history, {
            id = record.user_id,
            name = record.username,
            type = record.method,
            value = record.amount,
            role = record.role,
            date = record.date * 1000 
        })
    end

    return {
        data = history,
        perPage = data.pagination.perPage,
        total = data.pagination.total
    }
end

RegisterNUICallback('bank:list', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-profit-history',
        false,
        EnterPriseClass.activeEnterprise,
        data.page,
        data.searchTerm
    )
    callback(OnFormatCallback(response))
end)

RegisterNUICallback('bank:summary', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-profit-summary',
        false,
        EnterPriseClass.activeEnterprise
    )

    callback(response)
end)

RegisterNUICallback('bank:transfer', function(data, callback)
    local response = lib.callback.await('enterprise/ui/transfer-profit',
        false,
        EnterPriseClass.activeEnterprise,
        data.amount,
        data.playerId
    )
    callback(response)
end)

RegisterNUICallback('bank:withdraw', function(data, callback)
    local response = lib.callback.await('enterprise/ui/withdraw-profit',
        false,
        EnterPriseClass.activeEnterprise,
        data.amount
    )
    callback(response)
end)
