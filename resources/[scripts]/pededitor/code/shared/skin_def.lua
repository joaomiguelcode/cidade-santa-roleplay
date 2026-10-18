---@enum eSkinCategory
eSkinCategory = {
    HUMANOS    = 'humanos',
    ANIMAIS    = 'animais',
    CHARACTERS = 'personagens',
}

---@type table<string, boolean>
local gValidCategories = {}

for _, category in pairs( eSkinCategory ) do
    gValidCategories[ category ] = true
end

---@param category string
---@return boolean
function IsValidSkinCategory( category )
    return gValidCategories[ category ] == true
end

---@return string[]
function GetAllSkinCategories()
    local categories = {}

    for _, category in pairs( eSkinCategory ) do
        categories[ #categories + 1 ] = category
    end

    return categories
end

---@class SkinDef
---@field id number
---@field name string
---@field model string
---@field category string
---@field isFavorite boolean
---@field isActive boolean
---@field expiresAt? integer

---@class PlayerSkinsCache
---@field list SkinDef[]
---@field byModel table<string, SkinDef>
---@field lastUpdate number

---@class SkinDbRow
---@field player_id number
---@field skin_name string
---@field skin_model string
---@field skin_category string
---@field is_favorite number
---@field is_active number
---@field expires_at? integer

---@class FormattedSkinForClient
---@field id string
---@field name string
---@field favorite boolean
---@field active boolean
---@field status 'temporary'|'permanent'
---@field daysLeft? integer

---@alias FormattedSkinsData table<string, FormattedSkinForClient[]>

---@alias pededitor.CharacterId number

---@class pededitor.PendingPedPackage
---@field id integer
---@field offers string[]
---@field selectionLimit integer
---@field durationDays? integer
---@field createdAt? string
---@field redeemedPeds? table[]
---@field swapCooldown? integer

---@class pededitor.PedRedeemSlot
---@field id string
---@field packageId integer
---@field ordinal integer
---@field optionIds string[]
---@field status 'temporary'|'permanent'
---@field daysLeft? integer
---@field currentId? string
---@field current? table
---@field swapCooldown? integer

---@class pededitor.PedRedeemSession
---@field packages pededitor.PendingPedPackage[]
---@field slots pededitor.PedRedeemSlot[]
---@field openedAt integer

---@class pededitor.RedeemedSkin
---@field name string
---@field model string
---@field category string
---@field expiresAt? integer

---@class pededitor.StoredSkin : pededitor.RedeemedSkin
---@field characterId pededitor.CharacterId

---@class pededitor.PedRedeemResponse
---@field success boolean
---@field message? string
---@field data? table
