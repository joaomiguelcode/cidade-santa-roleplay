---@param pos vec3
---@param reportType number
---@return void
handleBlipIndicator = function(pos, reportType)
    local x, y, z = pos.x, pos.y, pos.z

    print(reportType)

    local handler = config.reportBlips[reportType].handler
    local timeToDelete = config.reportBlips[reportType].timeToDelete

    if (not handler) then
        return
    end

    local blip = handler(x, y, z)

    if (not timeToDelete) then
        return
    end

    SetTimeout(
        timeToDelete,
        function()
            if (DoesBlipExist(blip)) then
                RemoveBlip(blip)
            end
        end
    )
end
