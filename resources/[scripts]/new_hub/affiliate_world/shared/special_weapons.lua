---@class affiliateWorld.SpecialWeaponConfig
---@field private boolean
---@field name? string
---@field subtitle? string
---@field image? string
---@field imageIndex? string
---@field price? number
---@field filter? string
---@field weapon_type? string
---@field ammo? integer
---@field exclusiveOwner? string

---@type table<string, table<string, affiliateWorld.SpecialWeaponConfig>>
AFFILIATE_WORLD_SPECIAL_WEAPONS_BY_CITY = {
    CidadeNobre = {
        WEAPON_RAIJIN = { private = true },
        WEAPON_ONI = { private = true },
        WEAPON_SHINIGAMI = { private = true },
        WEAPON_TIGER = { private = true },
        WEAPON_TIGER_PISTOL = { private = true },
        WEAPON_TIGER_SNIPER = { private = true },
        WEAPON_WOLFSTORM = { private = true },
        WEAPON_BULLPUPRIFLE_MK2_LOBO = { private = true },
        WEAPON_HEAVYSNIPER_MK2_LOBO = { private = true },
        WEAPON_PL_PENHASHOP_G3_PCJ_V2 = { private = true },
    },
    Maresia = {
        WEAPON_ABISSAL = { private = true },

        --- isso nem existe tirar em produção 
        WEAPON_RAIJIN = { private = true },
        WEAPON_ONI = { private = true },
        WEAPON_SHINIGAMI = { private = true },
        WEAPON_TIGER = { private = true },
        WEAPON_TIGER_PISTOL = { private = true },
        WEAPON_TIGER_SNIPER = { private = true },
        WEAPON_WOLFSTORM = { private = true },
        WEAPON_BULLPUPRIFLE_MK2_LOBO = { private = true },
        WEAPON_HEAVYSNIPER_MK2_LOBO = { private = true },
        WEAPON_PL_PENHASHOP_G3_PCJ_V2 = { private = true },
    },
    Santa = {
        WEAPON_RAIJIN = { private = true },
        WEAPON_ONI = { private = true },
        WEAPON_SHINIGAMI = { private = true },
    },

}

---@param targetCityName? string
---@return table<string, affiliateWorld.SpecialWeaponConfig>
function GetAffiliateWorldSpecialWeaponsByCity(targetCityName)

    local currentCityName = targetCityName or cityName or GetConvar("cityName", "")

    return AFFILIATE_WORLD_SPECIAL_WEAPONS_BY_CITY[currentCityName] or {}
end

---@param weaponName string
---@param targetCityName? string
---@return affiliateWorld.SpecialWeaponConfig?
function GetAffiliateWorldSpecialWeaponConfig(weaponName, targetCityName)

    return GetAffiliateWorldSpecialWeaponsByCity(targetCityName)[weaponName]
end
