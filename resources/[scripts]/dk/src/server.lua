-- dk paired animations server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local activeRequests = {}

RegisterNetEvent('dk:requestAnim', function(targetSource, animIndex)
    local source = source
    local passport = vRP.Passport(source)
    local targetPassport = vRP.Passport(targetSource)
    if not passport or not targetPassport then return end
    
    local animData = Config.animsList[animIndex]
    if not animData or not animData.actived then return end
    
    if animData.request then
        activeRequests[targetSource] = {
            requester = source,
            animIndex = animIndex
        }
        TriggerClientEvent('Notify', targetSource, 'importante', ('Pedido de animação recebido: %s. Pressione Y para aceitar ou U para recusar.'):format(animData.description or animData.command))
    else
        TriggerClientEvent('dk:syncAnim', source, targetSource, animIndex, true)
        TriggerClientEvent('dk:syncAnim', targetSource, source, animIndex, false)
    end
end)

RegisterNetEvent('dk:acceptAnim', function()
    local source = source
    local req = activeRequests[source]
    if not req then return end
    activeRequests[source] = nil
    
    TriggerClientEvent('dk:syncAnim', req.requester, source, req.animIndex, true)
    TriggerClientEvent('dk:syncAnim', source, req.requester, req.animIndex, false)
end)

RegisterNetEvent('dk:stopAnim', function(targetSource)
    local source = source
    TriggerClientEvent('dk:stopAnim', source)
    if targetSource and targetSource > 0 then
        TriggerClientEvent('dk:stopAnim', targetSource)
    end
end)
