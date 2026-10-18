-- Espelha a validação da NUI: /^https:\/\/cdn\.santagroup\.gg\/\S+$/i
local AUDIO_CDN_PREFIX = 'https://cdn.santagroup.gg/'
local AUDIO_URL_MAX_LENGTH = 255

---@param url any
---@return string | nil normalizedUrl -- link sem espaços nas pontas, ou nil se não for do CDN
function NormalizeAudioUrl(url)

    if type(url) ~= 'string' then
        return nil
    end

    local trimmed = url:match('^%s*(.-)%s*$')

    if #trimmed <= #AUDIO_CDN_PREFIX or #trimmed > AUDIO_URL_MAX_LENGTH then
        return nil
    end

    if trimmed:sub(1, #AUDIO_CDN_PREFIX):lower() ~= AUDIO_CDN_PREFIX or trimmed:find('%s') then
        return nil
    end

    return trimmed
end
