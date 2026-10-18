---@enum ConversationTimeout
local ConversationTimeout = {
    
    MODEL_LOAD = 100,    -- Timeout for model loading ( ms )

    ANIM_LOAD  = 50,     -- Timeout for animation loading ( ms )
}

---@enum ConversationStreaming
local ConversationStreaming = {
    
    CREATE_DISTANCE = 50.0,  -- Distance to create NPC ( meters )
    DELETE_DISTANCE = 55.0,  -- Distance to delete NPC ( meters )
    CHECK_INTERVAL  = 1000,  -- Check interval in ms
}

---@class conversations.PedInstance
---@field id string
---@field data conversations.PedConversationData
---@field entityId number
---@field model string
---@field hasAnimationStages boolean

---@type table<string, conversations.PedInstance>
local gPedInstances = { }

eInteractionPriority = eInteractionPriority or {
    LOW = 0,
    MEDIUM = 1,
    HIGH = 2,
    VERY_HIGH = 3,
    CRITICAL = 4,
}

---@type number|nil
local gCurrentConversationEntityId = nil

---@type number|nil
local gCurrentConversationId = nil

local DEFAULT_PED_MODEL = 'a_m_m_business_01'

---@param buckets table|nil
---@param currentBucket number
---@return boolean
local function IsBucketAllowed( buckets, currentBucket )
	
	if not buckets then
		return true -- Se não especificado, permite em todos os buckets
	end
	
	-- Se for array, verificar se contém true (permite todos) ou false (nega todos)
	if type(buckets) == 'table' and #buckets > 0 then
		-- Array format: [true] = permite todos, [false] = nega todos
		local firstValue = buckets[1]
		if type(firstValue) == 'boolean' then
			return firstValue
		end
	end
	
	-- Object format: {[bucketId] = true, ...}
	if type(buckets) == 'table' then
		return buckets[currentBucket] == true
	end
	
	return true
end

---@param conversationDef conversations.ConversationDef
---@param overrideDescription string|nil
---@return table|nil
local function BuildConversationPayload( conversationDef, overrideDescription )

	if not conversationDef then
		return
	end

	return {
		id              = conversationDef.id,
		visible         = conversationDef.visible,
		name            = conversationDef.name,
		tag             = conversationDef.tag,
		description     = overrideDescription
			or conversationDef.overrideDescription
			or conversationDef.description,
		escText         = conversationDef.escText,
        theme           = conversationDef.theme,
		coords          = conversationDef.coords,
		buttons         = conversationDef.buttons,
		backgroundImage = conversationDef.backgroundImage,
		audio           = conversationDef.audio,
		entityId        = conversationDef.entityId,
		buckets         = conversationDef.buckets,
		ped             = conversationDef.ped
	}
end

