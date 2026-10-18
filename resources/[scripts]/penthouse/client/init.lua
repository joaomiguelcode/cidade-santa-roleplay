PenthouseManager = nil

CreateThread(function()
    Wait(0)
    PenthouseManager = PenthouseClient()
    PenthouseManager:initialize()
    print('^2[Penthouse]^7 Sistema inicializado com sucesso!')
end)

---@return PenthouseClient|nil
exports('GetPenthouseManager', function()
    return PenthouseManager
end)

---@return boolean
exports('IsInsidePenthouse', function()
    if not PenthouseManager then return false end
    return PenthouseManager:isInsidePenthouse()
end)

---@return table|nil
exports('GetCurrentPenthouse', function()
    if not PenthouseManager then return nil end
    if not PenthouseManager:isInsidePenthouse() then return nil end
    return PenthouseManager.insideHouseData.penthouse
end)


RegisterCommand('penthouse:debug', function()
    if not hasAdminGroup() then return end

    if not PenthouseManager then
        print('PenthouseManager não inicializado')
        return
    end

    print('=== PENTHOUSE DEBUG ===')
    print('Current Building:', PenthouseManager.currentBuildingId)
    print('Current Location:', PenthouseManager.currentEnterLocation)
    print('Inside House:', PenthouseManager.insideHouseData.interior ~= nil)

    if PenthouseManager.insideHouseData.penthouse then
        print('Current Penthouse:')
        print(json.encode(PenthouseManager.insideHouseData.penthouse, { indent = true }))
    end

    print('UI Visible:', PenthouseManager.ui:isAnyMenuVisible())
    print('Interactions:', json.encode(PenthouseManager.interactions:getAllInteractions()))
end)

RegisterCommand('penthouse:reset', function()
    if not hasAdminGroup() then return end

    if not PenthouseManager then
        print('PenthouseManager não inicializado')
        return
    end

    PenthouseManager.ui:closeAll()

    PenthouseManager.currentBuildingId = nil
    PenthouseManager.currentEnterLocation = nil
    PenthouseManager.insideHouseData = {}

    print('^2[Penthouse]^7 Sistema resetado!')
end)
