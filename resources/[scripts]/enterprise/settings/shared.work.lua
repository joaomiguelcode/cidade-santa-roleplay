---@class IWorkDefinition
---@field farmPoints vector4[] -- caso não tenha polyzone (coleta) configurada, use esses pontos
---@field deliveryPoints vector4[] -- entregas
---@field onInteractionPoint fun(user_id: number, cache: EnterPriseClass.Cache)?
---@field onInteractionDeliveryPoint fun(user_id: number, cache: EnterPriseClass.Cache)?

---@type table<string, IWorkDefinition>
GLOBAL_WORK_LIST = {}

---@param enterpriseType          string
---@return fun( workDefinition: IWorkDefinition ): IWorkDefinition
function DEFINE_WORK(enterpriseType)
    return function(workDefinition)
        GLOBAL_WORK_LIST[enterpriseType] = workDefinition
        return workDefinition
    end
end

DEFINE_WORK 'gas-station' {
    farmPoints = {},
    deliveryPoints = {},
}

DEFINE_WORK 'restaurant' {
    farmPoints = {},
    deliveryPoints = {},
}