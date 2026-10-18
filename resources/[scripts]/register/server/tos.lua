-- Register server module: tos.lua

RegisterServerEvent("register:acceptTerms")
AddEventHandler("register:acceptTerms", function()
    local source = source
    local license = vRP.Identities(source)
    if license then
        pcall(function()
            vRP.Query("accounts/updateTOS", { License = license })
        end)
    end
    TriggerClientEvent("register:openplayerdata", source)
end)

function Server.acceptTermsInline()
    local source = source
    local license = vRP.Identities(source)
    if license then
        pcall(function()
            vRP.Query("accounts/updateTOS", { License = license })
        end)
    end
    return true
end

function Server.updateTOS(val)
    local source = source
    local license = vRP.Identities(source)
    if license then
        pcall(function()
            vRP.Query("accounts/updateTOS", { License = license })
        end)
    end
    return true
end
