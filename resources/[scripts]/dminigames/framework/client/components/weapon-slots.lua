---@class WeaponSlots

if not class then
    error('[WeaponSlots] ERRO CRÍTICO: função class() não está disponível!')
end

WeaponSlots = class()

---@param minigameName? string
function WeaponSlots:__init(minigameName)
    self.minigameName = minigameName or 'WeaponSlots'
    self.controlsManager = ControlsManager(self.minigameName)
    self.slots = {}
    self.active = false
    self.lastEquippedSlot = nil
end

---@param slotsConfig table
function WeaponSlots:setSlots(slotsConfig)
    self.slots = slotsConfig

    for slotId, slot in pairs(self.slots) do
        slot.active = false
    end
end

---@param slotId number
---@param options? table
function WeaponSlots:toggleSlot(slotId, options)
    options = options or {}
    local slot = self.slots[slotId]

    if not slot then
        return false
    end

    local ped = PlayerPedId()
    local weaponHash = GetHashKey(slot.weapon)

    if self.lastEquippedSlot == slotId then
        self.slots[slotId].active = false

        RemoveWeaponFromPed(ped, weaponHash)
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        self.lastEquippedSlot = nil

        if options.onHolster then
            options.onHolster(slotId, slot)
        end

        local slots = {}
        for i = 1, #self.slots do
            slots[i] = {
                slot = i,
                name = self.slots[i].name,
                active = self.slots[i].active
            }
        end

        TriggerEvent('pvp:updateHudSlotItems', slots)

        return true
    end

    for otherSlotId, otherSlot in pairs(self.slots) do
        if otherSlotId ~= slotId then
            otherSlot.active = false

            local otherWeaponHash = GetHashKey(otherSlot.weapon)
            if HasPedGotWeapon(ped, otherWeaponHash, false) then
                RemoveWeaponFromPed(ped, otherWeaponHash)
            end
        end
    end

    GiveWeaponToPed(ped, weaponHash, slot.ammo or -1, false, true)

    self.lastEquippedSlot = slotId
    self.slots[slotId].active = true

    if options.onEquip then
        options.onEquip(slotId, slot)
    end

    local slots = {}
    for i = 1, #self.slots do
        slots[i] = {
            slot = i,
            name = self.slots[i].name,
            active = self.slots[i].active
        }
    end

    TriggerEvent('pvp:updateHudSlotItems', slots)

    CreateThread(function()
        local ammoMax = -1
        local ammoMin = -1

        while self.slots[slotId].active do
            local ped = PlayerPedId()
            local hash = GetSelectedPedWeapon(ped)
            local _, min = GetAmmoInClip(ped, hash)
            local max = GetAmmoInPedWeapon(ped, hash)

            if ammoMax ~= max or ammoMin ~= min then
                ammoMax = max
                ammoMin = min

                if (max - min) <= 0 then
                    max = 0
                else
                    max = max - min
                end

                TriggerEvent('pvp:updateHudWeapon', {
                    name = self.slots[slotId].name,
                    ammo = min,
                    maxAmmo = max
                })
            end

            Wait(100)
        end

        if not self.lastEquippedSlot then
            TriggerEvent('pvp:updateHudWeapon')
        end
    end)

    return true
end

---@param options? table
function WeaponSlots:registerControls(options)
    options = options or {}

    for slotId, slot in pairs(self.slots) do
        self.controlsManager:register(slot.key, function()
            self:toggleSlot(slotId, options)
        end, {
            description = ('Slot %d: %s'):format(slotId, slot.name),
            enabled = true
        })
    end

    local slots = {}
    for i = 1, #self.slots do
        slots[i] = {
            slot = i,
            name = self.slots[i].name,
            active = false
        }
    end

    TriggerEvent('pvp:updateHudSlotItems', slots)

    self.active = true
end

---@param slotsConfig table
---@param options? table
function WeaponSlots:start(slotsConfig, options)
    self:setSlots(slotsConfig)
    self:registerControls(options)

    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
end

function WeaponSlots:stop()
    for slotId, slot in pairs(self.slots) do
        slot.active = false
    end

    self.controlsManager:stopAll()
    self.slots = {}
    self.active = false
    self.lastEquippedSlot = nil

    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
end

---@param enabled boolean
function WeaponSlots:setAllEnabled(enabled)
    self.controlsManager:setAllEnabled(enabled)
end

---@return boolean active
function WeaponSlots:isActive()
    return self.active
end

function WeaponSlots:reequipLastWeapon()
    if not self.lastEquippedSlot or not self.slots[self.lastEquippedSlot] then
        return false
    end

    local ped = PlayerPedId()
    local slot = self.slots[self.lastEquippedSlot]
    local weaponHash = GetHashKey(slot.weapon)

    if HasPedGotWeapon(ped, weaponHash, false) then
        SetCurrentPedWeapon(ped, weaponHash, true)
        return true
    end

    return false
end
