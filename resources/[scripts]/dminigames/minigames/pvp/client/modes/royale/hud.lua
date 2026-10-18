---@class RoyaleHud
---@field visible boolean
---@field playerCount integer
---@field personalChestAvailable boolean
---@field revision integer
---@field tickAbort? fun()
---@field nextStatusAt number
---@field health? integer
---@field armor? integer
---@field cachedWeaponName? string
---@field cachedWeaponHash? number
---@field cachedDisplayName? string
---@field weaponName? string
---@field ammo? number
---@field maxAmmo? number
RoyaleHud = class()

local gUpdateIntervalMs = 200
-- Dois ticks mantem vida/colete dentro do limite de 500 ms.
local gStatusIntervalMs = 400

---@param action string
---@param payload? any
local function SendHudEvent( action, payload )

    TriggerEvent( ( 'pvp.hud:%s' ):format( action ), payload )
end

---@param value number
---@return integer
local function ClampPercent( value )

    return math.max( 0, math.min( 100, math.floor( value ) ) )
end

---@param hud RoyaleHud
local function ResetSamples( hud )

    hud.nextStatusAt = 0
    hud.health = nil
    hud.armor = nil
    hud.cachedWeaponName = nil
    hud.cachedWeaponHash = nil
    hud.cachedDisplayName = nil
    hud.weaponName = nil
    hud.ammo = nil
    hud.maxAmmo = nil
end

---@param weaponName string
---@return string
local function GetWeaponDisplayName( weaponName )

    local displayName = type( itemName ) == 'function' and itemName( weaponName ) or nil

    if type( displayName ) == 'string' and displayName ~= '' and displayName ~= 'Deletado' then
        return displayName
    end

    displayName = weaponName:gsub( '^WEAPON_', '' ):gsub( '_', ' ' ):lower()

    return ( displayName:gsub( '(%a)([%w]*)', function( firstLetter, remainingLetters )
        return ( '%s%s' ):format( firstLetter:upper(), remainingLetters )
    end ) )
end

---@param hud RoyaleHud
local function ClearWeapon( hud )

    if not hud.weaponName then return end

    hud.weaponName = nil
    hud.ammo = nil
    hud.maxAmmo = nil
    SendHudEvent( 'updateHudWeapon', nil )
    SendHudEvent( 'updateHudSlotItems', {} )
end

---@param hud RoyaleHud
---@param revision integer
---@param ped number
---@return boolean
local function IsCurrentSample( hud, revision, ped )

    return hud.visible and hud.revision == revision and PlayerPedId() == ped and DoesEntityExist( ped )
end

---@param hud RoyaleHud
---@param revision integer
local function RefreshHud( hud, revision )

    if not hud.visible or hud.revision ~= revision then return end

    if GetResourceState( 'hud' ) ~= 'started' then
        hud:Hide()
        return
    end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then return end

    local now = GetGameTimer()

    if now >= hud.nextStatusAt then
        local healthRange = GetEntityMaxHealth( ped ) - 100
        local health = healthRange > 0 and ClampPercent( ( GetEntityHealth( ped ) - 100 ) / healthRange * 100 ) or 0
        local armor = ClampPercent( GetPedArmour( ped ) )
        hud.nextStatusAt = now + gStatusIntervalMs

        if health ~= hud.health or armor ~= hud.armor then
            hud.health, hud.armor = health, armor
            SendHudEvent( 'updateHudStatus', { health = health, armor = armor } )
        end
    end

    local success, weaponName = false, nil

    if GetResourceState( 'inventory' ) == 'started' then
        success, weaponName = pcall( function() return exports.inventory:Weapons() end )
    end

    -- O export pode ceder: uma consulta antiga nao pode escrever na HUD reaberta.
    if not IsCurrentSample( hud, revision, ped ) then return end

    if GetResourceState( 'hud' ) ~= 'started' then
        hud:Hide()
        return
    end

    if not success or type( weaponName ) ~= 'string' or weaponName == '' then
        hud.cachedWeaponName, hud.cachedWeaponHash, hud.cachedDisplayName = nil, nil, nil
        ClearWeapon( hud )
        return
    end

    local changed = weaponName ~= hud.cachedWeaponName
    local weaponHash = changed and joaat( weaponName ) or hud.cachedWeaponHash
    local displayName = not changed and hud.cachedDisplayName or nil

    if GetSelectedPedWeapon( ped ) ~= weaponHash then
        hud.cachedWeaponName, hud.cachedWeaponHash, hud.cachedDisplayName = weaponName, weaponHash, displayName
        ClearWeapon( hud )
        return
    end

    if not displayName then
        displayName = GetWeaponDisplayName( weaponName )

        if not IsCurrentSample( hud, revision, ped ) or GetSelectedPedWeapon( ped ) ~= weaponHash then return end
    end

    hud.cachedWeaponName, hud.cachedWeaponHash, hud.cachedDisplayName = weaponName, weaponHash, displayName
    local _, ammo = GetAmmoInClip( ped, weaponHash )
    local maxAmmo = GetMaxAmmoInClip( ped, weaponHash, true )
    ammo = math.max( 0, tonumber( ammo ) or 0 )
    maxAmmo = math.max( ammo, tonumber( maxAmmo ) or ammo )
    local weaponChanged = hud.weaponName ~= weaponName

    if weaponChanged then
        SendHudEvent( 'updateHudSlotItems', { { slot = 1, name = weaponName, active = true } } )
    end

    if weaponChanged or hud.ammo ~= ammo or hud.maxAmmo ~= maxAmmo then
        hud.weaponName, hud.ammo, hud.maxAmmo = weaponName, ammo, maxAmmo
        SendHudEvent( 'updateHudWeapon', { name = displayName, ammo = ammo, maxAmmo = maxAmmo } )
    end