---@param pedData conversations.PedConversationData
---@return conversations.PedInstance|nil
local function CreateConversationPedInstance( pedData )

    assert( type( pedData ) == 'table', 'Invalid type for pedData: expected table' )
    
    assert( type( pedData.id ) == 'string' and pedData.id ~= '', 'Invalid type for pedData.id: expected non-empty string' )

    assert( type( pedData.coords ) == 'vector4', 'Invalid type for pedData.coords: expected vector4' )
    
    if gPedInstances[ pedData.id ] then

        -- sx.logger:warn( ('Ped instance already exists for id="%s"'):format( pedData.id ) )

        return gPedInstances[ pedData.id ]
    end
    
    -- Verificar se já existe um ped nas mesmas coordenadas e deletá-lo
    -- Isso previne peds duplicados quando o resource é reiniciado
    local targetCoords = vector3( pedData.coords.x, pedData.coords.y, pedData.coords.z )
    local nearbyPeds = GetGamePool( 'CPed' )
    for _, pedEntity in ipairs( nearbyPeds ) do
        if DoesEntityExist( pedEntity ) then
            local pedCoords = GetEntityCoords( pedEntity, false )
            local distance = #( targetCoords - pedCoords )
            -- Se está muito perto (menos de 1 metro), provavelmente é um ped duplicado
            -- Deletar para evitar peds sobrepostos
            if distance < 1.0 then
                print(('Found duplicate ped at coords (distance=%.2fm), deleting entityId=%d'):format(distance, pedEntity))
                DeleteEntity( pedEntity )
                -- Aguardar um frame para garantir que foi deletado
                Wait(0)
            end
        end
    end
    
    -- sx.logger:debug( ('Creating Ped instance for id="%s" at coords=%s'):format( pedData.id, json.encode( pedData.coords ) ) )

    local pedModel = pedData.model or DEFAULT_PED_MODEL
    local modelHash = GetHashKey( pedModel )
    
    local timeout = 0

    while not HasModelLoaded( modelHash ) and timeout < ConversationTimeout.MODEL_LOAD do
            
        RequestModel( modelHash )

        Wait( 0 )

        timeout = timeout + 1
    end

    if not HasModelLoaded( modelHash ) then

        print( ('Failed to load model "%s" for ped id="%s" after %d attempts'):format( pedModel, pedData.id, timeout ) )

        return
    end
    
    print(('Model "%s" loaded successfully for ped id="%s"'):format(pedModel, pedData.id))

    --[[
        INFO: feito desta forma usando ( pedData.coords.z - 1.0 ) 
        para garantir que o ped fique no chão pois não existe um 
        PlacePedOnGroundProperly ou algo do genero    
        
        - @TkzDev
    ]]

    local pedPlace = ( pedData.coords.z - 1.0 )
    
    local pedId = CreatePed( 4, modelHash, pedData.coords.x, pedData.coords.y, pedPlace, 0.0, false, false )
    
    if not DoesEntityExist( pedId ) then

        print( ('Failed to create ped entity for id="%s" at coords (%.2f, %.2f, %.2f)'):format( pedData.id, pedData.coords.x, pedData.coords.y, pedPlace ) )
        SetModelAsNoLongerNeeded( modelHash )

        return
    end
    
    print(('Ped entity created successfully: id="%s" entityId=%d'):format(pedData.id, pedId))
    
    SetEntityAsMissionEntity( pedId, true, true )
    SetPedDiesWhenInjured( pedId, false )
    SetPedCanPlayAmbientAnims( pedId, true )
    SetPedCanRagdollFromPlayerImpact( pedId, false )
    SetEntityHeading( pedId, pedData.coords.w )
    SetEntityVisible( pedId, true )
    SetEntityAlpha( pedId, 255, false )
    SetPedDefaultComponentVariation( pedId )
    SetEntityInvincible( pedId, true )
    FreezeEntityPosition( pedId, true )
    SetBlockingOfNonTemporaryEvents( pedId, true )

	local hasAnimationStages = false

	if pedData.animationStages then
		
		-- sx.logger:debug( ('Creating animation stage manager for ped id="%s"'):format( pedData.id ) )
		
		local manager = CreateAnimationStageManager( pedId, pedData.animationStages )
		
		if manager then

			hasAnimationStages = true

			-- sx.logger:info( ('Animation stage manager created for ped id="%s"'):format( pedData.id ) )
		end
		
	elseif pedData.animation then
		
        -- sx.logger:debug( ('Loading animation for ped id="%s": dict="%s" anim="%s"'):format( pedData.id, pedData.animation.dict, pedData.animation.anim ) )
        
        local animTimeout = 0
        while not HasAnimDictLoaded( pedData.animation.dict ) and animTimeout < ConversationTimeout.ANIM_LOAD do

            Wait( 0 )
            RequestAnimDict( pedData.animation.dict )

            animTimeout = animTimeout + 1
        end
        
        if not HasAnimDictLoaded( pedData.animation.dict ) then

            -- sx.logger:warn( ('Failed to load animation dict "%s" for ped id="%s"'):format( pedData.animation.dict, pedData.id ) )
        else
            TaskPlayAnim( pedId, pedData.animation.dict, pedData.animation.anim, 8.0, -8.0, -1, 1, 0, false, false, false )
            -- sx.logger:info( ('Animation started for ped id="%s"'):format( pedData.id ) )
        end
    end

    ---@type conversations.PedInstance
    local pedInstance = {
        id                  = pedData.id,
        data                = pedData,
        entityId            = pedId,
        model               = pedModel,
        hasAnimationStages  = hasAnimationStages
    }

    gPedInstances[ pedData.id ] = pedInstance
    SetModelAsNoLongerNeeded( modelHash )

    -- sx.logger:info( ('Ped instance created successfully for id="%s" entityId=%d'):format( pedData.id, pedId ) )

    return pedInstance
