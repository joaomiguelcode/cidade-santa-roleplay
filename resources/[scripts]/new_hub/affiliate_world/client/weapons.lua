local gAffiliateWorldWeaponHashes = {}

---@param weaponHash integer
local function TrackAffiliateWorldWeapon(weaponHash)
    gAffiliateWorldWeaponHashes[weaponHash] = true
end

---@param ped integer
---@return boolean
local function ClearTrackedAffiliateWorldWeapons(ped)
    local selectedWeaponHash = GetSelectedPedWeapon(ped)
    local hasTrackedSelectedWeapon = gAffiliateWorldWeaponHashes[selectedWeaponHash] == true
    local cleared = true

    if hasTrackedSelectedWeapon then
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    end

    for weaponHash in pairs(gAffiliateWorldWeaponHashes) do
        RemoveWeaponFromPed(ped, weaponHash)

        if HasPedGotWeapon(ped, weaponHash, false) then
            cleared = false
            sx.logger:error(("Affiliate temporary weapon cleanup failed weaponHash=%d"):format(weaponHash))
        else
            gAffiliateWorldWeaponHashes[weaponHash] = nil
        end
    end

    return cleared
end

---@param payload affiliateWorld.WeaponActionState
---@return boolean
function Client.ApplyAffiliateWorldWeapon(payload)
    if type(payload) ~= "table" or type(payload.weapon) ~= "string" then
        return false
    end

    local ped = PlayerPedId()

    if not DoesEntityExist(ped) then
        return false
    end

    ClearTrackedAffiliateWorldWeapons(ped)
 
    local weaponHash = GetHashKey(payload.weapon)

    GiveWeaponToPed(ped, weaponHash, payload.ammo, false, true)

    if type(payload.component) == "string" then
        local componentHash = GetHashKey(payload.component)
        GiveWeaponComponentToPed(ped, weaponHash, componentHash)
    end

    SetPedAmmo(ped, weaponHash, payload.ammo)
    SetCurrentPedWeapon(ped, weaponHash, true)
    TrackAffiliateWorldWeapon(weaponHash)

    return true
end

---@param weapon? string
---@return boolean
function Client.ClearAffiliateWorldWeapon(weapon)
    local ped = PlayerPedId()

    if not DoesEntityExist(ped) then
        return false
    end

    if type(weapon) == "string" then
        TrackAffiliateWorldWeapon(GetHashKey(weapon))
    end

    return ClearTrackedAffiliateWorldWeapons(ped)
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Client.ClearAffiliateWorldWeapon()
    end
end)
