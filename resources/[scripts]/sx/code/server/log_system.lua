
function sx.log(category, message, ...)
    print(('^3[SX:%s]^0 %s'):format(category or 'LOG', (message or ''):format(...)))
end
