---@class RoyaleAlliesClient
---@field matchId any?
---@field teamName string?
---@field teamHash integer?
---@field sources table<integer, boolean>
---@field sourceCount integer
---@field outlinedPedBySource table<integer, table>
RoyaleAlliesClient = class()

local ROYALE_ALLY_REFRESH_INTERVAL_MS = 500
local ROYALE_ALLY_ACTIVE_SCAN_MIN_SOURCES = 32
local ROYALE_ALLY_OUTLINE_COLOR = { 80, 170, 255 }
local ROYALE_ALLY_OUTLINE_SHADER = 1
local ROYALE_ALLY_OUTLINE_TEXTURE = 'waterreflection'

---@param value any
---@return integer?
local function PositiveInteger( value )

    value = tonumber( value )
    if not value or value < 1 or value % 1 ~= 0 then return end
    return value
end

---@param source integer
---@return integer? player
local function GetActivePlayer( source )

    local player = GetPlayerFromServerId( source )
    if player == -1 or not NetworkIsPlayerActive( player ) then return end
    return player
end

function RoyaleAlliesClient:__init()

    self.revision = 0
    self.active = false
    self.sources = {}
    self.sourceCount = 0
    self.outlinedPedBySource = {}
end

---@param matchId any
---@param teamName any Nome estavel do grupo de relacionamento enviado pelo servidor.
---@param sources any
---@return boolean
function RoyaleAlliesClient:Open( matchId, teamName, sources )

    teamName = type( teamName ) == 'string' and teamName or nil
    self:Close()
    if matchId == nil or not teamName or teamName == '' or type( sources ) ~= 'table' then return false end

    self.matchId = matchId
    self.teamName = teamName
    self.teamHash = GetHashKey( teamName )
    self.localSource = PositiveInteger( GetPlayerServerId( PlayerId() ) )
    self.sources = {}
    self.sourceCount = 0
    self.outlinedPedBySource = {}
    self.active = true
    self.revision = self.revision + 1

    AddRelationshipGroup( teamName )
    for _, value in ipairs( sources ) do
        local source = PositiveInteger( value )
        if source and source ~= self.localSource and not self.sources[ source ] then
            self.sources[ source ] = true
            self.sourceCount = self.sourceCount + 1
        end
    end

    self:Refresh()
    self:StartLoop( self.revision )
    return true
end

---@param entry table?
---@param source integer
---@return boolean
function RoyaleAlliesClient:IsOwnedPedEntry( entry, source )

    if type( entry ) ~= 'table' or not entry.ped or entry.ped == 0
        or not DoesEntityExist( entry.ped ) then return false end

    if not entry.networkId or entry.networkId <= 0
        or NetworkGetNetworkIdFromEntity( entry.ped ) ~= entry.networkId then return false end

    local owner = NetworkGetEntityOwner( entry.ped )
    return owner ~= nil and owner >= 0 and GetPlayerServerId( owner ) == source
end

---@param entry table?
---@param source integer
---@return boolean
function RoyaleAlliesClient:IsCurrentPedEntry( entry, source )

    if not self:IsOwnedPedEntry( entry, source ) then return false end
    if source == self.localSource then return PlayerPedId() == entry.ped end

    local player = GetActivePlayer( source )
    return player ~= nil and GetPlayerPed( player ) == entry.ped
end

---@param entry table?
---@param source integer
function RoyaleAlliesClient:RestorePed( entry, source )

    if not self:IsOwnedPedEntry( entry, source ) then return end

    local ped = entry.ped
    if entry.outlined then SetEntityDrawOutline( ped, false ) end
    SetEntityCanBeDamagedByRelationshipGroup( ped, true, self.teamHash )

    -- Preserva um grupo instalado por outro sistema depois deste helper.
    if GetPedRelationshipGroupHash( ped ) == self.teamHash then
        SetPedRelationshipGroupHash( ped, entry.previousGroupHash )
    end
end

---@param ped integer
---@param source integer
---@param outlined boolean
---@return table?
function RoyaleAlliesClient:ApplyPed( ped, source, outlined )

    if ped == 0 or not DoesEntityExist( ped ) or not self.teamHash then return end

    local entry = {
        ped = ped,
        source = source,
        networkId = NetworkGetNetworkIdFromEntity( ped ),
        previousGroupHash = GetPedRelationshipGroupHash( ped ),
        outlined = outlined == true,
    }
    if not entry.networkId or entry.networkId <= 0 then return end

    SetPedRelationshipGroupHash( ped, self.teamHash )
    SetEntityCanBeDamagedByRelationshipGroup( ped, false, self.teamHash )

    if entry.outlined then
        SetEntityDrawOutline( ped, true )
        SetEntityDrawOutlineColor(
            ROYALE_ALLY_OUTLINE_COLOR[ 1 ],
            ROYALE_ALLY_OUTLINE_COLOR[ 2 ],
            ROYALE_ALLY_OUTLINE_COLOR[ 3 ],
            255
        )
        SetEntityDrawOutlineShader( ROYALE_ALLY_OUTLINE_SHADER )
        Citizen.InvokeNative( 1759507165, ROYALE_ALLY_OUTLINE_TEXTURE )
    end

    return entry
end

---@param entry table
function RoyaleAlliesClient:ReapplyPedOwnership( entry )

    local ped = entry.ped
    SetPedRelationshipGroupHash( ped, self.teamHash )
    SetEntityCanBeDamagedByRelationshipGroup( ped, false, self.teamHash )

    if entry.outlined then
        SetEntityDrawOutline( ped, true )
        SetEntityDrawOutlineColor(
            ROYALE_ALLY_OUTLINE_COLOR[ 1 ],
            ROYALE_ALLY_OUTLINE_COLOR[ 2 ],
            ROYALE_ALLY_OUTLINE_COLOR[ 3 ],
            255
        )
        SetEntityDrawOutlineShader( ROYALE_ALLY_OUTLINE_SHADER )
        Citizen.InvokeNative( 1759507165, ROYALE_ALLY_OUTLINE_TEXTURE )
    end