end

---@param pedId string
local function DestroyConversationPedInstance( pedId )

    -- sx.logger:debug( ('Destroying ped id="%s"'):format( pedId ) )
    
    assert( type( pedId ) == 'string' and pedId ~= '', 'Invalid pedId' )
    
    local pedInstance = gPedInstances[ pedId ]

    if not pedInstance then

        -- sx.logger:warn( ('Ped instance not found for id="%s"'):format( pedId ) )
        
        return
    end

	if pedInstance.hasAnimationStages then
		DestroyAnimationStageManager( pedInstance.entityId )
	end

    if DoesEntityExist( pedInstance.entityId ) then
        DeleteEntity( pedInstance.entityId )
    end

    gPedInstances[ pedId ] = nil

    -- sx.logger:info( ('Ped instance destroyed for id="%s"'):format( pedId ) )
end

---@param conversationId number
local function CreateConversationInteract( conversationId )
	local conversationDef = gConversationDefinitions[ conversationId ]

	if not conversationDef then
		return
	end
	
	local interactId = ("conversation_%d"):format( conversationId )

	interact.addCoords({
		id = interactId,
		coords = vector3( conversationDef.coords.x, conversationDef.coords.y, conversationDef.coords.z ),
        priority = eInteractionPriority.HIGH,
		options = {
			{
				label = conversationDef.name,
				icon = conversationDef.icon,

				onSelect = function( data )
					RequestConversation( conversationId )
				end,

				canInteract = function( entity, distance, coords, id )
					return 
						not ( 
							exports.hud:Wanted( ) 

							and LocalPlayer.state.FFA

							and LocalPlayer.state.PVP

							and GlobalState.Restarting

						) and LocalPlayer.state.Route < 900000
				end
			}
		},

		renderDistance = conversationDef.renderDistance or 7.5,
		activeDistance = conversationDef.activeDistance or 5,
		cooldown = 1200
	})
	
	-- sx.logger:info( ('Interact created for conversation %d'):format( conversationId ) )
end

---@param conversationId number
local function RemoveConversationInteract( conversationId )
	
	local interactId = ("conversation_%d"):format( conversationId )
	
	interact.removeById( interactId )
	
	-- sx.logger:info( ('Interact removed for conversation %d'):format( conversationId ) )
end

---@param pedData conversations.PedConversationData
---@return conversations.PedInstance|nil
function CreatePedForConversation( pedData )
    
    print(('CreatePedForConversation: Creating ped for conversation id=%d'):format( pedData.conversationId ) )
    
    local pedInstance = CreateConversationPedInstance( pedData )
    
    if pedInstance then
        print(('CreatePedForConversation: Ped instance created successfully, entityId=%d'):format(pedInstance.entityId))
        -- Criar interação quando NPC é criado
        CreateConversationInteract( pedData.conversationId )
    else
        print(('CreatePedForConversation: Failed to create ped instance for conversation id=%d'):format( pedData.conversationId ) )
    end
    
    return pedInstance
end

---@param pedId string
local function DestroyPedForConversation( pedId )
    
    local pedInstance = gPedInstances[ pedId ]
    
    if not pedInstance then
        return
    end
    
    local conversationId = pedInstance.data.conversationId
    
    -- Remover interação quando NPC é deletado
    RemoveConversationInteract( conversationId )
    
    -- Destruir instância do ped
    DestroyConversationPedInstance( pedId )
    
    -- Limpar entityId da definição
    local conversationDef = gConversationDefinitions[ conversationId ]
    if conversationDef then
        conversationDef.entityId = nil
        -- sx.logger:debug( ('Cleared entityId for conversation %d'):format( conversationId ) )
    end
end

