DominationLootRenderer = class()

local gCurrent
local gSequence = 0
local gTxdName = 'domination_loot_runtime'
local gNatives = DminigamesRenderDiagnostics.Natives( 'loot' )

local function DistanceSquared( a, b )
    local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
    return dx * dx + dy * dy + dz * dz
end

function DominationLootRenderer:__init( owner )
    gSequence = gSequence + 1
    self.owner = owner
    self.token = ('%s-%s'):format( GetGameTimer(), gSequence )
    -- CreateRuntimeTextureFromDuiHandle nao substitui uma textura ja registrada.
    -- A nova DUI precisa de um TXD proprio, mesmo apos DestroyDui da sessao anterior.
    self.txdName = ('%s_%s'):format( gTxdName, self.token )
    self.drops, self.slots = {}, {}
    self.enabled = true
    self.nextSync = 0
    self.nextPickup = 0
    self.revision = 0
end

function DominationLootRenderer:Start()
    if self.dui or self.destroyed then return end

    gCurrent = self
    self.dui = gNatives.CreateDui( ('https://cfx-nui-%s/web/domination-loot.html?token=%s'):format(
        GetCurrentResourceName(), self.token ), 1024, 1024 )

    local function Update()
        if self.destroyed then return end

        self:Update()
        SetTimeout( DOMINATION_LOOT.updateIntervalMs, Update )
    end

    Update()
end

function DominationLootRenderer:Ready()
    if self.destroyed or not self.dui then return false end
    if self.ready then return true end

    local available = IsDuiAvailable( self.dui )

    if available ~= true and available ~= 1 then return false end

    if not self.runtimeTxd or self.runtimeTxd == 0 then
        self.runtimeTxd = gNatives.CreateRuntimeTxd( self.txdName )
    end

    if not self.runtimeTxd or self.runtimeTxd == 0 then return false end

    if not self.texture or self.texture == 0 then
        local handle = GetDuiHandle( self.dui )

        if not handle or handle == '' then return false end

        self.texture = gNatives.CreateRuntimeTextureFromDuiHandle( self.runtimeTxd, 'atlas', handle )
    end

    if not self.texture or self.texture == 0 then return false end

    -- O handle pode existir antes da superficie GPU. Verifica apenas no handshake,
    -- nunca por frame; o front ja repete ready enquanto o resultado for false.
    if GetRuntimeTextureWidth( self.texture ) ~= 1024 or GetRuntimeTextureHeight( self.texture ) ~= 1024 then return false end

    self.ready = true
    self.lastSignature = nil
    return self.ready
end

function DominationLootRenderer:Upsert( data )
    local previous = self.drops[ data.id ]

    if previous and previous.revision == data.revision then return end

    data.receivedAt = GetGameTimer()
    data.ground = previous and previous.ground
    self.drops[ data.id ] = data
end

function DominationLootRenderer:Receive( data )
    if self.destroyed or data.token ~= self.token then return end

    if data.action == 'snapshot' then
        local present = {}

        for _, drop in ipairs( data.drops ) do
            present[ drop.id ] = true
            self:Upsert( drop )
        end

        for id in pairs( self.drops ) do
            if not present[ id ] then self.drops[ id ] = nil end
        end

        self.grid = data.grid
    elseif data.action == 'ack' then
        self.grid = data.grid
    elseif data.action == 'upsert' then
        self:Upsert( data.drop )
    elseif data.action == 'remove' then
        local drop = self.drops[ data.id ]

        if drop and data.collector then
            local player = GetPlayerFromServerId( data.collector )

            if player ~= -1 then
                local target = GetEntityCoords( GetPlayerPed( player ) )
                drop.collectAt = GetGameTimer()
                drop.target = { x = target.x, y = target.y, z = target.z + 0.35 }
                drop.revision = drop.revision + 1
            else
                self.drops[ data.id ] = nil
            end
        else
            self.drops[ data.id ] = nil
        end
    end
end

function DominationLootRenderer:ResetGrid()
    self.grid = nil
    self.nextSync = 0
