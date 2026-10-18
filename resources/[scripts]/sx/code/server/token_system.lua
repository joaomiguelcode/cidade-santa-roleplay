
local tokens = {}
function sx.generatePlayerToken(source)
    local token = ('tok_%s_%s'):format(source, os.time())
    tokens[source] = token
    Player(source).state:set('authToken', token, false)
    return token
end

AddEventHandler('playerDropped', function()
    tokens[source] = nil
end)