---@param conversationDef conversations.ConversationDef
function OpenConversation( conversationDef )
    
    -- sx.logger:debug( ('Opening conversation for id=%d'):format( conversationDef.id ) )

    -- Garantir que o ped existe antes de abrir a conversa
    if not conversationDef.entityId then
        local success = EnsurePedForConversation( conversationDef.id )
        if not success then
            -- sx.logger:error( ('Failed to create ped for conversation %d'):format( conversationDef.id ) )
            return
        end
    end
    
    -- Verificar se a entidade ainda existe (pode ter sido deletada)
    if not DoesEntityExist( conversationDef.entityId ) then
        -- Tentar recriar o ped
        conversationDef.entityId = nil
        local success = EnsurePedForConversation( conversationDef.id )
        if not success then
            -- sx.logger:error( ('Failed to recreate ped for conversation %d'):format( conversationDef.id ) )
            return
        end
    end

    SetNuiFocus( true, true )

    -- sx.logger:debug( ('Conversation entityId=%d'):format( conversationDef.entityId ) )

    CreateCamInstance( conversationDef.entityId )
    
	gCurrentConversationEntityId = conversationDef.entityId
    gCurrentConversationId = conversationDef.id
	local currentStage = GetCurrentAnimationStage( conversationDef.entityId )
	
	if currentStage then
		SetAnimationStage( conversationDef.entityId, AnimationStage.TALKING )
	end

    SendNUIMessage(
        {       
            type = 'updateNPCData',
            data = BuildConversationPayload( conversationDef )
        }
    )

    exports.hud:hudDisplay( true )
    
    local visId = sx.client.visibility.beginVisibilityOverride()
    
    sx.client.visibility.addVisibilityOverrideExcludePlayer( visId, PlayerId() )
end

function CloseConversation( )

    -- sx.logger:debug( 'Closing conversation' )

    local conversationId = gCurrentConversationId

    DestroyCamInstance( )
    SetNuiFocus( false, false )
    
    if conversationId then
        local conversationDef = gConversationDefinitions[ conversationId ]

        if conversationDef then
            conversationDef.overrideDescription = nil
        end
    end

    gCurrentConversationId = nil
    SendNUIMessage(
        {
            type = 'hideNPC',
        }
    )
    
    exports.hud:hudDisplay( false )
    sx.client.visibility.endVisibilityOverride()
end 

---@param data { npcId: number, buttonId: number }
---@return boolean success
RegisterNUICallback( 'npcButtonClick', function( data, cb )
    
    local conversationId = data.npcId
    local buttonId = data.buttonId
    
    -- sx.logger:debug( ('Button clicked - conversationId=%d buttonId=%d'):format( conversationId, buttonId ) )
    
    if not conversationId or not buttonId then

        -- sx.logger:error( ('Invalid parameters - conversationId=%d buttonId=%d'):format( conversationId, buttonId ) )
        cb( { success = false } )

        return
    end

	if gCurrentConversationEntityId then

		local currentStage = GetCurrentAnimationStage( gCurrentConversationEntityId )

		-- sx.logger:debug( ('Button click - entityId=%d currentStage=%s'):format( gCurrentConversationEntityId, tostring( currentStage ) ) )

		if not currentStage then
            
			-- sx.logger:debug( 'Ped does not have animation stages configured' )
	
            return
		end

        SetAnimationStage( gCurrentConversationEntityId, AnimationStage.INTERACTING )
	end
    
    local success, err = pcall( ExecuteConversationButtonCallback, conversationId, buttonId )
    
    if not success then

        -- sx.logger:error( ('Button callback failed for conversationId=%d buttonId=%d: %s'):format( conversationId, buttonId, tostring( err ) ) )
        cb( { success = false } )

        return 
    end

    -- sx.logger:info( ('Button callback executed successfully for conversationId=%d buttonId=%d'):format( conversationId, buttonId ) )
    cb( { success = true } )
end)

