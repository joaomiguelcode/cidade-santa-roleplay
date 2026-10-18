functions = {
    instances = {}
}

functions.new = function()
    local resource = GetInvokingResource()

    functions.instances[resource] = functions.instances[resource] or tooltip()
    return functions.instances[resource]
end

functions.message = function(message)
    local resource = GetInvokingResource()
    local instance = functions.instances[resource]

    if (not instance) then
        return false, ('instance for resource %s does not exist'):format(resource)
    end

    instance:message(message)
end

functions.render = function(coords, maxDistance, dist)
    local resource = GetInvokingResource()
    local instance = functions.instances[resource]

    if (not instance) then
        return false, ('instance for resource %s does not exist'):format(resource)
    end

    instance:render3DSprite(coords, maxDistance, dist)
end

functions.setText = function(data)
    local resource = GetInvokingResource()
    local instance = functions.instances[resource]

    if (not instance) then
        return false, ('instance for resource %s does not exist'):format(resource)
    end

    instance:setText(data)
end

functions.destroy = function()
    local resource = GetInvokingResource()
    local instance = functions.instances[resource]

    if (not instance) then
        return false, ('instance for resource %s does not exist'):format(resource)
    end

    instance:destroy()
end

exports(
    'wrappers',
    function()
        functions.new()
        return functions
    end
)