end

---@param hud RoyaleHud
---@param revision integer
local function UpdateRoyaleHud( hud, revision )

    Wait( gUpdateIntervalMs )
    RefreshHud( hud, revision )
end

function RoyaleHud:__init()

    self.visible = false
    self.playerCount = 0
    self.personalChestAvailable = false
    self.revision = 0
    ResetSamples( self )
end

---@param count number
---@return boolean changed
function RoyaleHud:SetPlayerCount( count )

    count = tonumber( count )

    if not count or count ~= count or count <= -math.huge or count >= math.huge then return false end

    count = math.max( 0, math.floor( count ) )

    if self.playerCount == count then return false end

    self.playerCount = count

    if self.visible and GetResourceState( 'hud' ) == 'started' then
        SendHudEvent( 'updateHudPlayerCount', count )
    end

    return true
end

---@param available boolean
function RoyaleHud:SetPersonalChestAvailable( available )

    available = available == true

    if self.personalChestAvailable == available then return end

    self.personalChestAvailable = available

    if self.visible and GetResourceState( 'hud' ) == 'started' then
        SendHudEvent( 'setDominationStoreHintVisible', { visible = false, vehiclesVisible = false, personalChestVisible = available } )
    end
end

---@param playerCount? number
---@return boolean shown
function RoyaleHud:Show( playerCount )

    if playerCount ~= nil then self:SetPlayerCount( playerCount ) end

    if GetResourceState( 'hud' ) ~= 'started' then
        self:Hide()
        return false
    end

    if self.visible then return true end

    self.visible = true
    self.revision = self.revision + 1
    local revision = self.revision
    ResetSamples( self )
    SendHudEvent( 'setHudMode', 'FREE_FOR_ALL' )
    SendHudEvent( 'setPauseHintVisible', { visible = false } )
    SendHudEvent( 'setDominationStoreHintVisible', { visible = false, vehiclesVisible = false, personalChestVisible = self.personalChestAvailable } )
    SendHudEvent( 'clearKillFeed' )
    SendHudEvent( 'updateHudKills', 0 )
    SendHudEvent( 'updateHudPlayerCount', self.playerCount )
    SendHudEvent( 'updateHudSlotItems', {} )
    SendHudEvent( 'updateHudWeapon', nil )
    SendHudEvent( 'showHud' )
    RefreshHud( self, revision )

    if not self.visible or self.revision ~= revision then return false end

    self.tickAbort = sx.script.setTick( function() UpdateRoyaleHud( self, revision ) end )
    return true
end

function RoyaleHud:Hide()

    if not self.visible and not self.tickAbort then return end

    self.visible = false
    self.revision = self.revision + 1
    local abort = self.tickAbort
    self.tickAbort = nil

    if abort then abort() end

    ResetSamples( self )
    SendHudEvent( 'hideHud' )
    SendHudEvent( 'setPauseHintVisible', { visible = true } )
    SendHudEvent( 'setDominationStoreHintVisible', { visible = false, vehiclesVisible = false, personalChestVisible = false } )
    SendHudEvent( 'clearKillFeed' )
    SendHudEvent( 'updateHudWeapon', nil )
    SendHudEvent( 'updateHudSlotItems', {} )
end
