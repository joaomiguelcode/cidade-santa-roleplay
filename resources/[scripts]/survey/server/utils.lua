SurveyUtils = {}

function SurveyUtils.Sanitize(text)
    if type(text) ~= 'string' then return '' end
    return (text:gsub('[<>"\']', ''))
end
