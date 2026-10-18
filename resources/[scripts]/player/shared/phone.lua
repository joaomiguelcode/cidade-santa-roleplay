SMARTPHONE_CONFIG = {}

SMARTPHONE_CONFIG.SPECIAL_NUMBERS = {
    ['999-999-999'] = {
        canDeleteChannel = false,
        name = _t('commercial.number.offerts'),
        avatar = 'https://cdn.santagroup.gg/vips-notifies/danike.webp'
    },
}

local function GetSpecialNumbers()
    return SMARTPHONE_CONFIG.SPECIAL_NUMBERS
end

exports('GetSpecialNumbers', GetSpecialNumbers)

if not IsDuplicityVersion() then
    RegisterNUICallback('getSpecialNumbers', function(_, cb)
        cb(GetSpecialNumbers())
    end)
end
