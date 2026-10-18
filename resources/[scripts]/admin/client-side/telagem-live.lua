local gTelagemLiveSessionId = nil

RegisterNetEvent('telagemLive:start', function(payload)

    if source ~= 65535 or type(payload) ~= 'table' then return end

    gTelagemLiveSessionId = payload.sessionId
    SendNUIMessage({ telagemLive = true, action = 'start', payload = payload })
end)

RegisterNetEvent('telagemLive:stop', function(sessionId)

    if source ~= 65535 or sessionId ~= gTelagemLiveSessionId then return end

    gTelagemLiveSessionId = nil
    SendNUIMessage({ telagemLive = true, action = 'stop', sessionId = sessionId })
end)

RegisterNUICallback('telagemLiveAnswer', function(data, cb)

    if type(data) == 'table' and data.sessionId == gTelagemLiveSessionId then
        TriggerServerEvent('telagemLive:answer', data.sessionId, data.answer, data.error)
    end

    cb({ ok = true })
end)
