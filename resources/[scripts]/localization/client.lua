---@return string
local function GetCurrentLanguage()

    return GetConvar( 'language', 'pt-br' )
end
RegisterNUICallback( 'getLang', function( data, cb )
    local resourceNameRequestBy = data.resourceName and data.resourceName or data
    local language = GetCurrentLanguage()
    local supported = { ['pt-br'] = true, ['en-us'] = true, ['es-es'] = true,
        ['pt-pt'] = true, ['ar-sa'] = true }
    if resourceNameRequestBy == 'dashboard' and type(data) == 'table' and data.locale ~= nil then
        language = supported[data.locale] and data.locale or 'en-us'
    end

    local fileUrl = ('locales/frontend-i18n-config/%s/%s.json'):format(language, resourceNameRequestBy)
    local contents = LoadResourceFile( GetCurrentResourceName(), fileUrl )

    if not contents then
        fileUrl = ('locales/frontend-i18n-config/en-us/%s.json'):format(resourceNameRequestBy)
        contents = LoadResourceFile(GetCurrentResourceName(), fileUrl)
    end

    if not contents then
        print(('^3[localization] Warning: Locale not found for "%s", returning empty table^0'):format(tostring(resourceNameRequestBy)))
        cb({})
        return
    end

    local ok, locale = pcall(json.decode, contents)
    if ok and type(locale) == 'table' then
        cb( locale )
    else
        cb( {} )
    end
end)
