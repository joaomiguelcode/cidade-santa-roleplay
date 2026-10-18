-- smartphone middlewares definition
PhoneMiddlewares = {}

function RegisterPhoneMiddleware(name, handler)
    PhoneMiddlewares[name] = handler
end

function ExecutePhoneMiddlewares(action, source, data)
    for name, fn in pairs(PhoneMiddlewares) do
        local ok, allow = pcall(fn, action, source, data)
        if ok and allow == false then
            return false
        end
    end
    return true
end