---@param data any
RegisterNUICallback( 'closeNUI', function( data, cb )
	if not gCurrentConversationEntityId then

        -- sx.logger:warn( 'No current conversation entity ID set' )

        cb( false )

        return
    end

    local currentStage = GetCurrentAnimationStage( gCurrentConversationEntityId )

    -- sx.logger:debug( ('Current stage check: entityId=%d stage=%s INTERACTING=%d'):format( gCurrentConversationEntityId, tostring( currentStage ), AnimationStage.INTERACTING ) )

    -- if currentStage == AnimationStage.INTERACTING then

    --     sx.logger:warn( 'Cannot close conversation during INTERACTING stage' )

    --     cb( false )

    --     return
    -- end
    
    -- sx.logger:debug( 'Conversation interface closed successfully' )

    CloseConversation( )
    
    DestroyCamInstance( )

	if gCurrentConversationEntityId then

		local currentStage = GetCurrentAnimationStage( gCurrentConversationEntityId )

		if currentStage and currentStage ~= AnimationStage.INTERACTING then
			SetAnimationStage( gCurrentConversationEntityId, AnimationStage.IDLE )
		end

		gCurrentConversationEntityId = nil
	end
    
    cb( true )
end)

---@param conversationId number
---@param buttonId number
function TriggerConversationButtonClick( conversationId, buttonId )
	
	-- sx.logger:debug( ('Triggering button click for conversationId=%d buttonId=%d'):format( conversationId, buttonId ) )
	
	ExecuteConversationButtonCallback( conversationId, buttonId )
end

---@param conversationId number
function RequestConversation( conversationId )
	
	-- sx.logger:debug( ('Requesting conversation id=%d'):format( conversationId ) )
	
	local conversationDef = GetConversationDefinition( conversationId )
	
	if not conversationDef then
        
        -- sx.logger:error( ('Conversation %d not found for request'):format( conversationId ) )

        return
	end

    OpenConversation( conversationDef )
end

---@param conversationId number
local function EnsurePedForConversation( conversationId )
	
	local conversationDef = gConversationDefinitions[ conversationId ]
	
	if not conversationDef then
		return false
	end
	
	-- Se já existe entityId, NPC já está criado
	if conversationDef.entityId then
		return true
	end
	
	local pedId = ('conversation_ped_%d'):format( conversationId )
	local pedData = GetPedConversationData( pedId )
	
	if not pedData then
		return false
	end
	
	local pedInstance = CreatePedForConversation( pedData )
	
	if not pedInstance then
		return false
	end
	
	conversationDef.entityId = pedInstance.entityId
	
	return true
end

---@param conversationId number
local function RemoveConversation( conversationId )
	
	local conversationDef = gConversationDefinitions[ conversationId ]
	
	if not conversationDef then
		return
	end
	
	-- Remover NPC se existir - verificar tanto na tabela quanto pelo entityId
	local pedId = ('conversation_ped_%d'):format( conversationId )
	local pedInstance = gPedInstances[ pedId ]
	
	if pedInstance then
		-- Ped está na tabela, usar função de destruição completa
		DestroyPedForConversation( pedId )
	elseif conversationDef.entityId then
		-- Se não está na tabela mas tem entityId, deletar diretamente
		if DoesEntityExist( conversationDef.entityId ) then
			local entityType = GetEntityType( conversationDef.entityId )
			if entityType == 1 then -- Ped
				print(('Removing orphaned ped entityId=%d for conversation %d'):format(conversationDef.entityId, conversationId))
				-- Remover animações se existirem
				if GetCurrentAnimationStage then
					local stage = GetCurrentAnimationStage( conversationDef.entityId )
					if stage then
						DestroyAnimationStageManager( conversationDef.entityId )
					end
				end
				DeleteEntity( conversationDef.entityId )
			end
		end
		-- Limpar entityId
		conversationDef.entityId = nil
	end
	
	-- Remover interação
	RemoveConversationInteract( conversationId )
	
	-- Remover dados (ped, callbacks, definição) usando função do conversation_static_def.lua
	if RemoveConversationData then
		RemoveConversationData( conversationId )
	end
	
	-- sx.logger:info( ('Conversation %d removed completely'):format( conversationId ) )
end

