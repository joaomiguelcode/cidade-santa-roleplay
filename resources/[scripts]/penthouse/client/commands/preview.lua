previewPenthouse = function(source, args)
    if not hasAdminGroup() then
        return
    end

    local interiorId = tonumber(args[1])

    if not interiorId then
        return
    end

    local interior = config.interiors[interiorId]

    if not interior then
        return
    end

    local interior = interiors(interiorId, 1)

    interior:load()
end

RegisterCommand('preview', previewPenthouse)