end

function DominationLootRenderer:Update()
    local now = GetGameTimer()
    local playing = self.owner.active and self.owner.gameplayActive and not self.owner.selectorOpen
    local candidates = {}

    if playing then
        local ped = PlayerPedId()
        local position = GetEntityCoords( ped )
        local grid = ('%d:%d'):format( math.floor( position.x / DOMINATION_LOOT.cellSize ), math.floor( position.y / DOMINATION_LOOT.cellSize ) )

        if grid ~= self.grid and now >= self.nextSync then
            self.nextSync = now + 1000
            TriggerServerEvent( 'pvp.domination:syncLoot', self.token )
        end

        local nearest, nearestDistance

        for id, drop in pairs( self.drops ) do
            local age = now - drop.receivedAt + drop.age

            if age >= DOMINATION_LOOT.lifetimeSeconds * 1000 or ( drop.collectAt and now - drop.collectAt >= 420 ) then
                self.drops[ id ] = nil
            else
                local distance = DistanceSquared( position, drop )

                if distance <= DOMINATION_LOOT.drawDistance ^ 2 then
                    drop.distance = distance
                    local index = #candidates + 1

                    while index > 1 do
                        local previous = candidates[ index - 1 ]

                        if previous.distance < distance or ( previous.distance == distance and previous.id < drop.id ) then break end

                        candidates[ index ] = previous
                        index = index - 1
                    end

                    candidates[ index ] = drop
                    candidates[ math.min( DOMINATION_LOOT.maxVisiblePiles, 4 ) + 1 ] = nil
                end

                if not drop.collectAt and age >= DOMINATION_LOOT.pickupDelayMs
                    and distance <= DOMINATION_LOOT.pickupDistance ^ 2
                    and ( not nearestDistance or distance < nearestDistance ) then
                    nearest, nearestDistance = drop, distance
                end
            end
        end

        if nearest and now >= self.nextPickup and self.owner:CanLocalPlayerInteractWithBody() then
            self.nextPickup = now + DOMINATION_LOOT.pickupRetryMs
            TriggerServerEvent( 'pvp.domination:collectLoot', nearest.id, self.token )
        end
    else
        self:ResetGrid()
    end

    local selected = {}

    for i = 1, math.min( #candidates, DOMINATION_LOOT.maxVisiblePiles, 4 ) do selected[ candidates[ i ].id ] = candidates[ i ] end

    -- Slots estaveis: aproximar outra pilha nao troca o UV das que continuam visiveis.
    for slot, drop in pairs( self.slots ) do
        if selected[ drop.id ] then
            self.slots[ slot ] = selected[ drop.id ]
            selected[ drop.id ] = nil
        else
            self.slots[ slot ] = nil
        end
    end

    for _, drop in pairs( selected ) do
        for slot = 1, 4 do
            if not self.slots[ slot ] then
                if not drop.ground then
                    local found, ground = GetGroundZFor_3dCoord( drop.x, drop.y, drop.z + 1.0, false )
                    drop.ground = ( ( found == true or found == 1 ) and math.abs( ground - drop.z ) < 2.0 ) and ground or drop.z - 0.85
                end

                self.slots[ slot ] = drop
                break
            end
        end
    end

    if self.ready then self:Publish() end
end

function DominationLootRenderer:Publish()
    local parts, piles = {}, {}

    for slot = 1, 4 do
        local drop = self.enabled and self.slots[ slot ]
        parts[ slot ] = drop and ('%s:%s'):format( drop.id, drop.revision ) or '-'

        if drop then
            piles[ #piles + 1 ] = { slot = slot, id = drop.id, icons = drop.icons,
                splash = not drop.shown and GetGameTimer() - drop.receivedAt + drop.age < 1800,
                collecting = drop.collectAt ~= nil }
            drop.shown = true
        end
    end

    local signature = table.concat( parts, '/' )

    if signature ~= self.lastSignature then
        self.lastSignature = signature
        self.revision = self.revision + 1
        self.paintedRevision = nil
        SendDuiMessage( self.dui, json.encode( { action = 'piles', revision = self.revision, piles = piles } ) )
    end

    if #piles > 0 then self:StartDrawing() else self:StopDrawing() end
end

function DominationLootRenderer:StartDrawing()
    if self.abortDraw or not self.ready or not self.enabled or self.destroyed then return end

    self.loop = DminigamesRenderDiagnostics.LoopStarted( 'loot', self )
    self.abortDraw = sx.script.setTick( function() self:Draw() end )
end

function DominationLootRenderer:StopDrawing()
    if self.abortDraw then
        self.abortDraw()
        self.abortDraw = nil
        DminigamesRenderDiagnostics.LoopFinished( self.loop )
        self.loop = nil
    end
end

function DominationLootRenderer:show()
    self.enabled = true
    self.lastSignature = nil
end

function DominationLootRenderer:hide()
    self.enabled = false
    self:StopDrawing()

    if self.ready then self:Publish() end
end

function DominationLootRenderer:Draw()
    if self.paintedRevision ~= self.revision then return end

    local rotation = GetGameplayCamRot( 2 )
    local yaw, pitch = math.rad( rotation.z ), math.rad( rotation.x )
    local rx, ry = math.cos( yaw ), math.sin( yaw )
    local ux, uy, uz = math.sin( yaw ) * math.sin( pitch ), -math.cos( yaw ) * math.sin( pitch ), math.cos( pitch )
    local size = DOMINATION_LOOT.worldSize
    local half = size * 0.5
    local now = GetGameTimer()

    for slot, drop in pairs( self.slots ) do
        local x, y, z = drop.x, drop.y, drop.ground + 0.55

        if drop.collectAt then
            local t = math.min( 1, ( now - drop.collectAt ) / 400 )
            t = t * t
            x, y, z = x + ( drop.target.x - x ) * t, y + ( drop.target.y - y ) * t, z + ( drop.target.z - z ) * t
        end

        local ax, ay, az = x - rx * half - ux * half, y - ry * half - uy * half, z - uz * half
        local bx, by, bz = ax + rx * size, ay + ry * size, az
        local cx, cy, cz = bx + ux * size, by + uy * size, bz + uz * size
        local dx, dy, dz = ax + ux * size, ay + uy * size, az + uz * size
        local u, v = ( ( slot - 1 ) % 2 ) * 0.5, math.floor( ( slot - 1 ) / 2 ) * 0.5
        DrawTexturedPoly( ax, ay, az, bx, by, bz, cx, cy, cz, 255, 255, 255, 255,
            self.txdName, 'atlas', u, v + 0.5, 0.0, u + 0.5, v + 0.5, 0.0, u + 0.5, v, 0.0 )
        DrawTexturedPoly( ax, ay, az, cx, cy, cz, dx, dy, dz, 255, 255, 255, 255,
            self.txdName, 'atlas', u, v + 0.5, 0.0, u + 0.5, v, 0.0, u, v, 0.0 )
    end
end

function DominationLootRenderer:destroy()
    if self.destroyed then return end

    self.destroyed = true
    self:StopDrawing()

    if self.dui then gNatives.DestroyDui( self.dui ) end
    if gCurrent == self then gCurrent = nil end

    self.dui, self.texture, self.runtimeTxd = nil, nil, nil
    self.ready = false
    self.drops, self.slots = {}, {}
end

RegisterNUICallback( 'dominationLootReady', function( data, callback )
    local ready = gCurrent and data.token == gCurrent.token and gCurrent:Ready() or false
    callback( { ready = ready } )
end )

RegisterNUICallback( 'dominationLootPainted', function( data, callback )
    if gCurrent and data.token == gCurrent.token and data.revision == gCurrent.revision then
        gCurrent.paintedRevision = data.revision
    end

    callback( {} )
end )

RegisterNetEvent( 'pvp.domination:lootUpdate', function( data )
    if gCurrent and type( data ) == 'table' then gCurrent:Receive( data ) end
end )
