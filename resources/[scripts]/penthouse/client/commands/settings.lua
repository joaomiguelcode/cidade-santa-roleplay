RegisterCommand(translations[language]['settings_command'], function(source, args)
    if not PenthouseManager then
        return false
    end

    if not PenthouseManager:isInsidePenthouse() then
        return false
    end

    local penthouseId = PenthouseManager:getCurrentPenthouseId()
    local penthouse, isOwner = vSERVER.getPenthouseData(penthouseId)

    if not penthouse or not isOwner then
        return false
    end

    local visitorOptions = config.interiors[penthouse.interior].visitorOptions

    penthouse.visitorOptions = visitorOptions
    penthouse.level = config.interiors[penthouse.interior].level
    penthouse.storeUrl = config.storeLink[city]

    PenthouseManager.ui:showEditPenthouse(true, penthouse)
end)