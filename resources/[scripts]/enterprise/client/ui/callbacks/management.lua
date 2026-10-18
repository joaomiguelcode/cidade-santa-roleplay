RegisterNUICallback('management:getData', function(data, callback)
    local response = lib.callback.await('enterprise/ui/get-management-data', false, EnterPriseClass.activeEnterprise)

    if not next(response) then
        return callback({})
    end

    for _, record in pairs(response.financial) do
        record.date = record.date * 1000
    end

    callback(response)
end)

RegisterNUICallback('management:help', function(data, callback)
    lib.callback.await('enterprise/ui/get-management-help', false, EnterPriseClass.activeEnterprise)
    callback(true)
end)

RegisterNUICallback('management:updateRadio', function(data, callback)
    local response = lib.callback.await('enterprise/ui/update-radio', false, EnterPriseClass.activeEnterprise, data.frequency)
    callback(response)
end)


RegisterNUICallback('management:updateDistribution', function(data, callback)
    local response = lib.callback.await('enterprise/ui/update-distribution', false, EnterPriseClass.activeEnterprise, data)
    callback(response)
end)

RegisterNUICallback('management:updateRoles', function(data, callback)
    local response = lib.callback.await('enterprise/ui/update-roles', false, EnterPriseClass.activeEnterprise, data)
    callback(response)
end)

RegisterNUICallback('management:editUniform', function(data, callback)
    callback(true)
    SendNUIMessage({ action = "toggle", data = { active = false, cid = EnterPriseClass.activeEnterprise } })

    local data = {
        flags = eSkinshopOpenFlags.TEMPORARY_CUSTOMIZATION,
        customModel = data.type == 'male' and `mp_m_freemode_01` or `mp_f_freemode_01`,
        callback = function(cloth)
            SendNUIMessage({ action = "toggle", data = { active = true, cid = EnterPriseClass.activeEnterprise } })
            
            if not next(cloth) then
                return
            end

            data.customization = cloth
            lib.callback.await('enterprise/ui/edit-uniform', false, EnterPriseClass.activeEnterprise, data)
        end
    } ---@type ISkinShop.OpenWithFlags
    TriggerEvent("skinshop:open-with-flags", data)
end)
