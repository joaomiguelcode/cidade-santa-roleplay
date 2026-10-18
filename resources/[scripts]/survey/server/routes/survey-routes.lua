RegisterNetEvent('survey:server:submit', function(surveyKey, answers)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return end
    
    if SpamDetector.IsSpamming(passport) then
        TriggerClientEvent('Notify', src, 'negado', 'Aguarde antes de enviar novamente.', 5000)
        return
    end
    
    local ok, err = SurveyService.ProcessSubmission(passport, surveyKey, answers)
    if ok then
        TriggerClientEvent('Notify', src, 'verde', 'Obrigado por responder!', 5000)
    end
end)
