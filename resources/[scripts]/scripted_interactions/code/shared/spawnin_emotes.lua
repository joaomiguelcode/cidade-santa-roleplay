---@class SpawninEmoteScriptedInteractionDef
---@field name string
---@field states baseScriptedInteractionDef

---@type table<string, true>
local gSpawninEmoteScriptedInteractionNames = { }

local SPAWNIN_EMOTES_RESOURCE = 'spawnin_emotes'
local IMPORT_READY_TIMEOUT_MS = 15000
local IMPORT_POLL_INTERVAL_MS = 100

--- Invalida importacoes em voo: se o provider reiniciar de novo enquanto esperamos,
--- so a geracao mais nova pode escrever no registry.
local gImportGeneration = 0

--- Busca as definicoes assim que o provider ficar consultavel.
--- No instante do `onResourceStart` o resource ainda pode reportar "starting" e o export
--- ainda nao responde; desistir ai deixa o registry vazio ate um restart manual.
---@param generation number
---@return SpawninEmoteScriptedInteractionDef[] | nil
local function FetchSpawninEmoteDefinitions( generation )
    local state = GetResourceState( SPAWNIN_EMOTES_RESOURCE )
    if state ~= 'started' and state ~= 'starting' then
        return nil
    end

    local deadline = GetGameTimer() + IMPORT_READY_TIMEOUT_MS
    local lastError = 'resource nao atingiu estado started'

    while generation == gImportGeneration do

        if GetResourceState( SPAWNIN_EMOTES_RESOURCE ) == 'started' then

            local success, definitions = pcall( function()
                return exports.spawnin_emotes:getScriptedInteractionDefinitions()
            end )

            if success and type( definitions ) == 'table' then
                return definitions
            end

            lastError = success and ('export retornou %s'):format( type( definitions ) ) or tostring( definitions )
        end

        if GetGameTimer() >= deadline then
            sx.logger:error(
                ('Timed out importing scripted interactions from "%s" after %dms: %s')
                    :format( SPAWNIN_EMOTES_RESOURCE, IMPORT_READY_TIMEOUT_MS, lastError )
            )
            return nil
        end

        Wait( IMPORT_POLL_INTERVAL_MS )
    end

    return nil
end

---@param definitions SpawninEmoteScriptedInteractionDef[]
local function ApplySpawninEmoteScriptedInteractions( definitions )

    local namesSeen = { }
    local registeredCount = 0
    local refreshedCount = 0
    local failedCount = 0

    assert( type( definitions ) == 'table', 'spawnin_emotes retornou definicoes invalidas de scripted interaction' )

    for _, definition in ipairs( definitions ) do
        local success, result = pcall( function()
            assert(
                type( definition ) == 'table' and type( definition.name ) == 'string' and definition.name ~= '',
                'spawnin_emotes retornou uma scripted interaction sem nome valido'
            )

            assert(
                not namesSeen[ definition.name ],
                ('spawnin_emotes retornou a scripted interaction duplicada "%s"'):format( definition.name )
            )
            namesSeen[ definition.name ] = true

            if IsScriptedInteractionDefinitionValid( definition.name ) then
                assert(
                    gSpawninEmoteScriptedInteractionNames[ definition.name ],
                    ('Scripted interaction "%s" esta duplicada; mantenha a definicao somente no spawnin_emotes'):format( definition.name )
                )
                ReplaceScriptedInteractionDefinition( definition.name, definition.states )
                gSpawninEmoteScriptedInteractionNames[ definition.name ] = true
                return 'refreshed'
            end

            RegisterScriptedInteractionDefinition( definition.name, definition.states )
            gSpawninEmoteScriptedInteractionNames[ definition.name ] = true
            return 'registered'
        end )

        if not success then
            failedCount = failedCount + 1
            sx.logger:error(
                ('Failed to import spawnin_emotes scripted interaction "%s": %s')
                    :format( type( definition ) == 'table' and tostring( definition.name ) or '<invalid>', tostring( result ) )
            )
        elseif result == 'refreshed' then
            refreshedCount = refreshedCount + 1
        else
            registeredCount = registeredCount + 1
        end
    end

    sx.logger:info(
        ('Imported spawnin_emotes scripted interactions registered=%d refreshed=%d failed=%d total=%d')
            :format( registeredCount, refreshedCount, failedCount, #definitions )
    )
end

--- Importa em thread propria: a busca espera o provider ficar pronto, entao nao pode
--- bloquear o load do resource nem o handler do evento.
local function RegisterSpawninEmoteScriptedInteractions()

    gImportGeneration = gImportGeneration + 1

    local generation = gImportGeneration

    CreateThread( function()

        local definitions = FetchSpawninEmoteDefinitions( generation )

        if not definitions or generation ~= gImportGeneration then
            return
        end

        ApplySpawninEmoteScriptedInteractions( definitions )
    end )
end

RegisterSpawninEmoteScriptedInteractions()

local resourceStartEvent = IsDuplicityVersion() and 'onResourceStart' or 'onClientResourceStart'

AddEventHandler( resourceStartEvent, function( resourceName )

    if resourceName ~= SPAWNIN_EMOTES_RESOURCE then
        return
    end

    RegisterSpawninEmoteScriptedInteractions()
end )
