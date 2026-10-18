local TIME_PENTHOUSE_CONTEXT_ID = 'time_penthouse_list'

local function getTimePenthouseTranslations()
    return translations[language]['time_penthouse']
end

---@param status string
---@return string
local function getStatusLabel(status)
    local translate = getTimePenthouseTranslations()

    if status == 'expired' then
        return translate['status_expired']
    end

    return translate['status_active']
end

---@param penthouses table
---@return table
local function buildTimePenthouseOptions(penthouses)

    local translate = getTimePenthouseTranslations()
    local options = {}

    for _, penthouse in ipairs(penthouses) do
        local statusLabel = getStatusLabel(penthouse.status)
        local iconColor = penthouse.status == 'expired' and '#ef4444' or '#22c55e'
        local isPermanent = penthouse.remaining == translate['no_expiration']
        local description = isPermanent and translate['permanent'] or (translate['expires_in']):format(penthouse.remaining)
        local metadataLabel = isPermanent and translate['status_label'] or translate['expiration_label']
        local metadataValue = isPermanent and translate['permanent'] or penthouse.remaining
        local metadata = {
            { label = translate['id_label'], value = penthouse.penthouseId },
            { label = metadataLabel, value = metadataValue },
        }

        if penthouse.status == 'expired' then
            description = (translate['expired_ago']):format(penthouse.remaining)
            metadata[2] = { label = translate['expired_label'], value = penthouse.remaining }
        end

        options[#options + 1] = {
            title = (translate['item_title']):format(penthouse.interiorName, penthouse.code),
            description = description,
            icon = 'house',
            iconColor = iconColor,
            metadata = metadata,
        }
    end

    return options
end

---@param penthouses table
---@param targetCharacterId number
---@param hasExplicitTarget boolean
local function showTimePenthouseMenu(penthouses, targetCharacterId, hasExplicitTarget)
    local translate = getTimePenthouseTranslations()
    local title = translate['title_self']

    if hasExplicitTarget then
        title = (translate['title_target']):format(targetCharacterId)
    end

    lib.registerContext({
        id = TIME_PENTHOUSE_CONTEXT_ID,
        title = title,
        options = buildTimePenthouseOptions(penthouses)
    })

    lib.showContext(TIME_PENTHOUSE_CONTEXT_ID)
end

RegisterNetEvent('penthouse.client:showTimePenthouse', function(penthouses, targetCharacterId, hasExplicitTarget)
    showTimePenthouseMenu(penthouses, targetCharacterId, hasExplicitTarget)
end)
