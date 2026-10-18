
---@param animation string?
local function onFormAnimation(animation)
    local input = lib.inputDialog(_t('configure_animation_title'), {
        { type = 'input', label = _t('label_animation'), required = true, default = animation },
    })

    if not input then
        return
    end

    return input[1]
end

---@param enterprise_id number
---@param workflows IEnterPrise.WorkStation[]
function OnSelectConfigureFarm(enterprise_id, workflows)
    local fields = {}

    for id, data in pairs(workflows) do
        if data.method == 'farm' then
            table.insert(fields, {
                title = ('%s - %s'):format(data.animation, id),
                description = _t('farm_delete_desc'),
                onSelect = function()
                    PolyzoneEditor.start(data.points, function(points)
                        if not next(points) then
                            ---@type UseCase.WorkStation.Delete
                            local payload = { enterprise_id = enterprise_id, id = id }
                            return lib.callback.await('enterprise:workstation-delete-farm', false, payload)
                        end

                        local animation = onFormAnimation(data.animation)

                        if not animation then
                            return utils.notify(0, "Warning", _t('farm_no_animation_desc'), 5000, _t('farm_warning_title'))
                        end

                        ---@type UseCase.WorkStation.Update
                        local payload = {
                            animation = animation,
                            points = points,
                            enterprise_id = enterprise_id,
                            id = id,
                            method = 'farm',
                        }

                        lib.callback.await('enterprise:workstation-update-farm', false, payload)
                    end)
                end,
            })
        end
    end

    table.insert(fields, {
        title = _t('farm_create_title'),
        description = _t('farm_create_desc'),
        icon = 'plus-circle',
        onSelect = function()
            PolyzoneEditor.start({}, function(points)
                if not next(points) then
                    return utils.notify(0, "Warning", _t('farm_no_points_desc'), 5000, _t('farm_warning_title'))
                end

                local animation = onFormAnimation()

                if not animation then
                    return utils.notify(0, "Warning", _t('farm_no_animation_desc'), 5000, _t('farm_warning_title'))
                end

                ---@type UseCase.WorkStation.Create
                local payload = {
                    animation = animation,
                    points = points,
                    enterprise_id = enterprise_id,
                    method = 'farm',
                }

                lib.callback.await('enterprise:workstation-create-farm', false, payload)
            end)
        end,
    })

    local menu = lib.registerContext({
        id = 'enterprise:configure-farm',
        title = _t('farm_configure_title'),
        options = fields,
    })

    lib.showContext('enterprise:configure-farm')
end

DEFINE_CONTEXT_FORM {
    title = _t('configure_farms_title'),
    description = _t('configure_farms_desc'),
    icon = 'cog',
    onSelect = function()
        OnSelectEnterPriseList(function(enterprise)
            OnSelectConfigureFarm(enterprise.id, enterprise.workstations)
        end, DEFINE_GETTERS_ENTERPRISE_INFOS.WORKSTATIONS)
    end
}