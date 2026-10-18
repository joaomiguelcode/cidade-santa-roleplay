config = {}

config.callHelpGroup = 'Afiliado'

config.adminGroups = {
    ['Experiencia'] = 1,
    ['Admin'] = 3,
    ['Afiliado'] = 1,
    ['CS'] = 1
}

config.STAFF_PENTHOUSE_GROUPS = {
    ['Admin'] = 1,
    ['Developers'] = 1,
    ['CS'] = 1,
}

NEW_PENTHOUSE_VERSITION_CITIES = {
    ['Krown'] = true,
    ['Kingdom'] = true,
    ['Santa'] = true,
    ['Royal'] = true,
    ['Malta'] = true,
    ['CidadeNobre'] = true,
    ['Fronteira'] = true,
}

local CITY_NAME = GetConvar("cityName", "")

---@return 'v2' | 'legacy'
function GetPenthouseVerstion()
    return NEW_PENTHOUSE_VERSITION_CITIES[CITY_NAME] and  'v2' or 'legacy'
end