---@param resourceName string
local function RemoveConversationsByResource( resourceName )
	
	local removedCount = 0
	local conversationsToRemove = {}
	
	-- Primeiro, coletar todas as conversas do resource
	for conversationId, conversationDef in pairs( gConversationDefinitions ) do
		if conversationDef.resource == resourceName then
			table.insert( conversationsToRemove, conversationId )
		end
	end
	
	-- Depois, remover cada uma (isso evita problemas ao iterar e modificar a tabela)
	for _, conversationId in ipairs( conversationsToRemove ) do
		print(('Removing conversation %d from resource %s'):format(conversationId, resourceName))
		RemoveConversation( conversationId )
		removedCount = removedCount + 1
	end
	
	if removedCount > 0 then
		print(('Removed %d conversations from resource "%s"'):format( removedCount, resourceName ))
	end
end

---@param conversationData conversations.ConversationDef
---@return number conversationId
exports( 'CreateConversation', function( conversationData )

    --[[
    GAMBIARRA!! sx talvez seja necessario internamente, sx é fudido
    TODO: Melhorar
    --]]
    while not sx do
        Wait( 0 )

        print('sx not loaded')
    end

    assert( type( conversationData ) == 'table', 'Invalid conversationData: expected table' )
	
	-- Identificar o resource que está chamando este export
	local invokingResource = GetInvokingResource()
	if invokingResource and invokingResource ~= '' then
		-- Sempre usar o resource que está chamando (sobrescreve se já existir)
		conversationData.resource = invokingResource
	end
	
	local conversationId = CreateConversation( conversationData )
	
	if not conversationId then
        return
	end
    
    -- Aguardar um frame para garantir que os dados foram registrados
    Wait(0)
    
    -- Tentar criar ped imediatamente se jogador estiver perto
    if conversationData.coords then
        local success, playerCoords = pcall(function()
            return sx.client.player.getFocusPosition()
        end)
        
        if success and playerCoords then
            local conversationCoords = vector3(
                conversationData.coords.x,
                conversationData.coords.y,
                conversationData.coords.z
            )
            local distance = #( playerCoords - conversationCoords )
            
            if distance <= ConversationStreaming.CREATE_DISTANCE then
                -- Verificar bucket se especificado
                local currentBucket = vRP.GetCurrentRoutingBucket()
                local canCreate = IsBucketAllowed( conversationData.buckets, currentBucket )
                
                if canCreate then
                    EnsurePedForConversation( conversationId )
                end
            end
        end
    end
    
    CreateConversationInteract( conversationId )

	return conversationId
end)

---@param conversationId number
---@param buttonId number
exports( 'ExecuteButtonCallback', function( conversationId, buttonId )
	
    assert( type( conversationId ) == 'number', 'Invalid conversationId: expected number' )
	
    assert( type( buttonId ) == 'number', 'Invalid buttonId: expected number' )
	
	-- sx.logger:debug( ('Executing button callback for conversationId=%d buttonId=%d'):format( conversationId, buttonId ) )
	
	local success, err = pcall( ExecuteConversationButtonCallback, conversationId, buttonId )
	
	if not success then
		-- sx.logger:error( ('Failed to execute button callback: %s'):format( tostring( err ) ) )
        return
	end
end)

---@param conversationId number
---@return conversations.ConversationDef
exports( 'GetConversation', function( conversationId )
	
    assert( type( conversationId ) == 'number', 'Invalid conversationId: expected number' )
	
	return GetConversationDefinition( conversationId )
end)


---@return number|nil
exports( 'GetCurrentConversationId', function()

    return gCurrentConversationId

end)


---@param conversationId number
---@param description string
exports( 'SetDescription', function( conversationId, description )
    
    assert( type( conversationId ) == 'number', 'Invalid conversationId: expected number' )
    assert( type( description ) == 'string', 'Invalid description: expected string' )

    local conversationDef = GetConversationDefinition( conversationId )

    if not conversationDef then

        -- sx.logger:error( ('Conversation %d not found for description set'):format( conversationId ) )

        return
    end

    conversationDef.overrideDescription = description

    SendNUIMessage(
        {
            type = 'updateNPCData',
            data = BuildConversationPayload( conversationDef, description )
        }
    )

end)

---@param conversationId number
---@return boolean
exports( 'IsConversationValid', function( conversationId )
	
    assert( type( conversationId ) == 'number', 'Invalid conversationId: expected number' )
	
    return IsConversationDefinitionValid( conversationId )
end)

---@param conversationId number
exports( 'OpenConversation', function( conversationId )
	
    assert( type( conversationId ) == 'number', 'Invalid conversationId: expected number' )
	
	RequestConversation( conversationId )
end)