end

---@param source integer
---@param ped integer
---@return table?
function RoyaleAlliesClient:ReconcilePed( source, ped )

    local current = self.outlinedPedBySource[ source ]
    if ( not ped or ped == 0 ) and current then
        if not DoesEntityExist( current.ped )
            or NetworkGetNetworkIdFromEntity( current.ped ) ~= current.networkId then
            self.outlinedPedBySource[ source ] = nil
        else
            self:RestorePed( current, source )
            self.outlinedPedBySource[ source ] = nil
        end
        return
    end

    if current and current.ped == ped and self:IsCurrentPedEntry( current, source ) then
        if GetPedRelationshipGroupHash( ped ) ~= self.teamHash then
            self:ReapplyPedOwnership( current )
        end
        return current
    end

    if current then self:RestorePed( current, source ) end
    self.outlinedPedBySource[ source ] = nil
    if not ped or ped == 0 then return end

    local entry = self:ApplyPed( ped, source, true )
    if entry then self.outlinedPedBySource[ source ] = entry end
    return entry
end

---@return boolean
---@param force? boolean Reaplica a protecao do ped local depois de um revive confirmado.
function RoyaleAlliesClient:Refresh( force )

    if not self.active or not self.teamHash then return false end

    local localPed = PlayerPedId()
    local localEntry = self.localPedEntry
    if localPed ~= 0 and DoesEntityExist( localPed ) then
        if not localEntry or localEntry.ped ~= localPed
            or not self:IsCurrentPedEntry( localEntry, self.localSource ) then
            if localEntry then self:RestorePed( localEntry, self.localSource ) end
            self.localPedEntry = self:ApplyPed( localPed, self.localSource, false )
        else
            local groupHash = GetPedRelationshipGroupHash( localPed )
            if groupHash ~= self.teamHash then
                self:ReapplyPedOwnership( localEntry )
            elseif force == true then
                SetEntityCanBeDamagedByRelationshipGroup( localPed, false, self.teamHash )
            end
        end
    elseif localEntry then
        self:RestorePed( localEntry, self.localSource )
        self.localPedEntry = nil
    end

    local activePlayers
    if self.sourceCount > ROYALE_ALLY_ACTIVE_SCAN_MIN_SOURCES then
        activePlayers = GetActivePlayers()
    end

    if activePlayers and #activePlayers < self.sourceCount then
        local seenSources = {}
        for _, player in ipairs( activePlayers ) do
            if NetworkIsPlayerActive( player ) then
                local source = GetPlayerServerId( player )
                if self.sources[ source ] and not seenSources[ source ] then
                    seenSources[ source ] = true
                    self:ReconcilePed( source, GetPlayerPed( player ) )
                end
            end
        end

        -- Confirma os peds ja contornados por source antes de limpar um stream-out.
        for source in pairs( self.outlinedPedBySource ) do
            if self.sources[ source ] and not seenSources[ source ] then
                local player = GetActivePlayer( source )
                local ped = player and GetPlayerPed( player ) or 0
                self:ReconcilePed( source, ped )
            end
        end
    else
        for source in pairs( self.sources ) do
            local player = GetActivePlayer( source )
            local ped = player and GetPlayerPed( player ) or 0
            self:ReconcilePed( source, ped )
        end
    end

    for source, entry in pairs( self.outlinedPedBySource ) do
        if not self.sources[ source ] then
            self:RestorePed( entry, source )
            self.outlinedPedBySource[ source ] = nil
        end
    end
    return true
end

---@param payload table
---@return boolean
function RoyaleAlliesClient:ApplyDelta( payload )

    if not self.active or type( payload ) ~= 'table' or payload.matchId ~= self.matchId
        or type( payload.joined ) ~= 'boolean' then return false end

    local source = PositiveInteger( payload.source )
    if not source or source == self.localSource then return false end

    if payload.joined then
        if not self.sources[ source ] then
            self.sources[ source ] = true
            self.sourceCount = self.sourceCount + 1
        end
        local player = GetActivePlayer( source )
        local ped = player and GetPlayerPed( player ) or 0
        self:ReconcilePed( source, ped )
    else
        if self.sources[ source ] then
            self.sources[ source ] = nil
            self.sourceCount = self.sourceCount - 1
        end
        local entry = self.outlinedPedBySource[ source ]
        if entry then self:RestorePed( entry, source ) end
        self.outlinedPedBySource[ source ] = nil
    end
    return true
end

function RoyaleAlliesClient:StartLoop( revision )

    CreateThread( function()
        while self.active and self.revision == revision do
            Wait( ROYALE_ALLY_REFRESH_INTERVAL_MS )
            if self.active and self.revision == revision then self:Refresh() end
        end
    end )
end

function RoyaleAlliesClient:Close()

    local oldTeamHash = self.teamHash
    for source, entry in pairs( self.outlinedPedBySource ) do
        self:RestorePed( entry, source )
    end
    self.outlinedPedBySource = {}

    if self.localPedEntry then
        self:RestorePed( self.localPedEntry, self.localSource )
        self.localPedEntry = nil
    end
    if oldTeamHash then RemoveRelationshipGroup( oldTeamHash ) end

    self.active = false
    self.revision = self.revision + 1
    self.matchId = nil
    self.teamName = nil
    self.teamHash = nil
    self.localSource = nil
    self.sources = {}
    self.sourceCount = 0
end
