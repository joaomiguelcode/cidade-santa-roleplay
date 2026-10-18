---@param enterprise IEnterprise
---@param callback fun(workflows: table<number, number>)
local function onFormConfigureWorkflows(enterprise, callback)
    local fields = {}
    local workflowKeys = {}

    -- Guardar as keys dos workflows na ordem que foram inseridas
    for workflowIndex, data in pairs(WORKFLOWINFODATABASE) do
        if data.isPremium then
            table.insert(fields, {
                type = 'date',
                label = data.label,
                description = data.description,
                default = enterprise.workflowExpiresIn[workflowIndex] and
                    enterprise.workflowExpiresIn[workflowIndex] * 1000
            })

            table.insert(workflowKeys, workflowIndex)
        end
    end

    local input = lib.inputDialog(_t('configure_workflows_dialog'):format(enterprise.name, enterprise.id), fields)

    if not input then
        return lib.showContext('enterprise:show-staff-categories')
    end

    local response = {}

    -- Mapear corretamente: key do workflow = valor do input
    for index, value in ipairs(input) do
        local workflowIndex = workflowKeys[index]

        if workflowIndex then
            response[workflowIndex] = value
        end
    end

    callback(response)
end

DEFINE_CONTEXT_FORM {
    title = _t('configure_workflows_title'),
    description = _t('configure_workflows_desc'),
    icon = 'cog',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            onFormConfigureWorkflows(enterprise, function(workflows)
                lib.callback.await('enterprise:update-workflows', false, enterprise.id, workflows)
            end)
        end, DEFINE_GETTERS_ENTERPRISE_INFOS.WORKFLOW_EXPIRES_IN)
    end
}
