---@param enterprise IEnterprise
---@param callback fun(response: IEnterPrise.PassiveIncome)
local function OnFormConfigurePassiveIncome(enterprise, callback)
    local fields = {
        {
            type = 'number',
            label = 'Quantidade da Renda Passiva',
            description = ('%s. %s'):format(
                _t('enterprise_passive_income_desc'),
                _t('passive_income_max_limit_message'):format(parseFormat(SHARED_SETTINGS.MAX_PASSIVE_INCOME))
            ),
            default = next(enterprise.passive_income) and enterprise.passive_income.amount or 0,
            required = true,
            min = 0
        },
        {
            type = 'date',
            label = 'Data de Validade da Renda Passiva',
            description = _t('enterprise_passive_income_valid_at_desc'),
            default = next(enterprise.passive_income) and enterprise.passive_income.valid_at * 1000 or 0,
            required = true,
            min = 0
        }
    }

    local input = lib.inputDialog(_t('configure_passive_income_dialog'):format(
            enterprise.name,
            enterprise.id),
        fields
    )

    if not input then
        return lib.showContext('enterprise:show-staff-categories')
    end

    local passiveIncome = { amount = input[1], valid_at = input[2] }

    sx.logger:debug( ('Submitting passive income update enterpriseId=%s amount=%s validAt=%s max=%s'):format(
        tostring(enterprise.id),
        tostring(passiveIncome.amount),
        tostring(passiveIncome.valid_at),
        tostring(SHARED_SETTINGS.MAX_PASSIVE_INCOME)
    ) )

    callback(passiveIncome)
end

DEFINE_CONTEXT_FORM {
    title = _t('configure_passive_income_title'),
    description = _t('configure_passive_income_desc'),
    icon = 'cog',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            OnFormConfigurePassiveIncome(enterprise, function(passiveIncome)
                lib.callback.await('enterprise:update-passive-income', false, enterprise.id, passiveIncome)
            end)
        end, DEFINE_GETTERS_ENTERPRISE_INFOS.PASSIVE_INCOME)
    end
}