exports( 'CloseConversation', function(  )

	CloseConversation( )
end)

--- Worker thread para streaming de NPCs baseado em distância
CreateThread( function( )
    -- NOTE: Necessário esperar pelo sx carregar antes de usar uma funcao dele! pois ele não é uma prioridade de carregamento

    while not (sx and sx.client and sx.client.player and sx.client.player.getFocusPosition) do
        Wait( 200 )
    end

	while true do
		
		Wait( ConversationStreaming.CHECK_INTERVAL )
		
		local playerCoords = sx.client.player.getFocusPosition()
		
		for conversationId, conversationDef in pairs( gConversationDefinitions ) do
			
			if not conversationDef.coords then

                print('not conversation corods', conversationId)

				goto continue
			end
			
			local conversationCoords = vector3( conversationDef.coords.x, conversationDef.coords.y, conversationDef.coords.z )
			local distance = #( playerCoords - conversationCoords )
			
			local pedId = ('conversation_ped_%d'):format( conversationId )
			local hasPed = gPedInstances[ pedId ] ~= nil
			
			-- Verificar se o jogador está em um bucket permitido
			local currentBucket = vRP.GetCurrentRoutingBucket()
			local canSeeNPC = IsBucketAllowed( conversationDef.buckets, currentBucket )
			
			-- Se está perto, NPC não existe e bucket permite, criar
			if distance <= ConversationStreaming.CREATE_DISTANCE and not hasPed and canSeeNPC then
				
				-- sx.logger:debug( ('Player near conversation %d (%.2fm), creating NPC'):format( conversationId, distance ) )
				EnsurePedForConversation( conversationId )
				
			-- Se está longe, bucket não permite ou NPC existe, deletar
			elseif (distance > ConversationStreaming.DELETE_DISTANCE or not canSeeNPC) and hasPed then
				
				-- sx.logger:debug( ('Player far from conversation %d (%.2fm) or bucket not allowed, deleting NPC'):format( conversationId, distance ) )
				DestroyPedForConversation( pedId )
				
			end
			
			::continue::
		end
	end
end )

AddEventHandler( 'onResourceStart', function ( resourceName )
    
	if resourceName ~= GetCurrentResourceName() then
		return
	end

    -- Limpar peds órfãos que possam ter ficado do restart anterior
    -- Verificar todas as conversas registradas e limpar entityIds antigos
    for conversationId, conversationDef in pairs( gConversationDefinitions ) do
        if conversationDef.entityId then
            -- Verificar se a entidade ainda existe
            if DoesEntityExist( conversationDef.entityId ) then
                -- Verificar se é um ped (tipo 1)
                local entityType = GetEntityType( conversationDef.entityId )
                if entityType == 1 then -- Ped
                    -- Deletar o ped órfão diretamente
                    DeleteEntity( conversationDef.entityId )
                end
            end
            -- Limpar entityId da definição para forçar recriação
            conversationDef.entityId = nil
        end
    end
    
    -- Limpar tabela de instâncias de peds (já deve estar vazia, mas garantir)
    gPedInstances = {}

    if GetResourceState( 'sleepless_interact' ) ~= 'started' then

        -- sx.logger:error( 'sleepless_interact resource not started' )

        return
    end

	-- Worker thread já está rodando, não precisamos criar interações aqui
	-- Elas serão criadas automaticamente quando os NPCs forem criados pelo streaming
	-- sx.logger:info( 'Conversation streaming system started' )
end)

-- Limpar conversas quando o resource que as criou parar
AddEventHandler( 'onResourceStop', function ( resourceName )
    
	-- Não processar se for o próprio resource conversation
	if resourceName == GetCurrentResourceName() then
		
		-- Limpar todos os NPCs quando o resource conversation parar
		for _, pedInstance in pairs( gPedInstances ) do
			DestroyConversationPedInstance( pedInstance.id )
		end
		
		return
	end

	-- Remover todas as conversas criadas por este resource
	print(('Resource %s stopped, cleaning conversations...'):format(resourceName))
	RemoveConversationsByResource( resourceName )
end)
