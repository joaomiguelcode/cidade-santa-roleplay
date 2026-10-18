SurveyLowRatingLog = {}

function SurveyLowRatingLog.Log(passport, surveyKey, rating, answers)
    local webhook = SurveyWebhooks.lowRating
    if not webhook or webhook == '' then return end
    
    local payload = {
        embeds = {{
            title = '⚠️ Pesquisa de Satisfação - Avaliação Baixa',
            color = 16711680,
            fields = {
                { name = 'Passaporte', value = tostring(passport), inline = true },
                { name = 'Pesquisa', value = tostring(surveyKey), inline = true },
                { name = 'Nota', value = tostring(rating) .. '/10', inline = true },
                { name = 'Respostas', value = json.encode(answers) }
            },
            footer = { text = os.date('%d/%m/%Y %H:%M:%S') }
        }}
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end
